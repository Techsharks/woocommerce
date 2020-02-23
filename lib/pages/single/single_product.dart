import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:woocommerce/model/product.dart';
import 'package:woocommerce/pages/single/image_perview.dart';
import 'package:woocommerce/tools/tools.dart';

class SingleProduct extends StatefulWidget {
  final Product product;

  const SingleProduct({Key key, this.product}) : super(key: key);

  @override
  _SingleProductState createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  PageController _pageController;
  int counter = 0;
  @override
  void initState() {
    super.initState();
    _pageController = new PageController(viewportFraction: 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return new Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: new AppBar(
          title: new Text('${widget.product.name}'),
          centerTitle: true,
        ),
        body: new Container(
          child: new Column(
            children: <Widget>[
              new Container(
                height: 200,
                child: PageView(
                  pageSnapping: false,
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
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    );
                  }),
                ),
              ),
              new Expanded(
                child: new Column(
                  children: <Widget>[
                    new Text('sjdfksd'),
                    new Text('sjdfksd'),
                    new Text('sjdfksd'),
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: new Container(
          margin: EdgeInsets.only(bottom: 10),
          child: new RaisedButton(
            color: Theme.of(context).accentColor,
            child: new Text(
              'خرید',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              setState(() {
                counter++;
              });
            },
          ),
        ),
        floatingActionButton: new Container(
          height: 40,
          width: 40,
          alignment: Alignment.center,
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.blue,
          ),
          child: Tools.mBadge(counter),
        ),
      ),
    );
  }
}
