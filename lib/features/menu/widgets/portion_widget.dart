import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class PortionWidget extends StatelessWidget {
  final String? imageIcon;
  final IconData? icon;
  final String title;
  final bool hideDivider;
  final VoidCallback? onRoute;
  final Color? iconColor;

  final String? suffix;
  const PortionWidget({
    super.key, required this.imageIcon, required this.title,
    this.hideDivider = false, this.suffix, this.icon, this.onRoute,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onRoute,
      child: Container(
        padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).shadowColor.withValues(alpha:0.3),
            ),
            child: icon != null ? Icon(icon, size: 16, color: iconColor ?? Theme.of(context).hintColor) : CustomAssetImageWidget(
              imageIcon!, height: 16, width: 16, color: iconColor ?? Theme.of(context).hintColor,
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: Dimensions.paddingSizeDefault),
            Text(title, style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),

            suffix != null ? Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
              child: Text(suffix!, style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor)),
            ) : const SizedBox(),

            hideDivider ? const SizedBox(height: Dimensions.paddingSizeSmall) :
            Divider(
              color: Theme.of(context).hintColor.withValues(alpha:0.1),
            ),
          ])),
        ]),
      ),
    );
  }
}
