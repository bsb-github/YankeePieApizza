import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_bottom_sheet_header.dart';
import 'package:flutter_restaurant/common/widgets/custom_dialog_shape_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_restaurant/features/coupon/providers/coupon_provider.dart';
import 'package:flutter_restaurant/features/coupon/widgets/coupon_card_widget.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CouponAddWidget extends StatefulWidget {
  const CouponAddWidget({
    super.key,
    required TextEditingController couponController,
    required this.amountWithoutTax,
  }) : _couponController = couponController;

  final TextEditingController _couponController;
  final double amountWithoutTax;

  @override
  State<CouponAddWidget> createState() => _CouponAddWidgetState();
}

class _CouponAddWidgetState extends State<CouponAddWidget> {

  @override
  void initState() {
    Provider.of<CouponProvider>(context, listen: false).getCouponList(orderAmount: widget.amountWithoutTax);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final CouponProvider couponProvider = Provider.of<CouponProvider>(context, listen: false);
    final double height = MediaQuery.sizeOf(context).height;
    final Size size = MediaQuery.sizeOf(context);

    return CustomDialogShapeWidget(
      maxHeight: height * 0.6,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.isDesktop(context) ? 80 : Dimensions.paddingSizeLarge,
        vertical: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeExtraSmall,
      ),
      child: Column(children: [

        const CustomBottomSheetHeader(
          title: '',
          titleSize: Dimensions.fontSizeLarge,
          titleWeight: FontWeight.bold,
        ),

        if(ResponsiveHelper.isMobile())
          const SizedBox(height: Dimensions.paddingSizeLarge),

        /// for Coupon add text field
        Consumer<CouponProvider>(
          builder: (context, coupon, child) {
            return IntrinsicHeight(
              child: Row(children: [

                Expanded(child: CustomTextFieldWidget(
                  isShowBorder: true,
                  hintText: getTranslated('enter_coupon', context),
                  controller: widget._couponController,
                  prefixIconUrl: Images.couponSvg,
                  isShowPrefixIcon: true,
                  prefixIconColor: Theme.of(context).hintColor.withValues(alpha:0.5),
                  borderColor: Theme.of(context).hintColor.withValues(alpha:0.5),
                )),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                InkWell(
                  onTap: coupon.discount != 0 ? null : () {
                    _applyCouponMethod(coupon, context, true, widget._couponController.text);
                  },
                  child: Container(
                    width: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: coupon.discount! <= 0 ? !coupon.isLoading ? Text(
                      getTranslated('apply', context)!,
                      style: rubikSemiBold.copyWith(color: Colors.white),
                    ) : const Center(child: SizedBox(
                      width: Dimensions.paddingSizeLarge,
                      height: Dimensions.paddingSizeLarge,
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                    )) : InkWell(
                      onTap: () {
                        widget._couponController.clear();
                        coupon.removeCouponData(true);
                        showCustomSnackBarHelper(getTranslated('coupon_removed_successfully', context),isError: false);

                      },
                      child: const Icon(Icons.clear, color: Colors.white),
                    ),
                  ),
                ),
              ]),
            );
          },
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        Expanded(
          child: Consumer<CouponProvider>(
            builder: (context, coupon, child) {
              return coupon.availableCouponList == null ? _CouponShimmerWidget(isEnabled: couponProvider.availableCouponList == null) :
              (coupon.availableCouponList?.isNotEmpty ?? false) ? RefreshIndicator(
                onRefresh: () async {
                  await couponProvider.getCouponList();
                },
                backgroundColor: Theme.of(context).primaryColor,
                color: Theme.of(context).cardColor,
                child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

                  /// Available Coupon
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
                    child: Text(getTranslated('available_coupon_for_this_order', context)!, style: rubikBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  ),

                  ListView.builder(
                    itemCount: coupon.availableCouponList!.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: (){
                          Clipboard.setData(ClipboardData(text: coupon.availableCouponList![index].code ?? ''));
                          widget._couponController.text = coupon.availableCouponList![index].code ?? '';
                          showCustomSnackBarHelper(getTranslated('coupon_code_copied', context), isError:  false);
                        },
                        child: CouponCardWidget(
                            coupon: coupon.availableCouponList?[index],
                            fromCart: true,
                            onApplyTap: (coupon.discount != 0 || (coupon.selectedCouponIndex != null && coupon.selectedCouponIndex == index)) ? null : () {
                              Clipboard.setData(ClipboardData(text: coupon.availableCouponList![index].code ?? ''));
                              // widget._couponController.text = coupon.availableCouponList![index].code ?? '';
                              // showCustomSnackBarHelper(getTranslated('coupon_code_copied', context), isError:  false);

                              _applyCouponMethod(coupon, context, false, coupon.availableCouponList?[index].code ?? "", index: index);
                            }
                        ),
                      );

                    },
                  ),

                 if(coupon.unavailableCouponList!.isNotEmpty) Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
                    child: Text(getTranslated('unavailable_coupon', context)!, style: rubikBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  ),

                  /// UnAvailable Coupon
                  ListView.builder(
                    itemCount: coupon.unavailableCouponList!.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: null,
                        child: CouponCardWidget(
                          isAvailable: false,
                          coupon: coupon.unavailableCouponList?[index],
                          fromCart: true,
                          onApplyTap: (coupon.discount != 0 || (coupon.selectedCouponIndex != null && coupon.selectedCouponIndex == index)) ? null : () {
                            // Clipboard.setData(ClipboardData(text: coupon.unavailableCouponList![index].code ?? ''));
                            // widget._couponController.text = coupon.unavailableCouponList![index].code ?? '';
                            // showCustomSnackBarHelper(getTranslated('coupon_code_copied', context), isError:  false);

                            _applyCouponMethod(coupon, context, false, coupon.unavailableCouponList?[index].code ?? "", index: index);
                          },
                        ),
                      );
                    },
                  ),

                ])),
              ) : _NoCouponWidget(size: size);
            },
          ),
        ),

      ]),
    );
  }

  void _applyCouponMethod(CouponProvider coupon, BuildContext context, bool fromTextField, String couponCode, {int? index}) {
    if(couponCode.isNotEmpty && !coupon.isLoading ) {
      if(coupon.discount! < 1) {
        coupon.applyCoupon(couponCode, widget.amountWithoutTax, selectedIndex: index).then((discount) {
          if(context.mounted){
            context.pop();
            if (discount! > 0) {
              showCustomSnackBarHelper('${getTranslated('you_got', context)} ${PriceConverterHelper.convertPrice(discount)} ${getTranslated('discount', context)}', isError: false);
            } else {
              showCustomSnackBarHelper(getTranslated('invalid_code_or', context), isError: true);
              widget._couponController.clear();
            }
          }
        });
      } else {
        coupon.removeCouponData(true);
      }
    } else if(widget._couponController.text.isEmpty && fromTextField) {
      showCustomSnackBarHelper(getTranslated('enter_a_Coupon_code', context));
    }
  }
}

