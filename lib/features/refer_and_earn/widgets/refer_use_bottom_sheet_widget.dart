import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_dialog_shape_widget.dart';
import 'package:flutter_restaurant/features/profile/domain/models/userinfo_model.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/helper/date_converter_helper.dart';
import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ReferUseBottomSheetWidget extends StatelessWidget {
  final ReferralCustomerDetails referralDetails;
  const ReferUseBottomSheetWidget({super.key, required this.referralDetails});

  @override
  Widget build(BuildContext context) {

    var expireDate = DateConverterHelper.calculateExpireDate(
      createdAt: referralDetails.createdAt!,
      validity: referralDetails.customerDiscountValidity ?? 0,
      validityType: referralDetails.customerDiscountValidityType ?? "day",
    );

    return CustomDialogShapeWidget(
      padding: EdgeInsets.zero,
      maxWidth: ResponsiveHelper.isDesktop(context) ? 400 : null,
      child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [

        const SizedBox(height: Dimensions.paddingSizeLarge),

        /// Header Section
        if(ResponsiveHelper.isMobile())
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [

              const SizedBox(width: Dimensions.paddingSizeLarge),

              Container(
                transform: Matrix4.translationValues(12, 0, 0),
                width: 35, height: 4, decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha:0.3),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
              ),

              InkWell(
                onTap: () {
                  Provider.of<ProfileProvider>(context, listen: false).updateReferralInfoShowStatus(value: 1);
                  context.pop();
                },
                child: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    transform: Matrix4.translationValues(0, -10, 0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: Dimensions.paddingSizeDefault)),
              ),

            ]),
          ),


        const CustomAssetImageWidget(Images.congratulationIconSvg, height: 70, width: 70),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        Text(getTranslated('congratulations', context)!, style: rubikBold.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w800),),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          child: Text.rich(TextSpan(children: [
            TextSpan(text: '${getTranslated('you_have_received_a', context)!} ', style: rubikMedium.copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.70),
            )),

            TextSpan(
              text: referralDetails.customerDiscountAmountType == "amount"
                  ? PriceConverterHelper.convertPrice( referralDetails.customerDiscountAmount ?? 0) : "${referralDetails.customerDiscountAmount ?? 0} %",
              style: rubikSemiBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.90),
            ),),

            TextSpan(text: ' ${getTranslated('discount_on_your_first_order_by_using_a_referral_code_during_signup', context)!} ', style: rubikMedium.copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.70),
            )),

            TextSpan(text: '${getTranslated('this_offer_is_valid_until', context)!} ', style: rubikMedium.copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.70),
            )),

            TextSpan(text: DateConverterHelper.estimatedDate(expireDate), style: rubikSemiBold.copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.90),
            )),

          ]), textAlign: TextAlign.center),
        ),

        Text(getTranslated('thank_you', context)!, style: rubikMedium.copyWith(
          color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.70),
        )),
        const SizedBox(height: Dimensions.paddingSizeExtraLarge),


        SizedBox(width: 120, child: CustomButtonWidget(
          btnTxt: getTranslated('okay', context),
          onTap: (){
            Navigator.pop(context);
            Provider.of<ProfileProvider>(context, listen: false).updateReferralInfoShowStatus(value: 1);
          },
          borderRadius: Dimensions.radiusSmall,
        )),
        const SizedBox(height: Dimensions.paddingSizeExtraLarge)

      ]),
    );
  }
}
