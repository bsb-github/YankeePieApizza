import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class AddMoreItemButtonWidget extends StatelessWidget {
  const AddMoreItemButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [

      Material(
        color: Theme.of(context).primaryColor.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: ()=> RouterHelper.getSearchResultRoute(''),
          child: Container(
            //width: ResponsiveHelper.isDesktop(context) ? 130 : 120,
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
            child: Row(children: [


              Icon(Icons.add_circle_outline_rounded, color: Theme.of(context).primaryColor, size: Dimensions.fontSizeSmall),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),


              Text(getTranslated('add_more_item', context)!, style: ResponsiveHelper.isDesktop(context) ? rubikSemiBold.copyWith(
                fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor,
              ) : rubikRegular.copyWith(
                fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor,
              )),


            ]),
          ),
        ),
      ),

    ]);
  }
}