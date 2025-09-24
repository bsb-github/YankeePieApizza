import 'package:flutter_restaurant/common/enums/data_source_enum.dart';
import 'package:flutter_restaurant/common/reposotories/data_sync_repo.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';

class CategoryRepo extends DataSyncRepo{
  CategoryRepo({required super.dioClient, required super.sharedPreferences});

  Future<ApiResponseModel<T>> getCategoryList<T>({required DataSourceEnum source, String query = "", int offset = 1, int limit = 24}) async {
    return await fetchData<T>("${AppConstants.categoryUri}?limit=$limit&offset=$offset&name=$query", source);
  }

  Future<ApiResponseModel> getSubCategoryList(String parentID) async {
    try {
      final response = await dioClient.get('${AppConstants.subCategoryUri}$parentID',
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getCategoryProductList({required String? categoryID, required int offset, int limit = 10, required String type, String? name}) async {

    try {
      final response = await dioClient.get('${AppConstants.categoryProductUri}$categoryID?offset=$offset&limit=$limit&product_type=$type${name != null ? '&search=$name' : ''}');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}