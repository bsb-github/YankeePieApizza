import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/providers/theme_provider.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/features/order/providers/order_provider.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class PaymentInfoWidget extends StatelessWidget {
  const PaymentInfoWidget({
    super.key,
    required this.orderProvider,
  });

  final OrderProvider orderProvider;

  @override
  Widget build(BuildContext context) {
    bool isExpansion = orderProvider.trackModel?.paymentMethod == 'offline_payment' ||  (orderProvider.trackModel?.orderPartialPayments?.isNotEmpty ?? false);
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [

      IgnorePointer(
        ignoring: !isExpansion,
        child: ExpansionTile(
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          expandedAlignment: Alignment.centerLeft,
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          shape: Border.all(color: Colors.transparent, width: 0.001),
          iconColor: Theme.of(context).primaryColor,
          collapsedIconColor: Theme.of(context).primaryColor,
          textColor: Theme.of(context).textTheme.bodyMedium?.color,
          internalAddSemanticForOnTap: true,
          leading: CustomAssetImageWidget(Images.payment, width: 30, height: 30, color: themeProvider.darkTheme ? Colors.white : Colors.black),
          title: Text((orderProvider.trackModel?.orderPartialPayments?.isNotEmpty ?? false) ?
          getTranslated('partial_payment', context)! :
          (orderProvider.trackModel?.paymentMethod?.isNotEmpty ?? false)
              ? orderProvider.trackModel?.paymentMethod?.toTitleCase() ?? ''
              : getTranslated('digital_payment', context)!,
            style: rubikRegular,
          ),
          subtitle: isExpansion ?  Text(
            '${getTranslated('payment_by', context)} : ${orderProvider.trackModel?.paymentMethod != 'offline_payment'
                ?  orderProvider.trackModel?.paymentMethod?.toTitleCase() : orderProvider.trackModel?.offlinePaymentInformation?.paymentName}',
            style: rubikRegular.copyWith(color: Theme.of(context).hintColor),
          ) : null,
          trailing: isExpansion ? null : const SizedBox(),

          children: orderProvider.trackModel?.offlinePaymentInformation?.methodInformation != null
              ? orderProvider.trackModel!.offlinePaymentInformation!.methodInformation!.map((item) => Column(
            children: [
              _KeyValueItemWidget(
                item: item.key ?? '',
                value: item.value ?? '',
              ),

              if(orderProvider.trackModel!.offlinePaymentInformation!.methodInformation!.indexOf(item)
                  == orderProvider.trackModel!.offlinePaymentInformation!.methodInformation!.length -1
                  && (orderProvider.trackModel?.offlinePaymentInformation?.paymentNote?.isNotEmpty ?? false))
                _KeyValueItemWidget(
                  item: getTranslated('note', context)!,
                  value: orderProvider.trackModel?.offlinePaymentInformation?.paymentNote ?? '',
                  maxLines: 3,
                ),
            ],
          )).toList() : [],
        ),
      ),

    ]);
  }
}


class _KeyValueItemWidget extends StatelessWidget {
  final String item;
  final String value;
  final int maxLines;

  const _KeyValueItemWidget({
    required this.item, required this.value, this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(flex : 1, child: Text(item, style: poppinsRegular,maxLines: 1, overflow: TextOverflow.ellipsis)),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Expanded(flex: 2, child: Text(' :  $value',
          style: poppinsRegular, maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
        )),
      ]),
    );
  }
}
