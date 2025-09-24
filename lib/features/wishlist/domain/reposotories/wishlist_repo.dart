import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';

class WishListRepo {
  final DioClient? dioClient;

  WishListRepo({required this.dioClient});

  Future<ApiResponseModel> getWishList() async {
    try {
      final response = await dioClient!.get(AppConstants.wishListGetUri,
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponseModel> addWishList(int? productID) async {
    try {
      final response = await dioClient!.post(AppConstants.addWishListUri, data: {'product_id' : productID});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> removeWishList(int? productID) async {
    try {
      final response = await dioClient!.post(AppConstants.removeWishListUri, data: {'product_id' : productID, '_method':'delete', 'type': 'single'});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
