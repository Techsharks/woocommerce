import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:woocommerce/components/CustomListItem.dart';
import 'package:woocommerce/database/product_provider.dart';
import 'package:woocommerce/model/order.dart';
import 'package:woocommerce/model/product.dart';
import 'package:woocommerce/tools/tools.dart';

import '../home_page.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Order> orderList = List();
  int totalPayment = 0;

  @override
  void initState() {
    super.initState();
    _loadOrderList();
  }

  _loadOrderList() async {
    try {
      await (new ProductProvider()).getOrdersOffline().then((List<Order> order_list) {
        if (order_list.length > 0) {
          this.orderList.clear();
          setState(() {
            this.orderList = order_list;
          });
        }
      });
    } catch (e) {
      print('error in cart_page.dart');
    }

    getTotalPayment();
  }

  @override
  Widget build(BuildContext context) {
    return new Directionality(
      textDirection: TextDirection.rtl,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('لیست سفارش شما'),
          centerTitle: true,
          bottom: new PreferredSize(
            child: new Container(
              height: 40,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              decoration: Tools.boxDecoration(),
              child: new Text('${Tools.getCurrencySymbol()}${this.totalPayment}'),
            ),
            preferredSize: Size(double.infinity, 48),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(8.0),
          itemExtent: 135.0,
          children: List.generate(orderList.length, (index) {
            return CustomListItem(
              onAddClick: () {
                addToCart(orderList[index].product);
              },
              onRemoveClick: () {},
              price: orderList[index].product.price,
              quantity: orderList[index].quantity,
              thumbnail: CachedNetworkImage(
                imageUrl: orderList[index].product.images[0].src,
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
              title: '${orderList[index].product.name}',
            );
          }),
        ),
      ),
    );
  }

  Future<int> getTotalPayment() {
    this.totalPayment = 0;
    orderList.forEach((p) {
      int price = int.parse('${((p.product.price))}');
      setState(() {
        this.totalPayment += (price > 0) ? (price * p.quantity) : price;
      });
    });
  }

  addToCart(Product product) async {
    print('addToCart: ${product.id}');
    await (new ProductProvider()).addToCart(product).then((id) {
      this._loadOrderList();
      GlobalCartCounter += 1;
    });
  }

  removeFormCart(Product product) async {
    // await (new ProductProvider()).removeFormCart(product);
  }
}
