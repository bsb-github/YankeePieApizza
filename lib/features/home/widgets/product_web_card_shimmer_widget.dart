import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/providers/theme_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/common/widgets/rating_bar_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
class ProductWidgetWebShimmerWidget extends StatelessWidget {
  const ProductWidgetWebShimmerWidget({super.key, required this.isEnabled});
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(
          color: Theme.of(context).shadowColor, blurRadius: themeProvider.darkTheme ? 2 : 5,
          spreadRadius: themeProvider.darkTheme ? 0 : 1,
        )],
      ),
      child: Shimmer(
        duration: const Duration(seconds: 1), interval: const Duration(seconds: 1),
        enabled: isEnabled,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 105, width: 195,
            decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(top: Radius.circular(10)), color: Theme.of(context).shadowColor),
          ),
          Expanded(child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                child: Container(height: 15, color: Theme.of(context).shadowColor),
              ),

              const RatingBarWidget(rating: 0.0, size: Dimensions.paddingSizeDefault),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(height: Dimensions.paddingSizeSmall, width: 30, color: Theme.of(context).shadowColor),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Container(height: Dimensions.paddingSizeSmall, width: 30, color: Theme.of(context).shadowColor),
                ]),
              ),

              Container(
                height: 30, width: 150,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Theme.of(context).shadowColor),
              ),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            ]),
          )),

        ]),
      ),
    );
  }
}