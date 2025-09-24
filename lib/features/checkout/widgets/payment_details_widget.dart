import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/checkout/providers/checkout_provider.dart';
import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';
import 'payment_method_bottom_sheet_widget.dart';

class PaymentDetailsWidget extends StatelessWidget {
  final double total;
  const PaymentDetailsWidget({super.key,  required this.total});

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutProvider>(builder: (context, checkoutProvider, _) {
      bool showPayment = checkoutProvider.selectedPaymentMethod != null || (checkoutProvider.selectedOfflineValue != null );

      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withValues(alpha:0.5), blurRadius: Dimensions.radiusDefault)],
        ),
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: Text(getTranslated('payment_method', context)!, style: rubikBold.copyWith(
                fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeLarge : Dimensions.fontSizeDefault,
                fontWeight: ResponsiveHelper.isDesktop(context) ? FontWeight.w700 : FontWeight.w600,
              )),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              child: TextButton(
                onPressed: ()=> ResponsiveHelper.showDialogOrBottomSheet(context, PaymentMethodBottomSheetWidget(totalPrice: total)),
                child: Text(getTranslated(showPayment ? 'change' : 'add', context)!, style: rubikBold.copyWith(
                  color: ColorResources.getSecondaryColor(context),
                  fontSize:  Dimensions.fontSizeDefault ,
                )),
              ),
            ),
          ]),

          const SizedBox(height: Dimensions.paddingSizeExtraSmall,),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            child: Divider(thickness: 0.5, height: 0.5, color: Theme.of(context).hintColor.withValues(alpha: 0.4),),
          ),

           if(!showPayment ) Padding(
             padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal : Dimensions.paddingSizeLarge ),
             child: InkWell(
               onTap: ()=> ResponsiveHelper.showDialogOrBottomSheet(context, PaymentMethodBottomSheetWidget(totalPrice: total)),
               child: Row(children: [
                 const Icon(Icons.add_circle_outline, size: Dimensions.paddingSizeLarge),
                 const SizedBox(width: Dimensions.paddingSizeSmall),

                 Text(
                   getTranslated('add_payment_method', context)!,
                   style: rubikSemiBold.copyWith(fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeDefault : Dimensions.fontSizeSmall),
                 ),
               ]),
             ),
           ),

           if(showPayment) Padding(
             padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeLarge),
             child: SelectedPaymentView(total:   total),
           ),

          ]),
      );
    });
  }
}

class SelectedPaymentView extends StatelessWidget {
  const SelectedPaymentView({super.key, required this.total,});
  final double total;

  @override
  Widget build(BuildContext context) {
    final CheckoutProvider checkoutProvider = Provider.of<CheckoutProvider>(context, listen: false);

    double paidAmount = checkoutProvider.partialAmount !=null && checkoutProvider.partialAmount! > 0
        ? (total -  checkoutProvider.partialAmount!) : total;

    return  Column(children: [
      if(checkoutProvider.partialAmount == null) rowTextWidget(
          title: checkoutProvider.selectedOfflineMethod != null
              ? '${getTranslated('offline_payment', context)} (${checkoutProvider.selectedOfflineMethod?.methodName})'
              : checkoutProvider.selectedPaymentMethod?.getWayTitle ?? '',
          subTitle: PriceConverterHelper.convertPrice(paidAmount),
          context: context
      ),

      if(checkoutProvider.partialAmount != null) ...[
        rowTextWidget(
            title: getTranslated('paid_by_wallet', context) ?? "",
            subTitle: PriceConverterHelper.convertPrice(checkoutProvider.partialAmount),
            context: context
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        rowTextWidget(
            title: "${ checkoutProvider.selectedOfflineMethod != null
                ? "${getTranslated('paid_by', context) ?? ""} ${checkoutProvider.selectedOfflineMethod?.methodName}"
                : checkoutProvider.selectedPaymentMethod?.getWayTitle ?? ''} (${getTranslated('due', context) ?? ""})",
            subTitle: PriceConverterHelper.convertPrice(paidAmount),
            context: context
        ),
      ],

     if(checkoutProvider.selectedOfflineValue != null) Padding(
       padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
       child: Column(children: checkoutProvider.selectedOfflineValue!.map((method) => Padding(
         padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
         child: Row(children: [
            Flexible(child: Text(method.keys.single, style: rubikRegular.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7), fontSize: Dimensions.fontSizeSmall,
            ), maxLines: 1, overflow: TextOverflow.ellipsis)),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Flexible(child: Text(' :  ${method.values.single}', style: rubikRegular.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7), fontSize: Dimensions.fontSizeSmall,
            ), maxLines: 1, overflow: TextOverflow.ellipsis)),
          ]),
       )).toList()),
     ),
    ]);
  }

  Widget rowTextWidget({required String title, required String subTitle, required BuildContext context}){
    return  Row(children: [
      Expanded(child: Text(title,
        style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeDefault,
          color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
        ),
      )),
      Text(subTitle, textDirection: TextDirection.ltr,
        style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault),
      )
    ]);
  }
}
