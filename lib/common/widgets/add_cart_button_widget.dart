import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/product_model.dart';
import 'package:flutter_restaurant/features/cart/providers/cart_provider.dart';
import 'package:flutter_restaurant/helper/product_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class AddToCartButtonWidget extends StatelessWidget {
  const AddToCartButtonWidget({
    super.key, required this.product,

  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveHelper.isDesktop(context);

    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        int quantity = cartProvider.getCartProductQuantityCount(product);
        int cartIndex =   cartProvider.getCartIndex(product);


        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            boxShadow: [BoxShadow(
              color: Theme.of(context).primaryColor.withValues(alpha:0.2), offset: const Offset(0, 2),
              blurRadius: Dimensions.radiusExtraLarge, spreadRadius: Dimensions.radiusSmall,
            )],
          ),
          child: quantity == 0 ? Material(
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            color: Colors.white,
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap:()=> ProductHelper.addToCart(cartIndex: cartIndex, product: product),
              child: Padding(
                padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.add_circle, color: Theme.of(context).primaryColor, size: Dimensions.paddingSizeLarge),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Text(getTranslated('add', context)!, style: rubikBold.copyWith(
                    color: Theme.of(context).primaryColor, fontSize: isDesktop ? Dimensions.fontSizeDefault : Dimensions.fontSizeSmall,
                  )),
                ]),
              ),
            ),
          ) : Material(
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            color: Theme.of(context).primaryColor,
            clipBehavior: Clip.hardEdge,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeExtraSmall),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                InkWell(
                  onTap: ()=> cartProvider.onUpdateCartQuantity(index: cartIndex, product: product, isRemove: true),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.remove, size: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  child: Text(quantity.toString(), style: rubikRegular.copyWith(color: Colors.white)),
                ),

                InkWell(
                  onTap: ()=> cartProvider.onUpdateCartQuantity(index: cartIndex, product: product, isRemove: false),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.add, size: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),
                  ),
                ),
              ]),
            ),
          ),
        );
      }
    );
  }
}
