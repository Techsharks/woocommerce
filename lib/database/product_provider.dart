import 'package:flutter/rendering.dart';
import 'package:woocommerce/database/database_provider.dart';
import 'package:woocommerce/model/dynamicTabContent.dart';
import 'package:woocommerce/model/order.dart';
import 'package:woocommerce/model/product.dart';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:woocommerce/model/product_image.dart';
import 'package:woocommerce/model/woo_user.dart';
import 'package:woocommerce/pages/category.dart';
import 'dart:convert';

class ProductProvider extends DatabaseProvider {
  String _tableName = 'products';
  String _tableCategories = 'categories';
  String _tablePostCat = 'product_category';
  int thersholdPosts = 350;

  Future<Product> insert(Product product, {conflictAlgorithm: ConflictAlgorithm.replace}) async {
    // print(product.toMap().toString());
    product.id = await db.insert(_tableName, product.toMap(), conflictAlgorithm: conflictAlgorithm);
    return product;
  }

  Future<bool> insertAll(List<Product> product) async {
    await countPosts(deleteAlso: true);
    await Future.wait(product.map((product_item) async => await this.insert(product_item)));
    return true;
  }

  Future<Product> getSinglePost(int post_id) async {
    List<Map> maps = await db.rawQuery('SELECT p.*, IFNULL(f.post_id, 0) as isFavorite FROM posts as p left JOIN favorite as f ON p.id=f.post_id where p.id=$post_id');
//    print(maps.toList().toString());
    return Product.fromJson(maps[0]);
  }

