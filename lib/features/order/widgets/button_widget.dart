import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/cart_model.dart';
import 'package:flutter_restaurant/common/models/order_details_model.dart';
import 'package:flutter_restaurant/common/models/product_model.dart';
import 'package:flutter_restaurant/common/providers/product_provider.dart';
import 'package:flutter_restaurant/common/providers/theme_provider.dart';
import 'package:flutter_restaurant/common/widgets/custom_alert_dialog_widget.dart';
import 'package:flutter_restaurant/features/cart/providers/cart_provider.dart';
import 'package:flutter_restaurant/features/order/domain/models/reorder_product_model.dart';
import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/helper/product_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/order/providers/order_provider.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/features/order/widgets/order_cancel_dialog_widget.dart';
import 'package:provider/provider.dart';


class ButtonWidget extends StatelessWidget {
  final String? phoneNumber;
  const ButtonWidget({super.key, this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    final isPhoneNotAvailable = (phoneNumber == null || (phoneNumber != null && phoneNumber!.isEmpty));
    final double width = MediaQuery.of(context).size.width;

    return Consumer<OrderProvider>(builder: (context, orderProvider, _) {
      final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);

        return Column(children: [
          !orderProvider.showCancelled ? Center(
            child: Container(
              color: Theme.of(context).cardColor,
              width: width > 700 ? 700 : width,
              child: Row(children: [
                orderProvider.trackModel?.orderStatus == 'pending' ? Expanded(child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(1, 50),
                      backgroundColor: Theme.of(context).hintColor.withValues(alpha:0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        //side: BorderSide(width: 2, color: Theme.of(context).disabledColor),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context, barrierDismissible: false,
                        builder: (context) => OrderCancelDialogWidget(
                          orderID: orderProvider.trackModel!.id.toString(),
                          callback: (String message, bool isSuccess, String orderID) {
                            if (isSuccess) {
                              showCustomSnackBarHelper('$message. ${getTranslated('order_id', context)}: $orderID', isError: false);
                            } else {
                              showCustomSnackBarHelper(message, isError: true);
                            }
                          },
                        ),
                      );
                    },

                    child: Text(
                      getTranslated('cancel_order', context)!,
                      style: rubikBold.copyWith(
                        color: themeProvider.darkTheme ? Colors.white : ColorResources.homePageSectionTitleColor,
                        fontSize: Dimensions.fontSizeLarge,
                      ),
                    ),
                  ),
                )) : const SizedBox(),


              ]),
            ),
          ) : Center(
            child: Container(
              width: width > 700 ? 700 : width,
              height: 50,
              margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                getTranslated('order_cancelled', context)!,
                style: rubikBold.copyWith(color: Theme.of(context).primaryColor),
              ),
            ),
          ),

          (orderProvider.trackModel?.orderStatus == 'confirmed'
              || orderProvider.trackModel?.orderStatus == 'processing'
              || orderProvider.trackModel?.orderStatus == 'out_for_delivery')
              && orderProvider.trackModel?.orderType != 'dine_in'
              ?
          Center(
            child: Container(
              width: width > 700 ? 700 : width,
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: CustomButtonWidget(
                btnTxt: getTranslated('track_order', context),
                onTap: () =>  RouterHelper.getOrderTrackingRoute(
                  orderProvider.trackModel!.id,
                  phoneNumber: phoneNumber,
                ),
              ),
            ),
          ) : const SizedBox(),

          orderProvider.trackModel?.orderStatus == 'delivered' && !(orderProvider.trackModel?.isGuest ?? false) &&  orderProvider.trackModel?.orderType != 'pos' && isPhoneNotAvailable ? Center(
            child: Container(
              width: width > 700 ? 700 : width,
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: CustomButtonWidget(
                btnTxt: getTranslated('review', context),
                onTap: () => RouterHelper.getRateReviewRoute(orderId: orderProvider.trackModel?.id),
              ),
            ),
          ) : const SizedBox(),


          if(!(orderProvider.trackModel?.isGuest ?? false)
              && orderProvider.trackModel?.orderType != 'pos'
              && (orderProvider.trackModel?.orderStatus == 'delivered'
                  || orderProvider.trackModel?.orderStatus == 'returned'
                  || orderProvider.trackModel?.orderStatus == 'failed'
                  || orderProvider.trackModel?.orderStatus == 'canceled'))
            Container(
            width: width > 700 ? 700 : width,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, _) {
                return CustomButtonWidget(
                  isLoading: productProvider.isLoading,
                  btnTxt: getTranslated('reorder', context),
                  onTap: ()=> _reorderProduct(orderProvider.trackModel?.id, orderProvider.orderDetails),
                );
              }
            ),
          ),

          if( orderProvider.trackModel?.deliveryMan != null && (orderProvider.trackModel?.orderStatus != 'delivered') && ( phoneNumber == null ))
            Center(
              child: Container(
                width: width > 700 ? 700 : width,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: CustomButtonWidget(btnTxt: getTranslated('chat_with_delivery_man', context), onTap: (){
                   RouterHelper.getChatRoute(
                     orderId: orderProvider.trackModel?.id,
                     deliveryMan: orderProvider.trackModel?.deliveryMan,
                   );
                }),
              ),
            ),
        ],);
      }
    );
  }

  Future<void> _reorderProduct(int? orderId, List<OrderDetailsModel>? orderDetails) async {
    final ProductProvider productProvider = Provider.of<ProductProvider>(Get.context!, listen: false);
    List<CartModel> cartList = [];
    bool isProductChanged = false;

    ReorderProductModel? reorderProductModel = await productProvider.getReorderProductList(orderId);

    ({List<CartModel> cartList, bool? isProductChanged}) reorderCartData = _getReorderCartData(orderDetails, reorderProductModel);
    cartList = reorderCartData.cartList;
    isProductChanged = reorderCartData.isProductChanged ?? false;

    if(cartList.isEmpty) {
      ResponsiveHelper.showDialogOrBottomSheet(Get.context!, CustomAlertDialogWidget(
        icon: Icons.warning_rounded,
        subTitle: getTranslated('no_more_product_available_on_this_order', Get.context!),
        title: getTranslated('warning', Get.context!),
        isSingleButton: true,
        rightButtonText: getTranslated('ok', Get.context!),
      ));
    }else {
      if(isProductChanged) {
        ResponsiveHelper.showDialogOrBottomSheet(Get.context!, CustomAlertDialogWidget(
          icon: Icons.warning_rounded,
          subTitle: getTranslated('something_is_missing_in_this_branch', Get.context!),
          title: getTranslated('warning', Get.context!),
          onPressRight: (){
            _addToCart(cartList);
            RouterHelper.getDashboardRoute('cart');
          },
          rightButtonText: getTranslated('ok_continue', Get.context!),


        ));
      }else {
        _addToCart(cartList);
        RouterHelper.getDashboardRoute('cart');
      }
    }


  }


  ({List<CartModel> cartList, bool? isProductChanged}) _getReorderCartData(List<OrderDetailsModel>? orderDetails, ReorderProductModel? reorderProductModel) {

    final ProductProvider productProvider = Provider.of<ProductProvider>(Get.context!, listen: false);
    List<CartModel> cartList = [];
    bool isProductChanged = false;

    for (OrderDetailsModel orderDetail in orderDetails ?? []) {
      List<AddOn> addOnList = [];
      List<List<bool?>> selectedVariations = [];
      double variationPrice = 0;




      for(int i = 0; i < orderDetail.addOnIds!.length; i++) {
        addOnList.add(AddOn(id: orderDetail.addOnIds![i], quantity: orderDetail.addOnQtys![i]));
      }

      if(orderDetail.productDetails?.id != null && (reorderProductModel?.products?.isNotEmpty ?? false)) {
        Product? product =  reorderProductModel?.products?.firstWhere((product) => product.id == orderDetail.productDetails?.id);

        if(product?.isChanged ?? false) {
          isProductChanged = true;
        }

        ({double? price, List<Variation>? variatins}) productBranchWithPrice = ProductHelper.getBranchProductVariationWithPrice(product);


        if(product != null ) {
          if(productProvider.checkStock(product)){
            for(int j = 0; j < (productBranchWithPrice.variatins?.length ?? 0); j++){
              selectedVariations.add([]);

              if(orderDetail.variations == null) {
                for(int index = 0; index < (productBranchWithPrice.variatins?[j].variationValues?.length ?? 0); index ++){
                  selectedVariations[j].add(false);
                }
              }

              if((j + 1) > (orderDetail.variations?.length ?? 0)) {
                break;
              }

              if(productBranchWithPrice.variatins != null && orderDetail.variations != null) {
                for(int index = 0; index < (productBranchWithPrice.variatins?[j].variationValues?.length ?? 0); index ++){
                  bool isSelected = false;

                  for(int i= 0; i < (orderDetail.variations?[j].variationValues?.length ?? 0); i++){

                    isSelected = productBranchWithPrice.variatins?[j].variationValues?[index].level == orderDetail.variations?[j].variationValues?[i].level;

                    if(isSelected) {
                      variationPrice += productBranchWithPrice.variatins?[j].variationValues?[index].optionPrice ?? 0;
                      break;
                    }

                  }
                  selectedVariations[j].add(isSelected);

                }

              }

            }

          }else{
            isProductChanged = true;

          }

          double priceWithVariation = (productBranchWithPrice.price ?? 0) + variationPrice;

          CartModel cartModel = CartModel(
            priceWithVariation, PriceConverterHelper.convertWithDiscount(productBranchWithPrice.price, product.discount, product.discountType),
            productBranchWithPrice.variatins ?? [],
            (priceWithVariation - (PriceConverterHelper.convertWithDiscount( priceWithVariation, product.discount, product.discountType) ?? 0)),
            1,
            (priceWithVariation - (PriceConverterHelper.convertWithDiscount( priceWithVariation, product.tax, product.taxType) ?? 0)),
            addOnList, product,
            selectedVariations,
          );

          if(productProvider.checkStock(product)) {
            cartList.add(cartModel);

          }

        }

      }

    }

    return (cartList: cartList, isProductChanged: isProductChanged);
  }

  void _addToCart(List<CartModel> cartModelList) {
    final CartProvider cartProvider = Provider.of<CartProvider>(Get.context!, listen: false);

    for(int i = 0; i < cartModelList.length; i++) {
      cartProvider.isExistInCart(cartModelList[i].product?.id, null);

      if(cartProvider.isExistInCart(cartModelList[i].product?.id, null) == -1) {
        cartProvider.addToCart(cartModelList[i], null);

      }
    }

  }
}
