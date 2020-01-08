import 'package:flutter/material.dart';
import 'package:woocommerce/model/dynamicTabContent.dart';

class MainHomePage extends StatefulWidget {
  TabController tabController;
  List<DynamicTabContent> myList;

  MainHomePage({this.tabController, this.myList});

  @override
  _MainHomePageState createState() => _MainHomePageState(tabController);
}

class _MainHomePageState extends State<MainHomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  _MainHomePageState(this._tabController);

  @override
  void initState() {
    super.initState();
  }

  TabController getTabController() {
    return widget.tabController;
  }

  @override
  Widget build(BuildContext context) {
    return new TabBarView(
      controller: this._tabController,
      children: List.generate(widget.myList.length, (index) {
        return new Container(
          child: new Center(
            child: new Text('${widget.myList[index].title}'),
          ),
        );
      }),
    );
  }
}
