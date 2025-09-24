import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/order/providers/order_provider.dart';
import 'package:flutter_restaurant/features/order/widgets/delivery_info_widget.dart';
import 'package:flutter_restaurant/features/order/widgets/delivery_man_widget.dart';
import 'package:flutter_restaurant/features/order/widgets/item_info_widget.dart';
import 'package:flutter_restaurant/features/order/widgets/order_status_widget.dart';
import 'package:flutter_restaurant/features/order/widgets/payment_info_widget.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/date_converter_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class OrderDetailsWidget extends StatelessWidget {
  const OrderDetailsWidget({super.key, this.orderId});
  final int? orderId;

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    final bool isDesktop = ResponsiveHelper.isDesktop(context);

    return Consumer<OrderProvider>(
        builder: (context, order, _) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            if(isDesktop) Container(
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('${getTranslated('order', context)} #$orderId', style: rubikSemiBold.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                )),
                const SizedBox(height: Dimensions.paddingSizeSmall),

               if(order.trackModel?.createdAt != null) Text(DateConverterHelper.formatDate(
                  DateConverterHelper.isoStringToLocalDate(order.trackModel?.createdAt ?? ''), context,
                  isSecond: false,
                ), style: rubikRegular.copyWith(
                  color: Theme.of(context).hintColor,
                  fontSize: Dimensions.fontSizeSmall,
                )),
              ]),
            ),

            OrderStatusWidget(orderModel: order.trackModel),

            if(isDesktop) ...[
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
                margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(getTranslated('delivery_info', context)!, style: rubikBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  const Divider(height: Dimensions.paddingSizeLarge),

                  const DeliveryInfoWidget(),
                ]),
              ),

              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
                margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(getTranslated('item_info', context)!, style: rubikBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  ItemInfoWidget(orderProvider: order, splashProvider: splashProvider),
                ]),
              ),

             if(order.trackModel?.deliveryMan != null) Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
                margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(getTranslated('delivery_man', context)!, style: rubikBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  DeliveryManWidget(deliveryMan: order.trackModel!.deliveryMan!),
                ]),
              ),

              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
                margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(getTranslated('payment_info', context)!, style: rubikBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  // const SizedBox(height: Dimensions.paddingSizeDefault),

                  PaymentInfoWidget(orderProvider: order),
                ]),
              ),

              if(order.trackModel?.orderNote?.isNotEmpty ?? false)
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
                  margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(getTranslated('delivery_note', context)!, style: rubikBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      Text(order.trackModel?.orderNote ?? '', style: rubikRegular.copyWith(color: Theme.of(context).hintColor)),

                    ]),
                  ]),
                ),
            ],

            if(!isDesktop) Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(getTranslated('delivery_info', context)!, style: rubikBold),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: [BoxShadow(
                      color: Theme.of(context).shadowColor.withValues(alpha:0.5), blurRadius: Dimensions.radiusSmall,
                      spreadRadius: 1, offset: const Offset(2, 2),
                    )],
                  ),
                  // padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
                  child: const DeliveryInfoWidget(),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Text(getTranslated('item_info', context)!, style: rubikBold),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: [BoxShadow(
                      color: Theme.of(context).shadowColor.withValues(alpha:0.5),
                      blurRadius: Dimensions.radiusSmall, spreadRadius: 1, offset: const Offset(2, 2),
                    )],
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: ItemInfoWidget(orderProvider: order, splashProvider: splashProvider),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                if(order.trackModel?.deliveryMan != null) Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(getTranslated('delivery_man', context)!, style: rubikBold),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      boxShadow: [BoxShadow(
                        color: Theme.of(context).shadowColor.withValues(alpha:0.5), blurRadius: 5, spreadRadius: 1, offset: const Offset(2, 2),
                      )],
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child:  DeliveryManWidget(deliveryMan: order.trackModel!.deliveryMan!),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                ]),

                Text(getTranslated('payment_info', context)!, style: rubikBold),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: [
                      BoxShadow(color: Theme.of(context).shadowColor.withValues(alpha:0.5), blurRadius: 5, spreadRadius: 1, offset: const Offset(2, 2)),
                    ],
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: PaymentInfoWidget(orderProvider: order),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                if(order.trackModel?.orderNote?.isNotEmpty ?? false) ...[
                  Text(getTranslated('delivery_note', context)!, style: rubikBold),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      boxShadow: [BoxShadow(
                        color: Theme.of(context).shadowColor.withValues(alpha:0.5), blurRadius: 5, spreadRadius: 1, offset: const Offset(2, 2),
                      )],
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      Text(order.trackModel?.orderNote ?? '', style: rubikRegular.copyWith(color: Theme.of(context).hintColor)),
                    ]),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                ],
                const SizedBox(height: Dimensions.paddingSizeSmall),
              ]),
            ),

            /*Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${getTranslated('order_id', context)}:', style: rubikRegular),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

              Text(order.trackModel!.id.toString(), style: rubikMedium),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

              const Expanded(child: SizedBox()),

              const Icon(Icons.watch_later, size: 17),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

              order.trackModel!.deliveryTime != null ? Text(
                DateConverterHelper.deliveryDateAndTimeToDate(order.trackModel!.deliveryDate!, order.trackModel!.deliveryTime!, context),
                style: rubikRegular,
              ) : Text(
                DateConverterHelper.isoStringToLocalDateOnly(order.trackModel!.createdAt!),
                style: rubikRegular,
              ),
            ]),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Row(children: [
              Text('${getTranslated('item', context)}:', style: rubikRegular),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

              Text(order.orderDetails!.length.toString(), style: rubikMedium.copyWith(color: Theme.of(context).primaryColor)),
              const Expanded(child: SizedBox()),

              order.trackModel!.orderType == 'delivery' ? TextButton.icon(
                onPressed: () {
                  if(order.trackModel!.deliveryAddress != null) {
                    RouterHelper.getMapRoute(AddressModel(), deliveryAddress: order.trackModel!.deliveryAddress!);
                  } else{
                    showCustomSnackBarHelper(getTranslated('address_not_found', context));
                  }
                },
                icon: const Icon(Icons.map, size: 18),
                label: Text(getTranslated('delivery_address', context)!, style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(width: 1)),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    minimumSize: const Size(1, 30)
                ),
              ) : order.trackModel!.orderType == 'pos'
                  ? Text(getTranslated('pos_order', context)!, style: poppinsRegular) :
              order.trackModel!.orderType == 'dine_in' ? Text(getTranslated('dine_in', context)!, style: poppinsRegular) :
              Text(getTranslated('${order.trackModel!.orderType}', context)!, style: rubikMedium),

            ]),
            const Divider(height: 20),*/

          ]);
        }
    );
  }
}