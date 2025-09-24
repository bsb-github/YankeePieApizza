import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/no_data_widget.dart';
import 'package:flutter_restaurant/common/widgets/paginated_list_widget.dart';
import 'package:flutter_restaurant/features/order/domain/models/order_model.dart';
import 'package:flutter_restaurant/features/order/providers/order_provider.dart';
import 'package:flutter_restaurant/features/order/widgets/order_item_widget.dart';
import 'package:flutter_restaurant/features/order/widgets/order_shimmer_widget.dart';
import 'package:flutter_restaurant/helper/date_converter_helper.dart';
import 'package:flutter_restaurant/helper/debounce_helper.dart' show DebounceHelper;
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:provider/provider.dart';

class OrderListWidget extends StatelessWidget {
  final OrderModel? orderModel;
  final String filterType;
  const OrderListWidget({super.key, this.orderModel, required this.filterType,});
  @override
  Widget build(BuildContext context) {

    final DebounceHelper debounce = DebounceHelper(milliseconds: 500);

    return Consumer<OrderProvider>(
      builder: (context, orderProvider, index) {

        List<DateTime> dateTimeList = [];

        return orderModel != null ? orderModel!.orderList != null ? RefreshIndicator(
          onRefresh: () async {
            await Provider.of<OrderProvider>(context, listen: false).getOrderList(context, orderFilter: filterType);
          },
          backgroundColor: Theme.of(context).primaryColor,
          color: Theme.of(context).cardColor,
          child: PaginatedListWidget(
              onPaginate: (int? offset){
                debounce.run(() async {
                  await orderProvider.getOrderList(context, offset: offset, orderFilter: filterType);
                });
              },
              totalSize: orderModel!.totalSize,
              offset: orderModel!.offset ?? 1,
              limit: orderModel!.limit,
              builder: (loaderWidget){
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    itemCount: orderModel!.orderList?.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      DateTime originalDateTime = DateConverterHelper.getDateOnly(orderModel!.orderList![index].deliveryDate!);
                      DateTime convertedDate = DateTime(originalDateTime.year, originalDateTime.month, originalDateTime.day);
                      bool addTitle = false;
                      if(!dateTimeList.contains(convertedDate)) {
                        addTitle = true;
                        dateTimeList.add(convertedDate);
                      }
                      return OrderItemWidget(orderProvider: orderProvider, isRunning: filterType == "ongoing", orderItem: orderModel!.orderList![index], isAddDate: addTitle);
                    },
                  ),
                );
              },
          ),
        ) : const Center(child: NoDataWidget(isOrder: true)) : const OrderShimmerWidget();
      },
    );
  }
}
