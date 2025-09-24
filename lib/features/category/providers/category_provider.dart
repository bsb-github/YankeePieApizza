import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/enums/data_source_enum.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/common/models/product_model.dart';
import 'package:flutter_restaurant/common/providers/data_sync_provider.dart';
import 'package:flutter_restaurant/data/datasource/local/cache_response.dart';
import 'package:flutter_restaurant/features/category/domain/category_model.dart';
import 'package:flutter_restaurant/features/category/domain/reposotories/category_repo.dart';
import 'package:flutter_restaurant/helper/api_checker_helper.dart';

class CategoryProvider extends DataSyncProvider {
  final CategoryRepo? categoryRepo;

  CategoryProvider({required this.categoryRepo});

  CategoryData? _categoryModel;
  CategoryData? _searchCategoryModel;

  List<CategoryModel>? _categoryList;
  List<CategoryModel>? _searchCategoryList;
  List<CategoryModel>? _suggestionList;

  List<CategoryModel>? _subCategoryList;
  ProductModel? _categoryProductModel;
  bool _pageFirstIndex = true;
  bool _pageLastIndex = false;
  bool _isLoading = false;
  String? _selectedSubCategoryId;
  final TextEditingController _searchController = TextEditingController();
  int _searchLength = 0;
  bool _isSearch = true;

  List<CategoryModel>? get categoryList => _categoryList;
  List<CategoryModel>? get suggestionList => _suggestionList;
  List<CategoryModel>? get searchCategoryList => _searchCategoryList;

  List<CategoryModel>? get subCategoryList => _subCategoryList;
  ProductModel? get categoryProductModel => _categoryProductModel;

  CategoryData? get  categoryModel => _categoryModel;
  CategoryData? get  searchCategoryModel => _searchCategoryModel;



  bool get pageFirstIndex => _pageFirstIndex;
  bool get pageLastIndex => _pageLastIndex;
  bool get isLoading => _isLoading;
  String? get selectedSubCategoryId => _selectedSubCategoryId;
  TextEditingController  get searchController=> _searchController;
  int get searchLength => _searchLength;
  bool get isSearch => _isSearch;



  Future<void> getCategoryList(bool reload, {DataSourceEnum source = DataSourceEnum.local, int limit = 24, int offset  =1 }) async {
    if(_categoryList == null || reload || offset !=1) {
      _isLoading = true;

      if(offset == 1){
        fetchAndSyncData(
          fetchFromLocal: ()=> categoryRepo!.getCategoryList<CacheResponseData>(source: DataSourceEnum.local),
          fetchFromClient: ()=> categoryRepo!.getCategoryList(source: DataSourceEnum.client, limit: limit, offset: offset),
          onResponse: (data, _) {
            _categoryList = [];
            try{
              _categoryModel =  CategoryData.fromJson(data);
              _categoryList!.addAll(_categoryModel?.categories ??[]);

              if(_categoryList!.isNotEmpty){
                _selectedSubCategoryId = '${_categoryList?.first.id}';
              }
            }catch(_){
              _categoryList = [];

            }
            _isLoading = false;

            notifyListeners();
          },
        );

      }else{

        if(_categoryModel== null || offset != 1) {
          ApiResponseModel? response = await categoryRepo!.getCategoryList(source: DataSourceEnum.client, limit: limit, offset: offset);
          if (response.response?.data != null && response.response?.statusCode == 200) {

            if(offset == 1){

              _categoryList = [];
              _categoryModel =  CategoryData.fromJson(response.response?.data);
              _categoryList!.addAll(_categoryModel?.categories ??[]);

            } else {
              _categoryModel =  CategoryData.fromJson(response.response?.data);
              _categoryList?.addAll( CategoryData.fromJson(response.response?.data).categories ?? []);
            }
            _isLoading = false;
            notifyListeners();

          } else {
            ApiCheckerHelper.checkApi(response);

          }
        }
      }
    }
  }


