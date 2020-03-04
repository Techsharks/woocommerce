// created by faiz
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:woocommerce/model/product.dart';
import 'package:woocommerce/pages/single/single_product.dart';
import 'package:woocommerce/tools/tools.dart';

class ProductGrid extends StatefulWidget {
  final String title;
  final List<Product> products;
  final double height;
  final String sectionTag;
  final contianer_padding;
  final double item_height;

  const ProductGrid({Key key, this.item_height: 200, this.title: 'product_grid', @required this.products, this.height: 0, this.sectionTag, this.contianer_padding: 10}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProductGridState();
}

class ProductGridState extends State<ProductGrid> {
  @override
  Widget build(BuildContext context) {
    return (widget.products.length > 0)
        ? new SizedBox(
            height: widget.height,
            child: new Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              decoration: Tools.boxDecoration(),
              child: Wrap(
                children: List.generate(widget.products.length + 1, (index) {
                  if (index == 0) {
                    return new Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        width: MediaQuery.of(context).size.width,
                        child: new Text(
                          '${widget.title}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ));
                  } else
                    return new GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => SingleProduct(
                              product: widget.products[index-1],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: (MediaQuery.of(context).size.width - widget.contianer_padding) / 2,
                        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                        // color: Colors.grey[300],
                        height: widget.item_height,
                        child: new Container(
                          color: Colors.white,
                          child: new Wrap(
                            children: <Widget>[
                              CachedNetworkImage(
                                imageUrl: widget.products[index - 1].images[0].src,
                                imageBuilder: (context, imageProvider) => Container(
                                  height: widget.item_height - 40,
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
                              new Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: new Text('${widget.products[index - 1].name}'),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                }),
              ),
            ),
          )
        : Tools.prograssBar();
  }
}
