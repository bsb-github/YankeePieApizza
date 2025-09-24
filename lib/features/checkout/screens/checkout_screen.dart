import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/common/models/cart_model.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/common/widgets/not_logged_in_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_restaurant/features/address/domain/models/address_model.dart';
import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/branch/providers/branch_provider.dart';
import 'package:flutter_restaurant/features/cart/providers/cart_provider.dart';
import 'package:flutter_restaurant/features/cart/widgets/item_view_widget.dart';
import 'package:flutter_restaurant/features/checkout/domain/enum/delivery_type_enum.dart';
import 'package:flutter_restaurant/features/checkout/domain/models/check_out_model.dart';
import 'package:flutter_restaurant/features/checkout/providers/checkout_provider.dart';
import 'package:flutter_restaurant/features/checkout/widgets/confirm_button_widget.dart';
import 'package:flutter_restaurant/features/checkout/widgets/cost_summery_widget.dart';
import 'package:flutter_restaurant/features/checkout/widgets/delivery_details_widget.dart';
import 'package:flutter_restaurant/features/checkout/widgets/payment_details_widget.dart';
import 'package:flutter_restaurant/features/checkout/widgets/slot_widget.dart';
import 'package:flutter_restaurant/features/checkout/widgets/upside_expansion_widget.dart';
import 'package:flutter_restaurant/features/language/providers/localization_provider.dart';
import 'package:flutter_restaurant/features/order/providers/order_provider.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/checkout_helper.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/date_converter_helper.dart';
import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  final double? amount;
  final List<CartModel>? cartList;
  final bool fromCart;
  final bool isCutlery;
  final bool isFreeDelivery;
  final String? couponCode;
  const CheckoutScreen({super.key,  required this.amount, required this.fromCart,
    required this.cartList, required this.couponCode, required this.isCutlery, required this.isFreeDelivery});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final ScrollController scrollController = ScrollController();
  final GlobalKey dropdownKey = GlobalKey();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _noteController = TextEditingController();
  late bool _isLoggedIn;
  late List<CartModel?> _cartList;
  final List<PaymentMethod> _paymentList = [];
  final List<Color> _paymentColor = [];
  Branches? currentBranch;

  @override
  void initState() {
    super.initState();
    _onInitLoad();
  }


  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final LocalizationProvider localizationProvider = Provider.of<LocalizationProvider>(context, listen: false);

    bool kmWiseCharge = CheckOutHelper.isKmWiseCharge(deliveryInfoModel: splashProvider.deliveryInfoModel!);

    final bool isDesktop = ResponsiveHelper.isDesktop(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: (isDesktop ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBarWidget()) : CustomAppBarWidget(
        context: context, title: getTranslated('checkout', context), centerTitle: false,
        leading: InkWell(
          onTap: () => context.pop(),
          child: Icon(Icons.arrow_back_ios_rounded, color: Theme.of(context).primaryColor),
        ),
      )) as PreferredSizeWidget?,

      body: _isLoggedIn || splashProvider.configModel!.isGuestCheckout! ?  Column(children: [
        Expanded(child: CustomScrollView(controller: scrollController, slivers: [

          if(isDesktop) SliverToBoxAdapter(child: Center(child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
            child: Text(getTranslated('checkout', context)!, style: rubikBold.copyWith(
              fontSize: Dimensions.fontSizeOverLarge,
            )),
          ))),

          SliverToBoxAdapter(child: Consumer<LocationProvider>(builder: (context, locationProvider, _) {
            return Consumer<CheckoutProvider>(builder: (context, checkoutProvider, _) {


              checkoutProvider.getCheckOutData?.copyWith(deliveryCharge: checkoutProvider.deliveryCharge);

              return Center(child: Container(alignment: Alignment.topCenter, width: Dimensions.webScreenWidth, child: Column(children: [

                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(flex: 6, child: Container(
                    margin: EdgeInsets.only(
                      left: isDesktop ?  localizationProvider.isLtr ? 0 : Dimensions.paddingSizeDefault: Dimensions.paddingSizeDefault,
                      right: Dimensions.paddingSizeDefault,
                      top: isDesktop ? 0 : Dimensions.paddingSizeDefault,
                      bottom: isDesktop ? 0 : Dimensions.paddingSizeDefault,
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      /// for Delivery to & Delivery type
                      DeliveryDetailsWidget(
                        currentBranch: currentBranch,
                        kmWiseCharge: kmWiseCharge,
                        deliveryCharge: checkoutProvider.deliveryCharge,
                        amount: widget.amount,
                        dropdownKey: dropdownKey,
                        isFreeDelivery: widget.isFreeDelivery,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),


                      /// for Time Slot
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withValues(alpha:0.5), blurRadius: Dimensions.radiusDefault)],
                        ),
                        padding:  const EdgeInsets.all(Dimensions.paddingSizeLarge),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(getTranslated('preference_time', context)!, style: rubikBold.copyWith(
                            fontSize: isDesktop ? Dimensions.fontSizeLarge : Dimensions.fontSizeDefault,
                            fontWeight: isDesktop ? FontWeight.w700 : FontWeight.w600,
                          )),

                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          SizedBox(height: 50, child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                Radio(
                                  activeColor: Theme.of(context).primaryColor,
                                  value: index,
                                  groupValue: checkoutProvider.selectDateSlot,
                                  onChanged: (value)=> checkoutProvider.updateDateSlot(index),
                                ),
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                Text(index == 0 ? getTranslated('today', context)! : getTranslated('tomorrow', context)!, style: rubikRegular.copyWith(
                                  color: index == checkoutProvider.selectDateSlot ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge?.color,
                                )),
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                              ]);
                            },
                          )),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          SizedBox(
                            height: 40,
                            child: checkoutProvider.timeSlots != null ? checkoutProvider.timeSlots!.isNotEmpty ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: checkoutProvider.timeSlots!.length,
                              itemBuilder: (context, index) {
                                return SlotWidget(
                                  title: (
                                      index == 0 && checkoutProvider.selectDateSlot == 0  && splashProvider.isRestaurantOpenNow(context))
                                      ? getTranslated('asap', context)
                                      : '${DateConverterHelper.dateToTimeOnly(checkoutProvider.timeSlots![index].startTime!, context)} '
                                      '- ${DateConverterHelper.dateToTimeOnly(checkoutProvider.timeSlots![index].endTime!, context)}',
                                  isSelected: checkoutProvider.selectTimeSlot == index,
                                  onTap: () => checkoutProvider.updateTimeSlot(index),
                                );
                              },
                            ) : Center(child: Text(getTranslated('no_slot_available', context)!)) : const Center(child: CircularProgressIndicator()),
                          ),
                        ]),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      PaymentDetailsWidget(total: (widget.amount ?? 0) + (checkoutProvider.orderType == OrderType.takeAway ? 0 : checkoutProvider.deliveryCharge)),

                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      //if(!ResponsiveHelper.isDesktop(context)) PartialPayWidget(totalPrice: (widget.amount ?? 0) + (checkoutProvider.deliveryCharge )),

                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withValues(alpha:0.5), blurRadius: Dimensions.radiusDefault)],
                        ),
                        padding:  const EdgeInsets.all(Dimensions.paddingSizeLarge),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(getTranslated('add_delivery_note', context)!, style: rubikBold.copyWith(
                            fontSize: isDesktop ? Dimensions.fontSizeLarge : Dimensions.fontSizeDefault,
                            fontWeight: isDesktop ? FontWeight.w700 : FontWeight.w600,
                          )),
                          const SizedBox(height: Dimensions.fontSizeSmall),

                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha:0.2), width: 1),
                            ),
                            child: CustomTextFieldWidget(
                              controller: _noteController,
                              hintText: getTranslated('additional_note', context),
                              maxLines: 5,
                              inputType: TextInputType.multiline,
                              inputAction: TextInputAction.newline,
                              capitalization: TextCapitalization.sentences,
                              radius: Dimensions.radiusSmall,
                            ),
                          ),

                        ]),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                    ]),
                  )),

                  /// for web Cost Summery and Wallet balance card
                  if(isDesktop) Expanded(flex: 4, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    //PartialPayWidget(totalPrice: (widget.amount ?? 0) + (checkoutProvider.orderType == OrderType.takeAway ? 0 : checkoutProvider.deliveryCharge)),

                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withValues(alpha:0.5), blurRadius: Dimensions.radiusDefault)],
                      ),
                      padding:  const EdgeInsets.all(Dimensions.paddingSizeLarge),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [

                        CostSummeryWidget(
                          kmWiseCharge: kmWiseCharge,
                          deliveryCharge: checkoutProvider.orderType == OrderType.takeAway ? 0 : checkoutProvider.deliveryCharge,
                          subtotal: widget.amount,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        ConfirmButtonWidget(
                          noteController: _noteController,
                          callBack: _callback,
                          cartList: _cartList,
                          kmWiseCharge: kmWiseCharge,
                          orderType: checkoutProvider.orderType,
                          orderAmount: widget.amount!,
                          couponCode: widget.couponCode,
                          deliveryCharge: checkoutProvider.orderType == OrderType.takeAway ? 0 : checkoutProvider.deliveryCharge,
                          isCutlery: widget.isCutlery,
                          scrollController: scrollController,
                          dropdownKey: dropdownKey,
                        ),
                      ]),
                    ),

                  ])),
                ]),

              ])));
            });
          })),

          if(isDesktop) const SliverToBoxAdapter(
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              SizedBox(height: Dimensions.paddingSizeLarge),

              FooterWidget(),
            ]),
          ),

        ])),

        if(!isDesktop) Consumer<CheckoutProvider>(
          builder: (context, checkoutProvider, _) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withValues(alpha:0.1), blurRadius: 10)],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusDefault)),
              ),
              padding: const EdgeInsets.only(
                left: Dimensions.paddingSizeDefault,
                right: Dimensions.paddingSizeDefault,
                bottom: Dimensions.paddingSizeSmall,
              ),
              clipBehavior: Clip.hardEdge,
              child: Column(children: [

                UpsideExpansionWidget(
                  title: ItemViewWidget(
                    title: getTranslated('total_amount', context)!,
                    subTitle: PriceConverterHelper.convertPrice(widget.amount! + (checkoutProvider.orderType == OrderType.takeAway ? 0 : checkoutProvider.deliveryCharge)),
                    titleStyle: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).primaryColor),
                  ),
                  children: [
                    SizedBox(height : 150, child: CostSummeryWidget(
                      kmWiseCharge: kmWiseCharge,
                      deliveryCharge: checkoutProvider.orderType == OrderType.takeAway ? 0 : checkoutProvider.deliveryCharge,
                      subtotal: widget.amount,
                    )),
                  ],
                ),

                ConfirmButtonWidget(
                  noteController: _noteController,
                  callBack: _callback,
                  cartList: _cartList,
                  kmWiseCharge: kmWiseCharge,
                  orderType: checkoutProvider.orderType,
                  orderAmount: widget.amount!,
                  couponCode: widget.couponCode,
                  deliveryCharge: checkoutProvider.orderType == OrderType.takeAway ? 0 : checkoutProvider.deliveryCharge,
                  isCutlery: widget.isCutlery,
                  scrollController: scrollController,
                  dropdownKey: dropdownKey,
                ),
              ]),
            );
          },
        ),
      ]) : const NotLoggedInWidget(),
    );
  }


  Future<void> _onInitLoad() async {



    final CheckoutProvider checkoutProvider = Provider.of<CheckoutProvider>(context, listen: false);
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);
    final LocationProvider locationProvider = Provider.of<LocationProvider>(context, listen: false);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    locationProvider.setAreaID(isUpdate: false, isReload: true);
    checkoutProvider.setDeliveryCharge(isReload: true, isUpdate: false);
    final bool isGuestCheckout = (splashProvider.configModel!.isGuestCheckout!) && authProvider.getGuestId() != null;

    double deliveryCharge = 0;

    _cartList = [];
    widget.fromCart ? _cartList.addAll(cartProvider.cartList) : _cartList.addAll(widget.cartList!);


    if(cartProvider.cartList.isEmpty) {
      RouterHelper.getDashboardRoute('cart');
    }

    currentBranch = Provider.of<BranchProvider>(context, listen: false).getBranch();
    splashProvider.getOfflinePaymentMethod(true);

    checkoutProvider.clearPrevData();


    if(splashProvider.configModel!.cashOnDelivery!) {
      _paymentList.add(PaymentMethod(getWay: 'cash_on_delivery', getWayImage: Images.cashOnDelivery));
      _paymentColor.add( Colors.primaries[Random().nextInt(Colors.primaries.length)].withValues(alpha:0.02));
    }

    if(splashProvider.configModel?.walletStatus ?? false) {
      _paymentList.add(PaymentMethod(getWay: 'wallet_payment', getWayImage: Images.walletPayment));
      _paymentColor.add( Colors.primaries[Random().nextInt(Colors.primaries.length)].withValues(alpha:0.1));
    }

    for (var method in splashProvider.configModel?.activePaymentMethodList ?? []) {
      _paymentList.add(method);
      _paymentColor.add( Colors.primaries[Random().nextInt(Colors.primaries.length)].withValues(alpha:0.1));
    }

    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();



    if(_isLoggedIn || (splashProvider.configModel?.isGuestCheckout ?? false)) {

      if(_isLoggedIn){
        profileProvider.getUserInfo(false, isUpdate: false);
      }

      checkoutProvider.initializeTimeSlot(context).then((value) {
        checkoutProvider.sortTime();

      });
      await locationProvider.initAddressList();

      AddressModel? lastDeliveryAddress;
      AddressModel? selectedDeliveryAddress;


      if(_isLoggedIn && locationProvider.currentAddress != null) {
        lastDeliveryAddress = locationProvider.currentAddress;
        if(locationProvider.currentAddress?.id == null) {
          lastDeliveryAddress = locationProvider.currentAddress?.copyWith(
            contactName: '${profileProvider.userInfoModel?.fName} ${profileProvider.userInfoModel?.lName}',
            contactPhoneNumber: profileProvider.userInfoModel?.phone,
          );
        }

      }else if(!_isLoggedIn && locationProvider.currentAddress != null) {
        lastDeliveryAddress = locationProvider.currentAddress;

      }else if(_isLoggedIn){
        lastDeliveryAddress=  await locationProvider.getLastDeliveryAddress();
      }




      selectedDeliveryAddress = await CheckOutHelper.selectDeliveryAddressAuto(orderType: checkoutProvider.orderType, isLoggedIn: (_isLoggedIn || isGuestCheckout), lastAddress: lastDeliveryAddress, isFreeDelivery: widget.isFreeDelivery);


      deliveryCharge = CheckOutHelper.getDeliveryCharge(
        splashProvider : splashProvider,
        googleMapStatus: splashProvider.configModel!.googleMapStatus!,
        distance: checkoutProvider.distance,
        minimumDistanceForFreeDelivery: splashProvider.deliveryInfoModel?.deliveryChargeSetup?.minimumDistanceForFreeDelivery?.toDouble() ?? 0,
        shippingPerKm: splashProvider.deliveryInfoModel?.deliveryChargeSetup?.deliveryChargePerKilometer?.toDouble() ?? 0,
        minShippingCharge: splashProvider.deliveryInfoModel?.deliveryChargeSetup?.minimumDeliveryCharge?.toDouble() ?? 0,
        defaultDeliveryCharge: splashProvider.deliveryInfoModel?.deliveryChargeSetup?.fixedDeliveryCharge?.toDouble() ?? 0,
        isTakeAway: checkoutProvider.orderType == OrderType.takeAway,
        kmWiseCharge: splashProvider.deliveryInfoModel?.deliveryChargeSetup?.deliveryChargeType == 'distance',
        isFreeDelivery: widget.isFreeDelivery,
      );

      checkoutProvider.setDeliveryCharge(deliveryCharge: deliveryCharge, isUpdate: true);
      checkoutProvider.setCheckOutData = CheckOutModel(
        orderType: checkoutProvider.orderType.name.camelCaseToSnakeCase(),
        deliveryCharge: checkoutProvider.deliveryCharge,
        amount: widget.amount,
        placeOrderDiscount: 0,
        couponCode: widget.couponCode,
        orderNote: null,
      );

      if((selectedDeliveryAddress?.contactPersonName == null || selectedDeliveryAddress?.contactPersonNumber == null) && mounted){
        showCustomSnackBarHelper(getTranslated("add_contact_info_to_place_order", context), snackBarStatus: SnackBarStatus.info);
      }else if((selectedDeliveryAddress?.address == null) && mounted){
        showCustomSnackBarHelper(getTranslated("update_location_to_place_order", context), snackBarStatus: SnackBarStatus.info);
      }

      CheckOutHelper.selectPaymentMethodAutomatically(
        activePaymentMethodList: splashProvider.configModel?.activePaymentMethodList ?? [],
        isCashOnDeliveryActive: splashProvider.configModel?.cashOnDelivery ?? false,
      );
    }
  }




  void _callback(bool isSuccess, String message, String orderID) async {
    if(isSuccess) {
      if(widget.fromCart) {
        Provider.of<CartProvider>(context, listen: false).clearCartList();
      }
      Provider.of<OrderProvider>(context, listen: false).stopLoader();
      RouterHelper.getOrderSuccessScreen(orderID, 'success');

    }else {
      showCustomSnackBarHelper(message);
    }
  }



  Future<Uint8List> convertAssetToUnit8List(String imagePath, {int width = 30}) async {
    ByteData data = await rootBundle.load(imagePath);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!.buffer.asUint8List();
  }

}










