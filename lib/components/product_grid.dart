// created by faiz
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:woocommerce/model/product.dart';
import 'package:woocommerce/tools/tools.dart';

class ProductGrid extends StatefulWidget {
  final String title;
  final List<Product> products;
  final double height;
  final String sectionTag;

  const ProductGrid({
    Key key,
    this.title: 'product_grid',
    @required this.products,
    this.height: 0,
    this.sectionTag,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProductGridState();
}

class ProductGridState extends State<ProductGrid> {
  @override
  Widget build(BuildContext context) {
    return (widget.products.length > 0)
        ? new SizedBox(
            height: (widget.height > 0) ? widget.height : widget.products.length * 110.6666666667,
            child: new Container(
              margin: EdgeInsets.only(
                top: 10,
              ),
              padding: EdgeInsets.only(bottom: 4, right: 10, left: 10),
              decoration: Tools.boxDecoration(),
              child: new Column(
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.only(bottom: 5),
                    alignment: Alignment.bottomRight,
                    height: 30,
                    child: new Text(
                      '${widget.title}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  new Expanded(
                      child: new GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    children: List.generate(widget.products.length, (index) {
                      return new Container(
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        child: new Column(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: CachedNetworkImage(
                                height: 50,
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
                                    Tools.preloader(height: 100),
                                  ],
                                ),
                                errorWidget: (context, url, error) => Center(
                                  child: Icon(Icons.cloud_off),
                                ),
                              ),
                            ),
                            new Expanded(
                                child: new Text(
                              '${widget.products[index].name}',
                              style: TextStyle(),
                              textAlign: TextAlign.center,
                            ))
                          ],
                        ),
                      );
                    }),
                  ))
                ],
              ),
            ),
          )
        : Tools.prograssBar();
  }
}
