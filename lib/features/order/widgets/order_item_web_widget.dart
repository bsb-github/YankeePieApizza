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


class OrderItemWebWidget extends StatelessWidget {
  final Order orderItem;

  final OrderProvider orderProvider;
  const OrderItemWebWidget({super.key, required this.orderProvider, required this.orderItem});


  @override
  Widget build(BuildContext context) {
    final TrackerProvider timerProvider = Provider.of<TrackerProvider>(context, listen: false);

    return Column(mainAxisSize: MainAxisSize.min, children: [

      InkWell(
        onTap: () => RouterHelper.getOrderDetailsRoute('${orderItem.id}'),
        hoverColor: Theme.of(context).primaryColor.withValues(alpha:0.03),
        child: SizedBox(
          height: 80,
          child: Row(children: [

            Expanded(child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
              SizedBox(
                width: 80, height: 80,
                child: OrderedProductImageWidget(orderItem: orderItem),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Text(
                '#${orderItem.id.toString()}',
                style: rubikBold.copyWith(color: Theme.of(context).primaryColor),
              ),
            ])),

            Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                '${orderItem.detailsCount} ${getTranslated(orderItem.detailsCount! > 1 ? 'items' : 'item', context)}',
                style: rubikRegular.copyWith(color: Theme.of(context).hintColor.withValues(alpha:0.7)),
              ),
            ])),

            Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(DateConverterHelper.getEstimateTime(timerProvider.getEstimateDuration(orderItem, context) ?? const Duration(), context) , style: rubikBold.copyWith(color: Theme.of(context).primaryColor)),

            ])),

            Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text( PriceConverterHelper.convertPrice((orderItem.orderAmount ?? 0) + (orderItem.deliveryCharge ?? 0)), style: rubikBold),

            ])),

            Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                decoration: BoxDecoration(
                  color: ColorResources.buttonBackgroundColorMap['${orderItem.orderStatus}'],
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
                child: Text(
                  '${getTranslated('${orderItem.orderStatus}', context)}',
                  style: rubikSemiBold.copyWith(
                      color: ColorResources.buttonTextColorMap['${orderItem.orderStatus}']
                  ),
                ),
              ),
            ])),

          ]),
        ),
      ),

      Divider(color: Theme.of(context).primaryColor.withValues(alpha:0.2), thickness: 0.5),

    ]);
  }
}