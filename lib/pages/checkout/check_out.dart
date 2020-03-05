import 'package:flutter/material.dart';
import 'package:woocommerce/tools/text_input.dart';
import 'package:woocommerce/tools/tools.dart';

class CheckOutPage extends StatefulWidget {
  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  final _formKey = GlobalKey<FormState>();
  Widget messageWidget = Container();
  bool _isButtonDisabled = false;

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
                  TextInput(icon: Icon(Icons.person), text: 'نام'),
                  TextInput(icon: Icon(Icons.person_pin), text: 'تخلص'),
                  TextInput(icon: Icon(Icons.place), text: 'ادرس ۱'),
                  TextInput(icon: Icon(Icons.place), text: 'ادرس ۲', isRequired: false),
                  TextInput(icon: Icon(Icons.location_city), text: 'شهر', isRequired: false),
                  TextInput(icon: Icon(Icons.email), text: 'ایمیل'),
                  TextInput(icon: Icon(Icons.phone), text: 'شماره تماس'),
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
      onPressed: (this._isButtonDisabled) ? null:  () {
        if (_formKey.currentState.validate()) {
          setState(() {
            _isButtonDisabled = true;
          });
        } else {
          setState(() {
            // messageWidget = new CircularProgressIndicator();
          });
        }
      },
    );
  }
}
