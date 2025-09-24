import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/common/models/product_model.dart';
import 'package:flutter_restaurant/features/wishlist/domain/reposotories/wishlist_repo.dart';
import 'package:flutter_restaurant/helper/api_checker_helper.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../../helper/custom_snackbar_helper.dart';

class WishListProvider extends ChangeNotifier {
  final WishListRepo? wishListRepo;
  WishListProvider({required this.wishListRepo});

  List<Product>? _wishList;
  List<int?> _wishIdList = [];

  List<Product>? get wishList => _wishList;
  List<int?> get wishIdList => _wishIdList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void addToWishList(Product product, BuildContext context, Function callBack) async {
    _wishList!.add(product);
    _wishIdList.add(product.id);
    notifyListeners();
    ApiResponseModel apiResponse = await wishListRepo!.addWishList(product.id);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      callBack();
      Map map = apiResponse.response!.data;
      String? message = map['message'];
      showCustomSnackBarHelper(message,isError: false);
    } else {
      _wishList!.remove(product);
      _wishIdList.remove(product.id);
      ApiCheckerHelper.checkApi(apiResponse);
    }
    notifyListeners();
  }


  void removeFromWishList(Product product, BuildContext context, Function callBack) async {
    _wishList!.removeAt(_wishIdList.indexOf(product.id));
    _wishIdList.remove(product.id);
    notifyListeners();
    ApiResponseModel apiResponse = await wishListRepo!.removeWishList(product.id);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      callBack();
      Map map = apiResponse.response!.data;
      String? message = map['message'];
      showCustomSnackBarHelper(message,isError: false);
    } else {
      _wishList!.add(product);
      _wishIdList.add(product.id);
      ApiCheckerHelper.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> initWishList() async {
    _wishList = [];
    _wishIdList = [];
    if(Provider.of<AuthProvider>(Get.context!, listen: false).isLoggedIn()){
      _isLoading = true;
      ApiResponseModel apiResponse = await wishListRepo!.getWishList();
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _wishList = [];
        _wishIdList = [];
        _wishList!.addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
        for(int i = 0; i< _wishList!.length; i++){
          _wishIdList.add(_wishList![i].id);
        }

      } else {
        ApiCheckerHelper.checkApi(apiResponse);
      }
      _isLoading = false;
      notifyListeners();
    }
  }
}