  Future<bool> insertMenu(Map<String, dynamic> mapMenu) async {
    try {
      if (mapMenu.length > 0) await db.execute('DELETE FROM menu');
      await db.insert('menu', mapMenu, conflictAlgorithm: ConflictAlgorithm.replace);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> insertProductCat(Map<String, dynamic> mapData) async {
    await db.rawQuery('SELECT * FROM $_tablePostCat WHERE product_id= ${mapData['product_id']} AND cat_id=${mapData['cat_id']}').then((result) async {
      if (result.length <= 0) {
        await db.insert(_tablePostCat, mapData, conflictAlgorithm: ConflictAlgorithm.replace);
        // print('inserted product cat result[$result]');
        return true;
      }
    });
    return true;
  }

  Future<List<Product>> getProductsByCatOffline(int cat_id, {limit: 10, offest: 0}) async {
    await open();
    List<Map> maps = await db.rawQuery('''
        SELECT p.*
        FROM products as p
        INNER JOIN product_category as pc ON p.id = pc.product_id  WHERE pc.cat_id=$cat_id ORDER BY p.id DESC LIMIT $offest , $limit
        ''');
    List<Product> listProducts = [];
    maps.forEach((product) {
      listProducts.add(Product.fromJson(product));
    });

    return listProducts;
  }

  Future<List<Product>> getProductsOffline(int catId, {limit: 10, offest: 0}) async {
    await open();
    List<Map> maps = await db.rawQuery('''
        SELECT p.*
        FROM products as p
        INNER JOIN product_category as pc ON p.id = pc.product_id  WHERE pc.cat_id=$catId ORDER BY p.id DESC LIMIT $offest , $limit
        ''');
    List<Product> listProducts = [];
    maps.forEach((product) {
      List<ProductImage> productImageList = List();
      if (product['images'] != null && product['images'].length > 0) {
        json.decode(product['images']).forEach((img) {
          productImageList.add(new ProductImage.fromJson(img));
        });
      }

      listProducts.add(Product.fromJson(
        product,
        images: productImageList,
      ));
    });
    return listProducts;
  }

  Future<List<Product>> getBestSallerProductsOffline({int day: 700, limit: 10, offest: 0}) async {
    await open();
    List<Map> maps = await db.rawQuery('''
    SELECT p.* FROM products as p WHERE p.date_created > (SELECT DATETIME('now', '-$day day')) ORDER BY p.total_sales DESC LIMIT $offest,$limit
    ''');
    List<Product> listProducts = [];
    maps.forEach((product) {
      List<ProductImage> productImageList = List();
      if (product['images'] != null && product['images'].length > 0) {
        json.decode(product['images']).forEach((img) {
          productImageList.add(new ProductImage.fromJson(img));
        });
      }

      listProducts.add(Product.fromJson(
        product,
        images: productImageList,
      ));
    });
    return listProducts;
  }

  Future<List<Product>> getPopularProductsOffline({int day: 700, limit: 10, offest: 0}) async {
    await open();
    List<Map> maps = await db.rawQuery('''
    SELECT p.* FROM products as p WHERE p.date_created > (SELECT DATETIME('now', '-$day day')) ORDER BY p.wpb_post_views_count DESC LIMIT $offest,$limit
    ''');
    List<Product> listProducts = [];
    maps.forEach((product) {
      List<ProductImage> productImageList = List();
      if (product['images'] != null && product['images'].length > 0) {
        json.decode(product['images']).forEach((img) {
          productImageList.add(new ProductImage.fromJson(img));
        });
      }

      listProducts.add(Product.fromJson(
        product,
        images: productImageList,
      ));
    });
    await close();
    return listProducts;
  }

  Future<List<Product>> getFavoriteProductsOffline({limit: 10, offest: 0}) async {
    await open();
    List<Map> maps = await db.rawQuery('''
    SELECT p.*, IFNULL(f.product_id, 0) as isFavorite FROM products as p inner JOIN favorite as f ON p.id=f.product_id ORDER BY p.id LIMIT $offest, $limit
    ''');

    print('maps favorite: ${maps.length}');

    List<Product> listProducts = [];
    maps.forEach((product) {
      List<ProductImage> productImageList = List();
      if (product['images'] != null && product['images'].length > 0) {
        json.decode(product['images']).forEach((img) {
          productImageList.add(new ProductImage.fromJson(img));
        });
      }

      listProducts.add(Product.fromJson(
        product,
        images: productImageList,
      ));
    });

    await close();
    return listProducts;
  }

  Future<Product> getSingleProduct(int product_id) async {
    await open();
    List<Map> maps = await db.rawQuery('SELECT p.*, IFNULL(f.product_id, 0) as isFavorite FROM products as p left JOIN favorite as f ON p.id=f.product_id where p.id=$product_id');
    print('single product: ${maps.toList().toString()}');
    return Product.fromJson(maps[0]);
  }

  Future<int> saveToFavorite(Product product, int isFavorite) async {
    await open();
    int resualt = 0;
    if (isFavorite >= 1) {
      await db.rawDelete('DELETE FROM favorite WHERE product_id = ?', [product.id]).then((id) {
        print('removed from favorite product ID: $id');
        resualt = 0;
      });
    } else {
      await db.insert('favorite', {'product_id': product.id}, conflictAlgorithm: ConflictAlgorithm.replace).then((id) {
        print('added to favorite product ID: $id');
        resualt = 1;
      });
    }
    return resualt;
  }

  Future<int> countPosts({bool deleteAlso: false}) async {
    int count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $_tableName'));
    if (deleteAlso && count >= thersholdPosts) {
      print('thersholdPosts is $thersholdPosts: now deleteing old posts');
      bool d = await this.deleteDB();
      print('tables deleted successfully =>[$d]');
    }
    print('local posts: $count');
    return count;
  }

  Future<int> getCartCount() async {
    await open();
    int count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM cart'));
    print('cart count: $count');
    return count;
  }

  Future<int> addToCart(Product product) async {
    await open();
    int insertedID = 0;
    await db.insert('cart', {'product_id': product.id}).then((id) {
      print('product added to car RowID: $id');
      insertedID = id;
    });
    await close();
    return insertedID;
  }


  Future<int> removeFormCart(Product product) async {
    await open();
    int insertedID = 0;
    await db.insert('cart', {'product_id': product.id}).then((id) {
      print('product added to car RowID: $id');
      insertedID = id;
    });
    return insertedID;
  }
  

  Future<List<DynamicTabContent>> getMenuOffline({id: 1}) async {
    await open();
    List<Map> maps = await db.rawQuery('SELECT * FROM menu WHERE id=$id');
    List<DynamicTabContent> menu = List();
    if (maps.length > 0) {
      var responseBody = json.decode(maps[0]['menu']);
      await responseBody.forEach(
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
    }

    return menu;
  }

  Future<WooUser> saveWooUser(WooUser user) {
    return null;
  }

  Future<bool> deleteDB() async {
    try {
      print('try to delete db...');
      await open();
      await db.execute('DELETE FROM $_tableName');
      await db.execute('DELETE FROM categories');
      await db.execute('DELETE FROM product_category');
      await db.execute('DELETE FROM menu');
      await db.execute('DELETE FROM favorite');
      await open();
      return true;
    } catch (e) {
      print('error in deleteDatabase: ${e.toString()}');
    }
    return false;
  }

  Future<List<Order>> getOrdersOffline({int user_id}) async {
    await open();
    List<Map> maps = await db.rawQuery('''
    select p.*, count(p.id) as quantity, count( cast(p.price AS INTEGER) ) as total_per_item , c.id as order_id from cart as c inner join products as p on p.id = c.product_id group by c.product_id
    ''');

    print('maps getOrdersOffline: ${maps.length}');

    List<Order> orderList = List();

    maps.forEach((product) {
      List<ProductImage> productImageList = List();
      if (product['images'] != null && product['images'].length > 0) {
        json.decode(product['images']).forEach((img) {
          productImageList.add(new ProductImage.fromJson(img));
        });
      }

      orderList.add(
        new Order.fromJson(
          product,
          mProduct: Product.fromJson(product, images: productImageList),
        ),
      );
    });

    await close();

    return orderList;
  }
}
