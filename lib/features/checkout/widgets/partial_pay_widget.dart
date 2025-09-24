// import 'package:flutter/material.dart';
// import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
// import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
// import 'package:flutter_restaurant/features/checkout/providers/checkout_provider.dart';
// import 'package:flutter_restaurant/features/checkout/widgets/partial_pay_dialog_widget.dart';
// import 'package:flutter_restaurant/features/language/providers/localization_provider.dart';
// import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
// import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
// import 'package:flutter_restaurant/helper/price_converter_helper.dart';
// import 'package:flutter_restaurant/localization/language_constrants.dart';
// import 'package:flutter_restaurant/utill/dimensions.dart';
// import 'package:flutter_restaurant/utill/images.dart';
// import 'package:flutter_restaurant/utill/styles.dart';
// import 'package:provider/provider.dart';
//
// class PartialPayWidget extends StatelessWidget {
//   final double totalPrice;
//   const PartialPayWidget({super.key, required this.totalPrice});
//
//   @override
//   Widget build(BuildContext context) {
//     final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
//     final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
//     final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final LocalizationProvider localizationProvider = Provider.of<LocalizationProvider>(context, listen: false);
//
//
//     return Consumer<CheckoutProvider>(builder: (ctx, checkoutProvider, _) {
//
//       bool isPartialPayment = authProvider.isLoggedIn() && splashProvider.configModel!.isPartialPayment!
//           && splashProvider.configModel!.walletStatus!
//           && (profileProvider.userInfoModel != null
//               && (profileProvider.userInfoModel!.walletBalance ?? 0) > 0
//               &&  profileProvider.userInfoModel!.walletBalance! <= totalPrice);
//
//       bool isSelected = (checkoutProvider.paymentMethodIndex == 1 && checkoutProvider.selectedPaymentMethod != null);
//
//       return isPartialPayment ? Container(
//         decoration: BoxDecoration(
//           color: Theme.of(context).cardColor,
//           border: Border.all(color: Theme.of(context).hintColor.withValues(alpha:0.5), width: 0.5),
//           borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
//           image: DecorationImage(
//             alignment: localizationProvider.isLtr ? Alignment.centerRight : Alignment.centerLeft,
//             scale: 0.2,
//             colorFilter: ColorFilter.mode(Colors.white.withValues(alpha:0.08), BlendMode.dstATop),
//             image: const AssetImage(Images.partialPay),
//           ),
//         ),
//         padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
//         margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//
//           Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             const CustomAssetImageWidget(Images.partialPay, height: 30, width: 30),
//             const SizedBox(width: Dimensions.paddingSizeSmall),
//
//             Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Text(
//                 PriceConverterHelper.convertPrice(profileProvider.userInfoModel!.walletBalance!),
//                 style: rubikBold.copyWith(fontSize: Dimensions.fontSizeOverLarge, color: Theme.of(context).textTheme.bodyMedium?.color),
//               ),
//               const SizedBox(height: Dimensions.paddingSizeExtraSmall),
//
//               Text(
//                 checkoutProvider.partialAmount != null ? getTranslated('has_paid_by_your_wallet', context)! : getTranslated('your_have_balance_in_your_wallet', context)!,
//                 style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha:0.9)),
//               ),
//             ]),
//
//           ]),
//           const SizedBox(height: Dimensions.paddingSizeSmall),
//
//           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//
//             checkoutProvider.partialAmount != null || isSelected ? Row(children: [
//               Container(
//                 decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
//                 padding: const EdgeInsets.all(2),
//                 child: const Icon(Icons.check, size: 12, color: Colors.white),
//               ),
//               const SizedBox(width: Dimensions.paddingSizeExtraSmall),
//
//               Text(
//                 getTranslated('applied', context)!,
//                 style: rubikSemiBold.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color),
//               )
//             ]) : Text(
//               getTranslated('do_you_want_to_use_now', context)!,
//               style: rubikSemiBold.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color),
//             ),
//
//             InkWell(
//               onTap: (){
//                 if(checkoutProvider.partialAmount != null || isSelected){
//                   checkoutProvider.changePartialPayment();
//                   checkoutProvider.savePaymentMethod(index: null, method: null);
//                 }else{
//                   showDialog(context: context, builder: (ctx)=> PartialPayDialogWidget(
//                     isPartialPay: profileProvider.userInfoModel!.walletBalance! < totalPrice,
//                     totalPrice: totalPrice,
//                   ));
//                 }
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: checkoutProvider.partialAmount != null || isSelected ? Theme.of(context).cardColor : Theme.of(context).primaryColor,
//                   border: Border.all(color: checkoutProvider.partialAmount != null || isSelected ? Colors.red : Theme.of(context).primaryColor, width: 0.5),
//                   borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
//                 ),
//                 padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeExtraLarge),
//                 child: Text(
//                   checkoutProvider.partialAmount != null || isSelected ? getTranslated('remove', context)! : getTranslated('use', context)!,
//                   style: rubikBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: checkoutProvider.partialAmount != null || isSelected ? Colors.red : Colors.white),
//                 ),
//               ),
//             ),
//
//           ]),
//
//           isSelected ? Text(
//             '${getTranslated('remaining_wallet_balance', context)}: ${PriceConverterHelper.convertPrice(profileProvider.userInfoModel!.walletBalance! - totalPrice)}',
//             style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
//           ) : const SizedBox(),
//
//         ]),
//       ) : const SizedBox();
//     }
//     );
//
//   }
// }
