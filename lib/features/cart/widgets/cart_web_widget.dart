// import 'package:flutter/material.dart';
// import 'package:flutter_restaurant/common/models/product_model.dart';
// import 'package:flutter_restaurant/common/widgets/custom_divider_widget.dart';
// import 'package:flutter_restaurant/features/cart/providers/cart_provider.dart';
// import 'package:flutter_restaurant/features/cart/widgets/item_view_widget.dart';
// import 'package:flutter_restaurant/features/cart/widgets/cart_list_widget.dart';
// import 'package:flutter_restaurant/features/cart/widgets/checkout_button_widget.dart';
// import 'package:flutter_restaurant/features/cart/widgets/delivery_option_widget.dart';
// import 'package:flutter_restaurant/features/checkout/domain/enum/delivery_type_enum.dart';
// import 'package:flutter_restaurant/features/coupon/providers/coupon_provider.dart';
// import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
// import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
// import 'package:flutter_restaurant/helper/price_converter_helper.dart';
// import 'package:flutter_restaurant/helper/responsive_helper.dart';
// import 'package:flutter_restaurant/localization/language_constrants.dart';
// import 'package:flutter_restaurant/features/language/providers/localization_provider.dart';
// import 'package:flutter_restaurant/main.dart';
// import 'package:flutter_restaurant/utill/color_resources.dart';
// import 'package:flutter_restaurant/utill/dimensions.dart';
// import 'package:flutter_restaurant/utill/styles.dart';
// import 'package:provider/provider.dart';
//
// class CartWebWidget extends StatelessWidget {
//   const CartWebWidget({
//     super.key,
//     required this.addOnsList,
//     required this.availableList,
//     required TextEditingController couponController,
//     required this.total,
//     required this.kmWiseCharge,
//     required this.itemPrice,
//     required this.tax,
//     required this.addOns,
//     required this.discount,
//     required this.deliveryCharge,
//     required this.orderAmount,
//     required this.totalWithoutDeliveryFee,
//     required this.cart,
//   }) : _couponController = couponController;
//
//   final List<List<AddOns>> addOnsList;
//   final List<bool> availableList;
//   final TextEditingController _couponController;
//   final double total;
//   final bool kmWiseCharge;
//   final double itemPrice;
//   final double tax;
//   final double addOns;
//   final double discount;
//   final double? deliveryCharge;
//   final double orderAmount;
//   final double totalWithoutDeliveryFee;
//   final CartProvider cart;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//
//         if(ResponsiveHelper.isDesktop(context)) Expanded(child: Padding(
//           padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge,vertical: Dimensions.paddingSizeLarge),
//           child: CartListWidget(cart: cart, addOns: addOnsList, availableList: availableList),
//         )),
//         if(ResponsiveHelper.isDesktop(context))  const SizedBox(width: Dimensions.paddingSizeLarge),
//
//         Expanded(child: Container(
//           decoration:ResponsiveHelper.isDesktop(context) ? BoxDecoration(
//               color: Theme.of(context).canvasColor,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: [
//                 BoxShadow(
//                   color: Theme.of(context).shadowColor,
//                   blurRadius: 10,
//                 )
//               ]
//           ) : const BoxDecoration(),
//           margin: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall,vertical: Dimensions.paddingSizeLarge) : const EdgeInsets.all(0),
//           padding: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge,vertical: Dimensions.paddingSizeLarge) : const EdgeInsets.all(0),
//           child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//
//             // Product
//             if(!ResponsiveHelper.isDesktop(context)) CartListWidget(cart: cart, addOns: addOnsList, availableList: availableList),
//
//             // Coupon
//             Consumer<CouponProvider>(
//               builder: (context, coupon, child) {
//                 return IntrinsicHeight(
//                   child: Row(children: [
//                     Expanded(child: TextField(
//                       controller: _couponController,
//                       style: rubikRegular,
//                       decoration: InputDecoration(
//                         hintText: getTranslated('enter_promo_code', context),
//                         hintStyle: rubikRegular.copyWith(color: ColorResources.getHintColor(context)),
//                         isDense: true,
//                         filled: true,
//                         enabled: coupon.discount == 0,
//                         fillColor: Theme.of(context).cardColor,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.horizontal(
//                             left: Radius.circular(Provider.of<LocalizationProvider>(context, listen: false).isLtr ? 10 : 0),
//                             right: Radius.circular(Provider.of<LocalizationProvider>(context, listen: false).isLtr ? 0 : 10),
//                           ),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     )),
//
//                     InkWell(
//                       onTap: () {
//                         if(_couponController.text.isNotEmpty && !coupon.isLoading) {
//                           if(coupon.discount! < 1) {
//                             coupon.applyCoupon(_couponController.text, total - tax).then((discount) {
//                               if (discount! > 0) {
//                                 showCustomSnackBarHelper('You got ${PriceConverterHelper.convertPrice(discount)} discount', isError: false);
//                               } else {
//                                 showCustomSnackBarHelper(getTranslated('invalid_code_or', Get.context!), isError: true);
//                               }
//                             });
//                           } else {
//                             coupon.removeCouponData(true);
//                           }
//                         } else if(_couponController.text.isEmpty) {
//                           showCustomSnackBarHelper(getTranslated('enter_a_Coupon_code', context));
//                         }
//                       },
//                       child: Container(width: 100,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: Theme.of(context).primaryColor,
//                           borderRadius: BorderRadius.horizontal(
//                             left: Radius.circular(Provider.of<LocalizationProvider>(context, listen: false).isLtr ? 0 : 10),
//                             right: Radius.circular(Provider.of<LocalizationProvider>(context, listen: false).isLtr ? 10 : 0),
//                           ),
//                         ),
//                         child: coupon.discount! <= 0 ? !coupon.isLoading ? Text(
//                           getTranslated('apply', context)!,
//                           style: rubikSemiBold.copyWith(color: Colors.white),
//                         ) : const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)) : const Icon(Icons.clear, color: Colors.white),
//                       ),
//                     ),
//                   ]),
//                 );
//               },
//             ),
//             const SizedBox(height: Dimensions.paddingSizeLarge),
//
//             // Order type
//             Text(getTranslated('delivery_option', context)!, style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
//
//             Provider.of<SplashProvider>(context, listen: false).configModel!.homeDelivery!?
//             DeliveryOptionWidget(value: OrderType.delivery, title: getTranslated('delivery', context)!, deliveryCharge: 10):
//
//             Padding(
//               padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall,top: Dimensions.paddingSizeLarge),
//               child: Row(
//                 children: [
//                   Icon(Icons.remove_circle_outline_sharp,color: Theme.of(context).hintColor,),
//                   const SizedBox(width: Dimensions.paddingSizeExtraLarge),
//                   Text(getTranslated('home_delivery_not_available', context)!,style: TextStyle(fontSize: Dimensions.fontSizeDefault,color: Theme.of(context).primaryColor)),
//                 ],
//               ),
//             ),
//
//             Provider.of<SplashProvider>(context, listen: false).configModel!.selfPickup!?
//             DeliveryOptionWidget(value: OrderType.takeAway, title: getTranslated('take_away', context)!, deliveryCharge: 0):
//             Padding(
//               padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall,bottom: Dimensions.paddingSizeLarge),
//               child: Row(
//                 children: [
//                   Icon(Icons.remove_circle_outline_sharp,color: Theme.of(context).hintColor,),
//                   const SizedBox(width: Dimensions.paddingSizeExtraLarge),
//                   Text(getTranslated('self_pickup_not_available', context)!,style: TextStyle(fontSize: Dimensions.fontSizeDefault,color: Theme.of(context).primaryColor)),
//                 ],
//               ),
//             ),
//
//
//             // Total
//             ItemViewWidget(
//               title: getTranslated('items_price', context)!,
//               subTitle: PriceConverterHelper.convertPrice(itemPrice),
//             ),
//             const SizedBox(height: 10),
//
//             ItemViewWidget(
//               title: getTranslated('tax', context)!,
//               subTitle: '(+) ${PriceConverterHelper.convertPrice(tax)}',
//             ),
//             const SizedBox(height: 10),
//
//             ItemViewWidget(
//               title: getTranslated('addons', context)!,
//               subTitle: '(+) ${PriceConverterHelper.convertPrice(addOns)}',
//             ),
//             const SizedBox(height: 10),
//
//             ItemViewWidget(
//               title: getTranslated('discount', context)!,
//               subTitle: '(-) ${PriceConverterHelper.convertPrice(discount)}',
//             ),
//             const SizedBox(height: 10),
//
//             ItemViewWidget(
//               title: getTranslated('coupon_discount', context)!,
//               subTitle: '(-) ${PriceConverterHelper.convertPrice(Provider.of<CouponProvider>(context).discount)}',
//             ),
//             const SizedBox(height: 10),
//
//             kmWiseCharge ? const SizedBox() : ItemViewWidget(
//               title: getTranslated('delivery_fee', context)!,
//               subTitle: '(+) ${PriceConverterHelper.convertPrice(deliveryCharge)}',
//             ),
//
//             const Padding(
//               padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
//               child: CustomDividerWidget(),
//             ),
//
//             ItemViewWidget(
//               title: getTranslated(kmWiseCharge ? 'subtotal' : 'total_amount', context)!,
//               subTitle: PriceConverterHelper.convertPrice(total),
//               titleStyle: rubikSemiBold.copyWith(
//                 fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).primaryColor,
//               ),
//             ),
//
//             if(ResponsiveHelper.isDesktop(context)) const SizedBox(height: Dimensions.paddingSizeDefault),
//
//             if(ResponsiveHelper.isDesktop(context))
//               CheckOutButtonWidget(
//                 orderAmount: orderAmount,
//                 totalWithoutDeliveryFee: totalWithoutDeliveryFee,
//               ),
//
//           ]),
//         )),
//       ],
//     );
//   }
// }