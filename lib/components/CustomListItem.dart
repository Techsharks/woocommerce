import 'package:flutter/material.dart';
import 'package:woocommerce/tools/tools.dart';

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    this.thumbnail,
    this.title,
    this.price,
    this.quantity,
    this.onRemoveClick,
    this.onAddClick,
  });

  final Widget thumbnail;
  final String title;
  final String price;
  final int quantity;
  final onRemoveClick;
  final onAddClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(flex: 2, child: thumbnail),
          Expanded(
              flex: 4,
              child: _ProductDescription(
                title: title,
                price: price,
                quantity: quantity,
                onAddClick: this.onAddClick,
                onRemoveClick: this.onRemoveClick,
              )),
          // const Icon(Icons.more_vert, size: 16.0),
        ],
      ),
    );
  }
}

class _ProductDescription extends StatelessWidget {
  const _ProductDescription({Key key, this.title, this.price, this.quantity, this.onAddClick, this.onRemoveClick}) : super(key: key);

  final String title;
  final String price;
  final int quantity;
  final onRemoveClick;
  final onAddClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(1.0, 0.0, 10.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0)),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text('${Tools.getCurrencySymbol()}${price}', style: const TextStyle(fontSize: 10.0)),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              (quantity != null && quantity > 0) ? Text('تعداد : $quantity', style: const TextStyle(fontSize: 10.0)) : new Container(),
              (onRemoveClick != null && onAddClick != null)
                  ? new Row(
                      children: <Widget>[
                        new IconButton(icon: Icon(Icons.remove), onPressed: this.onRemoveClick),
                        new IconButton(icon: Icon(Icons.add), onPressed: this.onAddClick),
                      ],
                    )
                  : new Container()
            ],
          ),
        ],
      ),
    );
  }
}
