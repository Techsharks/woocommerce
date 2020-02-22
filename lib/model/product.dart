import 'dart:convert';
import 'package:woocommerce/model/product_category.dart';
import 'package:woocommerce/model/product_image.dart';

class Product {
  int id;
  int total_sales;
  int download_limit;
  int download_expiry;
  int shipping_class_id;
  int rating_count;
  int parent_id;
  int wpb_post_views_count;
// bools
  int on_sale;
  int in_stock;
  int purchasable;
  int is_virtual;
  int downloadable;
  int manage_stock;
  int backorders_allowed;
  int backordered;
  int sold_individually;
  int shipping_required;
  int shipping_taxable;
  int reviews_allowed;
  int featured;

  String name;
  String slug;
  String permalink;
  String date_created;
  String date_created_gmt;
  String type;
  String status;
  String catalog_visibility;
  String description;
  String short_description;
  String sku;
  String price;
  String regular_price;
  String sale_price;
  String price_html;
  String external_url;
  String button_text;
  String tax_status;
  String stock_quantity;
  String backorders;
  String weight;
  String shipping_class;
  String average_rating;
  String purchase_note;

  // array && lists
  Map<String, dynamic> dimensions;
  List<int> related_ids;
  List<int> upsell_ids;
  List<int> cross_sell_ids;
  List<ProductCategory> categories;
  List<String> tags;
  List<ProductImage> images;
  String images4db;
  String categories4db;

  Product({
    this.id,
    this.wpb_post_views_count,
    this.total_sales,
    this.download_limit,
    this.download_expiry,
    this.shipping_class_id,
    this.rating_count,
    this.parent_id,
    this.on_sale,
    this.in_stock,
    this.purchasable,
    this.is_virtual,
    this.downloadable,
    this.manage_stock,
    this.backorders_allowed,
    this.backordered,
    this.sold_individually,
    this.shipping_required,
    this.shipping_taxable,
    this.reviews_allowed,
    this.featured,
    this.name,
    this.slug,
    this.permalink,
    this.date_created,
    this.date_created_gmt,
    this.type,
    this.status,
    this.catalog_visibility,
    this.description,
    this.short_description,
    this.sku,
    this.price: '0',
    this.regular_price,
    this.sale_price,
    this.price_html,
    this.external_url,
    this.button_text,
    this.tax_status,
    this.stock_quantity,
    this.backorders,
    this.weight,
    this.shipping_class,
    this.average_rating,
    this.purchase_note,
    this.dimensions,
    this.related_ids,
    this.upsell_ids,
    this.cross_sell_ids,
    this.categories,
    this.tags,
    this.images,
    this.images4db,
    this.categories4db,
  });

