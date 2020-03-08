import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:woocommerce/components/ApiProvider.dart';
import 'package:woocommerce/components/product_grid.dart';
import 'package:woocommerce/components/product_slider.dart';
import 'package:woocommerce/model/product.dart';

class CategoryPage extends StatefulWidget {
  final String catId;

  const CategoryPage({Key key, this.catId});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> with AutomaticKeepAliveClientMixin<CategoryPage> {
  int offset = 0;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<Product> bestSallerProductList = List();
  List<Product> recentProductsList = List();
  bool bestSallerHide = false;

  var queryStr = '?limit=10&is_popular=1&meta_key=total_sales';

  void _onRefresh() async {
    _loadBestSallerByCat();
    offset = 0;
    await (new ApiProvider()).getProducts(endPoint: "get_product?limit=10&cat=${widget.catId}&offset=0").then((List<Product> productList) {
      if (mounted && productList.length > 0) {
        recentProductsList.clear();
        offset += 10;
        setState(() {
          recentProductsList.addAll(productList);
        });
        _refreshController.refreshCompleted(resetFooterState: true);
      } else {
        _refreshController.refreshFailed();
      }
    });
  }

  void _onLoading() async {
    await (new ApiProvider()).getProducts(endPoint: "get_product?limit=10&cat=${widget.catId}&offset=$offset").then((List<Product> productList) {
      if (mounted && productList.length > 0) {
        offset += 10;
        setState(() {
          recentProductsList.addAll(productList);
        });
        _refreshController.loadComplete();
      } else {
        _refreshController.loadNoData();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.queryStr += '&cat=${widget.catId}';
    _loadBestSallerByCat();
    _onLoading();
  }

  @override
  void dispose() {
    super.dispose();
    // _onLoading();
    // _onRefresh();
    // _loadBestSallerByCat();
  }

  _loadBestSallerByCat() async {
    try {
      await (new ApiProvider()).getProducts(endPoint: "get_product$queryStr").then((List<Product> productList) {
        if (mounted && productList.length > 0) {
          bestSallerProductList.clear();
          setState(() {
            bestSallerHide = false;
            bestSallerProductList.addAll(productList);
          });
        } else {
          setState(() {
            bestSallerHide = true;
          });
        }
      });
    } catch (e) {
      print('error in _loadBestSallerByCat category.dart');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text("pull up load");
          } else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text("Load Failed! Click retry!");
          } else if (mode == LoadStatus.canLoading) {
            body = Text("Release to load more");
          } else {
            body = Text("No more Data");
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView.builder(
        itemCount: 2,
        itemBuilder: ((context, index) {
          if (index == 0) {
            return (bestSallerHide == false)
                ? ProductSlider(
                    height: 180,
                    sectionTag: 'part22',
                    products: this.bestSallerProductList,
                    title: 'پرفروش‌ها',
                  )
                : new Container(
                    child: new Text('NO Best Saller In This Category'),
                  );
          } else {
            return new ProductGrid(
              height: 0,
              products: this.recentProductsList,
              title: 'محصولات جدید',
            );
          }
        }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
