import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  Database db;
  String path;

  Future open({String dbName: 'sharks.db', versionDb: 2}) async {
    var databasesPath = await getDatabasesPath();
    path = join(databasesPath, dbName);

    //  print('databasesPath: $databasesPath');
     print('_path: $path');

    db = await openDatabase(path, version: versionDb,
        onCreate: (Database db, int version) async {
      await db.execute('''
                  create table products ( 
                      id integer primary key, 
                      total_sales integer,
                      download_limit integer,
                      download_expiry integer,
                      shipping_class_id integer,
                      rating_count integer,
                      parent_id integer,
                      wpb_post_views_count integer,
                      on_sale integer default 0,
                      in_stock integer default 0,
                      purchasable integer default 0,
                      is_virtual integer default 0,
                      downloadable integer default 0,
                      manage_stock integer default 0,
                      backorders_allowed integer default 0,
                      backordered integer default 0,
                      sold_individually integer default 0,
                      shipping_required integer default 0,
                      shipping_taxable integer default 0,
                      reviews_allowed integer default 0,
                      featured integer default 0,
                      name text,
                      slug text,
                      permalink text,
                      date_created text,
                      date_created_gmt text,
                      type text,
                      status text,
                      catalog_visibility text,
                      description text,
                      short_description text,
                      sku text,
                      price text,
                      regular_price text,
                      sale_price text,
                      price_html text,
                      external_url text,
                      button_text text,
                      tax_status text,
                      stock_quantity text,
                      backorders text,
                      weight text,
                      shipping_class text,
                      average_rating text,
                      purchase_note text,
                      dimensions text,
                      related_ids text,
                      upsell_ids text,
                      cross_sell_ids text,
                      categories text,
                      tags text,
                      images text)
                  ''');

      await db.execute('''
                  create table categories ( 
                      id integer primary key, 
                      title text)
                  ''');

      await db.execute('''
                  create table product_category ( 
                      id integer primary key autoincrement, 
                      product_id integer not null,
                      cat_id integer not null)
                  ''');

      await db.execute('''
                  create table menu (
                      id integer primary key,
                      menu text)
                  ''');

      await db.execute('''
                  create table favorite (
                      product_id integer primary key)
                  ''');
    });
  }

  Future close() async => db.close();

  Future<bool> drop() async {
    try {
      var databasesPath = await getDatabasesPath();
      String _path = join(databasesPath, 'sharks.db');
      deleteDatabase(_path);
      return true;
    } catch (e) {
      print('error in deleteDatabase: ${e.toString()}');
    }
    return false;
  }
}
