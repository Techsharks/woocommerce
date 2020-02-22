// created by faiz
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

  static Container preloader({double height:140.00}) {
    return new Container(
      width: double.infinity,
      height: height,
      color: Colors.grey[200],
      child: Tools.prograssBar(),
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

/*

  new Container(
    height: 200.0,
    decoration: new BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.red,
            blurRadius: 25.0, // soften the shadow
            spreadRadius: 5.0, //extend the shadow
            offset: Offset(
              15.0, // Move to right 10  horizontally
              15.0, // Move to bottom 10 Vertically
            ),
          )
        ],
    );
    child: new Text("Hello world"),
);
*/

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
}
