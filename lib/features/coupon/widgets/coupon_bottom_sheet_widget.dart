import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_dialog_shape_widget.dart';
import 'package:flutter_restaurant/features/coupon/domain/models/coupon_model.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/date_converter_helper.dart';
import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:go_router/go_router.dart';

class CouponBottomSheetWidget extends StatelessWidget {
  final CouponModel? coupon;
  const CouponBottomSheetWidget({super.key, required this.coupon});

  @override
  Widget build(BuildContext context) {


    return CustomDialogShapeWidget(
      padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context) ? 35 : 0),
      child: SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        
          /// Header section
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
                  onTap: () => context.pop(),
                  child: Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      transform: Matrix4.translationValues(0, -13, 0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, size: Dimensions.fontSizeExtraLarge, color: Theme.of(context).hintColor)),
                ),
        
              ]),
            ),
        
          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge).copyWith(top: Dimensions.paddingSizeExtraSmall),
            child: Row(children: [
              const CustomAssetImageWidget(Images.couponIcon, height: 35, width: 35),
              const SizedBox(width: Dimensions.paddingSizeSmall),
        
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  coupon?.code ?? '',
                  style: rubikBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        
                Text('${PriceConverterHelper.getDiscountType(discount: coupon?.discount, discountType: coupon?.discountType)} ${coupon?.title}')
        
              ])
            ]),
          ),
        
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Divider(height: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.15)),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),
        
        
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                child: Text(getTranslated('terms_and_condition', context)!, style: rubikSemiBold),
              ),
        
              _CouponItemWidget(label: getTranslated('start_date', context), info: DateConverterHelper.localDateToIsoStringAMPM(DateConverterHelper.convertStringToDatetime(coupon?.startDate ?? ''), context)),
        
              _CouponItemWidget(label: getTranslated('end_date', context), info: DateConverterHelper.localDateToIsoStringAMPM(DateConverterHelper.convertStringToDatetime(coupon?.expireDate ?? ''), context)),
        
              _CouponItemWidget(label: getTranslated('limit_for_same_user', context), info: '${coupon?.limit}'),
        
              _CouponItemWidget(label: getTranslated('discount', context), info: PriceConverterHelper.getDiscountType(discount: coupon?.discount, discountType: coupon?.discountType)),
        
              _CouponItemWidget(label: getTranslated('maximum_discount', context), info: PriceConverterHelper.convertPrice(coupon?.maxDiscount)),
        
              _CouponItemWidget(label: getTranslated('minimum_order_amount', context), info: PriceConverterHelper.convertPrice(coupon?.minPurchase)),
        
            ]),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
        
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ? 60 : Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
            child: CustomButtonWidget(
              btnTxt: getTranslated('copy_this_coupon', context),
              onTap: (){
                Clipboard.setData(ClipboardData(text: coupon?.code ?? '')).then((value){
                  Future.delayed(const Duration(milliseconds: 800), () {
                    showCustomSnackBarHelper(getTranslated('coupon_code_copied', Get.context!), isError:  false);
                  });
                });
              },
              borderRadius: Dimensions.radiusDefault,
              postImage: Images.copyIcon,
            ),
          ),
        
        ]),
      ),
    );
  }
}

class _CouponItemWidget extends StatelessWidget {
  final String? label;
  final String? info;
  const _CouponItemWidget({this.label, this.info});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          height: Dimensions.paddingSizeExtraSmall,
          width: Dimensions.paddingSizeExtraSmall,
          decoration: BoxDecoration(
            color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
            shape: BoxShape.circle
          ),
        ),

        Text('$label : $info', style: rubikRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.55)))
      ]),
    );
  }
}

