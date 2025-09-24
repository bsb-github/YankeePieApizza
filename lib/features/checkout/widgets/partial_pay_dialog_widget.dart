// import 'package:flutter/material.dart';
// import 'package:flutter_restaurant/common/providers/theme_provider.dart';
// import 'package:flutter_restaurant/features/checkout/providers/checkout_provider.dart';
// import 'package:flutter_restaurant/helper/price_converter_helper.dart';
// import 'package:flutter_restaurant/localization/language_constrants.dart';
// import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
// import 'package:flutter_restaurant/utill/color_resources.dart';
// import 'package:flutter_restaurant/utill/dimensions.dart';
// import 'package:flutter_restaurant/utill/images.dart';
// import 'package:flutter_restaurant/utill/styles.dart';
// import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
// import 'package:provider/provider.dart';
// import 'package:go_router/go_router.dart';
//
// class PartialPayDialogWidget extends StatelessWidget {
//   final bool isPartialPay;
//   final double totalPrice;
//   const PartialPayDialogWidget({super.key, required this.isPartialPay, required this.totalPrice});
//
//   @override
//   Widget build(BuildContext context) {
//     final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
//     final CheckoutProvider checkoutProvider = Provider.of<CheckoutProvider>(context, listen: false);
//     final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
//
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
//       insetPadding: const EdgeInsets.all(30),
//       clipBehavior: Clip.antiAliasWithSaveLayer,
//       child: SizedBox(
//         width: 500,
//         child: Column(mainAxisSize: MainAxisSize.min, children: [
//
//           Align(alignment: Alignment.topRight, child: InkWell(
//             onTap: ()=> context.pop(),
//             child: const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Icon(Icons.clear, size: 24),
//             ),
//           )),
//
//
//           Image.asset(Images.note, width: 35, height: 35),
//           const SizedBox(height: Dimensions.paddingSizeSmall),
//
//           Text(
//             getTranslated('note', context)!, textAlign: TextAlign.center,
//             style: rubikBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: themeProvider.darkTheme ? Theme.of(context).primaryColor : ColorResources.homePageSectionTitleColor),
//           ),
//
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
//             child: Row(children: [
//
//               Expanded(
//                 child: RichText(textAlign : TextAlign.center, text: TextSpan(children: [
//                   TextSpan(text: getTranslated(
//                       isPartialPay ?
//                   'you_do_not_have_sufficient_balance_to_pay_full_amount_via_wallet'
//                   :
//                   'you_can_pay_the_full_amount_with_your_wallet', context)!, style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: themeProvider.darkTheme ? Theme.of(context).primaryColor : ColorResources.homePageSectionTitleColor)),
//
//                   const TextSpan(text: ' '),
//
//                   TextSpan(text: getTranslated(isPartialPay ? 'want_to_pay_partially_with_wallet' : 'want_to_pay_via_wallet', context)!,
//                     style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).colorScheme.error),),
//                 ])),
//               ),
//
//
//             ]),
//           ),
//
//
//           const SizedBox(height: Dimensions.paddingSizeDefault),
//
//           Image.asset(Images.partialPay, height: 35, width: 35),
//           const SizedBox(height: Dimensions.paddingSizeSmall),
//
//           Text(
//             PriceConverterHelper.convertPrice(profileProvider.userInfoModel?.walletBalance),
//             style: rubikBold.copyWith(fontSize: Dimensions.fontSizeOverLarge, color: Theme.of(context).primaryColor),
//           ),
//
//           Padding(
//             padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
//             child: Text(
//               isPartialPay ? getTranslated('can_be_paid_via_wallet', context)!
//                   : '${getTranslated('remaining_wallet_balance', context)}: ${PriceConverterHelper.convertPrice(profileProvider.userInfoModel!.walletBalance! - totalPrice)}',
//               style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor), textAlign: TextAlign.center,
//             ),
//           ),
//
//           Padding(
//             padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
//             child: Row(children: [
//               Expanded(child: CustomButtonWidget(
//                 btnTxt: getTranslated('no', context),
//                 backgroundColor: Theme.of(context).disabledColor,
//                 onTap: (){
//                   checkoutProvider.savePaymentMethod(index: null, method: null);
//                 if(checkoutProvider.partialAmount != null){
//                   checkoutProvider.changePartialPayment();
//                 }
//                 context.pop();
//                 },
//               )),
//               const SizedBox(width: Dimensions.paddingSizeSmall),
//
//               Expanded(child: CustomButtonWidget(btnTxt: getTranslated('yes_pay', context), onTap: (){
//                 if(isPartialPay){
//                   checkoutProvider.changePartialPayment(amount: totalPrice - profileProvider.userInfoModel!.walletBalance!);
//                 }else{
//                   checkoutProvider.setPaymentIndex(1);
//                   checkoutProvider.clearOfflinePayment();
//                   checkoutProvider.savePaymentMethod(index: checkoutProvider.paymentMethodIndex, method: checkoutProvider.paymentMethod);
//                 }
//                 context.pop();
//               })),
//             ]),
//           ),
//         ]),
//       ),
//     );
//   }
// }
