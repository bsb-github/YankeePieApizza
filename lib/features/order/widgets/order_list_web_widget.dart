import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/no_data_widget.dart';
import 'package:flutter_restaurant/common/widgets/paginated_list_widget.dart';
import 'package:flutter_restaurant/features/order/domain/models/order_model.dart';
import 'package:flutter_restaurant/features/order/providers/order_provider.dart';
import 'package:flutter_restaurant/features/order/widgets/order_item_web_widget.dart';
import 'package:flutter_restaurant/features/order/widgets/order_shimmer_widget.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class OrderListWebWidget extends StatelessWidget {
  final OrderModel? orderModel;
  final String filterType;
  const OrderListWebWidget({super.key, this.orderModel, required this.filterType});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: Consumer<OrderProvider>(
        builder: (context, order, index) {

          return orderModel != null ? orderModel!.orderList!.isNotEmpty ? RefreshIndicator(
            onRefresh: () async {
              await Provider.of<OrderProvider>(context, listen: false).getOrderList(context, offset: 1, orderFilter: filterType);
            },
            backgroundColor: Theme.of(context).primaryColor,
            color: Theme.of(context).cardColor,
            child: Column(children: [

              Container(
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).indicatorColor.withValues(alpha:0.05),
                  border: Border.all(color: Theme.of(context).indicatorColor.withValues(alpha:0.1)),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radiusDefault),
                    topRight: Radius.circular(Dimensions.radiusDefault),
                  ),
                ),
                child: Row(children: [
                  Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(getTranslated('order_details', context)!, style: rubikSemiBold),
                      const SizedBox(width: 50),
                    ]),
                  ])),

                  Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(getTranslated('quantity', context)!, style: rubikSemiBold),
                  ])),

                  Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(getTranslated('estimated_arrival', context)!, style: rubikSemiBold),
                  ])),

                  Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(getTranslated('total', context)!, style: rubikSemiBold),
                  ])),

                  Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(getTranslated('action', context)!, style: rubikSemiBold),
                  ])),
                ]),
              ),

              SizedBox(height: 400, child: PaginatedListWidget(
                onPaginate: (int? offset) async  {
                  await order.getOrderList(context, offset: offset, orderFilter: filterType);
                },
                totalSize: orderModel?.totalSize,
                offset: orderModel?.offset,
                limit: orderModel?.limit,
                builder: (loadingWidget){
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      itemCount: orderModel!.orderList!.length,
                      itemBuilder: (context, index) => SizedBox(height: 100, child: OrderItemWebWidget(
                        orderProvider: order,  orderItem: orderModel!.orderList![index],
                      )),
                    ),
                  );
                },
              )),

            ]),
          ) : const Center(child: NoDataWidget(isOrder: true)) : const OrderShimmerWidget();
        },
      ),
    );
  }
}
