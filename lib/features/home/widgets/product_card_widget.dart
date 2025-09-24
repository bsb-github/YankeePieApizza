import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/models/product_model.dart';
import 'package:flutter_restaurant/common/widgets/add_cart_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/product_tag_widget.dart';
import 'package:flutter_restaurant/common/widgets/rating_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/stock_tag_widget.dart';
import 'package:flutter_restaurant/common/widgets/wish_button_widget.dart';
import 'package:flutter_restaurant/features/cart/providers/cart_provider.dart';
import 'package:flutter_restaurant/features/home/enums/product_group_enum.dart';
import 'package:flutter_restaurant/features/home/enums/quantity_position_enum.dart';
import 'package:flutter_restaurant/features/language/providers/localization_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/helper/product_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/common/providers/product_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class ProductCardWidget extends StatelessWidget {
  final Product product;
  final QuantityPosition quantityPosition;
  final double imageHeight;
  final double imageWidth;
  final ProductGroup productGroup;
  final bool isShowBorder;

  const ProductCardWidget({
    super.key,
    required this.product,
    this.quantityPosition = QuantityPosition.left,
    this.imageHeight = 150,
    this.imageWidth = 220,
    this.productGroup = ProductGroup.common,
    this.isShowBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final LocalizationProvider localizationProvider = Provider.of<LocalizationProvider>(context, listen: false);

    final bool isDesktop = ResponsiveHelper.isDesktop(context);
    double? startingPrice = product.price;
    double? priceDiscount = PriceConverterHelper.convertDiscount(context, product.price, product.discount, product.discountType);
    bool isAvailable = ProductHelper.isProductAvailable(product: product);

    final isCenterAlign = productGroup == ProductGroup.chefRecommendation || productGroup == ProductGroup.branchProduct
        || (productGroup == ProductGroup.searchResult && !isDesktop) || productGroup == ProductGroup.frequentlyBought;

    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        int cartIndex = cartProvider.getCartIndex(product);
        String productImage = '${splashProvider.baseUrls!.productImageUrl}/${product.image}';
        // final size = MediaQuery.sizeOf(context);

        return Container(
          decoration: productGroup == ProductGroup.frequentlyBought ?
          const BoxDecoration() :
          BoxDecoration(
            boxShadow: [BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha:0.3),
                blurRadius: 10, spreadRadius: 0.2,
                offset: const Offset(0, 2)
            )],
          ),
          margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
          child: Material(
            color: Theme.of(context).cardColor,
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Theme.of(context).primaryColor.withValues(alpha:isShowBorder ? 0.2 : 0)),
              borderRadius: BorderRadius.circular(productGroup == ProductGroup.frequentlyBought ? Dimensions.radiusSmall : Dimensions.radiusLarge),
            ),
            child: InkWell(
              onTap: () => ProductHelper.addToCart(cartIndex: cartIndex, product: product),
              hoverColor: Theme.of(context).primaryColor.withValues(alpha:0.03),
              child: Stack(children: [

                productGroup == ProductGroup.setMenu ? Column(
                  crossAxisAlignment: isCenterAlign ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                  children: [
                    isDesktop ? Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      child: Stack(children: [
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          SizedBox(
                            width: imageWidth,
                            child: Stack(children: [
                              /// for product image
                              _ProductImageWidget(
                                imageHeight: imageHeight, imageWidth: imageWidth, productImage: productImage, productGroup: productGroup,
                              ),

                              Positioned(
                                right: localizationProvider.isLtr ? Dimensions.paddingSizeSmall : null,
                                top: Dimensions.paddingSizeSmall,
                                left: localizationProvider.isLtr ? null : Dimensions.paddingSizeSmall,
                                child: WishButtonWidget(product: product),
                              ),

                              /// for Stock Tag
                              StockTagWidget(product: product, productGroup: productGroup),

                              /// for discount tag
                              if(product.discount != null && product.discount != 0) Positioned.fill(child: Align(
                                alignment: localizationProvider.isLtr ? Alignment.topLeft: Alignment.topRight,
                                child: _DiscountTagWidget(product: product, productGroup: productGroup),
                              )),
                            ]),
                          ),

                          /// for product description
                          Expanded(child: _ProductDescriptionWidget(
                            product: product,
                            priceDiscount: priceDiscount,
                            startingPrice: startingPrice,
                            productGroup: ProductGroup.common,
                          )),
                        ]),

                        /// for wish button


                        /// for Add to card and Quantity button
                        if(productProvider.checkStock(product) && isAvailable)
                          Positioned.fill(child: Align(
                            alignment: localizationProvider.isLtr ? Alignment.bottomRight: Alignment.bottomLeft,
                            child: Container(
                              transform: Matrix4.translationValues(0, -5, 0),
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                              child: AddToCartButtonWidget(product: product),
                            ),
                          )),
                      ]),
                    ) : Expanded(child: Stack(children: [
                      Column(children: [Stack(children: [
                        /// for product image
                        _ProductImageWidget(imageHeight: imageHeight, imageWidth: imageWidth, productImage: productImage, productGroup: productGroup),

                        Positioned(
                          right: localizationProvider.isLtr ? Dimensions.paddingSizeSmall : null,
                          top: Dimensions.paddingSizeSmall,
                          left: localizationProvider.isLtr ? null : Dimensions.paddingSizeSmall,
                          child: WishButtonWidget(product: product),
                        ),

                        /// for Stock Tag
                        StockTagWidget(product: product),
                      ])]),

                      /// for product description
                      Positioned.fill(left: Dimensions.paddingSizeExtraSmall, right: Dimensions.paddingSizeExtraSmall, child: Align(alignment: Alignment.bottomCenter, child: Stack(children: [
                        Column(mainAxisSize: MainAxisSize.min, children: [
                          const SizedBox(height: 35),

                          Container(
                            transform: Matrix4.translationValues(0, -20, 0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                              boxShadow: [BoxShadow(
                                color: Theme.of(context).shadowColor.withValues(alpha:0.2),
                                offset: const Offset(0, 5), blurRadius: 20, spreadRadius: 10,
                              )],
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                            child: Column(mainAxisSize: MainAxisSize.min, children: [
                              _ProductDescriptionWidget(
                                product: product,
                                priceDiscount: priceDiscount,
                                startingPrice: startingPrice,
                                productGroup: productGroup,
                              ),
                            ]),
                          ),
                        ]),

                        if(productProvider.checkStock(product) && isAvailable)
                          Positioned.fill(child: Align(alignment: Alignment.topCenter, child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                            child: AddToCartButtonWidget(product: product),
                          ))),
                      ]))),
                    ])),
                  ],
                ) :
                Stack(children: [
                  Column(crossAxisAlignment: isCenterAlign ? CrossAxisAlignment.center : CrossAxisAlignment.start, children: [
                    Stack(children: [
                      /// for product image
                      _ProductImageWidget(imageHeight: imageHeight, imageWidth: imageWidth, productImage: productImage, productGroup: productGroup),

                      /// for Stock Tag
                      StockTagWidget(product: product, productGroup: productGroup),

                    ]),

                    /// for product description
                    _ProductDescriptionWidget(
                      product: product,
                      priceDiscount: priceDiscount,
                      startingPrice: startingPrice,
                      productGroup: productGroup,
                    ),
                  ]),

                  /// for Add to card and Quantity button
                  if(productProvider.checkStock(product) && isAvailable)
                    Positioned(top: imageHeight - 15, child: Align(
                      alignment: quantityPosition == QuantityPosition.left ? Alignment.bottomLeft
                          : quantityPosition == QuantityPosition.center ? Alignment.bottomCenter
                          : Alignment.bottomRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                        child: AddToCartButtonWidget(product: product),
                      ),
                    )),
                ]),

                if(productGroup != ProductGroup.setMenu) ...[
                  /// for wish button
                  Positioned(
                    right: localizationProvider.isLtr ? Dimensions.paddingSizeSmall : null,
                    top: Dimensions.paddingSizeSmall,
                    left: localizationProvider.isLtr ? null : Dimensions.paddingSizeSmall,
                    child: WishButtonWidget(product: product),
                  ),

                  /// for discount tag
                  if(product.discount != null && product.discount != 0) Positioned.fill(child: Align(
                    alignment: localizationProvider.isLtr ? Alignment.topLeft: Alignment.topRight,
                    child: _DiscountTagWidget(product: product, productGroup: productGroup),
                  )),
                ],

              ]),
            ),
          ),
        );
      },
    );
  }
}

