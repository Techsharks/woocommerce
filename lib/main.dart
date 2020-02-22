import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:woocommerce/tools/SharkLocalizations.dart';
import 'package:woocommerce/tools/tools.dart';
import 'home_page.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WooCommerce',
      onGenerateTitle: (BuildContext context) =>
          SharkLocalizations.of(context).title,
      localizationsDelegates: [
        const SharkLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [const Locale('en')],
      theme: ThemeData(
        primaryColor: Colors.white,
        fontFamily: 'IRANSans',
      ),
      home: Directionality(
        textDirection: Tools.AppDirection(),
        child: MyHomePage(),
      ),
    );
  }
}
