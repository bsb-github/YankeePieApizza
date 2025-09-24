import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/product_model.dart';
import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/helper/product_helper.dart';
import 'package:flutter_restaurant/features/cart/providers/cart_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/common/widgets/add_cart_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/product_tag_widget.dart';
import 'package:flutter_restaurant/common/widgets/rating_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/stock_tag_widget.dart';
import 'package:flutter_restaurant/common/widgets/wish_button_widget.dart';
import 'package:provider/provider.dart';

class CartProductCardWidget extends StatelessWidget {
  final Product product;

  const CartProductCardWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    double? startingPrice = product.price;
    double? priceDiscount = PriceConverterHelper.convertDiscount(context, product.price, product.discount, product.discountType);
    // bool isAvailable = ProductHelper.isProductAvailable(product: product);


    return Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          int cartIndex =   cartProvider.getCartIndex(product);
          String productImage = '${splashProvider.baseUrls!.productImageUrl}/${product.image}';

          return InkWell(
            onTap: () => ProductHelper.addToCart(cartIndex: cartIndex, product: product),
            child: Stack(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Stack(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    child: CustomImageWidget(
                      placeholder: Images.placeholderRectangle,
                      fit: BoxFit.cover, height: 120, width: 160,
                      image: productImage,
                    ),
                  ),

                  StockTagWidget(product: product),

                  /*if(!isAvailable) Positioned.fill(child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                    child: Container(
                      color: Colors.black.withValues(alpha:0.3),
                    ),
                  )),*/
                ]),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    Row(children: [
                      Expanded(child: Text(
                        product.name!, maxLines: 2, overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: rubikSemiBold,
                      )),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                      ProductTagWidget(product: product),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    RatingBarWidget(rating: product.rating!.isNotEmpty ? product.rating![0].average! : 0.0, size: Dimensions.paddingSizeDefault),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    FittedBox(child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        priceDiscount! > 0 ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                            child: CustomDirectionalityWidget(child: Text(
                              PriceConverterHelper.convertPrice(startingPrice),
                              style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, decoration: TextDecoration.lineThrough),
                            ))) : const SizedBox(),

                        CustomDirectionalityWidget(child: Text(PriceConverterHelper.convertPrice(
                          startingPrice, discount: product.discount, discountType: product.discountType,
                        ), style: rubikBold))
                      ],
                    )),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  ]),
                ),

              ]),

              Positioned(
                right: Dimensions.paddingSizeSmall,
                top: Dimensions.paddingSizeSmall,
                child: WishButtonWidget(product: product),
              ),

              if(product.discount != null && product.discount != 0) Positioned.fill(child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha:0.7),
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: Text(
                      PriceConverterHelper.getDiscountType(discount: product.discount, discountType: product.discountType),
                      style: rubikRegular.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              )),


              Positioned(bottom: 100, left: 40, child: AddToCartButtonWidget(product: product)),

            ]),
          );
        }
    );
  }
}





