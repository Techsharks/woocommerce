class ProductCategory {
  final int id;
  String name;
  String slug;

  ProductCategory({this.id, this.name, this.slug});

  factory ProductCategory.fromJson(Map<String, dynamic> _catJson) {
    return ProductCategory(
      id: (_catJson['id'] != null) ? _catJson['id'] : 0,
      name: (_catJson['name'] != null) ? _catJson['name'] : null,
      slug: (_catJson['slug'] != null) ? _catJson['slug'] : null,
    );
  }
}
