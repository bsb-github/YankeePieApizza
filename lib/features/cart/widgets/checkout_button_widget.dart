import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/cart/widgets/free_delivery_progressbar_widget.dart';
import 'package:flutter_restaurant/features/cart/widgets/guest_checkout_widget.dart';
import 'package:flutter_restaurant/features/checkout/providers/checkout_provider.dart';
import 'package:flutter_restaurant/features/coupon/providers/coupon_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CheckOutButtonWidget extends StatelessWidget {
  const CheckOutButtonWidget({
    super.key,
    required this.orderAmount,
    required this.totalWithoutDeliveryFee,
    required this.isFreeDelivery,
  });

  final double orderAmount;
  final double totalWithoutDeliveryFee;
  final bool isFreeDelivery;

  @override
  Widget build(BuildContext context) {
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    final CouponProvider couponProvider = Provider.of<CouponProvider>(context, listen: false);
    final CheckoutProvider checkoutProvider = Provider.of<CheckoutProvider>(context, listen: false);

    return ((splashProvider.configModel?.selfPickup ?? false) || (splashProvider.configModel?.homeDelivery ?? false)) ? Column(
      children: [

        FreeDeliveryProgressBarWidget(subTotal: totalWithoutDeliveryFee),
        Container(
          width: Dimensions.webScreenWidth,
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: CustomButtonWidget(btnTxt: getTranslated('proceed_to_checkout', context), onTap: () {
            if(authProvider.isLoggedIn()){
              if(orderAmount < (splashProvider.configModel?.minimumOrderValue ?? 0)) {
                showCustomSnackBarHelper('${getTranslated('minimum_order_is', context)} ${PriceConverterHelper.convertPrice(splashProvider.configModel!
                    .minimumOrderValue)}, ${getTranslated('you_have', context)} ${PriceConverterHelper.convertPrice(orderAmount)} ${getTranslated('in_your_cart_please_add_more', context)}');
              } else {
                RouterHelper.getCheckoutRoute(
                  totalWithoutDeliveryFee, 'cart',
                  couponProvider.code, checkoutProvider.isCutlerySelected,
                    isFreeDelivery ? "free_delivery" : ""
                );
              }
            } else{
              ResponsiveHelper.showDialogOrBottomSheet(context, GuestCheckoutWidget(onGuestTap: () {
                if(orderAmount < splashProvider.configModel!.minimumOrderValue!) {
                  showCustomSnackBarHelper('${getTranslated('minimum_order_is', context)} ${PriceConverterHelper.convertPrice(splashProvider.configModel!
                      .minimumOrderValue)}, ${getTranslated('you_have', context)} ${PriceConverterHelper.convertPrice(orderAmount)} ${getTranslated('in_your_cart_please_add_more', context)}');
                } else {
                  context.pop();

                  RouterHelper.getCheckoutRoute(
                    totalWithoutDeliveryFee, 'cart',
                    couponProvider.code,
                    checkoutProvider.isCutlerySelected,
                    isFreeDelivery ? "free_delivery" : ""
                  );
                }
              }));
            }
          }),
        ),
      ],
    ) : const SizedBox();
  }
}