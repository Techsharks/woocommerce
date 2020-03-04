import 'package:flutter/material.dart';
import 'package:woocommerce/home_page.dart';
import 'package:woocommerce/model/product.dart';
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
  List<Product> productList = new List();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (GlobalWooUser.status != null && GlobalWooUser.status == Helper.LOGIN_SUCCESS) {
      return UserProfileInfo();
    } else {
      return new LoginPage(
        onLoginSuccess: () {
          setState(() {
            GlobalWooUser.status = Helper.LOGIN_SUCCESS;
          });
        },
      );
    }
  }

  Widget UserProfileInfo() {
    return new SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: new Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: new ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: productList.length + 3,
            itemBuilder: (context, index) {
              if (index == 0) {
                return new Column(
                  children: <Widget>[
                    Container(
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
                      onTap: () async {
                        print('loging out');
                        await Tools.userLogOut().then((res) {
                          if (res) {
                            print('logouted successfully');
                            setState(() {
                              GlobalWooUser.status = Helper.LOGIN_FAILED;
                            });
                          } else {
                            print('not success loging out');
                          }
                        });
                      },
                    ),
                    new Divider(),
                    new SizedBox(
                      height: 20,
                    ),
                    (productList.length + 3 == 3) ? new Text('لیست خرید شما خالی') : new Container(),
                  ],
                );
              }
              return new ListTile(
                title: new Text('Itme ${index - 3}'),
                subtitle: new Text('${index + 20}'),
              );
            },
          ),
        ),
      ),
    );
  }
}
