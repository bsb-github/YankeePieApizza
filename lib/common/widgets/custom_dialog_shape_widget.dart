import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:go_router/go_router.dart';

class CustomDialogShapeWidget extends StatelessWidget {
  const CustomDialogShapeWidget({
    super.key, this.child, this.maxHeight, this.maxWidth,
    this.padding, this.margin,
  });

  final Widget? child;
  final double? maxHeight;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveHelper.isDesktop(context);
    final double height = MediaQuery.sizeOf(context).height;

    return Stack(children: [
      Container(
        constraints: BoxConstraints(maxHeight: maxHeight ?? height * 0.85, maxWidth: maxWidth ?? 500),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.vertical(
            top: const Radius.circular(Dimensions.radiusLarge),
            bottom: Radius.circular(ResponsiveHelper.isMobile() ? 0 : Dimensions.radiusLarge),
          ),
        ),
        padding: padding ?? EdgeInsets.symmetric(
          horizontal: isDesktop ? 80 : Dimensions.paddingSizeLarge,
          vertical: isDesktop ? 40 : Dimensions.paddingSizeExtraSmall,
        ),
        margin: margin ?? EdgeInsets.all(isDesktop ? Dimensions.fontSizeExtraLarge : 0),
        child: child,
      ),

      /// for web dialog close button
      if(isDesktop) Positioned(right: 0, top: 0, child: Material(
        color: Theme.of(context).cardColor.withValues(alpha: 0.8),
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
        child: InkWell(onTap: () => context.pop(), child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
          child: const Icon(Icons.close, size: Dimensions.fontSizeDefault),
        )),
      )),
    ]);
  }
}
