import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/models/offline_payment_model.dart';
import 'package:flutter_restaurant/common/providers/theme_provider.dart';
import 'package:flutter_restaurant/features/checkout/providers/checkout_provider.dart';
import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class OfflinePaymentWidget extends StatefulWidget {
  final double totalAmount;
  final OfflinePaymentModel? selectedOfflineMethod;
  final PaymentMethod? paymentMethod;
  final double? partialAmount;
  final int? paymentMethodIndex;
  final void Function({List<Map<String, String>>? selectedOfflineValue})? callBack;
  const OfflinePaymentWidget({super.key, required this.totalAmount, this.selectedOfflineMethod, this.callBack, this.paymentMethod, this.partialAmount, this.paymentMethodIndex});

  @override
  State<OfflinePaymentWidget> createState() => _OfflinePaymentWidgetState();
}

class _OfflinePaymentWidgetState extends State<OfflinePaymentWidget> {
  AutoScrollController? scrollController;
  Map<String, String>? selectedValue;


  @override
  void initState() {

    final CheckoutProvider checkoutProvider = Provider.of<CheckoutProvider>(context, listen: false);
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    checkoutProvider.updatePaymentVisibility(false);
    scrollController = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.horizontal,
    );

    int index = splashProvider.offlinePaymentModelList!.indexOf(widget.selectedOfflineMethod);

    scrollController?.scrollToIndex(index, preferPosition: AutoScrollPosition.middle);
    scrollController?.highlight(index);



    super.initState();
  }
  @override
  void dispose() {
    Provider.of<CheckoutProvider>(Get.context!, listen: false).updatePaymentVisibility(true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Center(child: SizedBox(width: 600, child: Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.9),
      margin: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      ),
      child: Consumer<CheckoutProvider>(builder: (context, checkoutProvider, _) {

        // return Text('data');
        return Column(children: [
          Expanded(child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(getTranslated('offline_payment', context)!, style: rubikSemiBold.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: themeProvider.darkTheme ? Theme.of(context).primaryColor : ColorResources.homePageSectionTitleColor
              )),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Image.asset(Images.offlinePayment, height: 100),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Text(getTranslated('pay_your_bill_using_the_info', context)!, textAlign: TextAlign.center, style: rubikRegular.copyWith(
                fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor,
              )),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              SingleChildScrollView(
                controller: scrollController, scrollDirection: Axis.horizontal,
                child: IntrinsicHeight(
                  child: Row(children: splashProvider.offlinePaymentModelList!.map((offline) => AutoScrollTag(
                    controller: scrollController!,
                    key: ValueKey(splashProvider.offlinePaymentModelList!.indexOf(offline)),
                    index: splashProvider.offlinePaymentModelList!.indexOf(offline),
                    child: InkWell(
                      onTap: () async {
                        checkoutProvider.formKey.currentState?.reset();
                        checkoutProvider.changePaymentMethod(offlinePaymentModel: offline);

                        await scrollController!.scrollToIndex(splashProvider.offlinePaymentModelList!.indexOf(offline), preferPosition: AutoScrollPosition.middle);
                        await scrollController!.highlight(splashProvider.offlinePaymentModelList!.indexOf(offline));
                      },
                      child: Container(
                        width: ResponsiveHelper.isMobile() ? MediaQuery.sizeOf(context).width * 0.8 : 300,
                        constraints: const BoxConstraints(minHeight: 160),
                        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          border: Border.all(color: Theme.of(context).secondaryHeaderColor.withValues(alpha:0.1), width: 1),
                          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                          boxShadow: [BoxShadow(
                            color: Theme.of(context).secondaryHeaderColor.withValues(alpha:0.05),
                            offset: const Offset(0, 4), blurRadius: 8,
                          )],
                        ),
                        child: Column(children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(offline?.methodName ?? '', style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).colorScheme.primary)),

                            if(offline?.id == checkoutProvider.selectedOfflineMethod?.id)
                              Row(mainAxisAlignment: MainAxisAlignment.end,  children: [
                                Text(getTranslated('pay_on_this_account', context)!, style: rubikRegular.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: Dimensions.fontSizeSmall,
                                )),
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                Icon(Icons.check_circle_rounded, color: Theme.of(context).secondaryHeaderColor, size: 20,)
                              ]),

                          ]),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          if(offline?.methodFields != null) BillInfoWidget(methodList: offline!.methodFields!),

                        ]),
                      ),
                    ),
                  )).toList()),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Text( '${getTranslated('amount', context)} : ${PriceConverterHelper.convertPrice(widget.totalAmount)}',
                style: rubikBold.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),


              if(widget.selectedOfflineMethod?.methodFields != null)
                PaymentInfoWidget(methodInfo: widget.selectedOfflineMethod!.methodInformations!),








            ]),
          )),
          const SizedBox(height: Dimensions.paddingSizeDefault),


          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            CustomButtonWidget(
              textStyle: rubikSemiBold.copyWith(
                color: ColorResources.homePageSectionTitleColor
              ),
              borderRadius: Dimensions.radiusDefault,
              btnTxt: getTranslated('close', context), width: 100,
              backgroundColor: Theme.of(context).hintColor.withValues(alpha:0.2),
              onTap: ()=> context.pop(),
            ),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            CustomButtonWidget(
              btnTxt: getTranslated('submit', context),
              borderRadius: Dimensions.radiusDefault,
              width: 130, onTap: (){
              if(checkoutProvider.formKey.currentState!.validate()){
                checkoutProvider.setOfflineSelectedValue(null);
                List<Map<String, String>>? data = [];
                checkoutProvider.field.forEach((key, value) {
                  data.add({key : value.text});
                });
                checkoutProvider.savePaymentMethod(
                  method: widget.paymentMethod,
                  selectedOfflineMethod: widget.selectedOfflineMethod,
                  selectedOfflineValue: data,
                  partialAmount: widget.partialAmount,
                  index: widget.paymentMethodIndex,
                );
                context.pop();
                context.pop();
              }

            },),
          ]),
        ]);
      }),
    )));
  }
}


