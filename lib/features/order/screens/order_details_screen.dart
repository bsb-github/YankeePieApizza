import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/order_details_model.dart';
import 'package:flutter_restaurant/common/models/response_model.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/common/widgets/no_data_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_restaurant/features/order/widgets/order_details_shimmer_widget.dart';
import 'package:flutter_restaurant/features/order/domain/models/order_model.dart';
import 'package:flutter_restaurant/features/order/providers/order_provider.dart';
import 'package:flutter_restaurant/features/order/widgets/button_widget.dart';
import 'package:flutter_restaurant/features/order/widgets/order_amount_widget.dart';
import 'package:flutter_restaurant/features/order/widgets/order_details_widget.dart';
import 'package:flutter_restaurant/helper/date_converter_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Order? orderModel;
  final int? orderId;
  final String? phoneNumber;
  final bool fromSplash;
  const OrderDetailsScreen({super.key, required this.orderModel, required this.orderId, this.phoneNumber, this.fromSplash = false});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffold = GlobalKey();


  void _loadData(BuildContext context) async {
    final OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);

    ResponseModel? response = await orderProvider.trackOrder(
      widget.orderId.toString(),
      orderModel: widget.orderModel,
      fromTracking: false,
      phoneNumber: widget.phoneNumber,
    );

    await orderProvider.getOrderDetails(
      widget.orderId.toString(),
      phoneNumber: widget.phoneNumber,
      isApiCheck: response != null && response.isSuccess,
    );
  }

  @override
  void initState() {
    super.initState();

    _loadData(context);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isDesktop = ResponsiveHelper.isDesktop(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if(widget.fromSplash) {
          RouterHelper.getMainRoute(action: RouteAction.pushNamedAndRemoveUntil);
          return;
        }

        if(didPop) return;

        if(context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        key: _scaffold,
        appBar: isDesktop
        ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBarWidget()) as PreferredSizeWidget?
        : AppBar(
          title: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text('${getTranslated('order', context)} #${widget.orderId}', style: rubikSemiBold.copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color,
            )),
            const SizedBox(height: Dimensions.paddingSizeSmall),

           Consumer<OrderProvider>(
             builder: (context, orderProvider, _) {
               return orderProvider.trackModel?.createdAt != null ? Text(DateConverterHelper.formatDate(
                 DateConverterHelper.isoStringToLocalDate(orderProvider.trackModel!.createdAt!), context,
                 isSecond: false,
               ), style: rubikRegular.copyWith(
                 color: Theme.of(context).hintColor,
                 fontSize: Dimensions.fontSizeSmall,
               )) : const SizedBox();
             }
           )

          ]),
          backgroundColor: Theme.of(context).cardColor,
          leading: IconButton(
            onPressed: () {
              if(widget.fromSplash) {
                RouterHelper.getMainRoute(action: RouteAction.pushNamedAndRemoveUntil);
              } else if(context.mounted) {
                Navigator.of(context).pop();
              }
            },
            color: Theme.of(context).primaryColor,
            highlightColor: Colors.transparent,
            icon: const Icon(Icons.arrow_back_ios),
          ),
          elevation: 0,
          centerTitle: true,
        ),

        body: Column(children: [
          Expanded(child: CustomScrollView(slivers: [
            SliverToBoxAdapter(child: Consumer<OrderProvider>(
              builder: (context, order, child) {
                double? deliveryCharge = 0;
                double itemsPrice = 0;
                double discount = 0;
                double tax = 0;
                double addOns = 0;
                double extraDiscount = 0;
                double referralDiscount = 0;
                if(order.orderDetails != null && order.orderDetails!.isNotEmpty && (order.trackModel != null &&  order.trackModel?.id != -1) ) {
                  if(order.trackModel?.orderType == 'delivery') {
                    deliveryCharge = order.trackModel!.deliveryCharge;
                  }
                  for(OrderDetailsModel orderDetails in order.orderDetails!) {
                    List<double> addonPrices = orderDetails.addOnPrices ?? [];
                    List<int> addonsIds = orderDetails.addOnIds != null ? orderDetails.addOnIds! : [];

                    if(addonsIds.length == addonPrices.length &&
                        addonsIds.length == orderDetails.addOnQtys?.length){
                      for(int i = 0; i < addonsIds.length; i++){
                        addOns = addOns + (addonPrices[i] * orderDetails.addOnQtys![i]);
                      }
                    }
                    itemsPrice = itemsPrice + (orderDetails.price! * orderDetails.quantity!);
                    discount = discount + (orderDetails.discountOnProduct! * orderDetails.quantity!);
                    tax = (tax + (orderDetails.taxAmount! * orderDetails.quantity!)) + orderDetails.addOnTaxAmount!;
                  }
                }

                if( order.trackModel != null &&  order.trackModel!.extraDiscount != null && order.trackModel?.id != -1) {
                  extraDiscount  = order.trackModel!.extraDiscount ?? 0.0;
                }

                if( order.trackModel != null &&  order.trackModel!.referralDiscount != null && order.trackModel?.id != -1) {
                  referralDiscount  = order.trackModel!.referralDiscount ?? 0.0;
                }
                double subTotal = itemsPrice + tax + addOns;
                double couponAmount = order.trackModel != null && order.trackModel?.id != -1 ?  order.trackModel?.couponDiscountAmount ?? 0 : 0;
                double total = itemsPrice + addOns - discount - extraDiscount + tax + deliveryCharge! - couponAmount - referralDiscount;


                return order.orderDetails == null || order.trackModel == null ?
                OrderDetailsShimmerWidget(enabled: !order.isLoading && order.orderDetails == null && order.trackModel == null) :
                (order.orderDetails?.isNotEmpty ?? false) ?
                isDesktop ? Column(children: [

                  Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall), child: Center(child: SizedBox(
                    width: Dimensions.webScreenWidth,
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall), child: SizedBox(
                        width: width > 700 ? 700 : width,
                        child: OrderDetailsWidget(orderId: widget.orderId))
                      ),

                      Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall), child: Container(
                        width: 400,
                        padding: width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
                        decoration: width > 700 ? BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        ) : null,
                        child: OrderAmountWidget(
                          itemsPrice: itemsPrice, tax: tax, addOns: addOns,
                          discount: discount, extraDiscount: extraDiscount,
                          total: total, subTotal: subTotal,
                          phoneNumber: widget.phoneNumber,
                          deliveryCharge: deliveryCharge,
                          referralDiscount: referralDiscount,
                        ),
                      )),
                    ]),
                  ))),


                ])
                    :
                Column(children: [
                  const OrderDetailsWidget(),

                  Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault), child: OrderAmountWidget(
                    itemsPrice: itemsPrice, tax: tax, addOns: addOns,
                    discount: discount, extraDiscount: extraDiscount,
                    total: total, subTotal: subTotal,
                    phoneNumber: widget.phoneNumber,
                    deliveryCharge: deliveryCharge,
                    referralDiscount: referralDiscount,
                  )),
                ]) : const Center(child: NoDataWidget(isFooter: false));
              },
            )),

            if(isDesktop) const SliverToBoxAdapter(
              child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                SizedBox(height: Dimensions.paddingSizeLarge),

                FooterWidget(),
              ]),
            ),

          ])),

          if(!isDesktop) ButtonWidget(phoneNumber: widget.phoneNumber),
        ]),
      ),
    );
  }
}




