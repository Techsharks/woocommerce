import 'package:flutter/material.dart';

class DynamicTabContent {
  IconData icon;
  int id;
  String title;
  Widget widget;

  DynamicTabContent.name({this.icon, this.title, this.widget, this.id});
}
