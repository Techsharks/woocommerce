import 'dart:math';

import 'package:flutter/material.dart';
import 'package:woocommerce/components/ApiProvider.dart';
import 'package:woocommerce/database/product_provider.dart';
import 'package:woocommerce/home_page.dart';
import 'package:woocommerce/model/woo_user.dart';
import 'package:woocommerce/tools/helper.dart';
import 'package:woocommerce/tools/text_input.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = new GlobalKey<FormState>();
  String _password;
  String _email;
  String _name;
  bool _loading = false;
  String message = null;
  Color _color = Colors.blue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: new AppBar(title: new Text('ایجاد حساب')),
        body: new SingleChildScrollView(
          child: new Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: new Form(
              key: _formKey,
              child: new Column(
                children: <Widget>[
                  TextInput(
                      icon: Icon(Icons.person_pin),
                      text: 'نام',
                      initialValue: 'faiz_' + '${(Random()).nextInt(100000)}',
                      onSaved: (name) {
                        GlobalWooUser.display_name = name;
                      }),
                  TextInput(
                    icon: Icon(Icons.email),
                    text: 'ایمیل',
                    initialValue: 'faiz_' + '${(Random()).nextInt(100000)}@sharks.af',
                    textInputType: TextInputType.emailAddress,
                    onSaved: (email) {
                      GlobalWooUser.user_email = email.trim();
                    },
                  ),
                  TextInput(
                    icon: Icon(Icons.lock),
                    text: 'پسورد',
                    initialValue: 'faiz@admin',
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'پسورد را وارد کنید';
                      } else if (value.length < 6) {
                        return 'پسورد کوتاه می باشد';
                      }
                      setState(() {
                        this._password = value;
                      });
                      return null;
                    },
                    onSaved: (password) {
                      GlobalWooUser.user_pass = password;
                    },
                  ),
                  TextInput(
                      icon: Icon(Icons.lock),
                      text: 'تکرار پسورد',
                      initialValue: 'faiz@admin',
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'تکرار پسورد را وارد کنید';
                        }
                        if (value != this._password) {
                          return 'پسورد باهم مطابقت ندارد';
                        }
                        return null;
                      }),
                  (this.message != null)
                      ? new Container(
                          padding: EdgeInsets.only(top: 15),
                          child: Text('${this.message}', style: TextStyle(color: this._color)),
                        )
                      : new Container(height: 0),
                  (!_loading)
                      ? GestureDetector(
                          child: new Container(
                            margin: EdgeInsets.only(top: 20),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blue[600],
                            ),
                            child: new Text('ایجاد حساب', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                          onTap: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              setState(() {
                                this._loading = true;
                                this.message = null;
                              });
                              try {
                                await (new ApiProvider()).createUser(GlobalWooUser).then((WooUser user) async {
                                  setState(() {
                                    this._loading = false;
                                    if (GlobalWooUser.status == Helper.CREATED) {
                                      this._color = Colors.green;
                                      this.message = 'حساب شما موفقانه ایجاد شد';
                                      Navigator.pop(context, {'status': true});
                                    } else if (GlobalWooUser.status == Helper.EXIST) {
                                      this._color = Colors.red;
                                      this.message = 'این حساب از قبل موجود است!';
                                    }
                                  });
                                });
                              } catch (e) {
                                setState(() {
                                  this._loading = false;
                                  this._color = Colors.red;
                                  this.message = 'خطا در شبکه !';
                                });
                              }
                            }
                          },
                        )
                      : new Container(margin: EdgeInsets.only(top: 20), child: new CircularProgressIndicator()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
