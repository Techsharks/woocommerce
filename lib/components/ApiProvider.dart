// created by faiz
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:woocommerce/database/product_provider.dart';
import 'package:woocommerce/model/dynamicTabContent.dart';
import 'package:woocommerce/model/product.dart';
import 'package:woocommerce/model/product_category.dart';
import 'package:woocommerce/model/product_image.dart';
import 'package:woocommerce/pages/category.dart';
import "dart:core";
import 'WooCommerceAPI.dart';

class ApiProvider {
  // static final String baseUrl = 'https://afthinkroom.com/woo';
  static final String baseUrl = 'https://dos.af';
  var client = new http.Client();
  ProductProvider db = new ProductProvider();

  WooCommerceAPI wc_api = new WooCommerceAPI(
    '$baseUrl',
    // "ck_e7c63273af43d68f821e52169f11b1af8f905e18",
    // "cs_86502e3532603ffc194e19a277df99b33509c2b6",
    "ck_dfeeea43b87f788f717a6b75cbf5267f355f662a",
    "cs_efed92186bbf9a4f8189fb0779b289a10d39931a",
  );

  Future<List<DynamicTabContent>> getMenu({String name: 'mobile_menu'}) async {
    var response = await client.get('$baseUrl/wp-json/wp/v2/menus/$name');
    var responseBody = json.decode(response.body);

    List<DynamicTabContent> menu = List();
    responseBody.forEach(
      (item) {
        menu.add(
          new DynamicTabContent.name(
            title: item['title'],
            id: item['ID'],
            object_id: item['object_id'],
            widget: new CategoryPage(catId: item['object_id']),
          ),
        );
      },
    );

    try {
      await db.open();
      await db.insertMenu({'id': 1, 'menu': json.encode(responseBody)});
    } catch (e) {
      print('erorr in inserting menu ApiProvider.dart[${StackTrace.current}]');
    }
    return menu;
  }

  Future<List<Product>> getProducts({String endPoint: 'products'}) async {
    var response = await wc_api.getAsync('$endPoint');
    // print('response =>: $response');

    List<Product> productList = List();
    await db.open();

    await response.forEach((product) async {
      // get product category
      List<ProductCategory> productCategoryList = List();
      String categories4db = json.encode(product['categories']);
      if (product['categories'] != null && product['categories'].length > 0)
        await product['categories'].forEach((catItme) async {
          productCategoryList.add(new ProductCategory.fromJson(catItme));
          await db.insertProductCat({
            'product_id': product['id'],
            'cat_id': catItme['id'],
          });
        });

      // get product images
      List<ProductImage> productImageList = List();
      String images4db = json.encode(product['images']);
      if (product['images'] != null && product['images'].length > 0)
        product['images'].forEach((img) {
          productImageList.add(new ProductImage.fromJson(img));
        });

      // get product
      productList.add(new Product.fromJson(
        product,
        images: productImageList,
        categories: productCategoryList,
        tags: [],
        related_ids: [],
        upsell_ids: [],
        cross_sell_ids: [],
        images4db: images4db,
        categories4db: categories4db,
      ));
    });

    if (productList.length > 0) await db.insertAll(productList);

    print('done all');
    return productList;
  }
}
