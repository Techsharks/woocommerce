import 'package:woocommerce/model/product.dart';

class Cart {
  final int id;
  int product_id;
  Product product;

  Cart({this.id, this.product_id, this.product});

  factory Cart.fromJson(Map<String, dynamic> _json) {
    return Cart(
      id: _json['id'],
      product_id: _json['product_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'product_id': product_id,
    };
  }
}
