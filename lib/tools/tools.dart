// created by faiz
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:woocommerce/home_page.dart';
import 'package:woocommerce/model/woo_user.dart';

class Tools {
  static Column prograssBar({double padding: 25}) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.all(padding),
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        )
      ],
    );
  }

  static Container preloader({double height: 140.00}) {
    return new Container(
      width: double.infinity,
      height: height,
      color: Colors.grey[200],
      child: Center(
        child: Tools.prograssBar(),
      ),
    );
  }

  static BoxDecoration boxDecoration({Color mColor: Colors.white}) {
    return BoxDecoration(
      boxShadow: <BoxShadow>[
        new BoxShadow(
          color: Colors.black54,
          blurRadius: 0,
          // offset: Offset(1, 0.0),
        )
      ],
      color: mColor,
    );
  }

  static TextDirection AppDirection({bool reverse: false}) {
    return (reverse ? TextDirection.ltr : TextDirection.rtl);
  }

  static Column prograssBar2({double padding: 25, int counter, int part}) {
    return (counter == part)
        ? new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.all(padding),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            ],
          )
        : new Column();
  }

  static mBadge(int counter) {
    return Badge(
      position: new BadgePosition(right: -15, top: -20),
      padding: EdgeInsets.all(8),
      showBadge: (counter == 0) ? false : true,
      animationType: BadgeAnimationType.slide,
      badgeContent: Text('$counter', style: TextStyle(color: Colors.white)),
      child: Icon(
        Icons.shopping_basket,
        color: Colors.white,
      ),
    );
  }

  static getCurrencySymbol() {
    return ' ؋ ';
  }

  static Future<bool> setCookieUser({String name, String field}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (field.isNotEmpty && name.isNotEmpty) {
      await prefs.setString(name, field);
      return true;
    }
    return false;
  }

  static Future<bool> setCookieUserObject(WooUser user) async {
    if (user != null) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_id', user.user_id);
        await prefs.setString('user_login', '${user.user_login}');
        await prefs.setString('user_pass', '${user.user_pass}');
        await prefs.setString('user_nicename', '${user.user_nicename}');
        await prefs.setString('first_name', '${user.first_name}');
        await prefs.setString('user_email', '${user.user_email}');
        await prefs.setString('user_url', '${user.user_url}');
        await prefs.setString('user_status', '${user.user_status}');
        await prefs.setString('display_name', '${user.display_name}');
        await prefs.setString('status', '${user.status}');
        await prefs.setString('password', '${user.user_pass}');
        await prefs.setString('avatar', '${user.avatar}');
      } catch (e) {
        print('error -> setCookieUserObject: $e');
        return false;
      }
    } else {
      print('object user is null');
    }
    return true;
  }

  static Future<WooUser> getCookieUserObject() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getInt('user_id') != null && prefs.getInt('user_id') > 0) {
        GlobalWooUser = new WooUser(
          user_id: prefs.getInt('user_id'),
          user_login: prefs.getString('user_login'),
          user_pass: prefs.getString('user_pass'),
          user_nicename: prefs.getString('user_nicename'),
          first_name: prefs.getString('first_name'),
          user_email: prefs.getString('user_email'),
          user_url: prefs.getString('user_url'),
          user_status: prefs.getString('user_status'),
          display_name: prefs.getString('display_name'),
          status: prefs.getString('status'),
          avatar: prefs.getString('avatar'),
        );
        return GlobalWooUser;
      }
    } catch (e) {
      print('error -> getCookieUserObject: $e');
      return null;
    }
    return null;
  }

  static Future<bool> isUserLogin() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getInt('user_id') != null && prefs.getInt('user_id') > 0) {
        await getCookieUserObject();
        return true;
      }
    } catch (e) {
      print('error -> isUserLogin: [${StackTrace.current}] $e');
      return false;
    }
    return false;
  }

  static Future<bool> userLogOut() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await getCookieUserObject();
    } catch (e) {
      print('error -> userLogOut: $e');
      return false;
    }
    return true;
  }
}
