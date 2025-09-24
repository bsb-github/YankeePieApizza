import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/cart_model.dart';
import 'package:flutter_restaurant/common/models/product_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/helper/date_converter_helper.dart';
import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/cart/providers/cart_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/common/providers/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/common/widgets/on_hover_widget.dart';
import 'package:flutter_restaurant/common/widgets/rating_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/stock_tag_widget.dart';
import 'package:flutter_restaurant/common/widgets/wish_button_widget.dart';
import 'package:flutter_restaurant/features/home/widgets/cart_bottom_sheet_widget.dart';
import 'package:provider/provider.dart';

class ProductWebWidget extends StatelessWidget {
  final bool fromPopularItem;
  final Product product;

  const ProductWebWidget({super.key, required this.product, this.fromPopularItem = false});

  @override
  Widget build(BuildContext context) {
    double? startingPrice;
    startingPrice = product.price;

    double? priceDiscount = PriceConverterHelper.convertDiscount(context, product.price, product.discount, product.discountType);

    bool isAvailable = product.availableTimeStarts != null && product.availableTimeEnds != null
        ? DateConverterHelper.isAvailable(product.availableTimeStarts!, product.availableTimeEnds!) : false;

    return ResponsiveHelper.isMobilePhone() ? _itemView(isAvailable, priceDiscount, startingPrice)
        : OnHoverWidget(builder: (isHover) {
          return _itemView(isAvailable, priceDiscount, startingPrice);
        });
  }

  void _addToCart(BuildContext context, int cartIndex) {
    ResponsiveHelper.isMobile() ? showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (con) => CartBottomSheetWidget(
        product: product,
        callback: (CartModel cartModel) {
          showCustomSnackBarHelper(getTranslated('added_to_cart', context), isError: false);
        },
      ),
    ) : showDialog(context: context, builder: (con) => Dialog(
      backgroundColor: Colors.transparent,
      child: CartBottomSheetWidget(
        product: product,
        fromSetMenu: true,
        callback: (CartModel cartModel) {
          showCustomSnackBarHelper(getTranslated('added_to_cart', context), isError: false);
        },
      ),
    ));
  }

  Consumer<CartProvider> _itemView(bool isAvailable, double? priceDiscount, double? startingPrice) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        int cartIndex =   cartProvider.getCartIndex(product);
        String productImage = '';
        try{
          productImage =  '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product.image}';
        }catch(e) {
          debugPrint('error ===> $e');
        }

        return InkWell(
          onTap: () => _addToCart(context, cartIndex),
          child: Stack(children: [

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(
                  color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 300]!,
                  blurRadius: Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                  spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
                )],
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                Stack(children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                    child: CustomImageWidget(
                      placeholder: Images.placeholderRectangle, fit: BoxFit.cover, height: 105, width: 195,
                      image: productImage,
                    ),
                  ),

                  StockTagWidget(product: product),
                ]),

                Flexible(child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(product.name!, style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: ColorResources.getCartTitleColor(context)),
                      maxLines: 2, overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    RatingBarWidget(rating: product.rating!.isNotEmpty ? product.rating![0].average! : 0.0, size: Dimensions.paddingSizeDefault),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    FittedBox(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      if(priceDiscount! > 0) Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                          child: CustomDirectionalityWidget(child: Text(
                            PriceConverterHelper.convertPrice(startingPrice),
                            style: rubikBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall, decoration: TextDecoration.lineThrough),
                          )),
                        ),

                      CustomDirectionalityWidget(child: Text(
                        PriceConverterHelper.convertPrice(startingPrice, discount: product.discount, discountType: product.discountType),
                        style: rubikBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                      )),
                    ])),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Align(alignment: Alignment.center, child: SizedBox(width: 100, child: FittedBox(child: ElevatedButton(
                      style : ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed:() => _addToCart(context, cartIndex),
                      child: Text(getTranslated('quick_view', context)!,style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                    )))),
                  ]),
                )),
              ]),
            ),

            Positioned.fill(child: Align(alignment: Alignment.topRight, child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: WishButtonWidget(product: product),
            ))),

          ]),
        );
      },
    );
  }
}




