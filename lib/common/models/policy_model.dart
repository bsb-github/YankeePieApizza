// To parse this JSON data, do
//
//     final policyModel = policyModelFromJson(jsonString);

import 'dart:convert';

PolicyModel policyModelFromJson(String str) => PolicyModel.fromJson(json.decode(str));

String policyModelToJson(PolicyModel data) => json.encode(data.toJson());

class PolicyModel {
  PolicyModel({
    this.returnPage,
    this.refundPage,
    this.cancellationPage,
    this.termsAndCondition,
    this.privacyPolicy,
    this.aboutUs,
  });

  Pages? returnPage;
  Pages? refundPage;
  Pages? cancellationPage;
  String? termsAndCondition;
  String? privacyPolicy;
  String? aboutUs;

  factory PolicyModel.fromJson(Map<String, dynamic> json) => PolicyModel(
    returnPage: Pages.fromJson(
      json: json["return_page"],
    ),

    refundPage: Pages.fromJson(
      json: json["refund_page"],
    ),

    cancellationPage: Pages.fromJson(
      json:  json["cancellation_page"],
    ),
    termsAndCondition: json["terms_and_conditions"],
    privacyPolicy: json["privacy_policy"],
    aboutUs: json["about_us"],
  );

  Map<String, dynamic> toJson() => {
    "return_page": returnPage?.toJson(),
    "refund_page": refundPage?.toJson(),
    "cancellation_page": cancellationPage?.toJson(),
    "terms_and_conditions": termsAndCondition,
    "privacy_policy": privacyPolicy,
    "about_us": aboutUs,
  };
}

class Pages {
  Pages({
    this.status,
    this.content,
  });

  bool? status;
  String? content;

  factory Pages.fromJson({
    required Map<String, dynamic> json,

  }) {
    Pages? pages;
    try{
      pages = Pages(
        status: int.tryParse(json["status"].toString()) == 1 ? true : false,
        content: json["content"],

      );

    }catch(e) {
      pages = null;
    }
    return pages!;



  }
  Map<String, dynamic> toJson() => {
    "status": status,
    "content": content,
  };
}