class _NoCouponWidget extends StatelessWidget {
  const _NoCouponWidget({required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: Dimensions.paddingSizeExtraLarge),
      SizedBox(
        height: size.height * 0.2, width: size.width * 0.2,
        child: const CustomAssetImageWidget(
          Images.noCouponSvg,
          fit: BoxFit.contain,
        ),
      ),
      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

      Text(
        getTranslated('no_promo_available', context)!,
        style: rubikSemiBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeLarge),
        textAlign: TextAlign.center,
      ),
    ]);
  }
}

class _CouponShimmerWidget extends StatelessWidget {
  const _CouponShimmerWidget({required this.isEnabled});
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      enabled: isEnabled,
      child: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge), child: Container(
            height: 85,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).shadowColor.withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Row(children: [

              Container(color: Theme.of(context).shadowColor.withValues(alpha:0.2), height: 35, width: 35),
              const SizedBox(width: Dimensions.paddingSizeDefault),

              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(color: Theme.of(context).shadowColor.withValues(alpha:0.2), height: 15, width: 120),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Container(color: Theme.of(context).shadowColor.withValues(alpha:0.2), height: 15, width: 100),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Container(color: Theme.of(context).shadowColor.withValues(alpha:0.2), height: 15, width: 80),
                ]),
              ),

            ]),
          ));
        },
      ),
    );
  }
}
