import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/features/onboarding/domain/models/onboarding_model.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/images.dart';

class OnBoardingRepo {
  final DioClient? dioClient;

  OnBoardingRepo({required this.dioClient});

  Future<ApiResponseModel> getOnBoardingList(BuildContext context) async {
    try {
      List<OnBoardingModel> onBoardingList = [
        OnBoardingModel(Images.onBoardingOne, getTranslated('find_your_desire_food', context), getTranslated('sign_up_or_sign_in_to_your_account_to_browse_choose_order_food', context)),
        OnBoardingModel(Images.onBoardingTwo, getTranslated('choose_your_delivery_type', context), getTranslated('order_food_for_home_delivery_or_takeaway_with_complete_order_tracking', context)),
        OnBoardingModel(Images.onBoardingThree, getTranslated('easy_checkout_fast_delivery', context), getTranslated('quick_checkout_receive_your_food_delivery_before_it_gets_cold_enjoy', context)),
      ];

      Response response = Response(requestOptions: RequestOptions(path: ''), data: onBoardingList, statusCode: 200);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
