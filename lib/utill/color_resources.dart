import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ColorResources {
  static Color getSearchBg(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme
        ? const Color(0xFF585a5c)
        : const Color(0xFFF4F7FC);
  }

  static Color getBackgroundColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme
        ? const Color(0xFF343636)
        : const Color(0xFFF4F7FC);
  }

  static Color getHintColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme
        ? const Color(0xFF98a1ab)
        : const Color(0xFF52575C);
  }

  static Color getGreyBunkerColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme
        ? const Color(0xFFE4E8EC)
        : const Color(0xFF25282B);
  }

  static Color getCartTitleColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme
        ? const Color(0xFF61699b)
        : const Color(0xFF000743);
  }

  static Color getProfileMenuHeaderColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme
        ? footerColor.withValues(alpha: 0.5)
        : footerColor.withValues(alpha: 0.2);
  }

  static Color getFooterColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme
        ? const Color(0xFF494949)
        : const Color(0xFFFFDDD9);
  }

  static Color getSecondaryColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme
        ? const Color(0xFFFFBA08)
        : const Color(0xFFFFBA08);
  }

  static Color getTertiaryColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme
        ? const Color(0xFF2B2727)
        : const Color(0xFFF3F8FF);
  }

  static const Color colorNero = Color(0xFF1F1F1F);
  static const Color searchBg = Color(0xFFF4F7FC);
  static const Color borderColor = Color(0xFFDCDCDC);
  static const Color footerColor = Color(0xFFFFDDD9);
  static const Color cardShadowColor = Color(0xFFA7A7A7);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color onBoardingBgColor = Color(0xffFCE4E0);
  static const Color homePageSectionTitleColor = Color(0xff583A3A);
  static const Color splashBackgroundColor = Color(0xFFfebb19);

  static const Map<String, Color> buttonBackgroundColorMap = {
    'pending': Color(0xffe9f3ff),
    'confirmed': Color(0xffe5f2ee),
    'processing': Color(0xffe5f3fe),
    'cooking': Color(0xffe5f3fe),
    'out_for_delivery': Color(0xfffff5da),
    'delivered': Color(0xffe5f2ee),
    'canceled': Color(0xffffeeee),
    'returned': Color(0xffffeeee),
    'failed': Color(0xffffeeee),
    'completd': Color(0xffe5f2ee),
  };

  static const Map<String, Color> buttonTextColorMap = {
    'pending': Color(0xff5686c6),
    'confirmed': Color(0xff72b89f),
    'processing': Color(0xff2b9ff4),
    'cooking': Color(0xff2b9ff4),
    'out_for_delivery': Color(0xffebb936),
    'delivered': Color(0xff72b89f),
    'canceled': Color(0xffff6060),
    'returned': Color(0xffff6060),
    'failed': Color(0xffff6060),
    'completd': Color(0xff72b89f),
  };
}
