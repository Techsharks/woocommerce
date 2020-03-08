import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:woocommerce/components/ApiProvider.dart';
import 'package:woocommerce/database/product_provider.dart';
import 'package:woocommerce/home_page.dart';
import 'package:woocommerce/model/order.dart';
import 'package:woocommerce/model/product.dart';
import 'package:woocommerce/model/woo_user.dart';
import 'package:woocommerce/tools/text_input.dart';
import 'package:woocommerce/tools/tools.dart';

class CheckOutPage extends StatefulWidget {
  final List<Order> orderList;

  const CheckOutPage({Key key, @required this.orderList}) : super(key: key);

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  final _formKey = GlobalKey<FormState>();
  Widget messageWidget = Container();
  bool _isButtonDisabled = false;
  Billing _billing = new Billing();
  @override
  void initState() {
    super.initState();

    Tools.getCookieUserObject();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: new AppBar(
          title: new Text('تصفیه حساب'),
          centerTitle: true,
        ),
        body: new SingleChildScrollView(
          child: new Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: new Form(
              key: _formKey,
              child: new Column(
                children: <Widget>[
                  TextInput(
                    initialValue: GlobalWooUser.display_name,
                    textInputType: TextInputType.text,
                    icon: Icon(Icons.person),
                    text: 'نام',
                    onSaved: (value) {
                      this._billing.first_name = value;
                    },
                  ),
                  TextInput(
                    textInputType: TextInputType.text,
                    icon: Icon(Icons.person_pin),
                    text: 'تخلص',
                    onSaved: (value) {
                      this._billing.last_name = value;
                    },
                  ),
                  TextInput(
                    initialValue: 'kabul kart-e-char',
                    icon: Icon(Icons.place),
                    text: 'ادرس ۱',
                    onSaved: (value) {
                      this._billing.address_1 = value;
                    },
                  ),
                  TextInput(
                    icon: Icon(Icons.place),
                    text: 'ادرس ۲',
                    isRequired: false,
                    onSaved: (value) {
                      this._billing.address_2 = value;
                    },
                  ),
                  TextInput(
                    initialValue: 'kabul',
                    icon: Icon(Icons.location_city),
                    text: 'شهر',
                    isRequired: false,
                    onSaved: (value) {
                      this._billing.city = value;
                    },
                  ),
                  TextInput(
                    initialValue: GlobalWooUser.user_email,
                    textInputType: TextInputType.emailAddress,
                    icon: Icon(Icons.email),
                    text: 'ایمیل',
                    onSaved: (value) {
                      this._billing.email = value;
                    },
                  ),
                  TextInput(
                    initialValue: '0793523024',
                    textInputType: TextInputType.phone,
                    icon: Icon(Icons.phone),
                    text: 'شماره تماس',
                    onSaved: (value) {
                      this._billing.phone = value;
                    },
                  ),
                  new SizedBox(height: 10),
                  messageWidget,
                  new Container(
                    margin: EdgeInsets.only(top: 10),
                    width: MediaQuery.of(context).size.width,
                    child: button(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  button() {
    return RaisedButton(
      textColor: Colors.white,
      color: Colors.blue,
      splashColor: Colors.red,
      elevation: 0,
      child: new Text('ثبت سفارش'),
      onPressed: (this._isButtonDisabled) ? null : onSavedClicked,
    );
  }

  onSavedClicked() async {
    _formKey.currentState.save();
    List<Map<dynamic, dynamic>> ids = List();

    widget.orderList.forEach((order) {
      ids.add(order.toMap());
    });

    // print('products: ${json.encode(ids)}');
    // print('billing: ${json.encode(this._billing.toMap())}');

    if (_formKey.currentState.validate()) {
      setState(() {
        _isButtonDisabled = true;
        messageWidget = new CircularProgressIndicator();
      });

      await (new ApiProvider()).createOrder(ids: json.encode(ids), billing: json.encode(this._billing.toMap())).then((status) {
        if (status) {
          setState(() {
            _isButtonDisabled = true;
            messageWidget = new Container(child: new Text('سفارش شما موفقانه ثبت شد', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)));
            updateCartTable();
          });
        } else {
          setState(() {
            _isButtonDisabled = false;
            messageWidget = new Container(child: new Text('ناموفق . خطا در شبکه .', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)));
          });
        }
      });
    }
  }

  updateCartTable() async {
    await (new ProductProvider()).setOrderedProducts(GlobalCartCounter).then((status) {
      setState(() {
        GlobalCartCounter = 0;
      });
    });
  }
}