class BillInfoWidget extends StatelessWidget {
  final List<MethodField> methodList;
  const BillInfoWidget({super.key, required this.methodList});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: methodList.map((method) => Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Flexible(
          child: Text('${method.fieldName ?? ''} :    ${method.fieldData}',
            style: rubikRegular, overflow: TextOverflow.ellipsis, maxLines: 1,
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Flexible(child: Text(' :  ${method.fieldData}',
          style: rubikRegular,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )),
      ]),
    )).toList());
  }
}

class PaymentInfoWidget extends StatefulWidget {
  final List<MethodInformation> methodInfo;

  const PaymentInfoWidget({super.key, required this.methodInfo});

  @override
  State<PaymentInfoWidget> createState() => _PaymentInfoWidgetState();
}

class _PaymentInfoWidgetState extends State<PaymentInfoWidget> {

  final TextEditingController noteTextController = TextEditingController();

  @override
  void dispose() {
    noteTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(getTranslated('payment_info', context)!, style: rubikSemiBold,),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      Consumer<CheckoutProvider>(
        builder: (context, orderProvider, _) {
          orderProvider.field = {};
          for(int i = 0; i < widget.methodInfo.length; i++){
            orderProvider.field.addAll({'${widget.methodInfo[i].informationName}' : TextEditingController()});
          }
          return Column(children: [
            Form(
                key: orderProvider.formKey,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orderProvider.field.length,
                  padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeExtraSmall, horizontal: 10,
                  ),

                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                    child: CustomTextFieldWidget(
                      onValidate: widget.methodInfo[index].informationRequired! ? (String? value){
                       return value != null && value.isEmpty ? '${widget.methodInfo[index].informationName?.replaceAll("_", " ").toCapitalized()
                       } ${getTranslated('is_required', context)}' : null;
                      }: null,
                      isShowBorder: true,
                      borderColor: Theme.of(context).hintColor.withValues(alpha:0.4),
                      controller: orderProvider.field['${widget.methodInfo[index].informationName}'],
                      hintText:  widget.methodInfo[index].informationPlaceholder,
                      fillColor: Theme.of(context).cardColor,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              child: CustomTextFieldWidget(
                fillColor: Theme.of(context).cardColor,
                isShowBorder: true,
                borderColor: Theme.of(context).hintColor.withValues(alpha:0.4),
                controller: noteTextController,
                hintText: getTranslated('enter_your_payment_note', context),
                maxLines: 5,
                inputType: TextInputType.multiline,
                inputAction: TextInputAction.newline,
                capitalization: TextCapitalization.sentences,
                onChanged: (value) {
                  orderProvider.selectedOfflineMethod?.copyWith(note: noteTextController.text);
                },
              ),
            ),

          ]);
        }
      ),
    ]);
  }
}
