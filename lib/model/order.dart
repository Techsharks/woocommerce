import 'package:woocommerce/model/product.dart';

class Order {
  int id;
  Product product;
  int quantity;
  int total_per_item;

  Order({this.id, this.product, this.quantity, this.total_per_item});

  factory Order.fromJson(Map<String, dynamic> _json, {Product mProduct}) {
    return Order(
      id: _json['order_id'],
      product: mProduct,
      quantity: _json['quantity'],
      total_per_item: _json['total_per_item'],
    );
  }
}
