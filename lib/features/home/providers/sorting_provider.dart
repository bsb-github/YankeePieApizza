import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/enums/product_sort_type_enum.dart';
import 'package:flutter_restaurant/features/home/enums/view_change_to_enum.dart';

class ProductSortProvider extends ChangeNotifier{
  ViewChangeTo _viewChangeTo = ViewChangeTo.gridView;
  ViewChangeTo get viewChangeTo => _viewChangeTo;

  bool _isSortingButtonClicked = false;
  bool get isSortingButtonClicked => _isSortingButtonClicked;

  ProductSortType _selectedShotType = ProductSortType.defaultType;
  ProductSortType get selectedShotType => _selectedShotType;

  void updateViewChange(ViewChangeTo view){
    _viewChangeTo = view;
    notifyListeners();
  }

  void toggleSortingButtonClicked (bool value, {bool isUpdate = true, bool isReload = false}){
    if(isReload){
      _isSortingButtonClicked = false;
    }else{
      _isSortingButtonClicked = value;
    }


    if(isUpdate){
      notifyListeners();
    }

  }


  void onChangeProductShortType(ProductSortType type){
    _selectedShotType = type;
    notifyListeners();
  }

}