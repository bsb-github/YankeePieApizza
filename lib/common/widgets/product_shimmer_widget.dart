import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ProductShimmerWidget extends StatelessWidget {
  final bool isList;
  final bool isEnabled;
  final double height;
  final double width;
  const ProductShimmerWidget({
    super.key, required this.isEnabled, this.height = 250, this.width = 180, required this.isList,
  });

  @override
  Widget build(BuildContext context) {

    return isList ? Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [

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
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: 8,
        itemBuilder: (context, index){
          return _ShimmerCardItem(isEnabled: isEnabled, width: width);
        },
      )),

    ]) : _ShimmerGridCardItem(isEnabled: isEnabled, width: width);
  }
}

class _ShimmerGridCardItem extends StatelessWidget {
  const _ShimmerGridCardItem({
    required this.isEnabled,
    required this.width,
  });

  final bool isEnabled;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
      ),
      child: Shimmer(
        duration: const Duration(seconds: 1), interval: const Duration(seconds: 1),
        enabled: isEnabled,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Container(
            height: 140, width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
              color: Theme.of(context).shadowColor.withValues(alpha:0.3),
            ),
          ),

          Align(
            alignment: Alignment.topLeft,
            child: Container(
              transform: Matrix4.translationValues(0, -20, 0),
              margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Theme.of(context).shadowColor,
              ),
              height: 30, width: 80,
            ),
          ),

          Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [

              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).shadowColor.withValues(alpha:0.5),
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                height: 15, width: 150,
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).shadowColor.withValues(alpha:0.5),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  height: 15, width: 40,
                ),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                Icon(Icons.star, color: Theme.of(context).shadowColor.withValues(alpha:0.5), size: Dimensions.paddingSizeDefault),
              ]),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).shadowColor.withValues(alpha:0.5),
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                height: 15, width: 80,
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            ]),
          )),

        ]),
      ),
    );
  }
}

class _ShimmerCardItem extends StatelessWidget {
  const _ShimmerCardItem({
    required this.isEnabled,
    required this.width,
  });

  final bool isEnabled;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
      ),
      child: Shimmer(
        duration: const Duration(seconds: 1), interval: const Duration(seconds: 1),
        enabled: isEnabled,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Container(
            height: 140, width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
              color: Theme.of(context).shadowColor.withValues(alpha:0.3),
            ),
          ),

          Align(
            alignment: Alignment.topLeft,
            child: Container(
              transform: Matrix4.translationValues(0, -20, 0),
              margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Theme.of(context).shadowColor,
              ),
              height: 30, width: 80,
            ),
          ),

          Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [

              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).shadowColor.withValues(alpha:0.5),
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                height: 20, width: 150,
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
                decoration: BoxDecoration(
                  color: Theme.of(context).shadowColor.withValues(alpha:0.5),
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                height: 15, width: 80,
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            ]),
          )),

        ]),
      ),
    );
  }
}
