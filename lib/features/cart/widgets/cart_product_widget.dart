import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/cart_model.dart';
import 'package:flutter_restaurant/common/models/product_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/cart/providers/cart_provider.dart';
import 'package:flutter_restaurant/features/coupon/providers/coupon_provider.dart';
import 'package:flutter_restaurant/common/providers/product_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/common/widgets/rating_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/stock_tag_widget.dart';
import 'package:flutter_restaurant/features/home/widgets/cart_bottom_sheet_widget.dart';
import 'package:flutter_restaurant/features/home/widgets/marque_text_widget.dart';
import 'package:provider/provider.dart';

class CartProductWidget extends StatelessWidget {
  final CartModel? cart;
  final int cartIndex;
  final List<AddOns> addOns;
  final bool isAvailable;
  const CartProductWidget({super.key, required this.cart, required this.cartIndex, required this.isAvailable, required this.addOns});

  @override
  Widget build(BuildContext context) {

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final couponProvider = Provider.of<CouponProvider>(context, listen: false);
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);

    List<Variation>? variationList;
    if(cart?.product!.branchProduct != null && cart!.product!.branchProduct!.isAvailable!) {
      variationList = cart?.product!.branchProduct!.variations;
    }else{
      variationList = cart!.product!.variations;
    }

    String variationText = '';
    if(variationList != null && cart!.variations!.isNotEmpty) {
      for(int index=0; index<cart!.variations!.length; index++) {
        if(cart!.variations![index].contains(true)) {
          variationText += '${variationText.isNotEmpty ? ', ' : ''}${cart!.product!.variations![index].name} (';
          for(int i=0; i<cart!.variations![index].length; i++) {
            if(cart!.variations![index][i]!) {
              variationText += '${variationText.endsWith('(') ? '' : ', '}${variationList[index].variationValues?[i].level} - ${
                  PriceConverterHelper.convertPrice(variationList[index].variationValues![i].optionPrice)
              }';
            }
          }
          variationText += ')';
        }
      }
    }

    final bool isDesktop = ResponsiveHelper.isDesktop(context);

    return InkWell(
      onTap: () {

        ResponsiveHelper.showDialogOrBottomSheet(context, CartBottomSheetWidget(
          product: cart!.product,
          cartIndex: cartIndex,
          cart: cart,
          fromCart: true,
          callback: (CartModel cartModel) {
            showCustomSnackBarHelper(getTranslated('updated_in_cart', context), isError: false);
          },
        ));

      },
      child: Container(
        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha:0.2), borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          boxShadow: [BoxShadow(
            offset: const Offset(10, 18),
            blurRadius: 35,
            color: Theme.of(context).hintColor.withValues(alpha: 0.25),
          )],
        ),
        child: Stack(children: [

          const Positioned(
            top: 0, bottom: 0, right: Dimensions.paddingSizeExtraLarge,
            child: Icon(Icons.delete, color: Colors.white, size: Dimensions.paddingSizeLarge),
          ),


          ClipRRect(
            child: Dismissible(
              key: UniqueKey(),
              onDismissed: (DismissDirection direction) {
                couponProvider.removeCouponData(true);
                cartProvider.removeFromCart(cartIndex);
              },
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    border: isDesktop ? Border.all(color: Theme.of(context).primaryColor.withValues(alpha:0.2), width: 0.5) : null,
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [

                    Padding(
                      padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                      child: Row(children: [
                        /// for cart image and stock tag
                        Stack(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            child: CustomImageWidget(
                              placeholder: Images.placeholderImage, height: 80, width: 80,
                              image: '${splashProvider.baseUrls!.productImageUrl}/${cart!.product!.image}',
                            ),
                          ),

                          StockTagWidget(product: cart!.product!),
                        ]),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(
                          flex: 5,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                            Text(cart!.product!.name!, style: isDesktop ? rubikBold : rubikSemiBold, maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                            Row(children: [
                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  RatingBarWidget(rating: (cart?.product?.rating?.isNotEmpty ?? false) ? cart?.product?.rating![0].average ?? 0 : 0.0, size: 12),
                                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                  if(!isDesktop)
                                    _PriceTagWidget(cart: cart),

                                  cart!.product!.variations!.isNotEmpty && variationText.isNotEmpty ? Padding(
                                    padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                                    child: Row(mainAxisSize: MainAxisSize.min,children: [
                                      Flexible(child: MarqueeWidget(
                                        backDuration: const Duration(microseconds: 500),
                                        animationDuration: const Duration(microseconds: 500),
                                        direction: Axis.horizontal,
                                        child: Row(children: [
                                          Text(
                                            '${getTranslated('variation', context)}: ',
                                            style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                                          ),

                                          CustomDirectionalityWidget(child: Text(variationText, style: rubikBold.copyWith(
                                            fontSize: isDesktop ? Dimensions.fontSizeSmall : Dimensions.fontSizeExtraSmall,
                                          ))),
                                        ]),
                                      )),
                                    ]),
                                  ) : const SizedBox(),

                                  addOns.isNotEmpty ? SizedBox(
                                    height: 30,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                                      itemCount: addOns.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                          child: Row(children: [
                                            InkWell(
                                              onTap: () {
                                                cartProvider.removeAddOn(cartIndex, index);
                                              },
                                              child: Icon(Icons.remove_circle, color: Theme.of(context).primaryColor, size: 15),
                                            ),
                                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                            Text(addOns[index].name!, style: rubikRegular.copyWith(
                                              fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor,
                                            )),
                                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                            // CustomDirectionalityWidget(child: Text(PriceConverterHelper.convertPrice(addOns[index].price), style: rubikMedium)),
                                            // const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                            Text('(${cart!.addOnIds![index].quantity})', style: rubikRegular.copyWith(
                                              fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor,
                                            )),
                                          ]),
                                        );
                                      },
                                    ),
                                  ) : const SizedBox(),
                                ]),
                              ),

                              if(!isDesktop)
                                _QuantityTagWidget(
                                  cart: cart, cartProvider: cartProvider, couponProvider: couponProvider,
                                  cartIndex: cartIndex, productProvider: productProvider,
                                ),
                            ]),
                          ]),
                        ),

                        if(isDesktop)
                          Expanded(flex: 3, child: Padding(
                            padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                              _PriceTagWidget(cart: cart),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              _QuantityTagWidget(
                                cart: cart, cartProvider: cartProvider, couponProvider: couponProvider,
                                cartIndex: cartIndex, productProvider: productProvider,
                              ),
                            ]),
                          )),
                      ]),
                    ),
                  ])),
            ),
          ),

        ]),
      ),
    );
  }
}

