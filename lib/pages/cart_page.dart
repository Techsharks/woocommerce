import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:woocommerce/components/CustomListItem.dart';
import 'package:woocommerce/database/product_provider.dart';
import 'package:woocommerce/model/order.dart';
import 'package:woocommerce/model/product.dart';
import 'package:woocommerce/pages/checkout/check_out.dart';
import 'package:woocommerce/pages/profile/login_page.dart';
import 'package:woocommerce/tools/tools.dart';

import '../home_page.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Order> orderList = List();
  int totalPayment = 0;
  Widget messageWidget = new Container();

  @override
  void initState() {
    super.initState();
    _loadOrderList();
  }

  _loadOrderList() async {
    setState(() {
      messageWidget = new SizedBox(
        width: 20,
        height: 20,
        child: new CircularProgressIndicator(
          strokeWidth: 3,
        ),
      );
    });
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
      print('error in cart_page.dart ${StackTrace.current}');
    }

    getTotalPayment();
  }

  @override
  Widget build(BuildContext context) {
    return new Directionality(
      textDirection: TextDirection.rtl,
      child: new Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          title: new Text(
            'لیست سفارش شما',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          centerTitle: true,
          bottom: new PreferredSize(
            child: new Container(
              height: 40,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              decoration: Tools.boxDecoration(),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  new Text('${Tools.getCurrencySymbol()}${this.totalPayment}'),
                  messageWidget,
                ],
              ),
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
              onRemoveClick: () {
                removeFormCart(orderList[index]);
              },
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
        bottomNavigationBar: new Card(
          // color: Colors.red,
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          elevation: 0,
          child: RaisedButton(
            textColor: Colors.white,
            color: Colors.blue,
            splashColor: Colors.red,
            elevation: 0,
            child: new Text('تصفیه حساب'),
            onPressed: () {
              Tools.isUserLogin().then((res) {
                if (res) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => new CheckOutPage()));
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return new Directionality(
                        textDirection: TextDirection.rtl,
                        child: new Scaffold(
                          appBar: new AppBar(title: new Text('ورود به سیستم')),
                          body: new LoginPage(
                            anyMessage: 'برای خرید شما اول وارد سیستم شوید',
                            onLoginSuccess: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => new CheckOutPage()));
                            },
                          ),
                        ),
                      );
                    }),
                  );
                }
              });
            },
          ),
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
        messageWidget = new Container();
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

  removeFormCart(Order order) async {
    await (new ProductProvider()).removeFormCart(order).then((rowID) {
      print('removed item[ $rowID ]');
      this._loadOrderList();
      GlobalCartCounter -= 1;
    });
  }
}
