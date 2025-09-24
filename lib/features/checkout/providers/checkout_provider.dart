import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/models/offline_payment_model.dart';
import 'package:flutter_restaurant/features/address/domain/models/address_model.dart';
import 'package:flutter_restaurant/features/checkout/domain/enum/delivery_type_enum.dart';
import 'package:flutter_restaurant/features/checkout/domain/models/check_out_model.dart';
import 'package:flutter_restaurant/features/order/domain/models/distance_model.dart';
import 'package:flutter_restaurant/features/order/domain/models/timeslote_model.dart';
import 'package:flutter_restaurant/features/order/domain/reposotories/order_repo.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/date_converter_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CheckoutProvider extends ChangeNotifier {
  final OrderRepo? orderRepo;
  CheckoutProvider({required this.orderRepo});


  int? _paymentMethodIndex;
  double? _partialAmount;
  PaymentMethod? _paymentMethod;
  PaymentMethod? _selectedPaymentMethod;
  OfflinePaymentModel? _selectedOfflineMethod;
  List<Map<String, String>>? _selectedOfflineValue;

  AddressModel? _selectedAddress;
  bool _isLoading = false;
  OrderType _orderType = OrderType.delivery;
  int _branchIndex = 0;
  List<TimeSlotModel>? _timeSlots;
  List<TimeSlotModel>? _allTimeSlots;
  int _selectDateSlot = 0;
  int _selectTimeSlot = 0;
  double _distance = -1;
  bool _isCutlerySelected = false;
  CheckOutModel? _checkOutData;
  double _deliveryCharge = 0;
  double? _bringChangeAmount;
  bool _showBringChangeInputOption = false;


  bool paymentVisibility = true;
  Map<String, TextEditingController> field  = {};
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();



  int? get paymentMethodIndex => _paymentMethodIndex;
  AddressModel? get selectedAddress => _selectedAddress;
  bool get isLoading => _isLoading;
  OrderType get orderType => _orderType;
  int get branchIndex => _branchIndex;
  List<TimeSlotModel>? get timeSlots => _timeSlots;
  List<TimeSlotModel>? get allTimeSlots => _allTimeSlots;
  int get selectDateSlot => _selectDateSlot;
  int get selectTimeSlot => _selectTimeSlot;
  double get distance => _distance;
  PaymentMethod? get paymentMethod => _paymentMethod;
  PaymentMethod? get selectedPaymentMethod => _selectedPaymentMethod;
  double? get partialAmount => _partialAmount;
  OfflinePaymentModel? get selectedOfflineMethod => _selectedOfflineMethod;
  List<Map<String, String>>? get selectedOfflineValue => _selectedOfflineValue;

  bool get isCutlerySelected => _isCutlerySelected;
  CheckOutModel? get getCheckOutData => _checkOutData;
  double get deliveryCharge => _deliveryCharge;
  double? get bringChangeAmount => _bringChangeAmount;
  bool get showBringChangeInputOption => _showBringChangeInputOption;


  set setPartialAmount(double? value)=> _partialAmount = value;
  set setCheckOutData(CheckOutModel value) {
    _checkOutData = value;
  }

  void setPaymentIndex(int? index, {bool isUpdate = true}) {
    _paymentMethodIndex = index;
    _paymentMethod = null;
    if(isUpdate){
      notifyListeners();
    }
  }

  void changePaymentMethod({PaymentMethod? digitalMethod, bool isUpdate = true, OfflinePaymentModel? offlinePaymentModel, bool isClear = false}){
    if(offlinePaymentModel != null){
      _selectedOfflineMethod = offlinePaymentModel;
    }else if(digitalMethod != null){
      _paymentMethod = digitalMethod;
      _paymentMethodIndex = null;
      _selectedOfflineMethod = null;
      _selectedOfflineValue = null;
    }
    if(isClear){
      _paymentMethod = null;
      _selectedPaymentMethod = null;
      clearOfflinePayment();

    }
    if(isUpdate){
      notifyListeners();
    }
  }

  void savePaymentMethod({int? index, PaymentMethod? method, bool isUpdate = true, double? partialAmount, OfflinePaymentModel? selectedOfflineMethod,  List<Map<String, String>>? selectedOfflineValue}){
    if(method != null){
      final isOfflinePayment = (method.type == 'offline' || (method.isOffline ?? false));
      _selectedPaymentMethod = method.copyWith('online', isOffline: isOfflinePayment );
    }else if(index != null && index == 1){
      _selectedPaymentMethod = PaymentMethod(
        getWayTitle: getTranslated('cash_on_delivery', Get.context!),
        getWay: 'cash_on_delivery',
        type: 'cash_on_delivery',
      );
    }else if(index != null && index == 0){
      _selectedPaymentMethod = PaymentMethod(
        getWayTitle: getTranslated('wallet_payment', Get.context!),
        getWay: 'wallet_payment',
        type: 'wallet_payment',
      );
    }else{
      _selectedPaymentMethod = null;
    }

    _paymentMethodIndex = index;
    _paymentMethod = method;
    _partialAmount = partialAmount;
    _selectedOfflineMethod = selectedOfflineMethod;
    _selectedOfflineValue = selectedOfflineValue;

   if(isUpdate){
     notifyListeners();
   }

  }

  void clearOfflinePayment(){
    _selectedOfflineMethod = null;
    _selectedOfflineValue = null;
  }





  void stopLoader() {
    _isLoading = false;
    notifyListeners();
  }

  void setSelectedAddress(AddressModel ? address, {bool isUpdate = true}) {
    _selectedAddress = address;


    if(isUpdate) {
      notifyListeners();
    }
  }

  void clearPrevData({bool isUpdate = false}) {
    _paymentMethod = null;
    _selectedAddress = null;
    _branchIndex = 0;
    _paymentMethodIndex = null;
    _selectedPaymentMethod = null;
    _selectedOfflineMethod = null;
    clearOfflinePayment();
    _partialAmount = null;
    _distance = -1;
    if(isUpdate){
      notifyListeners();
    }
  }


  void setOrderType(OrderType type, {bool notify = true}) {
    _orderType = type;
    if(notify) {
      notifyListeners();
    }
  }

  void setBranchIndex(int index) {
    _branchIndex = index;
    _selectedAddress = null;
    _distance = -1;
    notifyListeners();
  }

  Future<void> initializeTimeSlot(BuildContext context) async {
   final scheduleTime =  Provider.of<SplashProvider>(context, listen: false).configModel!.restaurantScheduleTime!;
   int? duration = Provider.of<SplashProvider>(context, listen: false).configModel!.scheduleOrderSlotDuration;
    _timeSlots = [];
    _allTimeSlots = [];
    _selectDateSlot = 0;
    int minutes = 0;
    DateTime now = DateTime.now();
    for(int index = 0; index < scheduleTime.length; index++) {
      DateTime openTime = DateTime(
        now.year,
        now.month,
        now.day,
        DateConverterHelper.convertStringTimeToDate(scheduleTime[index].openingTime!).hour,
        DateConverterHelper.convertStringTimeToDate(scheduleTime[index].openingTime!).minute,
      );

      DateTime closeTime = DateTime(
        now.year,
        now.month,
        now.day,
        DateConverterHelper.convertStringTimeToDate(scheduleTime[index].closingTime!).hour,
        DateConverterHelper.convertStringTimeToDate(scheduleTime[index].closingTime!).minute,
      );

      if(closeTime.difference(openTime).isNegative) {
        minutes = openTime.difference(closeTime).inMinutes;
      }else {
        minutes = closeTime.difference(openTime).inMinutes;
      }
      if(duration! > 0 && minutes > duration) {
        DateTime time = openTime;
        for(;;) {
          if(time.isBefore(closeTime)) {
            DateTime start = time;
            DateTime end = start.add(Duration(minutes: duration));
            if(end.isAfter(closeTime)) {
              end = closeTime;
            }
            _timeSlots!.add(TimeSlotModel(day: int.tryParse(scheduleTime[index].day!), startTime: start, endTime: end));
            _allTimeSlots!.add(TimeSlotModel(day: int.tryParse(scheduleTime[index].day!), startTime: start, endTime: end));
            time = time.add(Duration(minutes: duration));
          }else {
            break;
          }
        }
      }else {
        _timeSlots!.add(TimeSlotModel(day: int.tryParse(scheduleTime[index].day!), startTime: openTime, endTime: closeTime));
        _allTimeSlots!.add(TimeSlotModel(day: int.tryParse(scheduleTime[index].day!), startTime: openTime, endTime: closeTime));
      }
    }
    validateSlot(_allTimeSlots!, 0, notify: false);
  }
  void sortTime() {
    _timeSlots!.sort((a, b){
      return a.startTime!.compareTo(b.startTime!);
    });

    _allTimeSlots!.sort((a, b){
      return a.startTime!.compareTo(b.startTime!);
    });
  }

  void updateTimeSlot(int index) {
    _selectTimeSlot = index;
    notifyListeners();
  }

  void updateDateSlot(int index) {
    _selectDateSlot = index;
    if(_allTimeSlots != null) {
      validateSlot(_allTimeSlots!, index);
    }
    notifyListeners();
  }



  void validateSlot(List<TimeSlotModel> slots, int dateIndex, {bool notify = true}) {
    _timeSlots = [];
    int day = 0;
    if(dateIndex == 0) {
      day = DateTime.now().weekday;
    }else {
      day = DateTime.now().add(const Duration(days: 1)).weekday;
    }
    if(day == 7) {
      day = 0;
    }
    for (var slot in slots) {
      if (day == slot.day && (dateIndex == 0 ? slot.endTime!.isAfter(DateTime.now()) : true)) {
        _timeSlots!.add(slot);
      }
    }


    if(notify) {
      notifyListeners();
    }
  }


  Future<bool> getDistanceInMeter(LatLng originLatLng, LatLng destinationLatLng) async {
    _distance = -1;
    bool isSuccess = false;
    ApiResponseModel response = await orderRepo!.getDistanceInMeter(originLatLng, destinationLatLng);
    try {
      if (response.response!.statusCode == 200 && response.response!.data[0]['distanceMeters'] != null) {
        isSuccess = true;
        _distance = (DistanceModel.fromJson(response.response!.data[0]).distanceMeters ?? 0) /  1000;
      } else {
        _distance = getDistanceBetween(originLatLng, destinationLatLng) / 1000;
      }
    } catch (e) {
      _distance = getDistanceBetween(originLatLng, destinationLatLng) / 1000;
    }
    notifyListeners();
    return isSuccess;
  }



  double getDistanceBetween(LatLng startLatLng, LatLng endLatLng){
    return Geolocator.distanceBetween(
      startLatLng.latitude, startLatLng.longitude, endLatLng.latitude, endLatLng.longitude,
    );
  }

  void changePartialPayment({double? amount,  bool isUpdate = true}){
    _partialAmount = amount;
    if(isUpdate) {
      notifyListeners();
    }
  }
  void setOfflineSelectedValue(List<Map<String, String>>? data, {bool isUpdate = true}){
    _selectedOfflineValue = data;

    if(isUpdate){
      notifyListeners();
    }
  }


  void updatePaymentVisibility(bool vale){
    paymentVisibility = vale;
    // notifyListeners();
  }



  void updateCutleryStatus(bool selected){
    _isCutlerySelected = selected;
    notifyListeners();
  }

  void setDeliveryCharge({double? deliveryCharge, bool isUpdate = true, bool isReload = false}) {
    if(isReload){
      _deliveryCharge = 0;
    }else{
      _deliveryCharge = deliveryCharge ?? 0.0;
    }
    if(isUpdate){
      notifyListeners();
    }
  }

  void setBringChangeAmount({TextEditingController? amountController, bool isUpdate = true, bool isReload = false}) {
    if(amountController !=null && amountController.text.isNotEmpty && (double.tryParse(amountController.text) ?? 0) > 0 ) {
      _bringChangeAmount = double.tryParse(amountController.text) ?? 0;
    }else{
      _bringChangeAmount = null;
    }

    if(isUpdate){
      notifyListeners();
    }
  }

  void updateBringChangeInputOptionStatus(bool value, { bool isUpdate = true}){
    _showBringChangeInputOption = value;
    if(isUpdate){
      notifyListeners();
    }
  }

}