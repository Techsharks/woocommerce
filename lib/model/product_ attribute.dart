class ProductAttribute {
  
  final int id;
  String name;
  int position;
  bool visible;
  List options;

  ProductAttribute({
    this.id,
    this.name,
    this.position,
    this.visible,
    this.options,
  });

  factory ProductAttribute.fromJson(
    Map<String, dynamic> attributeJson,
  ) {
    return ProductAttribute(
      id: attributeJson['id'],
      name: attributeJson['name'],
      position: attributeJson['position'],
      visible: attributeJson['visible'],
      options: attributeJson['options'],
    );
  }
}
