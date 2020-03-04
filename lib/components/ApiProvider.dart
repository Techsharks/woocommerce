// created by faiz
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:woocommerce/database/product_provider.dart';
import 'package:woocommerce/home_page.dart';
import 'package:woocommerce/model/dynamicTabContent.dart';
import 'package:woocommerce/model/product.dart';
import 'package:woocommerce/model/product_category.dart';
import 'package:woocommerce/model/product_image.dart';
import 'package:woocommerce/model/woo_user.dart';
import 'package:woocommerce/pages/category.dart';
import 'package:woocommerce/tools/helper.dart';
import 'package:woocommerce/tools/tools.dart';
import "dart:core";
import 'WooCommerceAPI.dart';

class ApiProvider {
  // static final String baseUrl = 'https://afthinkroom.com/woo';
  static final String baseUrl = 'https://dos.af';
  static var header = {'Content-Type': 'application/json'};
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

  Future<WooUser> createUser(WooUser user) async {
    try {
      var userInfo = {
        'user_email': user.user_email,
        'user_pass': user.user_pass,
        'display_name': user.display_name,
      };
      print('saveing userInfo ${userInfo}');
      var response = await client.post('$baseUrl/wp-json/wc/v3/create_user', body: userInfo);

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        if (responseBody['status'] == Helper.CREATED) {
          GlobalWooUser = new WooUser.fromJson(responseBody);
        } else {
          GlobalWooUser.status = Helper.EXIST;
        }
      }
    } catch (e) {
      print('error in createing user ${e}');
    }
    
    return GlobalWooUser;
  }

  Future<WooUser> LoginUser({String email, String password}) async {
    try {
      var userInfo = {
        'email': email,
        'password': password,
      };
      var response = await client.post('$baseUrl/wp-json/wc/v3/login_customer', body: userInfo);

      var responseBody = json.decode(response.body);
      if (responseBody['status'] == Helper.LOGIN_SUCCESS) {
        GlobalWooUser = new WooUser.fromJson(responseBody);
        GlobalWooUser.user_pass = password;
        Tools.setCookieUserObject(GlobalWooUser).then((res) {
          print('local Saved user: $res');
        });
        print('login success info: ${GlobalWooUser.toMap()}');
      } else if (responseBody['status'] == Helper.LOGIN_FAILED) {
        GlobalWooUser = new WooUser(status: Helper.LOGIN_FAILED);
        print('login failed !');
      }
      return GlobalWooUser;
    } catch (e) {
      print('error in login ${e}');
      GlobalWooUser = new WooUser(status: Helper.INTERNET_CONNECTION_ERROR);
    }

    return GlobalWooUser;
  }
}
