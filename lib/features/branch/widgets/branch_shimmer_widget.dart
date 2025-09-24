import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BranchShimmerWidget extends StatelessWidget {
  const BranchShimmerWidget({super.key, required this.isEnabled});

  final bool isEnabled;
  
  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveHelper.isDesktop(context);
    
    return Column(children: [
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

      isDesktop ? SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (context, index) {
            return BranchShimmerCardWidget(isEnabled: isEnabled);
          },
        ),
      ) : ListView.builder(
        itemCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            height: 90,
            child: Shimmer(enabled: isEnabled, child: Row(children: [

              Container(width: 85, height: 80, decoration: BoxDecoration(
                color: Theme.of(context).shadowColor.withValues(alpha:0.3),
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              )),
              const SizedBox(width: Dimensions.paddingSizeLarge),

              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(width: 140, height: 20, color: Theme.of(context).shadowColor.withValues(alpha:0.3)),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Container(width: 200, height: 20, color: Theme.of(context).shadowColor.withValues(alpha:0.3)),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Container(width: 80, height: 20, color: Theme.of(context).shadowColor.withValues(alpha:0.3)),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                ]),
              ),

            ])),
          );
        },
      ),
    ]);
  }
}

class BranchShimmerCardWidget extends StatelessWidget {
  const BranchShimmerCardWidget({
    super.key,
    required this.isEnabled,
  });

  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
      width: 370,
      child: Shimmer(enabled: isEnabled, child: Stack(children: [

        Container(
          margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
          decoration: BoxDecoration(
            color: Theme.of(context).shadowColor.withValues(alpha:0.2),
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),

          child: Column(children: [

            Expanded(flex: 2, child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(Dimensions.radiusDefault),
                topLeft: Radius.circular(Dimensions.radiusDefault),
              ),
              child: Container(width: 370, height: 100, color: Theme.of(context).shadowColor.withValues(alpha:0.4)),
            )),

            Expanded(child: Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(Dimensions.radiusDefault), bottomRight: Radius.circular(Dimensions.radiusDefault),
                ),
              ),
              child: const SizedBox(),

            )),
            const SizedBox(height: Dimensions.paddingSizeSmall),
          ]),

        ),

        Positioned(bottom: Dimensions.paddingSizeDefault, child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end, children: [
            Container(width: 80, height: 80, color: Theme.of(context).shadowColor.withValues(alpha:0.3)),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: 150, height: 20, color: Theme.of(context).shadowColor.withValues(alpha:0.3)),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Container(width: 150, height: 20, color: Theme.of(context).shadowColor.withValues(alpha:0.3)),
            ]),
          ]),
        )),

        Positioned.fill(bottom: Dimensions.paddingSizeDefault, child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
          child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.end, children: [
            Container(width: 60, height: 20, color: Theme.of(context).shadowColor.withValues(alpha:0.3)),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Container(width: 40, height: 20, color: Theme.of(context).shadowColor.withValues(alpha:0.3)),
          ]),
        )),

      ])),
    );
  }
}
