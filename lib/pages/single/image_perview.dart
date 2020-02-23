import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:woocommerce/model/product.dart';
import 'package:woocommerce/tools/tools.dart';

class ImagePreview extends StatefulWidget {
  final Product product;
  final String imageUrl;
  final index;

  const ImagePreview({Key key, this.product, this.imageUrl, this.index}) : super(key: key);

  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  PageController _pageController;
  String title = ' ';
  @override
  void initState() {
    super.initState();
    _pageController = new PageController(initialPage: widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return new Directionality(
      textDirection: TextDirection.rtl,
      child: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: new Text(
            '$title',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          leading: new IconButton(
            icon: Icon((Platform.isIOS) ? Icons.arrow_back_ios : Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: new Container(
          color: Colors.black,
          child: PageView(
            controller: _pageController,
            children: List.generate(widget.product.images.length, (index) {
              return new CachedNetworkImage(
                imageUrl: widget.product.images[index].src,
                imageBuilder: (context, imageProvider) => PhotoView(
                  imageProvider: imageProvider,
                ),
                placeholder: (context, url) => new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[Tools.prograssBar()],
                ),
                errorWidget: (context, url, error) => Tools.preloader(),
              );
            }),
          ),
        ),
      ),
    );
  }
}
