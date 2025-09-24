import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:provider/provider.dart';

class PriceConverterHelper {
  static String convertPrice(double? price, {double? discount, String? discountType}) {
    final configModel = Provider.of<SplashProvider>(Get.context!, listen: false).configModel!;
    if(discount != null && discountType != null){
      if(discountType == 'amount') {
        price = price! - discount;
      }else if(discountType == 'percent') {
        price = price! - ((discount / 100) * price);
      }
    }
    return configModel.currencySymbolPosition == 'left'
        ? '${configModel.currencySymbol}' '${price?.toStringAsFixed(configModel.decimalPointSettings!).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},',
    )}'
        : '${price!.toStringAsFixed(configModel.decimalPointSettings!).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},',
    )}' ' ${configModel.currencySymbol}';
  }

  static double? convertWithDiscount(double? price, double? discount, String? discountType) {
    if(discountType == 'amount') {
      price = price! - discount!;
    }else if(discountType == 'percent' && (discount ?? 0) > 0) {
      price = price! - ((discount! / 100) * price);
    }
    return price;
  }

  static double addonTaxCalculation({double? taxPercentage,  double? addonItemPrice, int? quantity, String? discountType}){
    double taxAmount = 0;
    if(discountType == 'percent' && taxPercentage != null && addonItemPrice != null){
      taxAmount = (addonItemPrice * (quantity ?? 1)) * ((taxPercentage / 100));
    }else if (discountType == 'amount'){
      taxAmount = (quantity ?? 1) * (taxPercentage ?? 1);
    }
    return taxAmount;
  }



  static double? convertDiscount(BuildContext context, double? price, double? discount, String? discountType) {
    if(discountType == 'amount') {
      price =  discount;
    }else if(discountType == 'percent') {
      price = (discount! / 100) * price!;
    }
    return price;
  }

  static double calculation(double amount, double discount, String type, int quantity) {
    double calculatedAmount = 0;
    if(type == 'amount') {
      calculatedAmount = discount * quantity;
    }else if(type == 'percent') {
      calculatedAmount = (discount / 100) * (amount * quantity);
    }
    return calculatedAmount;
  }

  static String getDiscountType({required double? discount, required String? discountType}) {
   return '${discountType == 'percent' ? '${discount?.toInt()} %' : PriceConverterHelper.convertPrice(discount)} ${getTranslated('off', Get.context!)}';
  }


  static String longToShortPrice(double amount){
    int decimalPoint = 2 ;

    if (amount.abs() >= 1e12) {
      return '${(amount / 1e12).toStringAsFixed(decimalPoint)}T';
    } else if (amount.abs() >= 1e9) {
      return '${(amount / 1e9).toStringAsFixed(decimalPoint)}B';
    } else if (amount.abs() >= 1e6) {
      return '${(amount / 1e6).toStringAsFixed(decimalPoint)}M';
    } else {
      return amount.toStringAsFixed(decimalPoint);
    }
  }

}