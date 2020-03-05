import 'package:woocommerce/model/product.dart';

class Order {
  int id;
  Product product;
  int quantity;

  Order({this.id, this.product, this.quantity});

  factory Order.fromJson(Map<String, dynamic> _json, {Product mProduct}) {
    return Order(
      id: _json['order_id'],
      product: mProduct,
      quantity: _json['quantity']      
    );
  }
}
