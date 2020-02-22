// created by faiz
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:woocommerce/model/product.dart';
import 'package:woocommerce/tools/tools.dart';

class ProductSlider extends StatefulWidget {
  final String title;
  final List<Product> products;
  final double height;
  final String sectionTag;

  const ProductSlider({
    Key key,
    this.title: 'product_slider',
    @required this.products,
    this.height: 200,
    this.sectionTag,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProductSliderState();
}

class ProductSliderState extends State<ProductSlider> {
  @override
  Widget build(BuildContext context) {
    return (widget.products.length > 0)
        ? Container(
            margin: EdgeInsets.only(
              top: 10,
            ),
            padding: EdgeInsets.only(bottom: 4, right: 10, left: 10),
            decoration: Tools.boxDecoration(),
            child: new Column(
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.topRight,
                  child: new Text(
                    '${widget.title}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: widget.height,
                  child: new ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 2, right: 2),
                              padding: EdgeInsets.only(top: 5),
                              width: 150,
                              child: Hero(
                                tag: '${widget.products[index].id}_${widget.sectionTag}',
                                child: CachedNetworkImage(
                                  imageUrl: widget.products[index].images[0].src,
                                  imageBuilder: (context, imageProvider) => Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => new Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Tools.preloader(),
                                    ],
                                  ),
                                  errorWidget: (context, url, error) => Center(
                                    child: Icon(Icons.cloud_off),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          new Text(' ؋ ${widget.products[index].price} - ${widget.products[index].id}')
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          )
        : Tools.prograssBar();
  }
}
