import 'package:flutter/material.dart';
import 'package:woocommerce/database/database_provider.dart';
import 'package:woocommerce/database/product_provider.dart';
import 'package:woocommerce/pages/cart_page.dart';
import 'package:woocommerce/pages/main_page/main_favorite.dart';
import 'package:woocommerce/pages/main_page/main_user.dart';
import 'package:woocommerce/tools/SharkLocalizations.dart';
import 'package:woocommerce/tools/tools.dart';
import 'components/ApiProvider.dart';
import 'model/dynamicTabContent.dart';
import 'model/woo_user.dart';
import 'pages/home.dart';
import 'pages/main_page/main_home.dart';

int GlobalCartCounter = 0;
WooUser GlobalWooUser = new WooUser();

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;
  TabController _tabControllerMenu;
  int _tabIndex = 0;

  MainHomePage _mainHomePage;
  List<DynamicTabContent> myList = new List();

  @override
  void initState() {
    super.initState();
    _initDatabase();
    myList.add(new DynamicTabContent.name(title: 'Home', widget: new HomePage()));
    // myList.add(new DynamicTabContent.name(
    //     title: 'Category', widget: new CategoryPage()));

    _mainHomePage = new MainHomePage();
    _tabController = new TabController(length: 3, vsync: this);
    _tabController..addListener(_addListener);

    _tabControllerMenu = new TabController(
      length: myList.length,
      vsync: _mainHomePage.createState(),
    );
    
  }

  _initDatabase() async {
    await (new DatabaseProvider()).open().then((value) {
      _getMenu();
      _loadCartShoppingList();
    });
  }

  _loadCartShoppingList({bool reset: false}) async {
    await (new ProductProvider()).getCartCount().then((int count) {
      setState(() {
        if (reset) {
          GlobalCartCounter = count;
        } else {
          GlobalCartCounter += count;
        }
      });
    });
  }

  _addListener() {
    print('index: ${_tabController.index}');
    setState(() {
      _tabIndex = _tabController.index;
    });
  }

  _getMenu() async {
    try {
      await (new ProductProvider()).getMenuOffline().then((List<DynamicTabContent> data) async {
        if (mounted && data.length > 0) {
          _setMenu(data);
        }
        await (new ApiProvider()).getMenu().then((List<DynamicTabContent> data2) {
          if (mounted && data2.length > 0) {
            _setMenu(data2);
          }
        });
      });
    } catch (e) {
      print('error in home_page.dart ${StackTrace.current}');
    }
  }

  _setMenu(List<DynamicTabContent> res) async {
    myList.clear();
    myList.add(new DynamicTabContent.name(title: SharkLocalizations.of(context).getString('home_tab_title'), widget: new HomePage()));
    myList.addAll(res);
    setState(() {
      _tabControllerMenu = new TabController(
        length: myList.length,
        vsync: _mainHomePage.createState(),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
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
              hintStyle: new TextStyle(height: 1.4, fontSize: 13),
              border: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: SharkLocalizations.of(context).getString('search'),
              focusedBorder: new OutlineInputBorder(
                borderSide: new BorderSide(
                  color: Colors.grey[200],
                ),
              ),
            ),
          ),
        ),
        leading: new IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => new CartPage()));
            },
            child: new Container(
              // padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.blue,
              ),
              child: Tools.mBadge(GlobalCartCounter),
            ),
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

  @override
  bool get wantKeepAlive => true;
}
