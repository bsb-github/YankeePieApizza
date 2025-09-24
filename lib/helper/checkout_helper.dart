import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/models/delivery_info_model.dart';
import 'package:flutter_restaurant/common/models/offline_payment_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_loader_widget.dart';
import 'package:flutter_restaurant/features/address/domain/models/address_model.dart';
import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/branch/providers/branch_provider.dart';
import 'package:flutter_restaurant/features/checkout/domain/enum/delivery_type_enum.dart';
import 'package:flutter_restaurant/features/checkout/providers/checkout_provider.dart';
import 'package:flutter_restaurant/features/checkout/widgets/delivery_fee_dialog_widget.dart';
import 'package:flutter_restaurant/features/order/providers/order_provider.dart';
import 'package:flutter_restaurant/features/profile/domain/models/userinfo_model.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CheckOutHelper{
  static bool isWalletPayment({required ConfigModel configModel, required bool isLogin, required double? partialAmount, required bool isPartialPayment}){
    return configModel.walletStatus! && configModel.isPartialPayment! && isLogin && (partialAmount == null) && !isPartialPayment;
  }

  static bool isPartialPayment({required ConfigModel configModel, required bool isLogin, required UserInfoModel? userInfoModel}){
    return isLogin && configModel.isPartialPayment! && configModel.walletStatus! && (userInfoModel != null && userInfoModel.walletBalance! > 0);
  }

  static bool isPartialPaymentSelected({required int? paymentMethodIndex, required PaymentMethod? selectedPaymentMethod}){
    return (paymentMethodIndex == 1 && selectedPaymentMethod != null);
  }

  static List<Map<String, dynamic>> getOfflineMethodJson(List<MethodField>? methodList){
    List<Map<String, dynamic>> mapList = [];
    List<String?> keyList = [];
    List<String?> valueList = [];

    for(MethodField methodField in (methodList ?? [])){
      keyList.add(methodField.fieldName);
      valueList.add(methodField.fieldData);
    }

    for(int i = 0; i < keyList.length; i++) {
      mapList.add({'${keyList[i]}' : '${valueList[i]}'});
    }

    return mapList;
  }

  static AddressModel? getDeliveryAddress({
    required List<AddressModel?>? addressList,
    required AddressModel? selectedAddress,
    required AddressModel? lastOrderAddress,
    OrderType orderType = OrderType.delivery
  }){
    final BranchProvider branchProvider = Provider.of<BranchProvider>(Get.context!, listen: false);
    final SplashProvider splashProvider = Provider.of<SplashProvider>(Get.context!, listen: false);
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(Get.context!, listen: false);
    final AuthProvider authProvider = Provider.of<AuthProvider>(Get.context!, listen: false);
    final LocationProvider locationProvider = Provider.of<LocationProvider>(Get.context!, listen: false);

    AddressModel? deliveryAddress;
    if(selectedAddress != null) {
      deliveryAddress = AddressModel.fromJson(selectedAddress.toJson());

    }else if(lastOrderAddress != null){
      deliveryAddress = lastOrderAddress;
    }else if(addressList != null && addressList.isNotEmpty){
      deliveryAddress = addressList.first;
    }

    if(deliveryAddress != null && !isAddressInCoverage(branchProvider.getBranch(), deliveryAddress) && splashProvider.deliveryInfoModel?.deliveryChargeSetup?.deliveryChargeType == 'distance' && orderType != OrderType.takeAway) {
      deliveryAddress = null;
    }

    if(deliveryAddress == null ){
      if(authProvider.isLoggedIn()){
        deliveryAddress = AddressModel(
          contactPersonName: "${profileProvider.userInfoModel?.fName?? ""} ${profileProvider.userInfoModel?.lName ?? ""}",
          contactPersonNumber: profileProvider.userInfoModel?.phone,
          address: locationProvider.currentAddress?.address,
          latitude: locationProvider.currentAddress?.latitude,
          longitude: locationProvider.currentAddress?.longitude,
        );
      }else if (locationProvider.currentAddress != null){
        deliveryAddress = locationProvider.currentAddress;
      }
    }

    return deliveryAddress;
  }


  static bool isKmWiseCharge({required DeliveryInfoModel? deliveryInfoModel}) => deliveryInfoModel?.deliveryChargeSetup?.deliveryChargeType == 'distance' ? true : false;



  static Future<void> selectDeliveryAddress({
    required bool isAvailable,
    required AddressModel? address,
    required ConfigModel? configModel,
    required LocationProvider locationProvider,
    required CheckoutProvider checkoutProvider,
    required SplashProvider splashProvider,
    required bool shouldResetPaymentAndShowDeliveryDialog,
    bool enableChargeCalculation = true,
     bool isFreeDelivery = false,

  }) async {
    
    if(isAvailable) {

      Branches? currentBranch = Provider.of<BranchProvider>(Get.context!, listen: false).getBranch();

      checkoutProvider.setSelectedAddress(address, isUpdate: true);


      if(CheckOutHelper.isKmWiseCharge(deliveryInfoModel: splashProvider.deliveryInfoModel) && enableChargeCalculation) {
        if(shouldResetPaymentAndShowDeliveryDialog) {
          if(checkoutProvider.selectedPaymentMethod != null){
            showCustomSnackBarHelper(getTranslated('your_payment_method_has_been', Get.context!), isError: false);
          }
          checkoutProvider.savePaymentMethod();

        }
        showDialog(context: Get.context!, builder: (context) => Center(child: Container(
          height: 100, width: 100, alignment: Alignment.center,
          decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10)),
          child: CustomLoaderWidget(color: Theme.of(context).primaryColor),
        )), barrierDismissible: false);



        bool isSuccess = await checkoutProvider.getDistanceInMeter(

          LatLng(
            double.tryParse('${currentBranch?.latitude}') ?? 0,
            double.tryParse('${currentBranch?.longitude}') ?? 0,
          ),
          LatLng(
            double.tryParse('${address?.latitude}') ?? 0,
            double.tryParse('${address?.longitude}') ?? 0,
          ),

        );

        Navigator.pop(Get.context!);

        if(shouldResetPaymentAndShowDeliveryDialog) {
          await showDialog(context: Get.context!, builder: (context) => DeliveryFeeDialogWidget(
            amount: checkoutProvider.getCheckOutData?.amount,
            distance: checkoutProvider.distance,
            callBack: (deliveryCharge){
              checkoutProvider.setDeliveryCharge(deliveryCharge: deliveryCharge, isUpdate: false);
              checkoutProvider.getCheckOutData?.copyWith(deliveryCharge: deliveryCharge);
            },
            isFreeDelivery: isFreeDelivery,
          ));
        }
        else{
          checkoutProvider.getCheckOutData?.copyWith(deliveryCharge: getDeliveryCharge(
            splashProvider: splashProvider,
            googleMapStatus: configModel?.googleMapStatus ?? 0,
            distance: checkoutProvider.distance,
            minimumDistanceForFreeDelivery: splashProvider.deliveryInfoModel?.deliveryChargeSetup?.minimumDistanceForFreeDelivery?.toDouble() ?? 0,
            shippingPerKm: splashProvider.deliveryInfoModel?.deliveryChargeSetup?.deliveryChargePerKilometer?.toDouble() ?? 0,
            minShippingCharge: splashProvider.deliveryInfoModel?.deliveryChargeSetup?.minimumDeliveryCharge?.toDouble()?? 0,
            defaultDeliveryCharge: splashProvider.deliveryInfoModel?.deliveryChargeSetup?.fixedDeliveryCharge?.toDouble() ?? 0,
            isTakeAway: checkoutProvider.orderType == OrderType.takeAway,
            kmWiseCharge: splashProvider.deliveryInfoModel?.deliveryChargeSetup?.deliveryChargeType == 'distance',
            isFreeDelivery: isFreeDelivery
          ));
          checkoutProvider.setDeliveryCharge(deliveryCharge: checkoutProvider.getCheckOutData?.deliveryCharge , isUpdate: true);
        }

        if(!isSuccess){
          showCustomSnackBarHelper(getTranslated('failed_to_fetch_distance', Get.context!));
        }else{
          checkoutProvider.setSelectedAddress(address);
        }

      }

    }else{
      showCustomSnackBarHelper(getTranslated('out_of_coverage_for_this_branch', Get.context!));

    }
  }

  static double getDeliveryCharge({
    required SplashProvider splashProvider,
    required int googleMapStatus,
    int? areaID,
    required double distance,
    required double shippingPerKm,
    required double minShippingCharge,
    required double defaultDeliveryCharge,
    required double minimumDistanceForFreeDelivery,
    bool isTakeAway = false,
    bool kmWiseCharge = true,
    bool isFreeDelivery = false,
  }){

    double deliveryCharge = 0;

    if(isFreeDelivery){
      return deliveryCharge;
    }

    if(googleMapStatus == 0){
      if(!isTakeAway && splashProvider.deliveryInfoModel!.deliveryChargeSetup?.deliveryChargeType == 'fixed'){
        deliveryCharge = defaultDeliveryCharge;
      }else{
        for(DeliveryChargeByArea delivery in splashProvider.deliveryInfoModel!.deliveryChargeByArea!){
          if(areaID != null && areaID == delivery.id){
            deliveryCharge = delivery.deliveryCharge?.toDouble() ?? 0;
          }
        }
      }
    }else{
      if(splashProvider.deliveryInfoModel!.deliveryChargeSetup?.deliveryChargeType == 'area' && !isTakeAway){
        for(DeliveryChargeByArea delivery in splashProvider.deliveryInfoModel!.deliveryChargeByArea!){
          if(areaID != null && areaID == delivery.id){
            deliveryCharge = delivery.deliveryCharge?.toDouble() ?? 0;
          }
        }
      }else{
        if(!isTakeAway && kmWiseCharge && distance != -1) {
          if(minimumDistanceForFreeDelivery != 0 && distance <= minimumDistanceForFreeDelivery){
            deliveryCharge = 0.0;
          }else{
            deliveryCharge = distance * shippingPerKm;
            if(deliveryCharge < minShippingCharge) {
              deliveryCharge = minShippingCharge;
            }
          }
        }else if(!isTakeAway && !kmWiseCharge) {
          deliveryCharge = defaultDeliveryCharge;
        }
      }
    }
    return deliveryCharge;
  }



  static Future<AddressModel?> selectDeliveryAddressAuto({AddressModel ? pickedAddress , AddressModel? lastAddress, required bool isLoggedIn, required OrderType? orderType, bool shouldResetPaymentAndShowDeliveryDialog = false,  bool isFreeDelivery = false}) async {
    final LocationProvider locationProvider = Provider.of<LocationProvider>(Get.context!, listen: false);
    final CheckoutProvider checkoutProvider = Provider.of<CheckoutProvider>(Get.context!, listen: false);
    final SplashProvider splashProvider = Provider.of<SplashProvider>(Get.context!, listen: false);


    AddressModel? deliveryAddress = pickedAddress ?? CheckOutHelper.getDeliveryAddress(
      addressList: locationProvider.addressList,
      selectedAddress: checkoutProvider.selectedAddress,
      lastOrderAddress: lastAddress,
    );


    if(isLoggedIn && orderType == OrderType.delivery && deliveryAddress != null ){

      // CheckOutHelper.selectDeliveryAddress(
      //   splashProvider: splashProvider,
      //   isAvailable: true,
      //   address: selectedAddress,
      //   configModel: splashProvider.configModel!,
      //   locationProvider: locationProvider,
      //   checkoutProvider: checkoutProvider,
      //   fromAddressList: true,
      //   enableChargeCalculation: !widget.isFromAppbar,
      // );

      await CheckOutHelper.selectDeliveryAddress(
        isAvailable: true,
        splashProvider: splashProvider,
        address: deliveryAddress,
        configModel: splashProvider.configModel!,
        locationProvider: locationProvider,
        checkoutProvider: checkoutProvider,
        shouldResetPaymentAndShowDeliveryDialog: shouldResetPaymentAndShowDeliveryDialog,
        enableChargeCalculation: isLoggedIn,
        isFreeDelivery: isFreeDelivery
      );

    }

    return deliveryAddress;

  }

  static bool isAddressInCoverage(Branches? currentBranch, AddressModel address ){
    bool isAvailable = currentBranch == null || (currentBranch.latitude == null);
    if(!isAvailable && address.longitude != null && address.latitude != null) {
      double distance = Geolocator.distanceBetween(
        currentBranch.latitude!, currentBranch.longitude!,
        double.parse(address.latitude!), double.parse(address.longitude!),
      ) / 1000;

      isAvailable = distance < (currentBranch.coverage ?? 0);
    }

    return isAvailable;
  }

  static double getReferralDiscount({ReferralCustomerDetails? referralDetails, required double totalAmount}) {
    if (referralDetails == null || referralDetails.customerDiscountAmount == null) {
      return 0;
    }

    final discountAmount = referralDetails.customerDiscountAmount!;
    double referralDiscount;

    switch (referralDetails.customerDiscountAmountType?.toLowerCase()) {
      case 'amount':
        referralDiscount = discountAmount;
        break;
      case 'percent':
        referralDiscount = totalAmount * (discountAmount / 100);
        break;
      default:
        referralDiscount = 0;
    }

    return referralDiscount.clamp(0, totalAmount);
  }


  static selectPaymentMethodAutomatically({required List<PaymentMethod> activePaymentMethodList, required bool isCashOnDeliveryActive}) {
    final CheckoutProvider checkoutProvider = Provider.of<CheckoutProvider>(Get.context!, listen: false);

    final PaymentMethod? lastOrderedPaymentMethod = _getPreferredPaymentMethod(activePaymentMethodList);


    if(isCashOnDeliveryActive && lastOrderedPaymentMethod == null) {
      checkoutProvider.savePaymentMethod(index: 1);

    }else {
      if(activePaymentMethodList.isEmpty) return;
      checkoutProvider.savePaymentMethod(method: lastOrderedPaymentMethod ?? activePaymentMethodList.first);
    }

  }

  static PaymentMethod? _getPreferredPaymentMethod(List<PaymentMethod> availableMethods) {
    const excludedMethods = {
      'cash_on_delivery',
      'offline_payment',
      'wallet',
    };

    if(!Provider.of<AuthProvider>(Get.context!, listen: false).isLoggedIn()) {
      return null;
    }

    final String? lastUsedMethod = Provider.of<OrderProvider>(Get.context!, listen: false).getLastOrderPaymentMethod();

    if (lastUsedMethod == null ||
        lastUsedMethod.isEmpty ||
        excludedMethods.contains(lastUsedMethod)) {
      return null;
    }

    return availableMethods.firstWhereOrNull((method) => method.getWay == lastUsedMethod);
  }

}