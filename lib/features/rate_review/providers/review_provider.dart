
import 'dart:io';

import 'package:flutter_restaurant/common/models/order_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/reposotories/product_repo.dart';
import 'package:flutter_restaurant/features/rate_review/enum/rate_enum.dart';
import 'package:flutter_restaurant/features/refer_and_earn/domain/models/review_body_model.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/features/order/domain/models/order_model.dart';
import 'package:flutter_restaurant/common/models/response_model.dart';
import 'package:flutter_restaurant/helper/api_checker_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/features/order/providers/order_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class ReviewProvider extends ChangeNotifier {
  final ProductRepo? productRepo;

  ReviewProvider({required this.productRepo});


  bool _isReviewSubmitted = false;
  final bool _isDeliveryManReviewSubmitted = false;
  List<int> _ratingList = [];
  List<String> _reviewList = [];
  List<bool> _loadingList = [];
  List<ProductWiseReview> _productWiseReview = [];
  List<bool> _submitList = [];
  bool _isLoading = false;
  final List<Rate> _rateList = [Rate.bad, Rate.okay, Rate.average, Rate.good, Rate.excellent];
  // Rate? _rateStatus;
  int _rateIndex = -1;
  List<XFile>? _imageFiles;

  File? file;
  XFile? data;



  bool get isReviewSubmitted => _isReviewSubmitted;
  bool get isDeliveryManReviewSubmitted => _isDeliveryManReviewSubmitted;
  List<int> get ratingList => _ratingList;



  List<String> get reviewList => _reviewList;
  List<bool> get loadingList => _loadingList;
  List<bool> get submitList => _submitList;
  bool get isLoading => _isLoading;
  List<ProductWiseReview> get productWiseReview => _productWiseReview;
  List<Rate> get rateList => _rateList;
  // Rate? get rateStatus => _rateStatus;
  int get rateIndex => _rateIndex;
  List<XFile>? get imageFiles => _imageFiles;




  void initRatingData(List<OrderDetailsModel> orderDetailsList) {
    _ratingList = [];
    _reviewList = [];
    _loadingList = [];
    _submitList = [];
    _imageFiles = [];
    _productWiseReview = [];
    for (int i = 0; i < orderDetailsList.length; i++) {
      _ratingList.add(0);
      _reviewList.add('');
      _loadingList.add(false);
      _submitList.add(false);
    }
  }

  void setRatingIndex(int index, {bool isUpdate = true}) {
    _rateIndex = index;

    if(isUpdate) {
      notifyListeners();
    }
  }

  void setRating(int index, int rate) {
    _ratingList[index] = rate;
    notifyListeners();
  }








  void setReview(int index, String review) {
    _reviewList[index] = review;
  }


  Future<ResponseModel> submitReview(int index, ReviewBody reviewBody) async {
    _loadingList[index] = true;
    notifyListeners();

    ApiResponseModel response = await productRepo!.submitReview(reviewBody, _imageFiles);
    ResponseModel responseModel;
    if (response.response != null && response.response!.statusCode == 200) {
      _submitList[index] = true;
      responseModel = ResponseModel(true, 'Review submitted successfully');
      notifyListeners();
    } else {
      responseModel = ResponseModel(false, ApiCheckerHelper.getError(response).errors?.first.message);
    }
    _loadingList[index] = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> submitDeliveryManReview(ReviewBody reviewBody) async {
    _isLoading = true;
    notifyListeners();
    ApiResponseModel response = await productRepo!.submitDeliveryManReview(reviewBody);
    ResponseModel responseModel;
    if (response.response != null && response.response!.statusCode == 200) {
      responseModel = ResponseModel(true, getTranslated('review_submitted_successfully', Get.context!));
      updateSubmitted(true);

      notifyListeners();
    } else {
      responseModel = ResponseModel(false, ApiCheckerHelper.getError(response).errors?.first.message);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  updateSubmitted(bool value) {
    _isReviewSubmitted = value;
  }

  Future<DeliveryMan?> getDeliveryMan(String? orderId, {String? phoneNumber}) async {
    final OrderProvider orderProvider = Provider.of<OrderProvider>(Get.context!, listen: false);
    DeliveryMan? deliveryMan;

    await orderProvider.trackOrder(orderId.toString(), phoneNumber: phoneNumber).then((value) {
      deliveryMan = orderProvider.trackModel?.deliveryMan;
    });

    return deliveryMan;
  }

  Future<List<OrderDetailsModel>> getOrderList(String? orderId, {String? phoneNumber}) async {
    final OrderProvider orderProvider = Provider.of<OrderProvider>(Get.context!, listen: false);
    await orderProvider.getOrderDetails(orderId.toString(), phoneNumber: phoneNumber);

    List<OrderDetailsModel> orderDetailsList = [];
    List<int?> orderIdList = [];

    for (var orderDetails in orderProvider.orderDetails!) {
      if(!orderIdList.contains(orderDetails.productDetails!.id)) {
        orderDetailsList.add(orderDetails);
        orderIdList.add(orderDetails.productDetails!.id);
      }
    }
    return orderDetailsList;
  }

  /*void _choose() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50, maxHeight: 500, maxWidth: 500);
    if (pickedFile != null) {
      file = File(pickedFile.path);
    }
  }

  void _pickImage() async {
    data = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 60);
  }*/

  void setProductWiseRating (int productId, int rating, {bool isFromInit = false, List<OrderDetailsModel>? orderDetailsList}){
    if(isFromInit && (orderDetailsList != null && orderDetailsList.isNotEmpty)){
      for(OrderDetailsModel order in orderDetailsList){
        _productWiseReview.add(ProductWiseReview(order.productId!, -1, []));
      }
    }else{
      for(ProductWiseReview productWiseReview in _productWiseReview){
        if(productWiseReview.productId == orderDetailsList?[productId].productId){
          if(productWiseReview.rating == rating){
            productWiseReview.rating = -1;
          }else{
            productWiseReview.rating = rating;
          }
        }
      }
      notifyListeners();
    }
  }






  void pickImage(bool isRemove, int productId) async {
    if(isRemove) {
      _imageFiles = [];
    }else {
      try{
        final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 30);
        if(pickedImage != null){
          for(ProductWiseReview productWiseReview in _productWiseReview){
            if(productWiseReview.productId == productId){
              if(!productWiseReview.image!.contains(pickedImage)){
                productWiseReview.image!.add(pickedImage);
              }
            }
          }
          _imageFiles?.add(pickedImage);
        }
      }catch(error) {
        debugPrint('$error');
      }
    }
    notifyListeners();
  }


  void removeImage(int index , int productId){
    for(ProductWiseReview productWiseReview in _productWiseReview){
      if(productWiseReview.productId == productId){
          productWiseReview.image!.removeAt(index);
      }
    }
    _imageFiles!.removeAt(index);
    notifyListeners();
  }


}


class ProductWiseReview {
  int productId;
  int rating;
  List<XFile>? image;

  ProductWiseReview(this.productId, this.rating, this.image);

  @override
  String toString() {
    String imageString = (image == null || image!.isEmpty)
        ? 'No images'
        : image!.map((file) => file.path).join(', ');

    return 'ProductWiseReview(productId: $productId, rating: $rating, image: $imageString)';
  }
}