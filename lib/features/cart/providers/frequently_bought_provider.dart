import 'package:flutter/foundation.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/common/models/product_model.dart';
import 'package:flutter_restaurant/common/reposotories/product_repo.dart';
import 'package:flutter_restaurant/helper/api_checker_helper.dart';

class FrequentlyBoughtProvider extends ChangeNotifier {
  final ProductRepo? productRepo;

  FrequentlyBoughtProvider({required this.productRepo});

  // Latest products
  ProductModel? _frequentlyBoughtProductModel;

  ProductModel? get frequentlyBoughtProductModel => _frequentlyBoughtProductModel;

  Future<void> getFrequentlyBoughtProduct(int offset, bool reload, { bool isUpdate = true}) async {


    if(reload) {
      _frequentlyBoughtProductModel = null;

      if(isUpdate) {
        notifyListeners();
      }
    }

    if(_frequentlyBoughtProductModel == null || offset != 1) {
      ApiResponseModel? response = await productRepo?.getFrequentlyBoughtProductApi(offset);
      if (response?.response?.data != null && response?.response?.statusCode == 200) {
        if(offset == 1){
          _frequentlyBoughtProductModel = ProductModel.fromJson(response?.response?.data);
        } else {
          _frequentlyBoughtProductModel?.totalSize = ProductModel.fromJson(response?.response?.data).totalSize;
          _frequentlyBoughtProductModel?.offset = ProductModel.fromJson(response?.response?.data).offset;
          _frequentlyBoughtProductModel?.products?.addAll(ProductModel.fromJson(response?.response?.data).products ?? []);
        }

        notifyListeners();

      } else {
        ApiCheckerHelper.checkApi(response!);

      }
    }


  }


}
