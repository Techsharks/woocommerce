import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:woocommerce/components/product_grid.dart';
import 'package:woocommerce/database/product_provider.dart';
import 'package:woocommerce/model/product.dart';
import 'package:woocommerce/pages/single/single_product.dart';
import 'package:woocommerce/tools/tools.dart';

class MainFavoritePage extends StatefulWidget {
  @override
  _MainFavoritePageState createState() => _MainFavoritePageState();
}

class _MainFavoritePageState extends State<MainFavoritePage> {
  List<Product> listProducts = [];
  bool emptyList = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  _loadProducts() async {
    await (new ProductProvider()).getFavoriteProductsOffline().then((List<Product> proList) {
      if (proList.length > 0) {
        listProducts.clear();
        emptyList = false;
        listProducts.addAll(proList);
      } else {
        emptyList = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return (emptyList == true) ? new Center(child: new Text('لیست انتخاب شده ها خالی')) : myList();
  }

  Widget myList() {
    return new Container(
      margin: EdgeInsets.only(top: 10),
      color: Colors.white,
      child: new ListView.separated(
        itemCount: listProducts.length,
        itemBuilder: (context, index) {
          return new Directionality(
              textDirection: TextDirection.ltr,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => SingleProduct(
                        product: listProducts[index],
                      ),
                    ),
                  );
                },
                contentPadding: EdgeInsets.only(right: 10, left: 10),
                title: new Text(
                  '${listProducts[index].name}',
                  textAlign: TextAlign.right,
                ),
                leading: new CachedNetworkImage(
                  imageUrl: '${listProducts[index].images[0].src}',
                  width: 100,
                ),
                subtitle: new Text(
                  '${Tools.getCurrencySymbol()}${listProducts[index].price}',
                  textAlign: TextAlign.right,
                ),
              ));
        },
        separatorBuilder: (BuildContext context, int index) {
          return new Divider();
        },
      ),
    );
  }
}
