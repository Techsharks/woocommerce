import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:woocommerce/database/product_provider.dart';
import 'package:woocommerce/model/product.dart';
import 'package:woocommerce/pages/single/image_perview.dart';
import 'package:woocommerce/tools/tools.dart';

import '../../home_page.dart';

class SingleProduct extends StatefulWidget {
  final Product product;

  const SingleProduct({Key key, this.product}) : super(key: key);

  @override
  _SingleProductState createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  PageController _pageController;
  int pageIndex = 1;
  Product _product;

  @override
  void initState() {
    super.initState();
    _pageController = new PageController(viewportFraction: 1.0);
    _pageController.addListener(_pageControllerListener);

    (new ProductProvider()).getSingleProduct(widget.product.id).then((Product singleProduct) {
      print('product_id $singleProduct');
      setState(() {
        _product = singleProduct;
      });
    });

    _loadCartShoppingList(reset: true);
  }

  _pageControllerListener() {
    setState(() {
      this.pageIndex = (_pageController.page.toInt() + 1);
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

  @override
  Widget build(BuildContext context) {
    return new Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          actions: <Widget>[
            new IconButton(
                icon: Icon(
                  (_product == null || _product.isFavorite == 0) ? Icons.favorite_border : Icons.favorite,
                ),
                onPressed: () {
                  (new ProductProvider()).saveToFavorite((_product != null) ? _product : widget.product, _product.isFavorite).then((int id) {
                    setState(() {
                      print('id: $id');
                      _product.isFavorite = id;
                    });
                  });
                }),
            new PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [
                  new PopupMenuItem(
                    child: new Container(
                      alignment: Alignment.bottomRight,
                      child: new Text('شریک با دوستان'),
                    ),
                  ),
                  new PopupMenuItem(
                    child: new Container(
                      alignment: Alignment.bottomRight,
                      child: new Text('اشتراک برنامه'),
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
        body: new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(top: 5),
                height: 200,
                child: new Stack(
                  children: <Widget>[
                    new PageView(
                      pageSnapping: true,
                      controller: _pageController,
                      children: List.generate(widget.product.images.length, (index) {
                        return new CachedNetworkImage(
                          imageUrl: widget.product.images[index].src,
                          imageBuilder: (context, imageProvider) => new GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => new ImagePreview(
                                    imageUrl: widget.product.images[index].src,
                                    product: widget.product,
                                    index: index,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Tools.prograssBar(),
                          errorWidget: (context, url, error) => new Container(
                            decoration: BoxDecoration(color: Colors.grey[400]),
                            child: Center(child: Icon(Icons.cloud_off)),
                          ),
                        );
                      }),
                    ),
                    (widget.product.images.length > 0) ? imageCounter() : new Container(height: 0, width: 0),
                  ],
                ),
              ),
              new Container(
                alignment: Alignment.topRight,
                padding: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 0),
                child: new Text(
                  '${widget.product.name}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              new Container(
                alignment: Alignment.topRight,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: new Row(
                  children: <Widget>[
                    new Icon(Icons.remove_red_eye, size: 16),
                    new SizedBox(
                      width: 5,
                    ),
                    new Text('${widget.product.wpb_post_views_count * 10}', style: TextStyle(fontSize: 12))
                  ],
                ),
              ),
              new Container(
                alignment: Alignment.topRight,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: new Text(
                  'قیمت : ${Tools.getCurrencySymbol()}${widget.product.price}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
              ),
              new Container(
                alignment: Alignment.topRight,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: new Text(
                  '${widget.product.short_description}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
              ),
              new Divider(
                color: Theme.of(context).accentColor,
              ),
              new Container(
                alignment: Alignment.topRight,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: new Text(
                  '${widget.product.description}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: new Container(
          height: 50,
          margin: EdgeInsets.only(bottom: 0),
          child: new RaisedButton(
            color: Theme.of(context).accentColor,
            child: new Text(
              'خرید',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              await (new ProductProvider()).addToCart(widget.product).then((insertId) {
                print('add to cart $insertId');
                _loadCartShoppingList(reset: true);
              });
            },
          ),
        ),
        floatingActionButton: GestureDetector(
          onTap: () {
            print('list cart');
          },
          child: new Container(
            height: 50,
            width: 50,
            alignment: Alignment.center,
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.blue,
            ),
            child: Tools.mBadge(GlobalCartCounter),
          ),
        ),
      ),
    );
  }

  Positioned imageCounter() {
    return new Positioned(
      left: 0,
      bottom: 0,
      child: new Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.9],
            colors: [
              Colors.grey[500],
              Colors.grey[500],
            ],
          ),
        ),
        child: new SizedBox(
          width: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Text(
                '$pageIndex/${widget.product.images.length}',
                style: TextStyle(color: Colors.white),
              ),
              new SizedBox(
                width: 5,
              ),
              new Icon(
                Icons.image,
                color: Colors.white,
                size: 18,
              )
            ],
          ),
        ),
      ),
    );
  }
}
