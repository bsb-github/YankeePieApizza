// To parse this JSON data, do
//
//     final searchRecommendModel = searchRecommendModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_restaurant/features/category/domain/category_model.dart';

SearchRecommendModel searchRecommendModelFromJson(String str) => SearchRecommendModel.fromJson(json.decode(str));

String searchRecommendModelToJson(SearchRecommendModel data) => json.encode(data.toJson());

class SearchRecommendModel {
  List<CategoryModel> categories;
  List<String> cuisines;

  SearchRecommendModel({
    required this.categories,
    required this.cuisines,
  });

  factory SearchRecommendModel.fromJson(Map<String, dynamic> json) => SearchRecommendModel(
    categories: List<CategoryModel>.from(json["categories"].map((x) => CategoryModel.fromJson(x))),
    cuisines: List<String>.from(json["cuisines"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
    "cuisines": List<dynamic>.from(cuisines.map((x) => x)),
  };
}

