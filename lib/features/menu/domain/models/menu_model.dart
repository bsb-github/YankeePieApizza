import 'package:flutter/material.dart';

class MenuModel {
  String icon;
  String? title;
  Function route;
  Widget? iconWidget;
  bool showActive;

  MenuModel({required this.icon, required this.title, required this.route, this.iconWidget, this.showActive = false});
}