import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/app_routes.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/product_item.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);
    final products = productsProvider.items;

    return Scaffold(
      appBar: AppBar(
        title: Text("Gerenciar Produtos"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.PRODUCT_FORM);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(18),
        child: ListView.builder(
          itemCount: productsProvider.itemCount,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ProductItem(products[index]),
                Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}
