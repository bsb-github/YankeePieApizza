import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/features/coupon/domain/models/coupon_model.dart';
import 'package:flutter_restaurant/helper/date_converter_helper.dart';
import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class CouponCardWidget extends StatelessWidget {
  final CouponModel? coupon;
  final bool fromCart;
  final Function()? onApplyTap;
  final bool isAvailable;

  const CouponCardWidget({
    super.key,
    this.coupon,
    this.fromCart = false, this.onApplyTap, this.isAvailable = true,
  });

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, constraints) {
        final double widthSize = constraints.maxWidth;

        return Container(
          constraints: const BoxConstraints(maxHeight: 120),
          width: widthSize,
          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
          child: Stack(children: [
            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),
                  border: Border.all(width: 1, color: Colors.black.withValues(alpha: 0.05)),
                  boxShadow: [BoxShadow(
                    color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.1),
                    offset: const Offset(0, 5),
                    blurRadius: 10,
                    spreadRadius: -5,
                  )],
              ),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
                  width: widthSize * 0.3,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [

                    const CustomAssetImageWidget(Images.couponIcon, height: 30, width: 30),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Text(PriceConverterHelper.getDiscountType(discount: coupon?.discount, discountType: coupon?.discountType), style: rubikBold.copyWith(
                        fontSize: Dimensions.fontSizeLarge
                    ),overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 3),

                    Text(coupon?.title ?? '', style: rubikRegular.copyWith(
                        color: Theme.of(context).hintColor,
                        fontSize: Dimensions.fontSizeExtraSmall
                    ),overflow: TextOverflow.ellipsis),
                  ]),
                ),

                DottedLine(
                  direction: Axis.vertical,
                  dashColor: Theme.of(context).hintColor.withValues(alpha: 0.4),
                  lineThickness: 1,
                  dashLength: 5,
                ),


                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      fromCart ? Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                        width: 85, height: 35,
                        child: CustomButtonWidget(
                          btnTxt: getTranslated('apply', context),
                          borderRadius: 100,
                          showBorder: true,
                          borderColor: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                          backgroundColor: Theme.of(context).cardColor,
                          textStyle: rubikMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                          onTap: onApplyTap,
                        ),
                      ) :
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Flexible(child: Text(
                          coupon?.code ?? '',
                          style: rubikBold.copyWith(
                              fontSize: Dimensions.fontSizeLarge
                          ),
                          overflow: TextOverflow.ellipsis,
                        )),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                        const CustomAssetImageWidget(Images.copyIcon, height: Dimensions.paddingSizeDefault, width: Dimensions.paddingSizeDefault),
                      ]),

                      Text.rich(TextSpan(children: [
                        TextSpan(text: DateConverterHelper.isoStringToLocalDateOnly(coupon?.startDate ?? '')),

                        TextSpan(text: ' ${getTranslated('to', context)} '),

                        TextSpan(text: DateConverterHelper.isoStringToLocalDateOnly(coupon?.expireDate ?? '')),
                      ]), style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                      const SizedBox(height: 2),

                      Text.rich(TextSpan(children: [
                        TextSpan(text: '*', style: rubikRegular.copyWith(color: Colors.red, fontSize: Dimensions.fontSizeSmall)),

                        TextSpan(text: '${getTranslated('min_purchase', context)} '),

                        TextSpan(text: PriceConverterHelper.convertPrice(coupon?.minPurchase)),
                      ]), style: rubikRegular.copyWith(
                        fontSize: Dimensions.fontSizeExtraSmall,
                        color: Theme.of(context).hintColor,
                      )),

                    ],
                  ),
                ),

              ]),
            ),

            if(!isAvailable)
              Positioned.fill(child: Container(decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),
                  color: Theme.of(context).hintColor.withValues(alpha: 0.1),
              ))),

            Positioned(
              bottom: -22, left: widthSize * 0.3,
              child: Container(
                width: 22, height : 32,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(width: 1, color: Colors.black.withValues(alpha: 0.05)),
                ),
              ),
            ),

            Positioned(
              top: -22, left: widthSize * 0.3,
              child: Container(
                width: 22, height : 32,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(width: 1, color: Colors.black.withValues(alpha: 0.05)),
                ),
              ),
            ),


          ]),
        );
      }
    );
  }
}