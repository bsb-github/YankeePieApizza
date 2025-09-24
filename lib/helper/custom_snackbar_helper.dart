import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';

enum SnackBarStatus {error, success, alert, info}

void showCustomSnackBarHelper(String? message, {
  bool isError = true, bool isToast = false, SnackBarStatus? snackBarStatus}) {

  final Size size = MediaQuery.of(Get.context!).size;

  ScaffoldMessenger.of(Get.context!)..hideCurrentSnackBar()..showSnackBar(SnackBar(
    elevation: 0,
    shape: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(color: Colors.transparent)
    ),
    content: Align(alignment: Alignment.center,
      child: Material(color: Colors.black, elevation: 0, borderRadius: BorderRadius.circular(50),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [


            snackBarStatus != null && snackBarStatus == SnackBarStatus.info ? const Icon(
              Icons.warning_rounded,
              color: Colors.orangeAccent,
              size: 22, // Icon size
            ) : CircleAvatar(
              radius: 12, // Adjust radius as needed
              backgroundColor: isError ? Colors.red : Colors.green, // Background color of the circle
              child: Icon(
                isError ? Icons.close_rounded : Icons.check,
                color: Colors.white,
                size: 16, // Icon size
              ),
            ),

            const SizedBox(width: Dimensions.paddingSizeSmall),

            Flexible(child: Text(
              message ?? '',
              style: rubikBold.copyWith(
                color: Colors.white,
                fontSize: Dimensions.fontSizeDefault,
              ),
              textAlign: TextAlign.center,
            )),

          ]),
        ),
      ),
    ),
    margin: ResponsiveHelper.isDesktop(Get.context!)
        ?  EdgeInsets.only(right: size.width * 0.7, bottom: Dimensions.paddingSizeExtraSmall, left: Dimensions.paddingSizeExtraSmall)
        : EdgeInsets.only(bottom: size.height * 0.08),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,

  ));

}