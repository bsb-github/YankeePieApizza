import 'package:flutter_restaurant/common/models/product_model.dart';

class ReorderProductModel {
  int? requestedProductCount;
  int? responseProductCount;
  int? orderBranch;
  int? currentBranch;
  List<Product>? products;

  ReorderProductModel({int? totalSize, int? limit, int? offset, List<Product>? products}) {
    totalSize = totalSize;
    limit = limit;
    offset = offset;
    products = products;
  }

  ReorderProductModel.fromJson(Map<String, dynamic> json) {
    requestedProductCount = int.tryParse('${json['requested_product_count']}');
    responseProductCount = int.tryParse('${json['response_product_count']}');
    orderBranch = int.tryParse('${json['order_branch']}');
    currentBranch = int.tryParse('${json['current_branch']}');
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products!.add(Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requested_product_count'] = requestedProductCount;
    data['response_product_count'] = responseProductCount;
    data['order_branch'] = orderBranch;
    data['current_branch'] = currentBranch;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

