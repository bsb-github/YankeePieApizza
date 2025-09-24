import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/enums/data_source_enum.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/models/delivery_info_model.dart';
import 'package:flutter_restaurant/common/models/offline_payment_model.dart';
import 'package:flutter_restaurant/common/providers/data_sync_provider.dart';
import 'package:flutter_restaurant/data/datasource/local/cache_response.dart';
import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/splash/domain/reposotories/splash_repo.dart';
import 'package:flutter_restaurant/helper/date_converter_helper.dart';
import 'package:flutter_restaurant/helper/notification_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:provider/provider.dart';

import '../../../common/models/policy_model.dart';
import '../../../helper/api_checker_helper.dart';

class SplashProvider extends DataSyncProvider {
  final SplashRepo? splashRepo;
  SplashProvider({required this.splashRepo});

  ConfigModel? _configModel;
  DeliveryInfoModel? _deliveryInfoModel;
  BaseUrls? _baseUrls;
  final DateTime _currentTime = DateTime.now();
  PolicyModel? _policyModel;
  bool _cookiesShow = true;
  List<OfflinePaymentModel?>? _offlinePaymentModelList;
  PayloadModel? _payloadModel;



  ConfigModel? get configModel => _configModel;
  DeliveryInfoModel? get deliveryInfoModel => _deliveryInfoModel;
  BaseUrls? get baseUrls => _baseUrls;
  DateTime get currentTime => _currentTime;
  PolicyModel? get policyModel => _policyModel;
  bool get cookiesShow => _cookiesShow;
  List<OfflinePaymentModel?>? get offlinePaymentModelList => _offlinePaymentModelList;
  PayloadModel? get payloadModel => _payloadModel;






  void _startTimer (DateTime startTime){
    Timer.periodic(const Duration(seconds: 30), (Timer timer){

      DateTime now = DateTime.now();

      if (now.isAfter(startTime) || now.isAtSameMomentAs(startTime)) {
        timer.cancel();
        RouterHelper.getMaintainRoute();
      }

    });
  }




  bool isLoading = false;

  Future<ConfigModel?> initConfig(BuildContext context, DataSourceEnum source) async {
    if(source == DataSourceEnum.local) {
      ApiResponseModel<CacheResponseData> responseModel =  await splashRepo!.getConfig(source: DataSourceEnum.local);

      if(responseModel.isSuccess) {

        try{
          _configModel = ConfigModel.fromJson(jsonDecode(responseModel.response!.response));
          _baseUrls = _configModel?.baseUrls;
          if(context.mounted) {
            _onConfigAction(context);

          }
        }finally{
          if(context.mounted) {
            await initConfig(context, DataSourceEnum.client);
          }
        }

      }

      if(context.mounted) {
        await initConfig(context, DataSourceEnum.client);

      }

    }else {
      ApiResponseModel<Response> apiResponseModel = await splashRepo!.getConfig(source: DataSourceEnum.client);

      if(apiResponseModel.isSuccess) {
        _configModel = ConfigModel.fromJson(apiResponseModel.response?.data);
        _baseUrls = _configModel?.baseUrls;

        if(context.mounted) {
          await _onConfigAction(context);
        }

      }
    }


    return _configModel;
  }

  Future<void> _onConfigAction(BuildContext context) async {
    if (configModel != null) {

      if(_configModel?.maintenanceMode?.maintenanceStatus == 0){
        if((ResponsiveHelper.isWeb() && _configModel?.maintenanceMode?.selectedMaintenanceSystem?.webApp == 1) ||
            (!ResponsiveHelper.isWeb() && _configModel?.maintenanceMode?.selectedMaintenanceSystem?.customerApp == 1) ){
          if(_configModel?.maintenanceMode?.maintenanceTypeAndDuration?.maintenanceDuration == 'customize'){

            DateTime now = DateTime.now();
            DateTime specifiedDateTime = DateTime.parse(_configModel!.maintenanceMode!.maintenanceTypeAndDuration!.startDate!);

            Duration difference = specifiedDateTime.difference(now);

            if(difference.inMinutes > 0 && (difference.inMinutes < 60 || difference.inMinutes == 60)){
              _startTimer(specifiedDateTime);
            }

          }
        }
      }

      if(context.mounted){
        final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
        final LocationProvider locationProvider = Provider.of<LocationProvider>(context, listen: false);

        if(authProvider.getGuestId() == null && !authProvider.isLoggedIn()){
          final bool isSuccess = await authProvider.addGuest();

          if(isSuccess){
            Future.delayed(const Duration(milliseconds: 100)).then((_){
              locationProvider.initAddressList();
            });

          }


        }
      }



      if(!kIsWeb && context.mounted) {
        if(!Provider.of<AuthProvider>(context, listen: false).isLoggedIn()){
          await Provider.of<AuthProvider>(context, listen: false).updateToken();
        }
      }


      if(_configModel != null && _configModel?.branches != null && !isBranchSelectDisable()){
        await splashRepo?.setBranchId(_configModel!.branches![0]!.id!);
        await getDeliveryInfo(_configModel!.branches![0]!.id!);

      }

      notifyListeners();

    }
  }

