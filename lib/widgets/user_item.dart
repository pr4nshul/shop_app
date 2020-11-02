import 'package:flutter/material.dart';

class UserItem extends StatelessWidget {
  final String title;
  final String imageURL;

  UserItem({this.title, this.imageURL});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageURL),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(icon: Icon(Icons.edit,color: Theme.of(context).primaryColor,), onPressed: () {}),
            IconButton(icon: Icon(Icons.delete), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
