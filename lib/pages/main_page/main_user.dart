import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:woocommerce/components/CustomListItem.dart';
import 'package:woocommerce/database/product_provider.dart';
import 'package:woocommerce/home_page.dart';
import 'package:woocommerce/model/order.dart';
import 'package:woocommerce/model/woo_user.dart';
import 'package:woocommerce/pages/profile/login_page.dart';
import 'package:woocommerce/tools/helper.dart';
import 'package:woocommerce/tools/tools.dart';

// https://businessbloomer.com/woocommerce-display-products-purchased-user/

class MainUserPage extends StatefulWidget {
  @override
  _MainUserPageState createState() => _MainUserPageState();
}

class _MainUserPageState extends State<MainUserPage> {
  WooUser user = WooUser();

  Widget contentWidget = new Container(child: Tools.preloader());
  List<Order> orderList = List();
  var isUserLogin = Helper.LOGIN_FAILED;

  @override
  void initState() {
    super.initState();
    _getOrderedList();
  }

  _getOrderedList() async {
    await (new ProductProvider()).getOrdersOffline(status: 1).then((List<Order> orders) {
      orderList.clear();
      setState(() {
        orderList.addAll(orders);
      });
    });
  }

  onLoginSuccess() {
    setState(() {
      GlobalWooUser.status = Helper.LOGIN_SUCCESS;
    });
  }

  onLogOutClicked() async {
    await Tools.userLogOut().then((status) {
      print('logout status: $status');
      setState(() {
        GlobalWooUser.status = Helper.LOGIN_FAILED;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (GlobalWooUser.status == Helper.LOGIN_SUCCESS) {
      return userProfileInfo();
    } else {
      return new LoginPage(
        onLoginSuccess: this.onLoginSuccess,
      );
    }
  }

  Widget userProfileInfo() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 20),
        child: new Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: new ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: (orderList.length + 3),
            itemBuilder: (context, index) {
              if (index == 0) {
                return new Column(
                  children: <Widget>[
                    (GlobalWooUser.avatar != null)
                        ? CachedNetworkImage(
                            height: 100,
                            width: 100,
                            imageUrl: GlobalWooUser.avatar,
                            imageBuilder: (context, imageProvider) => Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey[400],
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => new Container(
                              decoration: new BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.grey[400]),
                              height: 100,
                              width: 100,
                            ),
                            errorWidget: (context, url, error) => Center(
                              child: Icon(Icons.cloud_off),
                            ),
                          )
                        : Container(
                            height: 100,
                            width: 100,
                            decoration: new BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.grey[400]),
                            child: new Center(
                              child: new Icon(Icons.person_outline),
                            ),
                          )
                  ],
                );
              } else if (index == 1) {
                return new ListTile(
                  title: new Text('${GlobalWooUser.display_name}', textAlign: TextAlign.center),
                  subtitle: new Text('${GlobalWooUser.user_email}', textAlign: TextAlign.center),
                );
              } else if (index == 2) {
                return new Column(
                  children: <Widget>[
                    new GestureDetector(
                      child: new Container(
                        width: 100,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(5),
                        decoration: new BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[new Text(' خروج '), new Icon(Icons.exit_to_app)],
                        ),
                      ),
                      onTap: onLogOutClicked,
                    ),
                    new Divider(),
                    new SizedBox(
                      height: 20,
                    ),
                    (orderList.length + 3 == 3) ? new Text('لیست خرید شما خالی') : new Container(),
                  ],
                );
              }
              return new SizedBox(
                height: 135.0,
                child: new GestureDetector(
                  child: CustomListItem(
                  price: orderList[index - 3].product.price,
                  quantity: orderList[index - 3].quantity,
                  thumbnail: CachedNetworkImage(
                    imageUrl: orderList[index - 3].product.images[0].src,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => new Container(
                      color: Colors.red,
                      height: 200,
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: Icon(Icons.cloud_off),
                    ),
                  ),
                  title: '${orderList[index - 3].product.name}',
                ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
