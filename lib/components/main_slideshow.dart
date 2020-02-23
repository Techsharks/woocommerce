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
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Tools.boxDecoration(),
      padding: EdgeInsets.only(bottom: 4),
      child: CarouselSlider(
        height: widget.height,
        aspectRatio: 2.0,
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
                      // new Container(
                      //   padding: EdgeInsets.only(
                      //       top: 20, bottom: 25, right: 10, left: 10),
                      //   width: MediaQuery.of(context).size.width,
                      //   decoration: BoxDecoration(
                      //       gradient: LinearGradient(
                      //     begin: Alignment.topCenter,
                      //     end: Alignment.bottomCenter,
                      //     colors: [
                      //       Colors.black.withOpacity(0.01),
                      //       Colors.black.withOpacity(0.6),
                      //       Colors.black.withOpacity(0.8),
                      //       Colors.black,
                      //     ],
                      //   )),
                      //   child: Text(
                      //     product.name,
                      //     maxLines: 3,
                      //     overflow: TextOverflow.ellipsis,
                      //     style: TextStyle(
                      //       color: Colors.white,
                      //       fontWeight: FontWeight.w700,
                      //       height: 1.3,
                      //       fontSize: 14,
                      //     ),
                      //   ),
                      // ),
                      // new Container(
                      //   padding:
                      //       EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      //   width: MediaQuery.of(context).size.width,
                      //   child: new Row(
                      //     children: <Widget>[
                      //       new Icon(
                      //         Icons.access_time,
                      //         color: Colors.white.withOpacity(0.7),
                      //         size: 10,
                      //       ),
                      //       new Padding(
                      //         padding: EdgeInsets.symmetric(
                      //             horizontal: 5, vertical: 2),
                      //         child: new Text(
                      //           product.date_created,
                      //           style: TextStyle(
                      //               color: Colors.white.withOpacity(0.7),
                      //               fontSize: 11),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
