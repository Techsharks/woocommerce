class ProductImage {
  final int id;
  String src;
  String src_small;
  String src_large;
  String name;

  ProductImage({this.id, this.name, this.src, this.src_large, this.src_small});

  factory ProductImage.fromJson(Map<String, dynamic> _json) {
    return ProductImage(
      id: _json['id'],
      src: _json['src'],
      name: _json['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'src': src,
      'name': name,
    };
  }
}
