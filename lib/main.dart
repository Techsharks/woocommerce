import 'package:flutter/material.dart';
import 'package:woocommerce/pages/category_page.dart';
import 'package:woocommerce/pages/main_page/main_favorite.dart';
import 'package:woocommerce/pages/main_page/main_home.dart';
import 'package:woocommerce/pages/main_page/main_user.dart';
import 'package:woocommerce/tools/tools.dart';

import 'model/dynamicTabContent.dart';
import 'pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  TabController _tabControllerMenu;
  int _tabIndex = 0;

  MainHomePage _mainHomePage;
  List<DynamicTabContent> myList = new List();

  @override
  void initState() {
    super.initState();

    myList
        .add(new DynamicTabContent.name(title: 'Home', widget: new HomePage()));
    myList.add(new DynamicTabContent.name(
        title: 'Category', widget: new CategoryPage()));

    _mainHomePage = new MainHomePage();
    _tabController = new TabController(length: 3, vsync: this);
    _tabControllerMenu = new TabController(
      length: myList.length,
      vsync: _mainHomePage.createState(),
    );
    _tabController..addListener(_addListener);
  }

  _addListener() {
    print('index: ${_tabController.index}');
    setState(() {
      _tabIndex = _tabController.index;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.1,
        title: new Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          child: new TextField(
            decoration: new InputDecoration(
              hintStyle: new TextStyle(height: 0.8, fontSize: 13),
              border: new OutlineInputBorder(),
              hintText: 'Search...',
              focusedBorder: new OutlineInputBorder(
                  borderSide: new BorderSide(
                color: Colors.grey[400],
              )),
            ),
          ),
        ),
        leading: new IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.add_shopping_cart),
            onPressed: () {},
          )
        ],
        bottom: (this._tabIndex == 0)
            ? new PreferredSize(
                child: new Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  decoration: Tools.boxDecoration(),
                  child: new TabBar(
                    isScrollable: true,
                    controller: this._tabControllerMenu,
                    tabs: List.generate(this.myList.length, (index) {
                      return new Tab(text: this.myList[index].title);
                    }),
                  ),
                ),
                preferredSize: Size(double.infinity, 48),
              )
            : null,
      ),
      body: new TabBarView(
        controller: this._tabController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          new MainHomePage(
            myList: this.myList,
            tabController: this._tabControllerMenu,
          ),
          new MainFavoritePage(),
          new MainUserPage()
        ],
      ),
      bottomNavigationBar: new Card(
        margin: EdgeInsets.zero,
        elevation: 10,
        child: new TabBar(
          controller: this._tabController,
          tabs: <Widget>[
            new Tab(
              icon: new Icon(Icons.home),
            ),
            new Tab(
              icon: new Icon(Icons.favorite),
            ),
            new Tab(
              icon: new Icon(Icons.person),
            ),
          ],
        ),
      ),
    );
  }
}
