import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/models/offline_payment_model.dart';
import 'package:flutter_restaurant/features/checkout/providers/checkout_provider.dart';
import 'package:flutter_restaurant/features/checkout/widgets/bring_change_input_widget.dart';
import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/features/checkout/widgets/offline_payment_widget.dart';
import 'package:flutter_restaurant/features/checkout/widgets/payment_button_widget.dart';
import 'package:flutter_restaurant/features/wallet/widgets/add_fund_dialogue_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:provider/provider.dart';


class PaymentMethodBottomSheetWidget extends StatefulWidget {
  final double totalPrice;
  const PaymentMethodBottomSheetWidget({super.key, required this.totalPrice});

  @override
  State<PaymentMethodBottomSheetWidget> createState() => _PaymentMethodBottomSheetWidgetState();
}

class _PaymentMethodBottomSheetWidgetState extends State<PaymentMethodBottomSheetWidget> {

  String partialPaymentCombinator = "all";

   final JustTheController? toolTip = JustTheController();
  TextEditingController? _bringAmountController;
  List<PaymentMethod> paymentList = [];

  int? _paymentMethodIndex;
  double? _partialAmount;
  PaymentMethod? _paymentMethod;
  OfflinePaymentModel? _selectedOfflineMethod;
  List<Map<String, String>>? _selectedOfflineValue;

