import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class ReferHintView extends StatelessWidget {
  final List<String?>? hintList;
  const ReferHintView({super.key, this.hintList});

  @override
  Widget build(BuildContext context) {


    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:0.2), width: 2),
        borderRadius: BorderRadius.only(
          topRight: const Radius.circular(20), topLeft: const Radius.circular(20),
          bottomLeft: ResponsiveHelper.isDesktop(context) ? const Radius.circular(Dimensions.radiusExtraLarge) : Radius.zero,
          bottomRight: ResponsiveHelper.isDesktop(context) ? const Radius.circular(Dimensions.radiusExtraLarge) : Radius.zero,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha:0.04),
          borderRadius: BorderRadius.only(
            topRight: const Radius.circular(Dimensions.radiusExtraLarge),
            topLeft: const Radius.circular(Dimensions.radiusExtraLarge),
            bottomLeft: ResponsiveHelper.isDesktop(context) ? const Radius.circular(Dimensions.radiusExtraLarge) : Radius.zero,
            bottomRight: ResponsiveHelper.isDesktop(context) ? const Radius.circular(Dimensions.radiusExtraLarge) : Radius.zero,
          ),
    ),

        child: Column(children: [
         if(!ResponsiveHelper.isDesktop(context)) Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha:0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            height: Dimensions.paddingSizeExtraSmall , width: 30,
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Row(children: [
            Image.asset(Images.iMark, height: Dimensions.fontSizeExtraLarge, color: Colors.white),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Text(
              getTranslated('how_you_it_works', context)!,
              style: rubikBold.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).textTheme.bodyLarge!.color),
            ),

          ]),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Column(children: hintList!.map((hint) => Row(
            children: [
              Container(
                margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(
                      color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha:0.05),
                      blurRadius: 6, offset: const Offset(0, 3),
                    )]
                ),
                child: Text('${hintList!.indexOf(hint) + 1}',style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.black)),
              ),
              const SizedBox(width: Dimensions.paddingSizeLarge,),

              Flexible(child: Text(hint!, style: rubikRegular.copyWith(
                fontSize: Dimensions.fontSizeLarge,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ))),
            ],
          ),).toList(),)
        ],),
      ),
    );
  }
}
