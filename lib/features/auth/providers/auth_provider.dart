// ignore_for_file: empty_catches

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/models/response_model.dart';
import 'package:flutter_restaurant/features/auth/domain/enum/auth_enum.dart';
import 'package:flutter_restaurant/features/auth/domain/models/signup_model.dart';
import 'package:flutter_restaurant/features/auth/domain/models/social_login_model.dart';
import 'package:flutter_restaurant/features/auth/domain/models/user_log_data.dart';
import 'package:flutter_restaurant/features/auth/domain/reposotories/auth_repo.dart';
import 'package:flutter_restaurant/features/cart/providers/cart_provider.dart';
import 'package:flutter_restaurant/features/profile/domain/models/userinfo_model.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/number_checker_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../../helper/api_checker_helper.dart';
import '../../../helper/custom_snackbar_helper.dart';
import '../../../localization/language_constrants.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepo? authRepo;

  AuthProvider({required this.authRepo});

  // for registration section
  bool _isLoading = false;
  String? _registrationErrorMessage = '';
  bool _isCheckedPhone = false;
  Timer? _timer;
  bool _isForgotPasswordLoading = false;
  bool _isNumberLogin = false;
  int? currentTime;
  String? _loginErrorMessage = '';
  bool _isPhoneNumberVerificationButtonLoading = false;
  bool resendButtonLoading = false;
  String? _verificationMsg = '';
  String _email = '';
  String _phone = '';
  String _verificationCode = '';
  bool _isEnableVerificationCode = false;
  bool _isActiveRememberMe = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleAccount;

  String? get loginErrorMessage => _loginErrorMessage;
  bool get isLoading => _isLoading;
  bool get isCheckedPhone => _isCheckedPhone;
  bool get isNumberLogin => _isNumberLogin;
  String get verificationCode => _verificationCode;
  String? get registrationErrorMessage => _registrationErrorMessage;
  set setIsLoading(bool value) => _isLoading = value;
  bool get isForgotPasswordLoading => _isForgotPasswordLoading;
  set setForgetPasswordLoading(bool value) => _isForgotPasswordLoading = value;
  bool get isPhoneNumberVerificationButtonLoading =>
      _isPhoneNumberVerificationButtonLoading;
  String? get verificationMessage => _verificationMsg;
  String get email => _email;
  String get phone => _phone;
  set setIsPhoneVerificationButttonLoading(bool value) =>
      _isPhoneNumberVerificationButtonLoading = value;
  bool get isEnableVerificationCode => _isEnableVerificationCode;
  bool get isActiveRememberMe => _isActiveRememberMe;

  updateRegistrationErrorMessage(String message) {
    _registrationErrorMessage = message;
    notifyListeners();
  }

  Future<ResponseModel> registration(
      SignUpModel signUpModel, ConfigModel config) async {
    _isLoading = true;
    _isCheckedPhone = false;
    _registrationErrorMessage = '';

    ResponseModel responseModel;
    String? token;
    String? tempToken;

    notifyListeners();

    ApiResponseModel apiResponse = await authRepo!.registration(signUpModel);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      showCustomSnackBarHelper(
          getTranslated('registration_successful', Get.context!),
          isError: false);

      Map map = apiResponse.response!.data;

      if (map.containsKey('temporary_token')) {
        tempToken = map["temporary_token"];
      } else if (map.containsKey('token')) {
        token = map["token"];
      }

      if (token != null) {
        await login(signUpModel.phone, signUpModel.password, 'phone');
        responseModel = ResponseModel(true, 'successful');
      } else {
        _isCheckedPhone = true;
        String type;

        if (config.customerVerification?.firebase == 1 ||
            config.customerVerification?.phone == 1) {
          type = 'phone';
        } else {
          type = 'email';
        }

        sendVerificationCode(config, signUpModel, type: type);

        responseModel = ResponseModel(false, tempToken);
      }
    } else {
      _registrationErrorMessage =
          ApiCheckerHelper.getError(apiResponse).errors![0].message;
      responseModel = ResponseModel(false, _registrationErrorMessage);
    }
    _isLoading = false;
    notifyListeners();

    return responseModel;
  }

  Future<ResponseModel> login(
      String? userInput, String? password, String? type) async {
    _isLoading = true;
    _loginErrorMessage = '';
    notifyListeners();

    ApiResponseModel apiResponse = await authRepo!
        .login(userInput: userInput, password: password, type: type);
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      String? token;
      String? tempToken;
      Map map = apiResponse.response!.data;
      if (map.containsKey('temporary_token')) {
        tempToken = map["temporary_token"];
      } else if (map.containsKey('token')) {
        token = map["token"];
      }

      if (token != null) {
        await _updateAuthToken(token);
        final ProfileProvider profileProvider =
            Provider.of<ProfileProvider>(Get.context!, listen: false);
        await profileProvider.getUserInfo(false, isUpdate: false);
      } else if (tempToken != null) {
        await sendVerificationCode(
            Provider.of<SplashProvider>(Get.context!, listen: false)
                .configModel!,
            SignUpModel(email: userInput, phone: userInput),
            type: type);
      }

      responseModel = ResponseModel(token != null, 'verification');
    } else {
      _loginErrorMessage =
          ApiCheckerHelper.getError(apiResponse).errors![0].message;
      responseModel = ResponseModel(false, _loginErrorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel?> forgetPassword(
      {required ConfigModel config,
      required String phoneOrEmail,
      required String type}) async {
    ResponseModel? responseModel;
    _isForgotPasswordLoading = true;
    notifyListeners();

    if (type == 'phone' &&
        config.customerVerification?.firebase == 1 &&
        config.customerVerification?.phone == 1) {
      await firebaseVerifyPhoneNumber(phoneOrEmail, isForgetPassword: true);
    } else {
      responseModel = await _forgetPassword(phoneOrEmail, type);
    }
    _isForgotPasswordLoading = false;
    notifyListeners();

    return responseModel;
  }

  Future<ResponseModel> _forgetPassword(String email, String type) async {
    _isForgotPasswordLoading = true;
    resendButtonLoading = true;
    notifyListeners();

    ApiResponseModel apiResponse = await authRepo!.forgetPassword(email, type);
    ResponseModel responseModel;

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      responseModel =
          ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      responseModel = ResponseModel(
          false, ApiCheckerHelper.getError(apiResponse).errors![0].message);
      ApiCheckerHelper.checkApi(apiResponse);
    }
    resendButtonLoading = false;
    _isForgotPasswordLoading = false;
    notifyListeners();

    return responseModel;
  }

  Future<void> updateToken() async {
    if (await authRepo!.getDeviceToken() != '@') {
      await authRepo!.updateDeviceToken();
    }
  }

  Future<ResponseModel> verifyToken(String email) async {
    _isPhoneNumberVerificationButtonLoading = true;
    notifyListeners();
    ApiResponseModel apiResponse =
        await authRepo!.verifyToken(email, _verificationCode);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      responseModel =
          ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      responseModel = ResponseModel(
          false, ApiCheckerHelper.getError(apiResponse).errors![0].message);
    }
    return responseModel;
  }

  Future<ResponseModel> resetPassword(
      String? mail, String? resetToken, String password, String confirmPassword,
      {required String type}) async {
    _isForgotPasswordLoading = true;
    notifyListeners();
    ApiResponseModel apiResponse = await authRepo!
        .resetPassword(mail, resetToken, password, confirmPassword, type: type);
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      responseModel =
          ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      responseModel = ResponseModel(
          false, ApiCheckerHelper.getError(apiResponse).errors![0].message);
    }
    _isForgotPasswordLoading = false;
    notifyListeners();
    return responseModel;
  }

  updateEmail(String email) {
    _email = email;
    notifyListeners();
  }

  updatePhone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  void clearVerificationMessage() {
    _verificationMsg = '';
  }

  Future<ResponseModel> checkEmail(String email, String? fromPage) async {
    _isPhoneNumberVerificationButtonLoading = true;
    resendButtonLoading = true;

    _verificationMsg = '';
    notifyListeners();
    ApiResponseModel apiResponse = await authRepo!.checkEmail(email);

    ResponseModel responseModel;

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      responseModel = ResponseModel(true, apiResponse.response!.data["token"]);

      bool isReplaceRoute =
          GoRouter.of(Get.context!).routeInformationProvider.value.uri.path ==
              RouterHelper.verify;

      if (fromPage != null && fromPage == FromPage.profile.name) {
        RouterHelper.getVerifyRoute(
          FromPage.profile.name,
          email,
          action:
              isReplaceRoute ? RouteAction.pushReplacement : RouteAction.push,
        );
      } else {
        RouterHelper.getVerifyRoute(
          FromPage.login.name,
          email,
          action:
              isReplaceRoute ? RouteAction.pushReplacement : RouteAction.push,
        );
      }
    } else {
      _verificationMsg =
          ApiCheckerHelper.getError(apiResponse).errors![0].message;
      showCustomSnackBarHelper(_verificationMsg);
      responseModel = ResponseModel(false, _verificationMsg);
    }
    _isPhoneNumberVerificationButtonLoading = false;
    resendButtonLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> verifyEmail(String email) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ApiResponseModel apiResponse =
        await authRepo!.verifyEmail(email, _verificationCode);

    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      String token = apiResponse.response!.data["token"];
      await _updateAuthToken(token);
      final ProfileProvider profileProvider =
          Provider.of<ProfileProvider>(Get.context!, listen: false);
      profileProvider.getUserInfo(true);
      responseModel =
          ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      _verificationMsg =
          ApiCheckerHelper.getError(apiResponse).errors![0].message;
      showCustomSnackBarHelper(_verificationMsg);
      responseModel = ResponseModel(false, _verificationMsg);
    }
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> checkPhone(String phone, String? fromPage) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ApiResponseModel apiResponse = await authRepo!.checkPhone(phone);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      responseModel = ResponseModel(true, apiResponse.response!.data["token"]);
      bool isReplaceRoute =
          GoRouter.of(Get.context!).routeInformationProvider.value.uri.path ==
              RouterHelper.verify;

      if (fromPage != null && fromPage == FromPage.profile.name) {
        RouterHelper.getVerifyRoute(
          FromPage.profile.name,
          phone,
          action:
              isReplaceRoute ? RouteAction.pushReplacement : RouteAction.push,
        );
      } else {
        RouterHelper.getVerifyRoute(
          FromPage.login.name,
          phone,
          action:
              isReplaceRoute ? RouteAction.pushReplacement : RouteAction.push,
        );
      }
    } else {
      _verificationMsg =
          ApiCheckerHelper.getError(apiResponse).errors![0].message;
      showCustomSnackBarHelper(_verificationMsg);
      responseModel = ResponseModel(false, _verificationMsg);
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> verifyPhone(String phone) async {
    _isPhoneNumberVerificationButtonLoading = true;
    String phoneNumber = phone;
    if (phone.contains('++')) {
      phoneNumber = phone.replaceAll('++', '+');
    }
    _verificationMsg = '';
    notifyListeners();
    ApiResponseModel apiResponse =
        await authRepo!.verifyPhone(phoneNumber, _verificationCode);

    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      responseModel =
          ResponseModel(true, apiResponse.response!.data["message"]);
      String token = apiResponse.response!.data["token"];
      await _updateAuthToken(token);
      final ProfileProvider profileProvider =
          Provider.of<ProfileProvider>(Get.context!, listen: false);
      profileProvider.getUserInfo(true);
    } else {
      _verificationMsg =
          ApiCheckerHelper.getError(apiResponse).errors![0].message;
      showCustomSnackBarHelper(_verificationMsg);
      responseModel = ResponseModel(false, _verificationMsg);
    }
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    return responseModel;
  }

  updateVerificationCode(String query, {bool isUpdate = true}) {
    if (query.length == 6) {
      _isEnableVerificationCode = true;
    } else {
      _isEnableVerificationCode = false;
    }
    _verificationCode = query;
    if (isUpdate) {
      notifyListeners();
    }
  }

  toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    notifyListeners();
  }

  bool isLoggedIn() {
    return authRepo!.isLoggedIn();
  }

  Future<bool> clearSharedData(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    _isLoading = true;
    notifyListeners();

    bool isSuccess = await authRepo!.clearSharedData();
    await authProvider.socialLogout();
    await authRepo?.dioClient?.updateHeader(getToken: null);

    if (context.mounted) {
      cartProvider.getCartData(context);
    }
    if (getGuestId() != null) {
      if (kDebugMode) {
        print('------------(update device token) -----from clearSharedData');
      }
      authRepo?.updateDeviceToken();
    }

    _isLoading = false;
    notifyListeners();
    return isSuccess;
  }

  void saveUserNumberAndPassword(UserLogData userLogData) {
    authRepo!.saveUserNumberAndPassword(jsonEncode(userLogData.toJson()));
  }

  UserLogData? getUserData() {
    UserLogData? userData;

    try {
      userData = UserLogData.fromJson(jsonDecode(authRepo!.getUserLogData()));
    } catch (error) {
      debugPrint('error ===> $error');
    }

    return userData;
  }

  Future<bool> clearUserLogData() async {
    return authRepo!.clearUserLog();
  }

  String getUserToken() {
    return authRepo!.getUserToken();
  }

  Future deleteUser() async {
    _isLoading = true;
    notifyListeners();
    ApiResponseModel response = await authRepo!.deleteUser();
    _isLoading = false;
    if (response.response!.statusCode == 200) {
      Provider.of<SplashProvider>(Get.context!, listen: false)
          .removeSharedData();
      showCustomSnackBarHelper(
          getTranslated('your_account_remove_successfully', Get.context!));
      RouterHelper.getLoginRoute(action: RouteAction.pushReplacement);
    } else {
      Get.context?.pop();
      ApiCheckerHelper.checkApi(response);
    }
  }

  Future<GoogleSignInAuthentication> googleLogin() async {
    GoogleSignInAuthentication auth;
    googleAccount = await _googleSignIn.signIn();
    auth = await googleAccount!.authentication;
    return auth;
  }

  Future socialLogin(SocialLoginModel socialLogin, Function callback) async {
    _isLoading = true;
    notifyListeners();

    ApiResponseModel apiResponse = await authRepo!.socialLogin(socialLogin);
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String? message = '';
      String? token = '';
      String? tempToken = '';
      UserInfoModel? userInfoModel;
      try {
        message = map['error_message'] ?? '';
      } catch (e) {
        debugPrint('error ===> $e');
      }

      try {
        token = map['token'];
      } catch (e) {}

      try {
        tempToken = map['temp_token'];
      } catch (e) {}

      if (map.containsKey('user')) {
        try {
          userInfoModel = UserInfoModel?.fromJson(map['user']);
          callback(true, null, message, null, userInfoModel, socialLogin.medium,
              socialLogin);
        } catch (e) {}
      }

      if (token != null) {
        authRepo!.saveUserToken(token);
        await authRepo!.updateDeviceToken();
        final ProfileProvider profileProvider =
            Provider.of<ProfileProvider>(Get.context!, listen: false);
        profileProvider.getUserInfo(true);
        clearUserLogData();
        callback(true, token, message, null, null, null, socialLogin);
      }

      if (tempToken != null) {
        callback(true, null, message, tempToken, null, null, socialLogin);
      }

      notifyListeners();
    } else {
      String? errorMessage =
          ApiCheckerHelper.getError(apiResponse).errors?.first.message;
      callback(false, '', errorMessage, null, null, null, socialLogin);
      notifyListeners();
    }
  }

  Future<void> socialLogout() async {
    final UserInfoModel? user =
        Provider.of<ProfileProvider>(Get.context!, listen: false).userInfoModel;
    if (user?.loginMedium?.toLowerCase() == 'google') {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      try {
        await googleSignIn.signOut();
        await googleSignIn.disconnect();
      } catch (e) {
        log("Error: $e");
      }
    }
  }

  void startVerifyTimer() {
    _timer?.cancel();
    currentTime = Provider.of<SplashProvider>(Get.context!, listen: false)
            .configModel!
            .otpResendTime ??
        0;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (currentTime! > 0) {
        currentTime = currentTime! - 1;
      } else {
        _timer?.cancel();
      }
      notifyListeners();
    });
  }

  Future<bool> addGuest() async {
    String? fcmToken = await authRepo?.getDeviceToken();
    ApiResponseModel apiResponse = await authRepo!.addGuest(fcmToken);

    final bool isSuccess = apiResponse.response != null &&
        apiResponse.response!.statusCode == 200 &&
        apiResponse.response?.data['guest']['id'] != null;

    if (isSuccess) {
      authRepo?.saveGuestId('${apiResponse.response?.data['guest']['id']}');
    }

    return isSuccess;
  }

  String? getGuestId() => isLoggedIn() ? null : authRepo?.getGuestId();

  Future<void> firebaseVerifyPhoneNumber(String phoneNumber,
      {bool isForgetPassword = false}) async {
    _isPhoneNumberVerificationButtonLoading = true;
    notifyListeners();

    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        _isPhoneNumberVerificationButtonLoading = false;
        notifyListeners();

        //Get.context!.pop();

        if (e.code == 'invalid-phone-number') {
          showCustomSnackBarHelper(getTranslated(
              'please_submit_a_valid_phone_number', Get.context!));
        } else {
          showCustomSnackBarHelper(getTranslated(
              '${e.message}'.replaceAll('_', ' ').toCapitalized(),
              Get.context!));
        }
      },
      codeSent: (String vId, int? resendToken) {
        _isPhoneNumberVerificationButtonLoading = false;
        notifyListeners();

        bool isReplaceRoute =
            GoRouter.of(Get.context!).routeInformationProvider.value.uri.path ==
                RouterHelper.verify;

        RouterHelper.getVerifyRoute(
          isForgetPassword ? FromPage.forget.name : FromPage.login.name,
          phoneNumber,
          session: vId,
          action:
              isReplaceRoute ? RouteAction.pushReplacement : RouteAction.push,
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _isPhoneNumberVerificationButtonLoading = false;
        notifyListeners();
        showCustomSnackBarHelper(
            getTranslated('please_try_again_later', Get.context!)!);
      },
    );
  }

  Future<void> firebaseOtpLogin(
      {required String phoneNumber,
      required String session,
      required String otp,
      bool isForgetPassword = false}) async {
    _isPhoneNumberVerificationButtonLoading = true;
    notifyListeners();
    ApiResponseModel apiResponse = await authRepo!.firebaseAuthVerify(
      session: session,
      phoneNumber: phoneNumber,
      otp: otp,
      isForgetPassword: isForgetPassword,
    );

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String? token;
      String? tempToken;

      try {
        token = map["token"];
        tempToken = map["temp_token"];
      } catch (error) {}

      if (isForgetPassword) {
        RouterHelper.getNewPassRoute(phoneNumber, otp);
      } else {
        if (token != null) {
          String? countryCode = NumberCheckerHelper.getCountryCode(phoneNumber);
          String? phone = NumberCheckerHelper.getPhoneNumber(
              phoneNumber, countryCode ?? '');
          await _updateAuthToken(token);
          final ProfileProvider profileProvider =
              Provider.of<ProfileProvider>(Get.context!, listen: false);
          profileProvider.getUserInfo(true);
          saveUserNumberAndPassword(UserLogData(
            countryCode: countryCode,
            phoneNumber: phone,
            email: null,
            password: null,
          ));
          RouterHelper.getMainRoute(action: RouteAction.pushReplacement);
        } else if (tempToken != null) {
          RouterHelper.getOtpRegistrationScreen(tempToken, phoneNumber,
              action: RouteAction.pushReplacement);
        }
      }
    } else {
      ApiCheckerHelper.checkApi(apiResponse, firebaseResponse: true);
    }

    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
  }

  Future<void> sendVerificationCode(ConfigModel config, SignUpModel signUpModel,
      {String? type, String? fromPage}) async {
    resendButtonLoading = true;
    notifyListeners();
    if (config.customerVerification!.status!) {
      if (type == 'email' && config.customerVerification?.email == 1) {
        checkEmail(signUpModel.email!, fromPage ?? '');
      } else if (type == 'phone' &&
          config.customerVerification?.firebase == 1) {
        firebaseVerifyPhoneNumber(signUpModel.phone!);
      } else if (type == 'phone' && config.customerVerification?.phone == 1) {
        checkPhone(signUpModel.phone!, fromPage ?? '');
      }
    }
    resendButtonLoading = false;
    notifyListeners();
  }

  Future<void> _updateAuthToken(String token) async {
    authRepo!.saveUserToken(token);
    await authRepo!.updateDeviceToken();
  }

  toggleIsNumberLogin({bool? value, bool isUpdate = true}) {
    if (value == null) {
      _isNumberLogin = !_isNumberLogin;
    } else {
      _isNumberLogin = value;
    }

    if (isUpdate) {
      notifyListeners();
    }
  }

  Future<ResponseModel> checkPhoneForOtp(String phone) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ApiResponseModel apiResponse = await authRepo!.checkPhone(phone);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      responseModel = ResponseModel(true, apiResponse.response!.data["token"]);
      bool isReplaceRoute =
          GoRouter.of(Get.context!).routeInformationProvider.value.uri.path ==
              RouterHelper.verify;

      RouterHelper.getVerifyRoute(
        FromPage.otp.name,
        phone,
        action: isReplaceRoute ? RouteAction.pushReplacement : RouteAction.push,
      );
    } else {
      _verificationMsg =
          ApiCheckerHelper.getError(apiResponse).errors![0].message;
      showCustomSnackBarHelper(_verificationMsg);
      responseModel = ResponseModel(false, _verificationMsg);
    }
    notifyListeners();
    return responseModel;
  }

  Future<(ResponseModel?, String?, UserInfoModel?)> verifyPhoneForOtp(
      String phone) async {
    _isPhoneNumberVerificationButtonLoading = true;
    String phoneNumber = phone;
    if (phone.contains('++')) {
      phoneNumber = phone.replaceAll('++', '+');
    }
    _verificationMsg = '';
    notifyListeners();
    ApiResponseModel apiResponse =
        await authRepo!.verifyOtp(phoneNumber, _verificationCode);
    notifyListeners();
    ResponseModel? responseModel;
    String? token;
    String? tempToken;
    UserInfoModel? userInfoModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;

      if (map.containsKey('temporary_token')) {
        tempToken = map["temporary_token"];
      } else if (map.containsKey('token')) {
        token = map["token"];
      } else if (map.containsKey('user')) {
        try {
          userInfoModel = UserInfoModel.fromJson(map['user']);
        } catch (e) {}
      }

      if (token != null) {
        await _updateAuthToken(token);
        final ProfileProvider profileProvider =
            Provider.of<ProfileProvider>(Get.context!, listen: false);
        profileProvider.getUserInfo(true);
        responseModel = ResponseModel(true, 'verification');
      } else if (tempToken != null) {
        responseModel = ResponseModel(true, 'verification');
      } else if (userInfoModel != null) {
        responseModel = ResponseModel(true, 'user');
      }
    } else {
      _verificationMsg =
          ApiCheckerHelper.getError(apiResponse).errors![0].message;
      showCustomSnackBarHelper(_verificationMsg);
      responseModel = ResponseModel(false, _verificationMsg);
    }
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    return (responseModel, tempToken, userInfoModel);
  }

  Future<ResponseModel> verifyProfileInfo(String userInput, String type) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ApiResponseModel apiResponse =
        await authRepo!.verifyProfileInfo(userInput, _verificationCode, type);
    ResponseModel? responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final ProfileProvider profileProvider =
          Provider.of<ProfileProvider>(Get.context!, listen: false);
      profileProvider.getUserInfo(true);
      showCustomSnackBarHelper(apiResponse.response!.data['message'],
          isError: false);
      responseModel = ResponseModel(true, 'verification');
    } else {
      _verificationMsg =
          ApiCheckerHelper.getError(apiResponse).errors![0].message;
      showCustomSnackBarHelper(_verificationMsg);
      responseModel = ResponseModel(false, _verificationMsg);
    }
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    return (responseModel);
  }

  Future<ResponseModel> registerWithOtp(String name,
      {String? email, required String phone}) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _loginErrorMessage = '';
    notifyListeners();
    ApiResponseModel apiResponse =
        await authRepo!.registerWithOtp(name, email: email, phone: phone);
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      String? token;
      Map map = apiResponse.response!.data;
      if (map.containsKey('token')) {
        token = map["token"];
      }
      if (token != null) {
        await _updateAuthToken(token);
        final ProfileProvider profileProvider =
            Provider.of<ProfileProvider>(Get.context!, listen: false);
        profileProvider.getUserInfo(true);
      }
      responseModel = ResponseModel(token != null, 'verification');
    } else {
      _loginErrorMessage =
          ApiCheckerHelper.getError(apiResponse).errors![0].message;
      showCustomSnackBarHelper(_loginErrorMessage);
      responseModel = ResponseModel(false, _loginErrorMessage);
    }
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<(ResponseModel, String?)> registerWithSocialMedia(String name,
      {required String email, String? phone}) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _loginErrorMessage = '';
    notifyListeners();
    ApiResponseModel apiResponse = await authRepo!
        .registerWithSocialMedia(name, email: email, phone: phone);
    ResponseModel responseModel;
    String? token;
    String? tempToken;

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      if (map.containsKey('token')) {
        token = map["token"];
      }
      if (map.containsKey('temp_token')) {
        tempToken = map["temp_token"];
      }

      if (token != null) {
        await _updateAuthToken(token);
        final ProfileProvider profileProvider =
            Provider.of<ProfileProvider>(Get.context!, listen: false);
        profileProvider.getUserInfo(true);
        responseModel = ResponseModel(true, 'verification');
      } else if (tempToken != null) {
        responseModel = ResponseModel(true, 'verification');
      } else {
        responseModel = ResponseModel(false, '');
      }
    } else {
      _loginErrorMessage =
          ApiCheckerHelper.getError(apiResponse).errors![0].message;
      showCustomSnackBarHelper(_loginErrorMessage);
      responseModel = ResponseModel(false, _loginErrorMessage);
    }
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    return (responseModel, tempToken);
  }

  Future<(ResponseModel?, String?)> existingAccountCheck(
      {String? email,
      required String phone,
      required int userResponse,
      required String medium}) async {
    _isPhoneNumberVerificationButtonLoading = true;
    notifyListeners();
    ApiResponseModel apiResponse = await authRepo!.existingAccountCheck(
        email: email, phone: phone, userResponse: userResponse, medium: medium);
    ResponseModel responseModel;
    String? token;
    String? tempToken;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;

      if (map.containsKey('token')) {
        token = map["token"];
      }

      if (map.containsKey('temp_token')) {
        tempToken = map["temp_token"];
      }

      if (token != null) {
        await _updateAuthToken(token);
        final ProfileProvider profileProvider =
            Provider.of<ProfileProvider>(Get.context!, listen: false);
        profileProvider.getUserInfo(true);
        responseModel = ResponseModel(true, 'token');
      } else if (tempToken != null) {
        responseModel = ResponseModel(true, 'tempToken');
      } else {
        responseModel = ResponseModel(true, '');
      }
    } else {
      _loginErrorMessage =
          ApiCheckerHelper.getError(apiResponse).errors![0].message;
      showCustomSnackBarHelper(_loginErrorMessage);
      responseModel = ResponseModel(false, _loginErrorMessage);
    }
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    return (responseModel, tempToken);
  }

  void togglePhoneNumberButton() {
    _isPhoneNumberVerificationButtonLoading =
        !_isPhoneNumberVerificationButtonLoading;
    notifyListeners();
  }
}
