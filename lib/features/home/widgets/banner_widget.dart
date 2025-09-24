import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/cart_model.dart';
import 'package:flutter_restaurant/common/models/product_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/features/category/domain/category_model.dart';
import 'package:flutter_restaurant/features/category/providers/category_provider.dart';
import 'package:flutter_restaurant/features/home/providers/banner_provider.dart';
import 'package:flutter_restaurant/features/home/widgets/cart_bottom_sheet_widget.dart';
import 'package:flutter_restaurant/features/language/providers/localization_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final CarouselSliderController _mainBannerController = CarouselSliderController();
  final CarouselSliderController _subBannerController = CarouselSliderController();
  int _currentIndex = 0;
  final int _subSliderIndex = 1;

  @override
  Widget build(BuildContext context) {
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final localizationProvider = Provider.of<LocalizationProvider>(context, listen: false);
    // final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Column(children: [

      Consumer<BannerProvider>(
        builder: (context, bannerProvider, child) {
          return bannerProvider.bannerList == null ? const _BannerShimmer():
          (bannerProvider.bannerList?.isNotEmpty ?? false)
          ? Container(
            decoration: ResponsiveHelper.isDesktop(context) ? BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ) : const BoxDecoration(),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
                child: Text(getTranslated('today_specials', context)!, style: rubikBold.copyWith(
                  color: ResponsiveHelper.isDesktop(context) ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeExtraLarge : Dimensions.fontSizeDefault,
                )),
              ),

              SizedBox(
                height: ResponsiveHelper.isDesktop(context)? 260 : 130,
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(width: Dimensions.paddingSizeLarge),
                  Expanded(flex: 7, child: CarouselSlider.builder(
                    disableGesture: false,
                    itemCount: bannerProvider.bannerList!.length <= 10 ? bannerProvider.bannerList!.length : 10,
                    carouselController: _mainBannerController,
                    options: CarouselOptions(
                      height: ResponsiveHelper.isDesktop(context)? 230 : 120,
                      viewportFraction: 1,
                      initialPage: _currentIndex,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      onPageChanged: (index, _) {

                        _currentIndex = index;
                        _subBannerController.animateToPage(
                          index == ((bannerProvider.bannerList?.length ?? 1) - 1) ? 0 : (index + 1),
                        );

                        if(mounted){
                          setState(() {});
                        }

                      },
                      scrollDirection: Axis.horizontal,
                    ),
                    itemBuilder: (context, index, realIndex) {
                      return Material(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        clipBehavior: Clip.hardEdge,
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            if(bannerProvider.bannerList![index].productId != null) {
                              Product? product;
                              for(Product prod in bannerProvider.productList) {
                                if(prod.id == bannerProvider.bannerList![index].productId) {
                                  product = prod;
                                  break;
                                }
                              }
                              if(product != null) {
                                ResponsiveHelper.showDialogOrBottomSheet(context, CartBottomSheetWidget(
                                  product: product,
                                  fromSetMenu: true,
                                  callback: (CartModel cartModel) {
                                    showCustomSnackBarHelper(getTranslated('added_to_cart', context), isError: false);
                                  },
                                ));

                              }

                            }else if(bannerProvider.bannerList![index].categoryId != null) {
                              CategoryModel? category;
                              for(CategoryModel categoryModel in Provider.of<CategoryProvider>(context, listen: false).categoryList!) {
                                if(categoryModel.id == bannerProvider.bannerList![index].categoryId) {
                                  category = categoryModel;
                                  break;
                                }
                              }
                              if(category != null) {
                                RouterHelper.getCategoryRoute(category);
                              }
                            }
                          },
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              child: CustomImageWidget(
                                placeholder: Images.placeholderBanner, width: double.infinity, height: ResponsiveHelper.isDesktop(context)? 250 : 120,
                                fit: BoxFit.cover,
                                image: '${splashProvider.baseUrls!.bannerImageUrl}/${bannerProvider.bannerList![index].image}',
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(flex: 3,child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    CarouselSlider.builder(
                      disableGesture: true,
                      itemCount: bannerProvider.bannerList?.length,
                      carouselController: _subBannerController,
                      options: CarouselOptions(
                        height: ResponsiveHelper.isDesktop(context)? 210 : 105,
                        scrollPhysics: const NeverScrollableScrollPhysics(),
                        viewportFraction: 1,
                        initialPage: _subSliderIndex,
                        autoPlayInterval: const Duration(seconds: 4),
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        scrollDirection: Axis.horizontal,
                      ),
                      itemBuilder: (context, index, realIndex) {
                        return Material(
                          borderRadius:  BorderRadius.horizontal(
                              left: localizationProvider.isLtr ? const Radius.circular(Dimensions.radiusDefault): const Radius.circular(0),
                              right: localizationProvider.isLtr ? const Radius.circular(0) : const Radius.circular(Dimensions.radiusDefault)
                          ),
                          clipBehavior: Clip.hardEdge,
                          color: Theme.of(context).primaryColor,
                          child: InkWell(
                            onTap: () {
                              if(bannerProvider.bannerList![index].productId != null) {
                                Product? product;
                                for(Product prod in bannerProvider.productList) {
                                  if(prod.id == bannerProvider.bannerList![index].productId) {
                                    product = prod;
                                    break;
                                  }
                                }
                                if(product != null) {
                                  ResponsiveHelper.showDialogOrBottomSheet(context, CartBottomSheetWidget(
                                    product: product,
                                    fromSetMenu: true,
                                    callback: (CartModel cartModel) {
                                      showCustomSnackBarHelper(getTranslated('added_to_cart', context), isError: false);
                                    },
                                  ));

                                }

                              }else if(bannerProvider.bannerList![index].categoryId != null) {
                                CategoryModel? category;
                                for(CategoryModel categoryModel in Provider.of<CategoryProvider>(context, listen: false).categoryList!) {
                                  if(categoryModel.id == bannerProvider.bannerList![index].categoryId) {
                                    category = categoryModel;
                                    break;
                                  }
                                }
                                if(category != null) {
                                  RouterHelper.getCategoryRoute(category);
                                }
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                //borderRadius: const BorderRadius.horizontal(left: Radius.circular(Dimensions.radiusDefault)),
                              ),
                              child: ClipRRect(
                                //borderRadius: const BorderRadius.horizontal(left: Radius.circular(Dimensions.radiusDefault)),
                                child: CustomImageWidget(
                                  placeholder: Images.placeholderBanner,
                                  fit: BoxFit.fitHeight,
                                  image: '${splashProvider.baseUrls!.bannerImageUrl}/${bannerProvider.bannerList![index].image}',
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    SizedBox(height: 5, child: ListView.builder(
                      itemCount: bannerProvider.bannerList!.length <= 10 ? bannerProvider.bannerList!.length : 10,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          width: _currentIndex == index ? Dimensions.paddingSizeLarge : 5, height: 5, decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                            color: ResponsiveHelper.isDesktop(context) ? Colors.white
                                : _currentIndex == index ? Theme.of(context).primaryColor :  Theme.of(context).primaryColor.withValues(alpha:0.3),
                          ),
                          margin: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
                        );
                      },
                    )),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  ])),

                ]),
              ),
            ]),
          )
              : const SizedBox();
        },
      ),

    ]);
  }
}

class _BannerShimmer extends StatelessWidget {
  const _BannerShimmer();

  @override
  Widget build(BuildContext context) {
    final bannerProvider = Provider.of<BannerProvider>(context, listen: false);

    return Shimmer(
      duration: const Duration(seconds: 2),
      enabled: bannerProvider.bannerList == null,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
          child: Container(
            height: Dimensions.paddingSizeLarge,
            width: 150,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Theme.of(context).shadowColor.withValues(alpha:0.2),
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
          ),
        ),

        SizedBox(
          height: ResponsiveHelper.isDesktop(context)? 240 : 130,
          child: Row(children: [

            const SizedBox(width:  Dimensions.paddingSizeLarge),
            Expanded(flex: 7, child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Theme.of(context).shadowColor.withValues(alpha:0.2),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
            )),
            const SizedBox(width:  Dimensions.paddingSizeSmall),

            Expanded(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Expanded(child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Theme.of(context).shadowColor.withValues(alpha:0.2),
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(Dimensions.radiusDefault)),
                ),
              )),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Container(
                height: 10,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Theme.of(context).shadowColor.withValues(alpha:0.4),
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
              ),
            ])),

          ]),
        ),
      ]),
    );
  }
}

