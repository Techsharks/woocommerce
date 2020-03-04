// created by faiz
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:woocommerce/model/product.dart';
import 'package:woocommerce/pages/single/single_product.dart';
import 'package:woocommerce/tools/tools.dart';

class MainSlideshow extends StatefulWidget {
  final String title;
  final List<Product> products;
  final double height;
  final String sectionTag;

  const MainSlideshow({
    Key key,
    this.title,
    @required this.products,
    this.height: 200,
    this.sectionTag,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => MainSlideshowState();
}

class MainSlideshowState extends State<MainSlideshow> {
  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Tools.boxDecoration(),
      padding: EdgeInsets.only(bottom: 4),
      child: new Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          CarouselSlider(
            height: widget.height,
            // aspectRatio: 2.0,
            viewportFraction: 100.00,
            // initialPage: 0,
            // realPage: 10,
            // autoPlay: true,
            autoPlayCurve: Curves.slowMiddle,
            realPage: 20,
            onPageChanged: (index) {
              setState(() {
                activeIndex = index;
              });
              print('index $index');
            },
            items: widget.products.map((product) {
              return Builder(
                builder: (BuildContext context) {
                  return new GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => SingleProduct(
                            product: product,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration:const BoxDecoration(
                        border: Border(
                          // top: BorderSide(width: 1.0, color: Color(0xFFFFFFFFFF)),
                          left: BorderSide(width: 1.0, color: Color(0xFFFeeeee9)),
                          // right: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
                          // bottom: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 2, right: 2, top: 4),
                      child: new Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          new Hero(
                            tag: '${product.id}_${widget.sectionTag}',
                            child: CachedNetworkImage(
                              imageUrl: product.images[0].src,
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[Tools.prograssBar()],
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          new Container(
            height: 20,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.products.length, (index) {
                return new Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.5),
                  width: 8,
                  height: 8,
                  decoration: new BoxDecoration(color: (index == this.activeIndex) ? Theme.of(context).accentColor : Colors.black, borderRadius: BorderRadius.circular(50)),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
