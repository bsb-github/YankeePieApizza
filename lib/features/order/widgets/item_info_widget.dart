import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/product_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/features/order/providers/order_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class ItemInfoWidget extends StatelessWidget {
  const ItemInfoWidget({
    super.key,
    required this.orderProvider,
    required this.splashProvider,
  });

  final OrderProvider orderProvider;
  final SplashProvider splashProvider;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: orderProvider.orderDetails!.length,
        itemBuilder: (context, index) {
          List<AddOns> addOns = [];
          List<AddOns>? addons = orderProvider.orderDetails![index].productDetails  == null
              ? [] : orderProvider.orderDetails![index].productDetails!.addOns;

          for (var id in orderProvider.orderDetails![index].addOnIds!) {
            for (var addOn in addons!) {
              if (addOn.id == id) {
                addOns.add(addOn);
              }
            }

          }

          String variationText = '';
          if(orderProvider.orderDetails![index].variations != null && orderProvider.orderDetails![index].variations!.isNotEmpty) {
            for(Variation variation in orderProvider.orderDetails![index].variations!) {
              variationText += '${variationText.isNotEmpty ? ', ' : ''}${variation.name} (';
              for(VariationValue value in variation.variationValues!) {
                variationText += '${variationText.endsWith('(') ? '' : ', '}${value.level} - ${value.optionPrice}';
              }
              variationText += ')';
            }
          }else if(orderProvider.orderDetails![index].oldVariations != null && orderProvider.orderDetails![index].oldVariations!.isNotEmpty) {
            variationText = orderProvider.orderDetails![index].oldVariations![0].type ?? '';
          }


          return orderProvider.orderDetails![index].productDetails != null ?
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                child: CustomImageWidget(
                  placeholder: Images.placeholderImage, height: 50, width: 50,
                  image: '${splashProvider.baseUrls!.productImageUrl}/'
                      '${orderProvider.orderDetails![index].productDetails!.image}',
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              ///Name Column
              Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(
                    orderProvider.orderDetails![index].productDetails!.name!,
                    style: rubikSemiBold,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )),
                ]),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Text(variationText, style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),

                if(ResponsiveHelper.isDesktop(context))
                  Text(
                    '${getTranslated('qty', context)}: ${orderProvider.orderDetails![index].quantity.toString()}',
                    style: rubikRegular.copyWith(color: Theme.of(context).hintColor),
                  ),
              ])),

              ///Quantity Column
              if(! ResponsiveHelper.isDesktop(context))
                Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'x ${orderProvider.orderDetails![index].quantity.toString()}',
                    style: rubikRegular.copyWith(color: Theme.of(context).hintColor),
                  ),
                ])),

              Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                CustomDirectionalityWidget(child: Text(
                  PriceConverterHelper.convertPrice(orderProvider.orderDetails![index].price! - orderProvider.orderDetails![index].discountOnProduct!),
                  overflow: TextOverflow.ellipsis, maxLines: 1,
                  style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                )),

                orderProvider.orderDetails![index].discountOnProduct! > 0 ? CustomDirectionalityWidget(child: Text(
                  PriceConverterHelper.convertPrice(orderProvider.orderDetails![index].price),
                  overflow: TextOverflow.ellipsis, maxLines: 1,
                  style: rubikSemiBold.copyWith(
                    decoration: TextDecoration.lineThrough,
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).hintColor.withValues(alpha:0.7),
                  ),
                )) : const SizedBox(),
              ])),
            ]),

            addOns.isNotEmpty ? Container(
              height: 30,
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
              child: Row(children: [
                Text('${getTranslated('addons', context)}: ', style: rubikRegular.copyWith(color: Theme.of(context).hintColor)),

                Expanded(child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: addOns.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                      child: Row(children: [

                        Text(addOns[i].name!, style: rubikRegular.copyWith(color: Theme.of(context).hintColor)),
                        const SizedBox(width: 2),

                        CustomDirectionalityWidget(child: Text(
                          PriceConverterHelper.convertPrice(addOns[i].price),
                          style: rubikRegular.copyWith(color: Theme.of(context).hintColor),
                        )),
                        const SizedBox(width: 2),

                        Text('(${orderProvider.orderDetails![index].addOnQtys![i]})', style: rubikRegular.copyWith(
                          color: Theme.of(context).hintColor,
                        )),

                      ]),
                    );
                  },
                )),
              ]),
            ) : const SizedBox.shrink(),

            const Padding(
              padding: EdgeInsets.only(top: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeSmall),
              child: Divider(height: 1),
            ),
          ]) : const SizedBox.shrink();
        },
      ),

     if(orderProvider.trackModel?.isCutlery ?? false) Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(getTranslated('cutlery', context)!, style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),

        Text(getTranslated('yes', context)!, style: rubikSemiBold),
      ]),
      const SizedBox(height: Dimensions.paddingSizeSmall),
    ]);
  }
}