import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/common/models/response_model.dart';
import 'package:flutter_restaurant/features/profile/domain/models/userinfo_model.dart';
import 'package:flutter_restaurant/features/profile/domain/reposotories/profile_repo.dart';
import 'package:flutter_restaurant/helper/api_checker_helper.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileRepo? profileRepo;

  ProfileProvider({required this.profileRepo});

  UserInfoModel? _userInfoModel;

  UserInfoModel? get userInfoModel => _userInfoModel;
  set setUserInfoModel(UserInfoModel? user) => _userInfoModel = user;

  Future<void> getUserInfo(bool reload, {bool isUpdate = true}) async {
    if(reload){
      _userInfoModel = null;
    }

    if(_userInfoModel == null){
      ApiResponseModel apiResponse = await profileRepo!.getUserInfo();
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _userInfoModel = UserInfoModel.fromJson(apiResponse.response!.data);
      } else {
        ApiCheckerHelper.checkApi(apiResponse);
      }
    }

    if(isUpdate){
      notifyListeners();
    }

  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> updateUserInfo(UserInfoModel updateUserModel, String password, File? file, XFile? data, String token) async {
    _isLoading = true;
    notifyListeners();
    ResponseModel responseModel;
    http.StreamedResponse response = await profileRepo!.updateProfile(updateUserModel, password, file, data, token);
    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      String? message = map["message"];
      _userInfoModel = updateUserModel;
      responseModel = ResponseModel(true, message);
    } else {
      responseModel = ResponseModel(false, '${response.statusCode} ${response.reasonPhrase}');
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  void updateReferralInfoShowStatus({int value = 1}) async {
     await profileRepo!.updateReferralInfoShowStatus(value: value);
  }




}
