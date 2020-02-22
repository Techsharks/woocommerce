import 'package:flutter/material.dart';
import 'package:woocommerce/model/dynamicTabContent.dart';

class MainHomePage extends StatefulWidget {
  TabController tabController;
  List<DynamicTabContent> myList;

  MainHomePage({this.tabController, this.myList});

  @override
  _MainHomePageState createState() => _MainHomePageState(tabController);
}

class _MainHomePageState extends State<MainHomePage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;

  _MainHomePageState(this._tabController);

  @override
  void initState() {
    super.initState();
  }

  TabController getTabController(){
    return widget.tabController;
  }

  @override
  Widget build(BuildContext context) {
    return new TabBarView(
      controller: widget.tabController,
      children: List.generate(widget.myList.length, (index) {
        return widget.myList[index].widget;
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
