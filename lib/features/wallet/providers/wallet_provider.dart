import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/wallet/domain/models/wallet_filter_body.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/features/wallet/domain/models/wallet_bonus_model.dart';
import 'package:flutter_restaurant/features/wallet/domain/models/wallet_model.dart';
import 'package:flutter_restaurant/features/wallet/domain/reposotories/wallet_repo.dart';
import 'package:flutter_restaurant/helper/api_checker_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/features/wallet/screens/wallet_screen.dart';
import 'package:provider/provider.dart';

List<TabButtonModel?> tabButtonList =  [
  TabButtonModel(getTranslated('convert_to_money', Get.context!), Images.wallet, (){}),
  TabButtonModel(getTranslated('earning', Get.context!), Images.earningImage, (){}),
  TabButtonModel(getTranslated('converted', Get.context!), Images.convertedImage, (){}),
];

class WalletProvider with ChangeNotifier {
  final WalletRepo? walletRepo;
  WalletProvider({required this.walletRepo});

  List<Transaction>? _transactionList;
  List<String> _offsetList = [];
  int _offset = 1;
  int? _pageSize;
  bool _isLoading = false;
  String _type = 'all';
  List<WalletFilterBody> _walletFilterList = [];
  List<WalletBonusModel>? _walletBonusList;

  int? get popularPageSize => _pageSize;
  bool get isLoading => _isLoading;
  int get offset => _offset;
  bool _paginationLoader = false;
  bool get paginationLoader => _paginationLoader;
  List<Transaction>? get transactionList => _transactionList;
  String get type => _type;
  List<WalletFilterBody> get walletFilterList => _walletFilterList;
  List<WalletBonusModel>? get walletBonusList => _walletBonusList;





  void updatePagination(bool value){
    _paginationLoader = value;
    notifyListeners();
  }


  int? selectedTabButtonIndex;

  set setOffset(int offset) {
    _offset = offset;
  }



  Future<void> getLoyaltyTransactionList(String offset, bool reload, bool fromWallet, {bool isEarning = false}) async {

    if(offset == '1' || reload) {
      _offsetList = [];
      _offset = 1;
      _transactionList = null;
      if(reload) {
        notifyListeners();
      }

    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      ApiResponseModel apiResponse;
      if(fromWallet){
        apiResponse = await walletRepo!.getWalletTransactionList(offset, _type);

      }else{
        apiResponse = await walletRepo!.getLoyaltyTransactionList(offset, isEarning ? 'earning' : 'converted');
      }






      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        if (offset == '1') {
          _transactionList = [];
        }
        _transactionList!.addAll(WalletModel.fromJson(apiResponse.response!.data).data!);
        _pageSize = WalletModel.fromJson(apiResponse.response!.data).totalSize;

        _isLoading = false;
        _paginationLoader = false;
        notifyListeners();
      } else {
        ApiCheckerHelper.checkApi(apiResponse);
      }
    } else {
      if(isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<bool> pointToWallet(double point, bool fromWallet) async {
    bool isSuccess = false;
    _isLoading = true;
    notifyListeners();
    ApiResponseModel apiResponse = await walletRepo!.pointToWallet(point: point);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      isSuccess = true;
      Provider.of<ProfileProvider>(Get.context!, listen: false).getUserInfo(true);
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
    _isLoading = false;
    notifyListeners();
    return isSuccess;
  }

 void setCurrentTabButton(int index, {bool isUpdate = true}){
   selectedTabButtonIndex = index;
    if(isUpdate) {
      if(index != 0) {
       getLoyaltyTransactionList('1', true, false, isEarning: index == 1);
      }
      notifyListeners();
    }
  }

  void insertFilterList(){
    _walletFilterList = [];
    for(int i=0; i < AppConstants.walletTransactionSortingList.length; i++){
      _walletFilterList.add(WalletFilterBody.fromJson(AppConstants.walletTransactionSortingList[i]));
    }
  }

  void setWalletFilerType(String type, {bool isUpdate = true}) {
    _type = type;
    if(isUpdate) {
      notifyListeners();
    }
  }


  Future<void> getWalletBonusList(bool reload) async {
    _walletBonusList = null;
    ApiResponseModel apiResponse = await walletRepo!.getWalletBonusList();

    _walletBonusList = [];
    if(apiResponse.response?.statusCode == 200) {
      for (var element in apiResponse.response?.data) {
        _walletBonusList?.add(WalletBonusModel.fromJson(element));

      }
    }
    notifyListeners();


  }

  bool checkToken(String token){
    if(walletRepo!.sharedPreferences!.containsKey(token)){
      return false;
    }else{
      walletRepo!.sharedPreferences!.setString(token, token);
      return true;
    }
  }



}

