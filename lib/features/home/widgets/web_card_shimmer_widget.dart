import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class WebCardShimmerWidget extends StatelessWidget {
  final bool isEnabled;
  final double height;
  const WebCardShimmerWidget({super.key, required this.isEnabled, this.height = 150});

  @override
  Widget build(BuildContext context) {

    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [

      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Shimmer(enabled: isEnabled, child: Container(
          height: 20, width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            color: Theme.of(context).shadowColor.withValues(alpha:0.3),
          ),
        )),

        Padding(
          padding: EdgeInsets.only(right: !ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0),
          child: Shimmer(enabled: isEnabled, child: Container(
            height: 20, width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
              color: Theme.of(context).shadowColor.withValues(alpha:0.3),
            ),
          )),
        ),
      ]),
      const SizedBox(height: Dimensions.paddingSizeLarge),

      SizedBox(height: height, child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: 12,
        itemBuilder: (context, index){
          return Container(
            margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
            child: Shimmer(duration: const Duration(seconds: 1), interval: const Duration(seconds: 1), enabled: isEnabled, child: Row(children: [

              Container(
                height: 130, width: 150,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                  color: Theme.of(context).shadowColor.withValues(alpha:0.5),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              SizedBox(width: 140, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Container(
                  height: 20, width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault), color: Theme.of(context).shadowColor.withValues(alpha:0.3),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).shadowColor.withValues(alpha:0.5),
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    height: 15, width: 30,
                  ),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                  Icon(Icons.star, color: Theme.of(context).shadowColor.withValues(alpha:0.3), size: Dimensions.paddingSizeDefault),
                ]),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Container(
                  height: 10, width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusLarge), color: Theme.of(context).shadowColor.withValues(alpha:0.2),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Align(alignment: Alignment.bottomRight, child: Container(
                  height: 25, width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                    color: Theme.of(context).shadowColor.withValues(alpha:0.4),
                  ),
                )),
              ])),

            ])),
          );
        },
      )),

    ]);
  }
}