  factory Product.fromJson(
    Map<String, dynamic> _json, {
    List<ProductImage> images: const [],
    List<ProductCategory> categories: const [],
    List<String> tags: const [],
    List<int> related_ids: const [],
    List<int> upsell_ids: const [],
    List<int> cross_sell_ids: const [],
    String images4db: null,
    String categories4db: null,
  }) {
    return Product(
      // integers
      id: (_json['id'] != null) ? _json['id'] : 0,
      total_sales: (_json['total_sales'] != null) ? _json['total_sales'] : 0,
      download_limit: (_json['download_limit'] != null) ? _json['download_limit'] : 0,
      download_expiry: (_json['download_expiry'] != null) ? _json['download_expiry'] : 0,
      shipping_class_id: (_json['shipping_class_id'] != null) ? _json['shipping_class_id'] : 0,
      rating_count: (_json['rating_count'] != null) ? _json['rating_count'] : 0,
      parent_id: (_json['parent_id'] != null) ? _json['parent_id'] : 0,
      wpb_post_views_count: (_json['wpb_post_views_count'] != null) ? _json['wpb_post_views_count'] : 0,

      // booleans
      featured: (_json['featured'] != null) ? _json['featured'] : 0,
      on_sale: (_json['on_sale'] != null) ? _json['on_sale'] : 0,
      purchasable: (_json['purchasable'] != null) ? _json['purchasable'] : 0,
      is_virtual: (_json['is_virtual'] != null) ? _json['is_virtual'] : 0,
      downloadable: (_json['downloadable'] != null) ? _json['downloadable'] : 0,
      manage_stock: (_json['manage_stock'] != null) ? _json['manage_stock'] : 0,
      in_stock: (_json['in_stock'] != null) ? _json['in_stock'] : 0,
      backorders_allowed: (_json['backorders_allowed'] != null) ? _json['backorders_allowed'] : 0,
      backordered: (_json['backordered'] != null) ? _json['backordered'] : 0,
      sold_individually: (_json['sold_individually'] != null) ? _json['sold_individually'] : 0,
      shipping_required: (_json['shipping_required'] != null) ? _json['shipping_required'] : 0,
      shipping_taxable: (_json['shipping_taxable'] != null) ? _json['shipping_taxable'] : 0,
      reviews_allowed: (_json['reviews_allowed'] != null) ? _json['reviews_allowed'] : 0,

      // strings
      name: (_json['name'] != null) ? _json['name'] : null,
      slug: (_json['slug'] != null) ? _json['slug'] : null,
      permalink: (_json['permalink'] != null) ? _json['permalink'] : null,
      date_created: (_json['date_created'] != null) ? _json['date_created'] : null,
      date_created_gmt: (_json['date_created_gmt'] != null) ? _json['date_created_gmt'] : null,
      type: (_json['type'] != null) ? _json['type'] : null,
      status: (_json['status'] != null) ? _json['status'] : null,
      catalog_visibility: (_json['catalog_visibility'] != null) ? _json['catalog_visibility'] : null,
      description: (_json['description'] != null) ? _json['description'] : null,
      short_description: (_json['short_description'] != null) ? _json['short_description'] : null,
      sku: (_json['sku'] != null) ? _json['sku'] : null,
      price: (_json['price'] != null) ? showPrice(_json['price']) : null,
      regular_price: (_json['regular_price'] != null) ? _json['regular_price'] : null,
      sale_price: (_json['sale_price'] != null) ? _json['sale_price'] : null,
      price_html: (_json['price_html'] != null) ? _json['price_html'] : null,
      external_url: (_json['external_url'] != null) ? _json['external_url'] : null,
      button_text: (_json['button_text'] != null) ? _json['button_text'] : null,
      tax_status: (_json['tax_status'] != null) ? _json['tax_status'] : null,
      stock_quantity: (_json['stock_quantity'] != null) ? _json['stock_quantity'] : null,
      backorders: (_json['backorders'] != null) ? _json['backorders'] : null,
      weight: (_json['weight'] != null) ? _json['weight'] : null,
      shipping_class: (_json['shipping_class'] != null) ? _json['shipping_class'] : null,
      average_rating: (_json['average_rating'] != null) ? _json['average_rating'] : null,
      purchase_note: (_json['purchase_note'] != null) ? _json['purchase_note'] : null,

      dimensions: {'d': _json['dimensions']},
      related_ids: related_ids,
      upsell_ids: upsell_ids,
      cross_sell_ids: cross_sell_ids,
      categories: categories,
      tags: tags,
      images: images,
      images4db: images4db,
      categories4db: categories4db,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'total_sales': total_sales,
      'download_limit': download_limit,
      'download_expiry': download_expiry,
      'shipping_class_id': shipping_class_id,
      'rating_count': rating_count,
      'parent_id': parent_id,
      'wpb_post_views_count': wpb_post_views_count,
      'featured': featured,
      'on_sale': on_sale,
      'purchasable': purchasable,
      'is_virtual': is_virtual,
      'downloadable': downloadable,
      'manage_stock': manage_stock,
      'in_stock': in_stock,
      'backorders_allowed': backorders_allowed,
      'backordered': backordered,
      'sold_individually': sold_individually,
      'shipping_required': shipping_required,
      'shipping_taxable': shipping_taxable,
      'reviews_allowed': reviews_allowed,
      'name': name,
      'slug': slug,
      'permalink': permalink,
      'date_created': date_created,
      'date_created_gmt': date_created_gmt,
      'type': type,
      'status': status,
      'catalog_visibility': catalog_visibility,
      'description': description,
      'short_description': short_description,
      'sku': sku,
      'price': price,
      'regular_price': regular_price,
      'sale_price': sale_price,
      'price_html': price_html,
      'external_url': external_url,
      'button_text': button_text,
      'tax_status': tax_status,
      'stock_quantity': stock_quantity,
      'backorders': backorders,
      'weight': weight,
      'shipping_class': shipping_class,
      'average_rating': average_rating,
      'purchase_note': purchase_note,
      'dimensions': json.encode('${dimensions}'),
      'related_ids': json.encode('${related_ids}'),
      'upsell_ids': json.encode('${upsell_ids}'),
      'cross_sell_ids': json.encode('${cross_sell_ids}'),
      'categories': json.encode('${categories4db}'),
      'tags': json.encode('${tags}'),
      'images': images4db,

      // json.encode(_json['photos'])
    };
  }
}

String showPrice(String _price) {
  if (_price.length > 0) {
    return _price;
  } else {
    return '0';
  }
}
