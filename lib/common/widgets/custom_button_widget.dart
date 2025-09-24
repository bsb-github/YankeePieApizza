import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class CustomButtonWidget extends StatelessWidget {
  final Function? onTap;
  final String? btnTxt;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final double borderRadius;
  final double? width;
  final double? height;
  final bool transparent;
  final EdgeInsets? margin;
  final IconData? iconData;
  final String? postImage;
  final bool isLoading;
  final Color? borderColor;
  final bool showBorder;


  const CustomButtonWidget({
    super.key, this.onTap, required this.btnTxt,
    this.backgroundColor, this.textStyle,
    this.borderRadius = 10, this.width, this.transparent = false,
    this.height, this.margin, this.isLoading = false, this.iconData, this.postImage, this.borderColor, this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: onTap == null ? Theme.of(context).disabledColor : transparent
          ? Colors.transparent : backgroundColor ?? Theme.of(context).primaryColor,
      // minimumSize: Size(MediaQuery.of(context).size.width, 50),
      minimumSize: Size(width != null ? width! : Dimensions.webScreenWidth, height != null ? height! : 50),

      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: showBorder ? BorderSide(width: 1, color: borderColor ?? Theme.of(context).primaryColor) : BorderSide.none
      ),
    );

    return TextButton(
      onPressed: isLoading ? null : onTap as void Function()?,
      style: flatButtonStyle,
      child: isLoading ?
      Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(
          height: 15, width: 15,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 2,
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Text(getTranslated('loading', context)!, style: rubikBold.copyWith(color: Colors.white)),
      ]),
      ) : Row(mainAxisAlignment: MainAxisAlignment.center, children: [

        Icon(iconData, color: Colors.white, size: iconData != null ? 20 : 0),
        SizedBox(width: iconData != null ?  Dimensions.paddingSizeSmall : 0),

        Text(
          btnTxt ?? "",
          style: textStyle ?? rubikSemiBold.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeLarge),
        ),

        SizedBox(width: postImage != null ?  Dimensions.paddingSizeSmall : 0),
        if(postImage != null)
        CustomAssetImageWidget(postImage ?? '', height: Dimensions.paddingSizeDefault, width: Dimensions.paddingSizeDefault, color: Theme.of(context).cardColor),

      ]),
    );
  }
}
