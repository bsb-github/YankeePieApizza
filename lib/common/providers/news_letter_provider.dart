import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/common/reposotories/news_letter_repo.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';

class NewsLetterProvider extends ChangeNotifier {
  final NewsLetterRepo? newsLetterRepo;
  NewsLetterProvider({required this.newsLetterRepo});


  Future<void> addToNewsLetter(String email) async {
    ApiResponseModel apiResponse = await newsLetterRepo!.addToNewsLetter(email);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      showCustomSnackBarHelper(getTranslated('successfully_subscribe', Get.context!),isError: false);
      notifyListeners();
    } else {
      showCustomSnackBarHelper(getTranslated('mail_already_exist', Get.context!));
    }
  }
}
