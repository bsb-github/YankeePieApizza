import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_restaurant/main.dart';

class ResponsiveHelper {

  static bool isMobilePhone() {
    if (!kIsWeb) {
      return true;
    }else {
      return false;
    }
  }

  static bool isWeb() {
    return kIsWeb;
  }

  static bool isMobile() {
    final size = MediaQuery.of(Get.context!).size.width;
    if (size < 650 || !kIsWeb) {
      return true;
    } else {
      return false;
    }
  }

  static bool isTab(context) {
    final size = MediaQuery.of(context).size.width;
    if (size < 1100 && size >= 650) {
      return true;
    } else {
      return false;
    }
  }

  static bool isDesktop(context) {
    final size = MediaQuery.of(context).size.width;
    if (size >= 1100) {
      return true;
    } else {
      return false;
    }
  }

  static void showDialogOrBottomSheet(BuildContext context, Widget view, {bool isDismissible = true}){
    if(ResponsiveHelper.isDesktop(context)) {
      showDialog(context: context, barrierDismissible: isDismissible, builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: view,
      ));
    }else{
      showModalBottomSheet(
        isDismissible: isDismissible,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        useSafeArea: true,
        context: context,
        builder: (ctx) => view,
      );
    }
  }
}