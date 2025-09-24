import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:provider/provider.dart';

class FreeDeliveryProgressBarWidget extends StatelessWidget {
  const FreeDeliveryProgressBarWidget({
    super.key,
    required double subTotal,
  }) : _subTotal = subTotal;

  final double _subTotal;

  @override
  Widget build(BuildContext context) {
    final deliveryIndo = Provider.of<SplashProvider>(context, listen: false).deliveryInfoModel;

    return deliveryIndo?.deliveryChargeSetup?.freeDeliveryStatus ?? false ? Container(
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Column(children: [
        Row(children: [
          Icon(Icons.discount_outlined, color: Theme.of(context).primaryColor),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
          (_subTotal / (deliveryIndo?.deliveryChargeSetup?.freeDeliveryOverAmount ?? 0))  < 1 ?
          CustomDirectionalityWidget(child: Text(
            '${PriceConverterHelper.convertPrice((deliveryIndo?.deliveryChargeSetup?.freeDeliveryOverAmount ?? 0) - _subTotal)} ${getTranslated('more_to_free_delivery', context)}',
          )) : Text(getTranslated('enjoy_free_delivery', context) ?? ""),
        ]),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        LinearProgressIndicator(
          value: (_subTotal / (deliveryIndo?.deliveryChargeSetup?.freeDeliveryOverAmount ?? 0)),
          color: Theme.of(context).primaryColor,
          backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),
      ]),
    ) : const SizedBox();
  }
}