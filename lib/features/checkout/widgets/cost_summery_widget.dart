import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/cart/widgets/item_view_widget.dart';
import 'package:flutter_restaurant/features/checkout/domain/enum/delivery_type_enum.dart';
import 'package:flutter_restaurant/features/checkout/providers/checkout_provider.dart';
import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class CostSummeryWidget extends StatelessWidget {
  final bool kmWiseCharge;
  final double? deliveryCharge;
  final double? subtotal;
  const CostSummeryWidget({
    super.key, required this.kmWiseCharge,
    this.deliveryCharge, this.subtotal,

  });

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveHelper.isDesktop(context);

    return Consumer<CheckoutProvider>(
      builder: (context, checkoutProvider, _) {
        bool isTakeAway = checkoutProvider.orderType == OrderType.takeAway;

        return Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Align(alignment: Alignment.center,
                child: Text(getTranslated('cost_summery', context)!, style: rubikBold.copyWith(
                  fontSize: isDesktop ? Dimensions.fontSizeExtraLarge : Dimensions.fontSizeDefault,
                  fontWeight: isDesktop ? FontWeight.w700 : FontWeight.w600,
                )),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              const Divider(thickness: 0.08, color: Colors.black),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              ItemViewWidget(
                title: getTranslated('subtotal', context)!,
                subTitle: PriceConverterHelper.convertPrice(subtotal),
                titleStyle: rubikSemiBold,
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

             if(!isTakeAway) ItemViewWidget(
                title: getTranslated('delivery_fee', context)!,
                subTitle: (!isTakeAway || checkoutProvider.distance != -1) ?
                '(+) ${PriceConverterHelper.convertPrice( isTakeAway ? 0 : deliveryCharge)}'
                    : getTranslated('not_found', context)!,
               titleStyle: rubikSemiBold,
              ),

              const Divider(thickness: 0.08, color: Colors.black),
              /*const Padding(
                padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: CustomDividerWidget(),
              ),*/

             if(isDesktop) ItemViewWidget(
               title: getTranslated('total_amount', context)!,
               subTitle: PriceConverterHelper.convertPrice(subtotal! + (isTakeAway ? 0 : (deliveryCharge ?? 0))),
               titleStyle: rubikSemiBold,
               subTitleStyle: rubikBold,
             ),
            ]),
          ),

        ]);
      }
    );
  }
}
