import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/checkout/domain/enum/delivery_type_enum.dart';
import 'package:flutter_restaurant/features/checkout/providers/checkout_provider.dart';
import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/common/widgets/custom_directionality_widget.dart';
import 'package:provider/provider.dart';

class DeliveryOptionWidget extends StatelessWidget {
  final OrderType value;
  final String title;
  final double deliveryCharge;
  const DeliveryOptionWidget({super.key, required this.value, required this.title, required this.deliveryCharge});

  @override
  Widget build(BuildContext context) {

    return Consumer<CheckoutProvider>(
      builder: (context, checkoutProvider, child) {
        bool isActive = value == checkoutProvider.orderType;
        return Container(
          decoration: BoxDecoration(
            color: isActive ?  Theme.of(context).primaryColor.withValues(alpha:0.1) : Theme.of(context).cardColor,
            border: Border.all(color: isActive ? Theme.of(context).primaryColor.withValues(alpha:0.3) : Theme.of(context).hintColor.withValues(alpha:0.3)),
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          ),
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
          child: InkWell(
            onTap: () => checkoutProvider.setOrderType(value, notify: true),
            child: Row(
              children: [
                Radio(
                  value: value,
                  groupValue: checkoutProvider.orderType,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (OrderType? value) => checkoutProvider.setOrderType(value ?? OrderType.delivery),
                  visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Text(title, style: rubikBold.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: isActive ? null : Theme.of(context).hintColor,
                )),
                const Spacer(),

                CustomDirectionalityWidget(child: Text(
                  '${value == OrderType.delivery ? isActive ? PriceConverterHelper.convertPrice(deliveryCharge) : PriceConverterHelper.convertPrice(0.00) : getTranslated('free', context)}',
                  style: rubikBold.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: isActive ? null : Theme.of(context).hintColor,
                  ),
                )),

              ],
            ),
          ),
        );
      },
    );
  }
}