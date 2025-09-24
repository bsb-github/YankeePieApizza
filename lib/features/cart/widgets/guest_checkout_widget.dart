import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_bottom_sheet_header.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_dialog_shape_widget.dart';
import 'package:flutter_restaurant/common/widgets/on_hover_widget.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class GuestCheckoutWidget extends StatelessWidget {
  const GuestCheckoutWidget({super.key, required this.onGuestTap});
  final VoidCallback? onGuestTap;

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    final bool isDesktop = ResponsiveHelper.isDesktop(context);

    return CustomDialogShapeWidget(maxHeight: isDesktop ? 350 : 270, child: Column(
      crossAxisAlignment: isDesktop ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Center(child: CustomBottomSheetHeader(showCloseButton: false)),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Text(getTranslated('to_save_your_order_please_login', context)!, style: rubikBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Text(
          getTranslated('if_you_want_to_save_your_order_you_need_to_login_first', context)!, style: rubikRegular.copyWith(
          color: Theme.of(context).hintColor,
        ),
          textAlign: isDesktop ? TextAlign.center : TextAlign.start,
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        SizedBox(height: 40, child: Row(children: [
          Expanded(
            child: CustomButtonWidget(
              btnTxt: getTranslated('signup', context), backgroundColor: Theme.of(context).disabledColor.withValues(alpha:0.1),
              textStyle: rubikBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
              onTap: () {
                context.pop();
                return RouterHelper.getCreateAccountRoute();
              },
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(
            child: CustomButtonWidget(
              btnTxt: getTranslated('login', context), backgroundColor: Theme.of(context).primaryColor,
              textStyle: rubikBold.copyWith(color: Colors.white),
              onTap: () {
                context.pop();
                RouterHelper.getLoginRoute();
              }
            ),
          ),
        ])),
        const SizedBox(height: Dimensions.paddingSizeLarge),

       if(splashProvider.configModel?.isGuestCheckout ?? false) Row(children: [
          const SizedBox(width: Dimensions.paddingSizeSmall),
          const Expanded(child: Divider()),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Text(getTranslated('or_continue_as_a', context)!, style: rubikRegular.copyWith(
            color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall,
          )),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

          InkWell(onTap: onGuestTap, child: OnHoverWidget(builder: (bool isHovered)=> Text(
            getTranslated('guest', context)!,
            style: rubikBold.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: isHovered ? Theme.of(context).primaryColor : null,
            ),
          ))),

          const SizedBox(width: Dimensions.paddingSizeSmall),
          const Expanded(child: Divider()),
          const SizedBox(width: Dimensions.paddingSizeSmall),
        ]),
        const SizedBox(height: Dimensions.paddingSizeDefault),
      ],
    ));
  }
}