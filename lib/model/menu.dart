class MenuModel {
  final int id;
  String title;
  String type;

  MenuModel({this.id, this.title, this.type});

  factory MenuModel.fromJson(Map<String, dynamic> _json) {
    return MenuModel(
      id: _json['ID'],
      title: _json['title'],
      type: _json['type'],
    );
  }
}
