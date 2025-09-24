import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class CustomAlertDialogWidget extends StatelessWidget {
  final String? image;
  final IconData? icon;
  final String? title;
  final String? subTitle;
  final String? leftButtonText;
  final String? rightButtonText;
  final Function? onPressLeft;
  final Function? onPressRight;
  final Color? iconColor;
  final Widget? child;
  final bool isLoading;
  final bool isSingleButton;
  final double? width;
  final double? height;
  final bool isPadding;
  final bool isHeaderBarExist;

  const CustomAlertDialogWidget({
    super.key, this.image, this.icon, this.title,
    this.subTitle, this.leftButtonText, this.rightButtonText,
    this.onPressLeft,  this.onPressRight, this.iconColor,
    this.child, this.isLoading = false, this.isSingleButton = false, this.width,
    this.height, this.isPadding = true, this.isHeaderBarExist = true,
  });

  @override
  Widget build(BuildContext context) {
    return _CustomAlertDialogShape(
      width: width,
      height: height,
      isPadding: isPadding,
      isHeaderBarExist: isHeaderBarExist,
      child: child ?? Container(
        padding: const EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeLarge,
          horizontal: Dimensions.paddingSizeSmall,
        ),
        width: ResponsiveHelper.isDesktop(context) ? (Dimensions.webScreenWidth / 2) : MediaQuery.sizeOf(context).width,
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          if(ResponsiveHelper.isDesktop(context)) const SizedBox(height: Dimensions.paddingSizeLarge),

          if(image != null) CustomAssetImageWidget(image!, width: 50),

          if(icon != null) Icon(icon!, size: 50, color: iconColor ?? Theme.of(context).colorScheme.error),

          const SizedBox(height: Dimensions.paddingSizeDefault),

         if(title != null) Text(title!, style: rubikBold.copyWith(
            fontSize: Dimensions.fontSizeExtraLarge,
          ), textAlign: TextAlign.center),
          const SizedBox(height: Dimensions.paddingSizeDefault),


          if(subTitle != null)Text(subTitle!, style: rubikRegular.copyWith(
            fontSize: Dimensions.fontSizeLarge,
          ), textAlign: TextAlign.center),

          const SizedBox(height: 50),


          Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
            if(!isSingleButton) Flexible(child: SizedBox(
              width: ResponsiveHelper.isDesktop(context) ? 120 : null,
              child: CustomButtonWidget(
                backgroundColor: Theme.of(context).disabledColor.withValues(alpha:0.2),
                btnTxt: leftButtonText ?? getTranslated('no', context),
                textStyle: rubikSemiBold.copyWith(color: Theme.of(context).textTheme.titleMedium?.color, fontSize: Dimensions.fontSizeLarge),
                onTap: isLoading ? null : onPressLeft ?? ()=> Navigator.pop(context),
              ),
            )),
            if(!isSingleButton) const SizedBox(width: Dimensions.paddingSizeDefault),


            Flexible(child: SizedBox(
              width: ResponsiveHelper.isDesktop(context) ? 120 : null,
              child: CustomButtonWidget(
                isLoading: isLoading,
                btnTxt:  rightButtonText ?? getTranslated('yes', context),
                onTap: onPressRight ?? ()=> Navigator.pop(context),
              ),
            )),

          ]),




        ]),
      ),
    );
  }
}


class _CustomAlertDialogShape extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final bool isPadding;
  final bool isHeaderBarExist;
  const _CustomAlertDialogShape({required this.child, this.width, this.height, this.isPadding = true, this.isHeaderBarExist = true});

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context) ? Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(width: width ?? 400, height: height, child: Stack(
        children: [
          child,
          Positioned.fill(child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Align(alignment: Alignment.topRight, child: InkWell(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              onTap: ()=> Navigator.pop(context),
              child: Icon(Icons.cancel, color: Theme.of(context).colorScheme.error),
            )),
          ))
        ],
      )),
    ) : Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
      padding: isPadding ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: ResponsiveHelper.isMobile()
            ? const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
            : const BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        if(isHeaderBarExist)
          Container(height: 4, width: 40, decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: BorderRadius.circular(25),
          )),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        child,

      ]),
    );
  }
}
