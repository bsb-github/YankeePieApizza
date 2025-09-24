import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/features/coupon/domain/models/coupon_model.dart';
import 'package:flutter_restaurant/features/coupon/domain/reposotories/coupon_repo.dart';
import 'package:flutter_restaurant/helper/api_checker_helper.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class CouponProvider extends ChangeNotifier {
  final CouponRepo? couponRepo;
  CouponProvider({required this.couponRepo});

  List<CouponModel>? _availableCouponList;
  List<CouponModel>? _unavailableCouponList;
  List<CouponModel>? _searchedCouponList;
  CouponModel? _coupon;
  double? _discount = 0.0;
  String? _code = '';
  bool _isLoading = false;
  bool _isActiveSuffixIcon = false;
  bool _isSearchComplete = true;
  int? _selectedCouponIndex;

  CouponModel? get coupon => _coupon;
  double? get discount => _discount;
  String? get code => _code;
  bool get isLoading => _isLoading;
  bool get isActiveSuffixIcon => _isActiveSuffixIcon;
  bool get isSearchComplete => _isSearchComplete;
  int? get selectedCouponIndex => _selectedCouponIndex;
  List<CouponModel>? get availableCouponList => _availableCouponList;
  List<CouponModel>? get unavailableCouponList => _unavailableCouponList;
  List<CouponModel>? get searchedCouponList => _searchedCouponList;

  var searchController = TextEditingController();

  Future<void> getCouponList({double? orderAmount}) async {
    ApiResponseModel apiResponse = await couponRepo!.getCouponList(
      guestId: Provider.of<AuthProvider>(Get.context!, listen: false).getGuestId(),
      orderAmount: orderAmount
    );
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {

      _availableCouponList = [];
      _unavailableCouponList = [];
      apiResponse.response!.data['available'].forEach((category) => _availableCouponList!.add(CouponModel.fromJson(category)));
      apiResponse.response!.data['unavailable'].forEach((category) => _unavailableCouponList!.add(CouponModel.fromJson(category)));

      notifyListeners();
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
  }

  Future<double?> applyCoupon(String coupon, double amountWithoutVat, {int? selectedIndex}) async {
    if(selectedIndex !=null){
      _selectedCouponIndex = selectedIndex;
    }else{
      _isLoading = true;
    }
    notifyListeners();
    ApiResponseModel apiResponse = await couponRepo!.applyCoupon(coupon, guestId: Provider.of<AuthProvider>(Get.context!, listen: false).getGuestId(),);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _coupon = CouponModel.fromJson(apiResponse.response!.data);
      _code = _coupon!.code;
      if (_coupon!.minPurchase != null && _coupon!.minPurchase! <= amountWithoutVat) {
        if(_coupon!.discountType == 'percent') {
          if(_coupon!.maxDiscount != null && _coupon!.maxDiscount != 0) {
            _discount = (_coupon!.discount! * amountWithoutVat / 100) < _coupon!.maxDiscount! ? (_coupon!.discount! * amountWithoutVat / 100) : _coupon!.maxDiscount;
          }else {
            _discount = _coupon!.discount! * amountWithoutVat / 100;
          }
        }else {
          if(_coupon!.maxDiscount != null){
            _discount = _coupon!.discount;
          }
          _discount = _coupon!.discount;
        }
      } else {
        _discount = 0.0;
      }
    } else {
      _discount = 0.0;
    }
    if(selectedIndex != null){
      _selectedCouponIndex = null;
    }else{
      _isLoading = false;
    }
    notifyListeners();
    return _discount;
  }

  void removeCouponData(bool notify) {
    _coupon = null;
    _isLoading = false;
    _discount = 0.0;
    _code = '';
    if(notify) {
      notifyListeners();
    }
  }

  void searchCoupon({required String query}) {
    _searchedCouponList = [];
    _searchedCouponList = _availableCouponList?.where((item) {
      final titleLower = item.title?.toLowerCase() ?? "";
      final subtitleLower = item.code?.toLowerCase() ?? "";
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower) || subtitleLower.contains(searchLower);
    }).toList();
  }

  void showSuffixIcon(context,String text){
    if(text.isNotEmpty){
      _isActiveSuffixIcon = true;
    }else if(text.isEmpty){
      _isActiveSuffixIcon = false;
    }
    notifyListeners();
  }

  void clearSearchController({bool shouldUpdate = true} ){
    searchController.clear();
    _isSearchComplete = true;
    _isActiveSuffixIcon = false;

    if(shouldUpdate){
      notifyListeners();
    }
  }
}