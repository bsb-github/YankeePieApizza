import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_restaurant/features/checkout/providers/checkout_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class BringChangeInputWidget extends StatefulWidget {
  final TextEditingController? amountController;
  const BringChangeInputWidget({super.key, this.amountController});

  @override
  State<BringChangeInputWidget> createState() => _BringChangeInputWidgetState();
}

class _BringChangeInputWidgetState extends State<BringChangeInputWidget> {

  final FocusNode _amountFocus = FocusNode();

  @override
  Widget build(BuildContext context) {

    final ConfigModel configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;

    return Consumer<CheckoutProvider>(builder: (ctx, checkoutProvider,_){
      return Column(
        children: [

          if(checkoutProvider.showBringChangeInputOption) Container(
            padding: const EdgeInsets.symmetric(vertical : Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeLarge),
            margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.5), width: 0.5),
                color: Theme.of(context).hintColor.withValues(alpha: 0.05)
            ),

            width: double.infinity,
            child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("${getTranslated("change_amount", context) ?? ""} (${configModel.currencySymbol})", style: rubikMedium.copyWith(
                overflow: TextOverflow.ellipsis,
              )),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              Text(getTranslated("bring_cash_hint_text", context) ?? "", style: rubikRegular.copyWith(
                  overflow: TextOverflow.ellipsis, fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7)
              )),

              const SizedBox(height: Dimensions.paddingSizeSmall),
              SizedBox(
                child: CustomTextFieldWidget(
                  radius: Dimensions.radiusSeven,
                  hintText: getTranslated('amount', context),
                  fillColor: Theme.of(context).cardColor,
                  borderColor: Theme.of(context).disabledColor.withValues(alpha: 0.5),
                  isShowBorder: true,
                  focusNode: _amountFocus,
                  controller: widget.amountController,
                  inputType: TextInputType.phone,
                ),
              ),
            ]),
          ),

          TextButton(
            onPressed: (){
              checkoutProvider.updateBringChangeInputOptionStatus(!checkoutProvider.showBringChangeInputOption);
            },
            style: ButtonStyle(
              padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
              minimumSize: WidgetStateProperty.all(const Size(0, 0)), // Remove minimum constraints
              tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduce tap target size
            ),
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              child: Text(
                checkoutProvider.showBringChangeInputOption ? "${getTranslated("see_less_minus", context)}" : "${getTranslated("see_more_plus", context)}",
                style: rubikRegular.copyWith(color: Theme.of(context).indicatorColor, decoration: TextDecoration.underline, decorationColor: Theme.of(context).indicatorColor ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
