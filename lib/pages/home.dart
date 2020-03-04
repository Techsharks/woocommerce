import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:woocommerce/components/ApiProvider.dart';
import 'package:woocommerce/components/main_slideshow.dart';
import 'package:woocommerce/components/product_grid.dart';
import 'package:woocommerce/components/product_slider.dart';
import 'package:woocommerce/database/product_provider.dart';
import 'package:woocommerce/model/product.dart';
import 'package:woocommerce/tools/tools.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> _productList = List();
  List<Product> _productList2 = List();
  List<Product> _productList3 = List();
  List<Product> _productList4 = List();

  int _offset = 0;

  Map<String, dynamic> _map = {
    'part1': {'title': 'سوپر مارکت ویژه', 'catId': 42, 'limit': 10, 'endpoint': '?limit=10&cat=42'},
    'part2': {'title': 'پربیننده‌ها', 'catId': 0, 'limit': 10, 'endpoint': '?limit=10&is_popular=1&meta_key=wpb_post_views_count'},
    'part3': {'title': 'پرفروش‌ها', 'catId': 0, 'limit': 10, 'endpoint': '?limit=10&is_popular=1&meta_key=total_sales'},
    'part4': {'title': 'محصولات ویژه', 'catId': 72, 'limit': 6, 'endpoint': '?limit=6&cat=72'},
  };

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    _getProducts();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  void _getProducts() async {
    var query = [_productList, _productList2, _productList3, _productList4];
    _getProductsOffline();
    for (int i = 0; i < 4; i++) {
      String endPoint = '${this._map['part${i + 1}']['endpoint']}';
      try {
        await (new ApiProvider()).getProducts(endPoint: "get_product$endPoint").then((List<Product> plist) {
          if (mounted && plist.length > 0) {
            _offset += 10;
            query[i].clear();
            setState(() {
              query[i].addAll(plist);
            });
          }
        });
      } catch (e) {
        print('part$i error: $e [pages/home.dart]');
        _getProduct('$endPoint', query[i]);
      }
    }
  }

  void _getProductsOffline() async {
    // slideshow offline
    await (new ProductProvider()).getProductsOffline(_map['part1']['catId']).then((List<Product> list) {
      if (mounted && list.length > 0) {
        _productList.clear();
        setState(() {
          _productList.addAll(list);
        });
      }
    });

    // part 2 offline
    await (new ProductProvider()).getPopularProductsOffline().then((List<Product> list) {
      if (mounted && list.length > 0) {
        _productList2.clear();
        setState(() {
          _productList2.addAll(list);
        });
      }
    });

    // part 3 offline
    await (new ProductProvider()).getBestSallerProductsOffline().then((List<Product> list) {
      if (mounted && list.length > 0) {
        _productList3.clear();
        setState(() {
          _productList3.addAll(list);
        });
      }
    });

    // part 4 offline (spaciel cat)
    await (new ProductProvider()).getProductsOffline(_map['part4']['catId']).then((List<Product> list) {
      if (mounted && list.length > 0) {
        _productList4.clear();
        setState(() {
          _productList4.addAll(list);
        });
      } else {
        // print('hahahha its coming null fuck you ---------- part ${_map['part4']['catId']}');
      }
    });
  }

  void _getProduct(String endPoint, List<Object> list) async {
    print('try to reload the[$endPoint] [pages/home.dart]');
    await (new ApiProvider()).getProducts(endPoint: 'get_product$endPoint').then((List<Product> plist) {
      if (mounted && plist.length > 0) {
        list.clear();
        setState(() {
          list.addAll(plist);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.grey[100],
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("بالا بکشید");
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("ناموفق. سعی دوباره ! ");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("رها کنید");
            } else {
              body = Text("تمام");
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
        child: myListView,
      ),
    );
  }

  get myListView => ListView.builder(
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return (this._productList.length > 0)
                ? MainSlideshow(
                    products: this._productList,
                    sectionTag: 'slideshow',
                  )
                : Tools.prograssBar();
          } else if (index == 1) {
            return ProductSlider(
              height: 180,
              sectionTag: 'part2',
              products: this._productList2,
              title: _map['part2']['title'],
            );
          } else if (index == 2) {
            return ProductSlider(
              height: 180,
              sectionTag: 'part3',
              products: this._productList3,
              title: _map['part3']['title'],
            );
          } else {
            return new ProductGrid(
              height: 680,
              products: this._productList4,
              title: this._map['part4']['title'],
            );
          }
        },
      );
}
