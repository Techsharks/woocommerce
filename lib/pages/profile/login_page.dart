import 'package:flutter/material.dart';
import 'package:woocommerce/components/ApiProvider.dart';
import 'package:woocommerce/home_page.dart';
import 'package:woocommerce/model/woo_user.dart';
import 'package:woocommerce/pages/profile/register_page.dart';
import 'package:woocommerce/tools/helper.dart';

class LoginPage extends StatefulWidget {
  var onLoginSuccess;

  LoginPage({Key key, this.onLoginSuccess}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var userInfo;
  String email = null;
  String pass = null;
  TextEditingController _controllerEmail = new TextEditingController();
  TextEditingController _controllerPass = new TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  String message = null;
  bool isLoging = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: new Form(
          key: _formKey,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new TextFormField(
                controller: _controllerEmail,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'ایمیل تان را وارد کنید';
                  }
                  return null;
                },
                decoration: new InputDecoration(icon: Icon(Icons.email), border: InputBorder.none, hintText: 'ایمیل'),
              ),
              new Divider(color: Colors.grey[900]),
              new TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'پسورد تان را وارد کنید';
                  }
                  return null;
                },
                controller: _controllerPass,
                decoration: new InputDecoration(icon: Icon(Icons.enhanced_encryption), border: InputBorder.none, hintText: 'پسورد'),
              ),
              new Divider(color: Colors.grey[900]),
              (this.message == null)
                  ? new Container()
                  : new Container(
                      child: new Text('${message}', style: TextStyle(color: Colors.red)),
                    ),
              (this.isLoging == true)
                  ? new CircularProgressIndicator()
                  : new GestureDetector(
                      onTap: () async {
                        setState(() {
                          this.message = null;
                        });
                        if (!_formKey.currentState.validate()) return;

                        print('login');
                        try {
                          setState(() {
                            this.isLoging = true;
                            this.message = null;
                          });
                          await (new ApiProvider()).LoginUser(email: this._controllerEmail.text.trim(), password: this._controllerPass.text).then((WooUser user) {
                            setState(() {
                              this.isLoging = false;
                              if (user.status == Helper.LOGIN_FAILED) {
                                this.message = 'ایمیل یا پسورد شما اشتباه می باشد';
                              } else if (user.status == Helper.LOGIN_SUCCESS) {
                                widget.onLoginSuccess();
                                setState(() {
                                  GlobalWooUser.status = Helper.LOGIN_SUCCESS;
                                });
                              }
                            });
                          });
                        } catch (e) {
                          print('eroor $e');
                          setState(() {
                            this.isLoging = false;
                            this.message = 'خطا در شبکه';
                            GlobalWooUser.status = Helper.LOGIN_FAILED;
                          });
                        }
                      },
                      child: new Container(
                        margin: EdgeInsets.only(top: 20),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue,
                        ),
                        child: new Text('ورود', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
              new GestureDetector(
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => new RegisterPage())).then((info) {
                    setState(() {
                      _controllerEmail.text = GlobalWooUser.user_email;
                      _controllerPass.text = GlobalWooUser.user_pass;
                    });
                  });
                },
                child: new Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: new Text('ایجاد حساب', style: TextStyle(fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          )),
    );
  }
}
