import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:go_router/go_router.dart';

class CustomBottomSheetHeader extends StatelessWidget {
  const CustomBottomSheetHeader({
    super.key,
    this.title,
    this.showDragBar = true,
    this.showCloseButton = true,
    this.titleSize,
    this.titleWeight
  });

  final String? title;
  final bool? showDragBar;
  final bool? showCloseButton;
  final double? titleSize;
  final FontWeight? titleWeight;



  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [

      const SizedBox(height: Dimensions.paddingSizeSmall),
      if(! ResponsiveHelper.isDesktop(context) && (showDragBar ?? false))
        Center(child: Container(
          width: 35, height: 4, decoration: BoxDecoration(
          color: Theme.of(context).hintColor.withValues(alpha:0.3),
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        )),

      if(! ResponsiveHelper.isDesktop(context))
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          if(title != null)
            Text(title ?? '', style: rubikSemiBold.copyWith(
                fontSize: titleSize ?? Dimensions.fontSizeSmall,
              fontWeight: titleWeight,
            )),

          if(showCloseButton!)
            InkWell(
              onTap: () => context.pop(),
              child: Icon(Icons.close, size: Dimensions.paddingSizeDefault, color: Theme.of(context).hintColor),
            ),
        ]),

      if(ResponsiveHelper.isDesktop(context) && title != null)
        Center(child: Text(title ?? '', style: rubikBold.copyWith(fontSize: Dimensions.fontSizeLarge))),

    ]);
  }
}