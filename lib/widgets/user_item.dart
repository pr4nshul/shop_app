import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../screens/edit_product_Screen.dart';

class UserItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageURL;

  UserItem({@required this.id,this.title, this.imageURL});

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
            IconButton(icon: Icon(Icons.edit,color: Theme.of(context).primaryColor,), onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName,arguments: id);
            }),
            IconButton(icon: Icon(Icons.delete), onPressed: () {
              Provider.of<ProductProvider>(context,listen: false).delete(id);
            }),
          ],
        ),
      ),
    );
  }
}
