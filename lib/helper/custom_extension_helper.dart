import 'package:flutter/material.dart';
import 'package:flutter_restaurant/theme/custom_theme_colors.dart';

extension ContextInfo on BuildContext {


  //theme context
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  CustomThemeColors get customThemeColors => theme.extension<CustomThemeColors>()!;


  //scaffold context
  ScaffoldMessengerState get scaffoldMessengerState => ScaffoldMessenger.of(this);


  //media query context
  Size get size => MediaQuery.of(this).size;
  double get height => size.height;
  double get width => size.width;


}


extension StringMethods on String {

  String get png => 'assets/images.$this.png';
  String get pathUrl => '/$this';

  String get removeUnderScore => replaceAll('_', ' ');
  String get capitalFirstLetter => this[0].toUpperCase() + substring(1, length);

}