class _ProductImageWidget extends StatelessWidget {
  const _ProductImageWidget({
    required this.imageHeight,
    required this.imageWidth,
    required this.productImage,
    required this.productGroup
  });

  final double imageHeight;
  final double imageWidth;
  final String productImage;
  final ProductGroup productGroup;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        productGroup == ProductGroup.frequentlyBought && !ResponsiveHelper.isDesktop(context) ? Dimensions.radiusSmall : Dimensions.radiusDefault,
      ),
      child: CustomImageWidget(
        placeholder: Images.placeholderRectangle,
        fit: BoxFit.cover, height: imageHeight, width: imageWidth,
        image: productImage,
      ),
    );
  }
}

class _ProductDescriptionWidget extends StatelessWidget {
  const _ProductDescriptionWidget({
    required this.product,
    required this.priceDiscount,
    required this.startingPrice,
    required this.productGroup,
  });

  final Product product;
  final double? priceDiscount;
  final double? startingPrice;
  final ProductGroup productGroup;

  @override
  Widget build(BuildContext context) {
    final isCenterAlign = productGroup == ProductGroup.chefRecommendation || productGroup == ProductGroup.setMenu ||
        productGroup == ProductGroup.branchProduct || (productGroup == ProductGroup.frequentlyBought && !ResponsiveHelper.isDesktop(context));

    final ConfigModel? configModel = Provider.of<SplashProvider>(context, listen: false).configModel;
    final isHalalTagAvailable = (product.branchProduct?.halalStatus == 1) && (configModel?.halalTagStatus == 1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
      child: Column(
        crossAxisAlignment: isCenterAlign ?  CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [

          const SizedBox(height: Dimensions.paddingSizeDefault),
          Row(mainAxisAlignment: isCenterAlign ? MainAxisAlignment.center : MainAxisAlignment.start, children: [

            Flexible(child: Text(product.name!, maxLines: 1, overflow: TextOverflow.ellipsis, style: rubikSemiBold)),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            ProductTagWidget(product: product),
            if(isHalalTagAvailable) const SizedBox(width: Dimensions.paddingSizeExtraSmall),

            if(isHalalTagAvailable) CustomAssetImageWidget(
              Images.halalIconSvg, height: Dimensions.paddingSizeLarge,
              width: Dimensions.paddingSizeLarge,
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ]),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          product.rating!.isNotEmpty ? product.rating![0].average! > 0.0 ? RatingBarWidget(rating: product.rating![0].average! , size: Dimensions.paddingSizeDefault): const SizedBox() : const SizedBox(),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          FittedBox(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            priceDiscount! > 0 ? Padding(
                padding: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
                child: CustomDirectionalityWidget(child: Text(
                  PriceConverterHelper.convertPrice(startingPrice),
                  style: rubikRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall, decoration: TextDecoration.lineThrough, color: Theme.of(context).hintColor,
                  ),
                ))) : const SizedBox(),

            CustomDirectionalityWidget(child: Text(
              PriceConverterHelper.convertPrice(startingPrice, discount: product.discount, discountType: product.discountType),
              style: rubikBold.copyWith(fontSize: Dimensions.fontSizeSmall),
            )),
          ])),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        ],
      ),
    );
  }
}

class _DiscountTagWidget extends StatelessWidget {
  const _DiscountTagWidget({required this.product, required this.productGroup});

  final Product product;
  final ProductGroup productGroup;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall), child: Container(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(color: Theme.of(context).primaryColor.withValues(alpha:0.7), borderRadius: BorderRadius.circular(Dimensions.radiusLarge)),
      child: Text(
        PriceConverterHelper.getDiscountType(discount: product.discount, discountType: product.discountType),
        style: rubikBold.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
      ),
    ));
  }
}





