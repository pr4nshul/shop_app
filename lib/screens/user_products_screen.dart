import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './edit_product_Screen.dart';
import '../widgets/user_item.dart';
import '../providers/product_provider.dart';
import '../widgets/app_drawer.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-products';
  Future<void> _refresh(BuildContext context) async{
    await Provider.of<ProductProvider>(context,listen: false).setFetchProducts();
  }
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          FlatButton(onPressed: () {
            Navigator.of(context).pushNamed(EditProductScreen.routeName);
          }, child: const Icon(Icons.add,color: Colors.white,)),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: ()=>_refresh(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (_, i) => Column(
              children: [
                UserItem(
                  id: productsData.items[i].id,
                  title: productsData.items[i].title,
                  imageURL: productsData.items[i].imageUrl,
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
