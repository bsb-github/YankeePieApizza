import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/features/auth/domain/models/signup_model.dart';
import 'package:flutter_restaurant/features/auth/domain/models/social_login_model.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  AuthRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponseModel> registration(SignUpModel signUpModel) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.registerUri,
        data: signUpModel.toJson(),
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> login({String? userInput, String? password, String? type}) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.loginUri,
        data: {"email_or_phone": userInput, "password": password, "type": type},
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> registerWithOtp(String name, {String? email, required String phone}) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.registerWithOtp,
        data: {"name": name, "email": email, "phone": phone},
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> registerWithSocialMedia(String name, {required String email,String? phone}) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.registerWithSocialMedia,
        data: {"name": name, "email": email, "phone": phone},
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> existingAccountCheck({String? email, required String phone, required int userResponse, required String medium}) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.existingAccountCheck,
        data: {"email": email, 'phone': phone,  "user_response": userResponse, "medium": medium},
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<void> subscribeTokenToTopic(token, topic) async {
    await dioClient?.post(AppConstants.subscribeToTopic, data: {"token": '$token', "topic": topic});
  }


  Future<ApiResponseModel> updateDeviceToken({String? fcmToken}) async {
    try {
      String? deviceToken = '@';

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
        NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
          alert: true, announcement: false, badge: true, carPlay: false,
          criticalAlert: false, provisional: false, sound: true,
        );
        if(settings.authorizationStatus == AuthorizationStatus.authorized) {
          deviceToken = (await getDeviceToken())!;
        }
      }else {
        deviceToken = (await getDeviceToken())!;
      }

      if(!kIsWeb){
        if(fcmToken == null) {
          FirebaseMessaging.instance.subscribeToTopic(AppConstants.topic);
        }else{
          FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.topic);
        }
      }else{
        await subscribeTokenToTopic(deviceToken, fcmToken ?? AppConstants.topic);
      }


      Map<String, dynamic> data = {"_method": "put", "cm_firebase_token": fcmToken ?? deviceToken};
      if(getGuestId() != null) {
        data.addAll({'guest_id' : getGuestId()});
      }

      Response response = await dioClient!.post(
        AppConstants.tokenUri,
        data: data,
      );

      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<String?> getDeviceToken() async {
    String? deviceToken = '@';
    try{
      deviceToken = (await FirebaseMessaging.instance.getToken())!;

    }catch(error){
      debugPrint('eroor ====> $error');
    }
    if (deviceToken != null) {
      debugPrint('--------Device Token---------- $deviceToken');
    }

    return deviceToken;
  }

  // for forgot password
  Future<ApiResponseModel> forgetPassword(String email, String type) async {
    try {
      Response response = await dioClient!.post(AppConstants.forgetPasswordUri, data: {"email_or_phone": email, "type" : type});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> verifyToken(String email, String token) async {
    try {
      Response response = await dioClient!.post(AppConstants.verifyTokenUri, data: {"email_or_phone": email, "reset_token": token});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> resetPassword(String? mail, String? resetToken, String password, String confirmPassword, {required String type}) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.resetPasswordUri,
        data: {"_method": "put", "reset_token": resetToken, "password": password, "confirm_password": confirmPassword, "email_or_phone": mail, "type":type},
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for verify email number
  Future<ApiResponseModel> checkEmail(String email) async {
    try {
      Response response = await dioClient!.post(AppConstants.checkEmailUri, data: {"email": email});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> verifyEmail(String email, String token) async {
    try {
      Response response = await dioClient!.post(AppConstants.verifyEmailUri, data: {"email": email, "token": token});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }



  //verify phone number

  Future<ApiResponseModel> checkPhone(String phone) async {
    try {
      Response response = await dioClient!.post(AppConstants.baseUrl + AppConstants.checkPhoneUri + phone, data: {"phone" : phone});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> verifyPhone(String phone, String token) async {
    try {
      Response response = await dioClient!.post(
          AppConstants.verifyPhoneUri, data: {"phone": phone.trim(), "token": token});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> verifyOtp(String phone, String token) async {
    try {
      Response response = await dioClient!.post(
          AppConstants.verifyOtpUri, data: {"phone": phone.trim(), "token": token});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponseModel> verifyProfileInfo(String userInput, String token, String type) async {
    try {
      Response response = await dioClient!.post(
          AppConstants.verifyProfileInfo, data: {"email_or_phone": userInput, "token": token, "type": type});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }




  // for  user token
  Future<void> saveUserToken(String token) async {
    dioClient!.updateHeader(getToken: token);

    try {

      await sharedPreferences!.setString(AppConstants.token, token);
    } catch (e) {
      rethrow;
    }
  }

  String getUserToken() {
    return sharedPreferences!.getString(AppConstants.token) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences!.containsKey(AppConstants.token);
  }

  Future<bool> clearSharedData() async {
    if(!kIsWeb) {
      Future.delayed(const Duration(milliseconds: 100)).then((value) async =>
      await FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.topic));
    }

   try{
     await dioClient!.post(
       AppConstants.tokenUri,
       data: {"_method": "put", "cm_firebase_token": '@'},
     );
   }catch(error){
      debugPrint('error $error');
   }
    
    await updateDeviceToken(fcmToken: '@');
    await sharedPreferences!.remove(AppConstants.token);
    await sharedPreferences!.remove(AppConstants.cartList);
    await sharedPreferences!.remove(AppConstants.userAddress);
    await sharedPreferences!.remove(AppConstants.searchAddress);
    return true;
  }

  Future<void> saveUserNumberAndPassword(String userData) async {
    try {
      await sharedPreferences!.setString(AppConstants.userLogData, userData);
    } catch (e) {
      rethrow;
    }
  }

  String getUserLogData() {
    return sharedPreferences!.getString(AppConstants.userLogData) ?? "";
  }

  Future<bool> clearUserLog() async {
    return await sharedPreferences!.remove(AppConstants.userLogData);
  }

  Future<ApiResponseModel> deleteUser() async {
    try{
      Response response = await dioClient!.delete(AppConstants.customerRemove);
      return ApiResponseModel.withSuccess(response);
    }catch(e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }

  }

  Future<ApiResponseModel> socialLogin(SocialLoginModel socialLogin) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.socialLogin,
        data: socialLogin.toJson(),
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponseModel> addGuest(String? fcmToken) async {
    try{
      Response response = await dioClient!.post(AppConstants.addGuest, data: {'fcm_token': fcmToken});
      return ApiResponseModel.withSuccess(response);
    }catch(e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }

  }

  Future<void> saveGuestId(String id) async {
    try {
      await sharedPreferences!.setString(AppConstants.guestId, id);
    } catch (e) {
      rethrow;
    }
  }

  String? getGuestId()=> sharedPreferences?.getString(AppConstants.guestId);

  Future<ApiResponseModel> firebaseAuthVerify({required String phoneNumber, required String session, required String otp, required bool isForgetPassword}) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.firebaseAuthVerify,
        data: {
          'sessionInfo' : session,
          'phoneNumber' : phoneNumber,
          'code' : otp,
          'is_reset_token' : isForgetPassword ? 1 : 0,
        },
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<void> setAppleLoginEmail(String email) async {
    try {
      await sharedPreferences!.setString(AppConstants.appleLoginEmail, email);
    } catch (e) {
      rethrow;
    }
  }

  String getAppleLoginEmail() => sharedPreferences!.getString(AppConstants.appleLoginEmail) ?? "";



}
