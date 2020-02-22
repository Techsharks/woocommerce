import 'package:flutter/material.dart';

class DynamicTabContent {
  IconData icon;
  int id;
  String title;
  Widget widget;
  String object_id;

  DynamicTabContent.name({this.icon, this.title, this.widget, this.id, this.object_id});
}
