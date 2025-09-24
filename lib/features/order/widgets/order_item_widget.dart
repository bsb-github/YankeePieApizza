import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/order/domain/models/order_model.dart';
import 'package:flutter_restaurant/features/order/providers/order_provider.dart';
import 'package:flutter_restaurant/features/order/widgets/ordered_product_image_widget.dart';
import 'package:flutter_restaurant/features/order_track/providers/tracker_provider.dart';
import 'package:flutter_restaurant/helper/date_converter_helper.dart';
import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';


class OrderItemWidget extends StatelessWidget {
  final Order orderItem;
  final bool isRunning;
  final OrderProvider orderProvider;
  final bool isAddDate;
  const OrderItemWidget({super.key, required this.orderProvider, required this.isRunning, required this.orderItem, required this.isAddDate});

  @override
  Widget build(BuildContext context) {
    final TrackerProvider timerProvider = Provider.of<TrackerProvider>(context, listen: false);

    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      if(!isRunning && isAddDate)
        Padding(
          padding: const EdgeInsets.only(left:Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall),
          child: Text(DateConverterHelper.estimatedDate(DateTime.parse(orderItem.deliveryDate!)), style: rubikRegular.copyWith(
            color: Theme.of(context).hintColor,
            fontSize: Dimensions.fontSizeDefault,
          )),
        ),

      Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
          margin: const EdgeInsets.only(left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
          child: InkWell(
            onTap: () => RouterHelper.getOrderDetailsRoute('${orderItem.id}'),
            child: Column(children: [

              isRunning
                ? Row(children: [

                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      OrderedProductImageWidget(orderItem: orderItem),

                    ]),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(
                    flex: 3,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(
                          '#${orderItem.id.toString()}',
                          style: rubikBold.copyWith(color: Theme.of(context).primaryColor),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                          decoration: BoxDecoration(
                            color: ColorResources.buttonBackgroundColorMap['${orderItem.orderStatus}'],
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                          child: Text(
                            '${getTranslated('${orderItem.orderStatus}', context)}',
                            style: rubikSemiBold.copyWith(color: ColorResources.buttonTextColorMap['${orderItem.orderStatus}'], fontSize: Dimensions.fontSizeSmall),
                          ),
                        ),
                      ]),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(
                          '${orderItem.detailsCount} ${getTranslated(orderItem.detailsCount! > 1 ? 'items' : 'item', context)}',
                          style: rubikRegular.copyWith(color: Theme.of(context).hintColor.withValues(alpha:0.7), fontSize: Dimensions.fontSizeSmall),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                        Text(getTranslated('estimate_arrival', context)!, style: rubikSemiBold.copyWith(
                          color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeExtraSmall,
                        )),
                      ]),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text( PriceConverterHelper.convertPrice((orderItem.orderAmount ?? 0) + (orderItem.deliveryCharge ?? 0)), style: rubikBold),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                        Text(DateConverterHelper.getEstimateTime(timerProvider.getEstimateDuration(orderItem, context) ?? const Duration(), context) , style: rubikBold.copyWith(color: Theme.of(context).primaryColor)),
                      ]),

                    ]),
                  ),

              ])
                : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Expanded(
                    flex: 3,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [

                      Text(
                        '${getTranslated('order', context)} #${orderItem.id.toString()}',
                        style: rubikBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      Text(PriceConverterHelper.convertPrice((orderItem.deliveryCharge ?? 0) + (orderItem.orderAmount ?? 0)), style: rubikBold.copyWith(
                        fontSize: Dimensions.fontSizeLarge
                      )),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      Text(getTranslated(orderItem.paymentMethod, context) ?? '', style: rubikSemiBold),

                    ]),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeExtraSmall),
                        decoration: BoxDecoration(
                          color: ColorResources.buttonBackgroundColorMap['${orderItem.orderStatus}'],
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        ),
                        child: Text(
                          '${getTranslated('${orderItem.orderStatus}', context)}',
                          style: rubikSemiBold.copyWith(
                              color: ColorResources.buttonTextColorMap['${orderItem.orderStatus}'],
                              fontSize: Dimensions.fontSizeSmall
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      OrderedProductImageWidget(orderItem: orderItem),

                    ]),
                  ),

              ]),

            ]),
          ),
        ),

    ]);
  }
}

