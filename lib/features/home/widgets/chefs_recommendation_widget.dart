import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/providers/product_provider.dart';
import 'package:flutter_restaurant/common/providers/theme_provider.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_single_child_list_widget.dart';
import 'package:flutter_restaurant/common/widgets/on_hover_widget.dart';
import 'package:flutter_restaurant/common/widgets/product_shimmer_widget.dart';
import 'package:flutter_restaurant/common/widgets/title_widget.dart';
import 'package:flutter_restaurant/features/home/enums/product_group_enum.dart';
import 'package:flutter_restaurant/features/home/enums/quantity_position_enum.dart';
import 'package:flutter_restaurant/features/home/widgets/product_card_widget.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class ChefsRecommendationWidget extends StatefulWidget {
  const ChefsRecommendationWidget({super.key});

  @override
  State<ChefsRecommendationWidget> createState() => _ChefsRecommendationWidgetState();
}

class _ChefsRecommendationWidgetState extends State<ChefsRecommendationWidget> {
  final CarouselSliderController sliderController = CarouselSliderController();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveHelper.isDesktop(context);
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Column(children: [

      Consumer<ProductProvider>(builder: (context, productProvider, _) {
        return (productProvider.recommendedProductModel == null) ? Center(
          child: Container(width: Dimensions.webScreenWidth,
            padding: EdgeInsets.only(left: !isDesktop ? Dimensions.paddingSizeLarge : 0),
            child: ProductShimmerWidget(
              isEnabled: productProvider.popularLocalProductModel == null,
              isList: true,
            ),
          ),
        ) : (productProvider.recommendedProductModel?.products?.isEmpty ?? true) ? const SizedBox() : Column(children: [
          if(!isDesktop)
            Container(
              color: Theme.of(context).cardColor,
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeSmall),
              width: Dimensions.webScreenWidth,
              child: TitleWidget(
                title: getTranslated('chefs_recommendation', context),
                isShowLeadingIcon: true,
                leadingIcon: const CustomAssetImageWidget(Images.chefSvg, width: Dimensions.paddingSizeDefault, height: Dimensions.paddingSizeDefault),
              ),
            ),

            if(isDesktop)
              Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(getTranslated('chefs_recommendation', context)!, style: rubikBold.copyWith(
                    fontSize: Dimensions.fontSizeExtraLarge,
                    color: themeProvider.darkTheme ? Theme.of(context).colorScheme.onSecondary : ColorResources.homePageSectionTitleColor
                )),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                const CustomAssetImageWidget(Images.chefSvg, width: Dimensions.paddingSizeExtraLarge, height: Dimensions.paddingSizeExtraLarge),
              ])),

            if(isDesktop) const SizedBox(height: Dimensions.paddingSizeDefault),


            Center(child: Container(
              decoration: BoxDecoration(
                color: isDesktop ? Theme.of(context).primaryColor.withValues(alpha:0.1) : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              width: Dimensions.webScreenWidth,
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
              child: Stack(children: [

                Center(child: SizedBox(
                  width: 800,
                  child: (productProvider.recommendedProductModel?.products?.length ?? 0) > 3 ? CarouselSlider.builder(
                    itemCount: productProvider.recommendedProductModel?.products?.length,
                    carouselController: sliderController,
                    options: CarouselOptions(
                      height: 360,
                      viewportFraction: ResponsiveHelper.isDesktop(context) ?  0.33 : ResponsiveHelper.isTab(context) ? 0.5 : 0.65,
                      enlargeFactor: 1,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      scrollDirection: Axis.horizontal,
                    ),
                    itemBuilder: (context, index, realIndex) {
                      return Padding(
                        padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        child: ProductCardWidget(
                          product: productProvider.recommendedProductModel!.products![index],
                          imageHeight: isDesktop ? 240 : 220,
                          imageWidth: double.maxFinite,
                          quantityPosition: QuantityPosition.center,
                          productGroup: ProductGroup.chefRecommendation,
                        ),
                      );

                    },
                  ) : Center(
                    child: CustomSingleChildListWidget(
                      scrollDirection: Axis.horizontal,
                      itemCount: productProvider.recommendedProductModel?.products?.length ?? 0,
                      mainAxisAlignment: MainAxisAlignment.center,
                      itemBuilder: (index)=> Padding(
                        padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        child: SizedBox(height: 360, width: isDesktop ? 240 : 220, child: ProductCardWidget(
                          product: productProvider.recommendedProductModel!.products![index],
                          imageHeight: isDesktop ? 240 : 220,
                          imageWidth: double.maxFinite,
                          quantityPosition: QuantityPosition.center,
                          productGroup: ProductGroup.chefRecommendation,
                        )),
                      ),
                    ),
                  ),
                )),

                if(isDesktop && (productProvider.recommendedProductModel?.products?.length ?? 0) > 3 ) ...[
                  Positioned.fill(child: Align(alignment: Alignment.centerLeft, child: Padding(
                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge),
                    child: OnHoverWidget(
                      builder: (isHover) {
                        return Material(
                          borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                          color: Colors.transparent,
                          clipBehavior: Clip.hardEdge,
                          child: InkWell(
                            onTap: () => sliderController.previousPage(),

                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:isHover ? 1 : 0.7), width: 2),
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                              child: Icon(
                                Icons.arrow_back_rounded, size: Dimensions.paddingSizeExtraLarge,
                                color: Theme.of(context).primaryColor.withValues(alpha:isHover ? 1 : 0.7),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ))),

                  Positioned.fill(child: Align(alignment: Alignment.centerRight, child: Padding(
                    padding: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                    child: OnHoverWidget(
                      builder: (isHover) {
                        return Material(
                          borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                          color: Colors.transparent,
                          clipBehavior: Clip.hardEdge,
                          child: InkWell(
                            onTap: () => sliderController.nextPage(),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:isHover ? 1 : 0.7), width: 2),
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                              child: Icon(
                                Icons.arrow_forward_rounded, size: Dimensions.paddingSizeExtraLarge,
                                color: Theme.of(context).primaryColor.withValues(alpha:isHover ? 1 : 0.7),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ))),
                ],


              ]),
            )),

          ]);
        },
      ),

    ]);
  }
}