  Future<void> getDeliveryInfo(int branchId) async{

    fetchAndSyncData(
      fetchFromLocal: ()=> splashRepo!.getDeliveryInfo<CacheResponseData>(branchId, source: DataSourceEnum.local),
      fetchFromClient: ()=> splashRepo!.getDeliveryInfo(branchId, source: DataSourceEnum.client),
      onResponse: (data, _){
        _deliveryInfoModel = DeliveryInfoModel.fromJson(data);
        notifyListeners();
      },
    );
  }


  Future<bool> initSharedData() {
    return splashRepo!.initSharedData();
  }

  Future<bool> removeSharedData() {
    return splashRepo!.removeSharedData();
  }

  bool isRestaurantClosed(bool today) {
    DateTime date = DateTime.now();
    if(!today) {
      date = date.add(const Duration(days: 1));
    }
    int weekday = date.weekday;
    if(weekday == 7) {
      weekday = 0;
    }
    for(int index = 0; index <  _configModel!.restaurantScheduleTime!.length; index++) {
      if(weekday.toString() ==  _configModel!.restaurantScheduleTime![index].day) {
        return false;
      }
    }
    return true;
  }

  bool isRestaurantOpenNow(BuildContext context) {
    if(isRestaurantClosed(true)) {
      return false;
    }
    int weekday = DateTime.now().weekday;
    if(weekday == 7) {
      weekday = 0;
    }
    for(int index = 0; index <  _configModel!.restaurantScheduleTime!.length; index++) {
      if(weekday.toString() ==  _configModel!.restaurantScheduleTime![index].day && DateConverterHelper.isAvailable(
        _configModel!.restaurantScheduleTime![index].openingTime!,
        _configModel!.restaurantScheduleTime![index].closingTime!,
      )) {
        return true;
      }
    }
    return false;
  }

  Future<void> getPolicyPage() async {

    fetchAndSyncData(
      fetchFromLocal: ()=> splashRepo!.getPolicyPage(source: DataSourceEnum.local),
      fetchFromClient: ()=> splashRepo!.getPolicyPage(source: DataSourceEnum.client),
      onResponse: (data, _){
        _policyModel = PolicyModel.fromJson(data);
        notifyListeners();

      },
    );

  }

  void cookiesStatusChange(String? data) {
    if(data != null){
      splashRepo!.sharedPreferences!.setString(AppConstants.cookiesManagement, data);
    }
    _cookiesShow = false;
    notifyListeners();
  }

  bool getAcceptCookiesStatus(String? data) => splashRepo!.sharedPreferences!.getString(AppConstants.cookiesManagement) != null
      && splashRepo!.sharedPreferences!.getString(AppConstants.cookiesManagement) == data;

  int getActiveBranch(){
    int branchActiveCount = 0;
    for(int i = 0; i < _configModel!.branches!.length; i++){
      if(_configModel!.branches![i]!.status ?? false) {
        branchActiveCount++;
        if(branchActiveCount > 1){
          break;
        }
      }
    }
    if(branchActiveCount == 0){
      splashRepo?.setBranchId(-1);
    }
    return branchActiveCount;
  }

  bool isBranchSelectDisable()=> getActiveBranch() != 1;

  Future<void> getOfflinePaymentMethod(bool isReload) async {
    if(_offlinePaymentModelList == null || isReload){
      _offlinePaymentModelList = null;
    }
    if(_offlinePaymentModelList == null){
      ApiResponseModel apiResponse = await splashRepo!.getOfflinePaymentMethod();
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _offlinePaymentModelList = [];

        apiResponse.response?.data.forEach((v) {
          _offlinePaymentModelList?.add(OfflinePaymentModel.fromJson(v));
        });

      } else {
        ApiCheckerHelper.checkApi(apiResponse);
      }
      notifyListeners();
    }

  }




  void setPayloadModel ({PayloadModel? payloadModel, bool isUpdate = true}){
    _payloadModel = payloadModel;
    if(isUpdate){
      notifyListeners();
    }
  }

}