  Future<void> getSearchCategoryList({int limit = 24, int offset  =1 , String? query }) async {

    _isLoading = true;
    notifyListeners();

    ApiResponseModel? response = await categoryRepo!.getCategoryList(source: DataSourceEnum.client, limit: limit, offset: offset, query: query ?? "");
    if (response.response?.data != null && response.response?.statusCode == 200) {

      if(offset == 1){

        _searchCategoryList = [];
        _searchCategoryModel =  CategoryData.fromJson(response.response?.data);
        _searchCategoryList!.addAll(_searchCategoryModel?.categories ??[]);

      } else {
        _searchCategoryModel =  CategoryData.fromJson(response.response?.data);
        _searchCategoryList?.addAll( CategoryData.fromJson(response.response?.data).categories ?? []);
      }

    } else {
      ApiCheckerHelper.checkApi(response);

    }

    _isLoading = false;
    notifyListeners();

  }

  Future<void> getSuggestionCategoryList() async {

    ApiResponseModel? response = await categoryRepo!.getCategoryList(source: DataSourceEnum.client, limit: 5, offset: 1, query: _searchController.text);

    if(response.response?.data != null && response.response?.statusCode == 200){
      if( response.response?.data['categories'].isNotEmpty){
        _suggestionList = [];
        response.response?.data['categories'].forEach((category) => _suggestionList!.add(CategoryModel.fromJson(category)));
      }
      notifyListeners();
    }

  }





  void getSubCategoryList(String categoryID, {String type = 'all', String? name}) async {
    _subCategoryList = null;
    _isLoading = true;
    ApiResponseModel apiResponse = await categoryRepo!.getSubCategoryList(categoryID);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _subCategoryList= [];
      apiResponse.response!.data.forEach((category) => _subCategoryList!.add(CategoryModel.fromJson(category)));
      getCategoryProductList(categoryID, 1, type: type);
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future getCategoryProductList(String? categoryID, int offset, {String type = 'all', String? name}) async {

    if(_selectedSubCategoryId != categoryID || offset == 1) {
      _categoryProductModel = null;
    }
    _selectedSubCategoryId = categoryID;
    notifyListeners();

    if(_categoryProductModel == null || offset != 1) {
      ApiResponseModel apiResponse = await categoryRepo!.getCategoryProductList(categoryID: categoryID, offset: offset, type: type, name: name);

      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        if(offset == 1) {
          _categoryProductModel = ProductModel.fromJson(apiResponse.response?.data);
        }else {
          _categoryProductModel?.totalSize = ProductModel.fromJson(apiResponse.response?.data).totalSize;
          _categoryProductModel?.offset = ProductModel.fromJson(apiResponse.response?.data).offset;
          _categoryProductModel?.products?.addAll(ProductModel.fromJson(apiResponse.response?.data).products ?? []);
        }
      }else {
        ApiCheckerHelper.checkApi(apiResponse);
      }
    }

    notifyListeners();
  }

  int _selectCategory = -1;
  final List<int> _selectedCategoryList = [];

  int get selectCategory => _selectCategory;
  List<int> get selectedCategoryList => _selectedCategoryList;

  void updateSelectCategory({required int id}) {
    _selectCategory = id;
    if (_selectedCategoryList.contains(id)) {
      _selectedCategoryList.remove(id);
    } else {
      _selectedCategoryList.add(id);
    }

    debugPrint(selectedCategoryList.toString());
    notifyListeners();
  }

  void clearSelectedCategory()=> _selectedCategoryList.clear();

  updateProductCurrentIndex(int index, int totalLength) {
    if(index > 0) {
      _pageFirstIndex = false;
      notifyListeners();
    }else{
      _pageFirstIndex = true;
      notifyListeners();
    }
    if(index + 1  == totalLength) {
      _pageLastIndex = true;
      notifyListeners();
    }else {
      _pageLastIndex = false;
      notifyListeners();
    }
  }

  getSearchText(String searchText, {bool isUpdate = true}){
    _searchLength = searchText.length;

    if(_searchLength < 1){
      _searchCategoryModel = null;
      _searchCategoryList = null;
    }
    if(isUpdate){
      notifyListeners();
    }
  }

  searchDone(){
    _isSearch = !_isSearch;
    notifyListeners();
  }
}


