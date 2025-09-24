import 'package:dio/dio.dart';
import 'package:flutter_restaurant/common/enums/data_source_enum.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/common/models/product_model.dart';
import 'package:flutter_restaurant/common/providers/data_sync_provider.dart';
import 'package:flutter_restaurant/data/datasource/local/cache_response.dart';
import 'package:flutter_restaurant/features/home/domain/models/banner_model.dart';
import 'package:flutter_restaurant/features/home/domain/reposotories/banner_repo.dart';

class BannerProvider extends DataSyncProvider {
  final BannerRepo? bannerRepo;
  BannerProvider({required this.bannerRepo});

  List<BannerModel>? _bannerList;
  final List<Product> _productList = [];

  List<BannerModel>? get bannerList => _bannerList;
  List<Product> get productList => _productList;


  Future<void> getBannerList(bool reload, {DataSourceEnum dataSource = DataSourceEnum.local}) async {
    if (_bannerList == null || reload) {
       fetchAndSyncData(
        fetchFromLocal: () => bannerRepo!.getBannerList<CacheResponseData>(source: DataSourceEnum.local),
        fetchFromClient: () => bannerRepo!.getBannerList<Response>(source: DataSourceEnum.client),
        onResponse: (response, _) {
          _bannerList = [];

          response?.forEach((category) {
            BannerModel bannerModel = BannerModel.fromJson(category);

            if(bannerModel.product != null) {
              _productList.add(bannerModel.product!);
            }
            _bannerList!.add(bannerModel);
          });

          notifyListeners();
        },
      );
    }
  }


  Future<Product?> getProductDetails(String productID) async {
    Product? product;
    ApiResponseModel apiResponse = await bannerRepo!.getProductDetails(productID);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      product = Product.fromJson(apiResponse.response!.data);
      _productList.add(product);
    }
    return product;
  }
}