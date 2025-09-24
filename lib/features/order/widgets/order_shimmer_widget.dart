import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class OrderShimmerWidget extends StatelessWidget {
  const OrderShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Center(
          child: Container(
            width: Dimensions.webScreenWidth,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Shimmer(
              duration: const Duration(seconds: 2),
              enabled: true,
              child: ResponsiveHelper.isDesktop(context) ? Column(children: [

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      height: 70, width: 80,
                      margin: const EdgeInsets.only(left: Dimensions.paddingSizeLarge),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).shadowColor.withValues(alpha:0.3)),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    Container(height: 15, width: 80, color: Theme.of(context).shadowColor.withValues(alpha:0.3)),
                  ]),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Container(height: 15, width: 150, color: Theme.of(context).shadowColor.withValues(alpha:0.3)),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                  Container(height: 15, width: 100, color: Theme.of(context).shadowColor.withValues(alpha:0.3)),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                  Container(height: 15, width: 100, color: Theme.of(context).shadowColor.withValues(alpha:0.3)),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                  Container(
                    height: 20, width: 80,
                    margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      color: Theme.of(context).shadowColor.withValues(alpha:0.3),
                    ),
                  ),
                ]),

                Divider(color: Theme.of(context).hintColor.withValues(alpha:0.2), thickness: 0.5),

              ]) : Row(children: [

                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      child: Container(color: Theme.of(context).shadowColor.withValues(alpha:0.3), height: 65, width: 65),
                    ),

                  ]),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(
                  flex: 3,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Container(height: 15, width: 90, color: Theme.of(context).shadowColor.withValues(alpha:0.3)),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                      Container(height: 15, width: 50, color: Theme.of(context).shadowColor.withValues(alpha:0.3)),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Container(height: 15, width: 70, color: Theme.of(context).shadowColor.withValues(alpha:0.3)),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                      Container(height: 15, width: 70, color: Theme.of(context).shadowColor.withValues(alpha:0.3)),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Container(height: 15, width: 80, color: Theme.of(context).shadowColor.withValues(alpha:0.3)),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                      Container(height: 15, width: 80, color: Theme.of(context).shadowColor.withValues(alpha:0.3)),
                    ]),

                  ]),
                ),

              ]),
            ),
          ),
        );
      },
    );
  }
}
