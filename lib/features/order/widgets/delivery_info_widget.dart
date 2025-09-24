import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/features/checkout/domain/enum/delivery_type_enum.dart';
import 'package:flutter_restaurant/features/order/providers/order_provider.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class DeliveryInfoWidget extends StatelessWidget {

  const DeliveryInfoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Column(children: [

        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CustomAssetImageWidget(Images.restaurantLocationSvg, width: 20, height: 20, color: Theme.of(context).primaryColor),
          const SizedBox(width: Dimensions.paddingSizeDefault),

          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
            Text(getTranslated('from', context)!, style: rubikRegular),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Text(orderProvider.trackModel?.branches?.name ?? '', style: rubikBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
          ])),
        ]),

        if(orderProvider.trackModel?.orderType == OrderType.delivery.name && (orderProvider.trackModel?.deliveryAddress?.address?.isNotEmpty ?? false)) ...[
          const Divider(height: Dimensions.paddingSizeLarge),

          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CustomAssetImageWidget(Images.locationPlacemarkSvg, width: 20, height: 20, color: Theme.of(context).secondaryHeaderColor),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(getTranslated('to_', context)!, style: rubikRegular),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Text(orderProvider.trackModel?.deliveryAddress?.address ?? '', style: rubikBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
            ])),
          ]),
        ],

      ]),
    );
  }
}