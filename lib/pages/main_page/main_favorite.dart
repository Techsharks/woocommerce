import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:woocommerce/components/CustomListItem.dart';
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
    _loadProducts();
    super.initState();
  }

  _loadProducts() async {
    try {
      await (new ProductProvider()).getFavoriteProductsOffline().then((List<Product> proList) {
        if (proList.length > 0) {
          listProducts.clear();
          setState(() {
            emptyList = false;
            listProducts.addAll(proList);
          });
        } else {
          setState(() {
            emptyList = true;
          });
        }
      });
    } catch (e) {
      print('error in main_favorite.dart: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return (emptyList == true) ? new Center(child: new Text('لیست انتخاب شده ها خالی')) : myList();
  }

  Widget myList() {
    return new Container(
      margin: EdgeInsets.only(top: 10),
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        itemExtent: 135.0,
        children: List.generate(listProducts.length, (index) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => new SingleProduct(
                    product: listProducts[index],
                  ),
                ),
              );
            },
            child: CustomListItem(
              price: listProducts[index].price,
              thumbnail: CachedNetworkImage(
                imageUrl: listProducts[index].images[0].src,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Tools.preloader(),
                  ],
                ),
                errorWidget: (context, url, error) => Center(
                  child: Icon(Icons.cloud_off),
                ),
              ),
              title: '${listProducts[index].name}',
            ),
          );
        }),
      ),
    );
  }
}
