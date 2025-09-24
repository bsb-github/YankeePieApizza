import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class BranchInfoWidget extends StatelessWidget {
  final double scrollingRate;
  const BranchInfoWidget({super.key, required this.scrollingRate});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return isDesktop ? Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

      Row(mainAxisSize: MainAxisSize.min, children: [
        Text(
          'Dhanmondi Branch', style: rubikSemiBold.copyWith(color: isDesktop ? Theme.of(context).textTheme.bodyMedium!.color : Theme.of(context).primaryColor),
          maxLines: 1, overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Container(
          margin: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
          width: Dimensions.paddingSizeExtraSmall, height: Dimensions.paddingSizeExtraSmall,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha:0.5),
            shape: BoxShape.circle,
          ),
        ),

        RichText(text: TextSpan(children: [
          TextSpan(text: '12 km', style: rubikRegular.copyWith(color: Theme.of(context).primaryColor)),
          TextSpan(text: ' Away', style: rubikRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall)),
        ])),
      ]),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      Row(mainAxisSize: MainAxisSize.min, children: [
        CustomAssetImageWidget(
          Images.locationPlacemarkSvg, width: Dimensions.paddingSizeDefault, height: Dimensions.paddingSizeDefault,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

        Flexible(child: Text(
          'address address address address', maxLines: 1, overflow: TextOverflow.ellipsis,
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
        )),
      ]),

    ])
    : Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

      Stack(children: [
        Row(children: [
          const SizedBox(width: Dimensions.paddingSizeLarge),
          Expanded(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

            SizedBox(height: scrollingRate * 30),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Text(
              'Dhanmondi Branch', style: rubikSemiBold.copyWith(color: Theme.of(context).primaryColor),
              maxLines: 1, overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Text(
              'address address address address', maxLines: 1, overflow: TextOverflow.ellipsis,
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            RichText(text: TextSpan(children: [
              TextSpan(text: 'Minimum Start', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
              TextSpan(text: ' \$20', style: rubikRegular.copyWith(
                color: Theme.of(context).textTheme.bodyMedium!.color,
                fontSize: Dimensions.fontSizeSmall,
              )),
            ])),
          ])),

          Container(
            transform: Matrix4.translationValues(0, (scrollingRate * 25) - 40, 0),
            width: 70 - (scrollingRate * 50),
            height: 70 - (scrollingRate * 50),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:0.5), width: 0.2),
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ),
            margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
            padding: const EdgeInsets.all(2),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              clipBehavior: Clip.hardEdge,
              child: CustomAssetImageWidget(
                Images.logo,
                height: 60 - (scrollingRate * 50), width: 60 - (scrollingRate * 50), fit: BoxFit.contain,
              ),
            ),
          ),
        ]),

        Positioned(
          right: 20, bottom: 5,
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('12 km', style: rubikRegular.copyWith(color: Theme.of(context).primaryColor), textAlign: TextAlign.right),
            Text(
              'Away',
              textAlign: TextAlign.right,
              style: rubikRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeExtraSmall),
            ),
          ]),
        ),
      ]),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
        child: Divider(color: Theme.of(context).hintColor.withValues(alpha:0.3), thickness: 0.5),
      ),

      Padding(
        padding: const EdgeInsets.only(right: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeLarge),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Icon(Icons.access_time, color: Theme.of(context).primaryColor, size: Dimensions.paddingSizeDefault),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

            Text('20-30 min', style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyMedium!.color)),
          ]),

          Row(children: [
            CustomAssetImageWidget(
              Images.locationPlacemarkSvg,
              height: Dimensions.paddingSizeDefault,
              width: Dimensions.paddingSizeDefault,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

            Text(
              'Location',
              style: rubikRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).primaryColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ]),

          Row(children: [
            Icon(Icons.star_rounded, color: Theme.of(context).primaryColor, size: Dimensions.paddingSizeLarge),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

            Text(
              '4.5',
              style: rubikSemiBold.copyWith(
                fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Text(
              '1200+ Review',
              style: rubikRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor, decoration: TextDecoration.underline,
              ),
            ),
          ]),
        ]),
      ),

    ]);
  }
}
