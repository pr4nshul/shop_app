import 'dart:convert';
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exception.dart';
import '../keys/api.dart';
class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiryDate;
  Timer authTimer;
  bool get isAuth {
    return token != null;
  }
  String get userId{
    return _userId;
  }
  String get token {
    if (_token != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _expiryDate != null) {
      return _token;
    }
    return null;
  }

  Future<void> signUp(String email, String password) async {
    return authenticate(email, password, "signUp?key= $webApi");
  }
  Future<void> login(String email, String password) async {
    return authenticate(email, password, "signInWithPassword?key=$webApi");
  }
  Future<void> authenticate(String email,String password,String urlSegment)async{
    var url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment";
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({"token" : _token , "userId" : _userId , "expiryDate" : _expiryDate.toIso8601String()});
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }
  Future<bool> tryAutoLogin() async{
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false;
    }
    final extractedData = json.decode(prefs.getString('userData')) as Map<String,Object>;
    final expiryDate = DateTime.parse(extractedData['expiryDate']);
    if(expiryDate.isBefore(DateTime.now())){
      return false;
    }
    _expiryDate = expiryDate;
    _userId = extractedData['userId'];
    _token = extractedData['token'];
    notifyListeners();
    autoLogout();
    return true;
  }
  Future<void> logout() async{
    _userId =null;
    _token = null;
    _expiryDate = null;
    if(authTimer!=null){
      authTimer.cancel();
      authTimer=null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
  void autoLogout(){
    if(authTimer!=null){
      authTimer.cancel();
    }
    final expiryTime = _expiryDate.difference(DateTime.now()).inSeconds;
    authTimer = Timer(Duration(seconds: expiryTime),logout);
  }
}