  @override
  Widget build(BuildContext context) {

    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    final ProfileProvider profileProvider  = Provider.of<ProfileProvider>(context, listen: false);
    final ConfigModel configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;

    return SingleChildScrollView(
      child: Center(child: SizedBox(width: 550, child: Column(mainAxisSize: MainAxisSize.min, children: [

        Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.8),
          width: 550,
          margin: const EdgeInsets.only(top: kIsWeb ? 0 : 30),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: ResponsiveHelper.isMobile() ? const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge))
                : const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.paddingSizeExtraSmall,
          ),
          child: SafeArea(
            child: Consumer<CheckoutProvider>(
                builder: (ctx, checkoutProvider, _) {

                  double bottomPadding = MediaQuery.of(context).padding.bottom;

                  double walletBalance = profileProvider.userInfoModel?.walletBalance ?? 0;
                  bool isPartialPayment = widget.totalPrice > walletBalance;
                  bool isWalletSelectAndNotPartial = _paymentMethodIndex == 0 && !isPartialPayment;

                  bool hideCOD = isWalletSelectAndNotPartial
                      || (_partialAmount !=null && (partialPaymentCombinator == "digital_payment" || partialPaymentCombinator == "offline_payment"));

                  bool hideDigital = isWalletSelectAndNotPartial
                      || (_partialAmount !=null && (partialPaymentCombinator == "cod" || partialPaymentCombinator == "offline_payment"));

                  bool hideOffline = isWalletSelectAndNotPartial
                      || (_partialAmount !=null && (partialPaymentCombinator == "cod" || partialPaymentCombinator == "digital_payment"));


                  return Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [

                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    !ResponsiveHelper.isDesktop(context) ? Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 4, width: 35,
                        decoration: BoxDecoration(color: Theme.of(context).disabledColor.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(10)),
                      ),
                    ) : const SizedBox(),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () => context.pop(),
                          child: const Icon(Icons.clear, size: 20,),
                        ),
                      ),
                    ),

                    Text(getTranslated('choose_payment_method', context)!, style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Text(getTranslated('total_bill', context)!, style: rubikRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7)
                    )),
                    Text(PriceConverterHelper.convertPrice(widget.totalPrice), style: rubikBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

                    const SizedBox(height:  Dimensions.paddingSizeDefault),

                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.2,
                        maxHeight: MediaQuery.of(context).size.height * 0.5,
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge * (ResponsiveHelper.isDesktop(context) ? 2 : 1),),
                          child: Column(children: [

                            configModel.walletStatus! && authProvider.isLoggedIn() && walletBalance > 0 ? PaymentButtonWidget(
                              icon: Images.walletIcon,
                              isWallet: true,
                              title: getTranslated('pay_via_wallet', context)!,
                              isSelected: _paymentMethodIndex == 0,
                              hidePaymentMethod: false ,
                              walletBalance: walletBalance,
                              totalPrice: widget.totalPrice,
                              partialAmount: _partialAmount,
                              chooseAnyPayment:  _paymentMethodIndex != null || _paymentMethod != null,
                              callBack: ({int? paymentMethodIndex, double? partialAmount}){
                                setState(() {
                                  _paymentMethodIndex = paymentMethodIndex;
                                  _partialAmount = partialAmount;
                                  _paymentMethod = null;
                                });
                              },
                            ) : const SizedBox(),

                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                            configModel.cashOnDelivery! ? PaymentButtonWidget(
                              icon: Images.moneyIcon,
                              title: getTranslated('cash_on_delivery', context)!,
                              walletBalance: walletBalance,
                              hidePaymentMethod: hideCOD,
                              totalPrice: widget.totalPrice,
                              isSelected: _paymentMethodIndex == 1,
                              chooseAnyPayment: _paymentMethodIndex != null || _paymentMethod != null,
                              callBack: ({int? paymentMethodIndex, double? partialAmount}){
                                setState(() {
                                  _paymentMethodIndex = paymentMethodIndex;
                                  _paymentMethod = null;
                                  _selectedOfflineValue = null;
                                  _selectedOfflineMethod = null;
                                });
                              },
                            ) : const SizedBox(),

                            if(_paymentMethodIndex == 1)
                              BringChangeInputWidget(amountController: _bringAmountController),


                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            if(paymentList.isNotEmpty) Opacity(
                              opacity: (hideOffline && hideDigital) ? 0.4 : 1 ,
                              child: Stack( children: [
                                PaymentMethodView(
                                  toolTip: toolTip,
                                  paymentList: paymentList,
                                  hideDigital: hideDigital,
                                  hideOffline: hideOffline,
                                  selectedPaymentMethod: _paymentMethod?.getWayTitle,
                                  selectedOfflineMethod: _selectedOfflineMethod,
                                  selectedOfflineValue: _selectedOfflineValue,
                                  onTap: (index){
                                    setState(() {
                                      _paymentMethod =  paymentList[index];
                                      _paymentMethodIndex = null;
                                      _selectedOfflineMethod = null;
                                      _selectedOfflineValue = null;
                                    });

                                  },

                                  callBack: ({OfflinePaymentModel? offlinePaymentModel, List<Map<String, String>>? selectedOfflineValue}){
                                   setState(() {
                                     _selectedOfflineValue = selectedOfflineValue;
                                     _selectedOfflineMethod = offlinePaymentModel;
                                   });
                                  },
                                ),

                                if( hideOffline && hideDigital) Positioned.fill(child: Container(
                                  color: Colors.transparent,
                                )),

                              ]),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                          ]),
                        ),
                      ),
                    ),


                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge * (ResponsiveHelper.isDesktop(context) ? 2 : 1),),
                      child: CustomButtonWidget(
                        btnTxt: getTranslated('select', context),
                        onTap: _paymentMethodIndex == null
                            && _paymentMethod == null
                            || (_paymentMethod != null && _paymentMethod?.type == 'offline' && _selectedOfflineMethod == null)
                            ? null : () {
                          if((_paymentMethod?.type == 'offline' || (_paymentMethod?.isOffline ?? false)) && _selectedOfflineValue == null){
                            showDialog(context: context, builder: (ctx)=> OfflinePaymentWidget(
                              totalAmount: isPartialPayment && _partialAmount != null ? (widget.totalPrice - walletBalance) : widget.totalPrice,
                              selectedOfflineMethod: _selectedOfflineMethod,
                              paymentMethod: _paymentMethod,
                              partialAmount: _partialAmount,
                              paymentMethodIndex: _paymentMethodIndex,
                            ));
                          }else{
                            if(_paymentMethodIndex == 1){
                              checkoutProvider.setBringChangeAmount(amountController: _bringAmountController);
                            }
                            checkoutProvider.savePaymentMethod(index: _paymentMethodIndex, method: _paymentMethod, partialAmount: _partialAmount, selectedOfflineValue: _selectedOfflineValue, selectedOfflineMethod: _selectedOfflineMethod);
                            context.pop();

                          }
                        },
                      ),
                    ),

                    SizedBox(height: bottomPadding> 0 ? 0 : Dimensions.paddingSizeDefault,)

                  ]);
                }
            ),
          ),
        ),
      ]))),
    );
  }

  @override
  void initState() {
    super.initState();

    _bringAmountController = TextEditingController();


    final ConfigModel configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;
    final CheckoutProvider checkoutProvider = Provider.of<CheckoutProvider>(context, listen: false);

     checkoutProvider.setBringChangeAmount(isUpdate: false);

    partialPaymentCombinator = configModel.partialPaymentCombineWith?.toLowerCase() ?? "all";

    paymentList.addAll(configModel.activePaymentMethodList ?? []);

    if(configModel.isOfflinePayment!){
      paymentList.add(PaymentMethod(
        getWay: 'offline', getWayTitle: getTranslated('offline', context),
        type: 'offline',
        getWayImage: Images.offlinePayment,
      ));
    }
    _initializeData();
  }


  _initializeData (){
    final CheckoutProvider checkoutProvider =  Provider.of<CheckoutProvider>(context, listen: false);
     _paymentMethodIndex = checkoutProvider.paymentMethodIndex;
     _partialAmount = checkoutProvider.partialAmount ;
     _paymentMethod = checkoutProvider.paymentMethod;
    _selectedOfflineMethod = checkoutProvider.selectedOfflineMethod;
    _selectedOfflineValue = checkoutProvider.selectedOfflineValue;
  }
}
