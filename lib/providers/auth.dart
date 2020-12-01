import 'dart:convert';
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
    } catch (error) {
      throw error;
    }
  }
  void logout(){
    _userId =null;
    _token = null;
    _expiryDate = null;
    if(authTimer!=null){
      authTimer.cancel();
      authTimer=null;
    }
    notifyListeners();
  }
  void autoLogout(){
    if(authTimer!=null){
      authTimer.cancel();
    }
    final expiryTime = _expiryDate.difference(DateTime.now()).inSeconds;
    authTimer = Timer(Duration(seconds: expiryTime),logout);
  }
}
