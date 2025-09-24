import 'package:flutter_restaurant/common/models/cart_model.dart';
import 'package:flutter_restaurant/common/models/product_model.dart';
import 'package:flutter_restaurant/features/home/widgets/cart_bottom_sheet_widget.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/date_converter_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';

class ProductHelper{
  static bool isProductAvailable({required Product product})=>
      product.availableTimeStarts != null && product.availableTimeEnds != null
          ? DateConverterHelper.isAvailable(product.availableTimeStarts!, product.availableTimeEnds!) : false;

   static void addToCart({required int cartIndex, required Product product}) {
     ResponsiveHelper.showDialogOrBottomSheet(Get.context!, CartBottomSheetWidget(
       product: product,
       fromSetMenu: true,
       callback: (CartModel cartModel) {
         showCustomSnackBarHelper(getTranslated('added_to_cart', Get.context!), isError: false);
       },
     ));
  }

  static ({List<Variation>? variatins, double? price}) getBranchProductVariationWithPrice(Product? product){

    List<Variation>? variationList;
    double? price;

    if(product?.branchProduct != null && (product?.branchProduct?.isAvailable ?? false)) {
      variationList = product?.branchProduct?.variations;
      price = product?.branchProduct?.price;

    }else{
      variationList = product?.variations;
      price = product?.price;
    }

    return (variatins: variationList, price: price);
  }


}