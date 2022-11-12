import 'package:flutter/material.dart';

import '../widgets/categories_list.dart';
import '../widgets/my_appbar.dart';
import '../widgets/products_list.dart';
import '../widgets/search_input.dart';

class ProductsOverviewScreen extends StatelessWidget {
  const ProductsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "VISH",
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications,
              ))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: SearchInput()),
          const SizedBox(
            height: 10,
          ),
          CategoriesList(),
          const SizedBox(
            height: 25,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Text(
              "Produtos",
              style: TextStyle(
                  fontSize: 24, color: Colors.black, fontFamily: "Acme"),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
              child: ProductsList(
            false,
          )),
        ],
      ),
      drawer: Drawer(),
    );
  }
}