class _QuantityTagWidget extends StatelessWidget {
  const _QuantityTagWidget({
    required this.cart,
    required this.cartProvider,
    required this.couponProvider,
    required this.productProvider,
    required this.cartIndex,
  });

  final CartModel? cart;
  final CartProvider cartProvider;
  final ProductProvider productProvider;
  final CouponProvider couponProvider;
  final int cartIndex;


  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall), child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            couponProvider.removeCouponData(true);
            if (cart!.quantity! > 1) {
              cartProvider.setQuantity(isIncrement: false, fromProductView: false, cart: cart, productIndex: null);
            }else {
              cartProvider.removeFromCart(cartIndex);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Theme.of(context).hintColor.withValues(alpha:0.5)),
            ),
            child: Icon(Icons.remove, size: Dimensions.fontSizeExtraLarge, color: Theme.of(context).hintColor.withValues(alpha:0.8)),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          child: Text(cart!.quantity.toString(), style: rubikRegular),
        ),

        InkWell(
          onTap: () {
            int quantity = cart != null && cart!.product != null ? cartProvider.getCartProductQuantityCount(cart!.product!) : 0;
            couponProvider.removeCouponData(true);
            if(productProvider.checkStock(cart!.product!, quantity: quantity)){
              cartProvider.setQuantity(isIncrement: true, fromProductView: false, cart: cart, productIndex: null);
            }else{
              showCustomSnackBarHelper(getTranslated('out_of_stock', context));
            }
          },
          child: Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, size: Dimensions.fontSizeExtraLarge, color: Colors.white),
          ),
        ),
      ],
    ));
  }
}


class _PriceTagWidget extends StatelessWidget {
  const _PriceTagWidget({
    required this.cart,
  });

  final CartModel? cart;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveHelper.isDesktop(context);

    return Row(mainAxisAlignment: isDesktop ? MainAxisAlignment.end : MainAxisAlignment.start, children: [
      if(cart!.discountAmount! > 0 ) ... [
        Flexible(child: CustomDirectionalityWidget(
          child: Text(PriceConverterHelper.convertPrice((cart!.product!.price!)), style: rubikRegular.copyWith(
            color: Theme.of(context).hintColor.withValues(alpha:0.7),
            fontSize: Dimensions.fontSizeSmall,
            decoration: TextDecoration.lineThrough,
          )),
        )),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
      ],

      Flexible(child: CustomDirectionalityWidget(child: Text(
        PriceConverterHelper.convertPrice(cart!.discountedPrice),
        style: rubikBold.copyWith(fontSize: isDesktop ? Dimensions.fontSizeLarge : Dimensions.fontSizeSmall),
      ))),
    ]);
  }
}
