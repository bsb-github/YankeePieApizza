import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/cart_model.dart';
import 'package:flutter_restaurant/features/category/domain/category_model.dart';
import 'package:flutter_restaurant/common/models/product_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/home/providers/banner_provider.dart';
import 'package:flutter_restaurant/features/cart/providers/cart_provider.dart';
import 'package:flutter_restaurant/features/category/providers/category_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/features/home/widgets/cart_bottom_sheet_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class MainSliderWidget extends StatefulWidget {
  const MainSliderWidget({super.key});

  @override
  State<MainSliderWidget> createState() => _MainSliderWidgetState();
}

class _MainSliderWidgetState extends State<MainSliderWidget> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return  Consumer<BannerProvider>(
      builder: (context, banner, child){
        return banner.bannerList != null ? banner.bannerList!.isNotEmpty ? Center(
          child: Column(
            children: [
              CarouselSlider.builder(
                itemCount: banner.bannerList!.length,
                options: CarouselOptions(
                    height: 300,
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                    viewportFraction: 1,
                    autoPlay: true,
                    autoPlayAnimationDuration: const Duration(seconds: 1),
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }
                ),
                itemBuilder: (ctx, index, realIdx) {
                  return Consumer<CartProvider>(
                      builder: (context, cartProvider, child) {
                      return InkWell(
                        onTap: () {
                          if(banner.bannerList![index].productId != null) {
                            Product? product;
                            for(Product prod in banner.productList) {
                              if(prod.id == banner.bannerList![index].productId) {
                                product = prod;

                                break;
                              }
                            }
                            if(product != null) {
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
                              ): showDialog(context: context, builder: (con) => Dialog(
                                backgroundColor: Colors.transparent,
                                child: CartBottomSheetWidget(
                                  product: product,
                                  callback: (CartModel cartModel) {
                                    showCustomSnackBarHelper(getTranslated('added_to_cart', context), isError: false);
                                  },
                                ),
                              )

                              );

                            }

                          }else if(banner.bannerList![index].categoryId != null) {
                            CategoryModel? category;
                            for(CategoryModel categoryModel in Provider.of<CategoryProvider>(context, listen: false).categoryList!) {
                              if(categoryModel.id == banner.bannerList![index].categoryId) {
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
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                          ),
                          child:  ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                            child: FadeInImage.assetNetwork(
                              placeholder: Images.placeholderBanner, width: size.width, height: size.height, fit: BoxFit.cover,
                              image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.bannerImageUrl}/${ banner.bannerList![index].image}',
                              imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderBanner, width: size.width, height: size.height, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      );
                    }
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: banner.bannerList!.map((b) {
                  int index = banner.bannerList!.indexOf(b);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index
                          ? Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha:0.9)
                          : Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha:0.4),
                    ),
                  );
                }

                ).toList(),
                ),

            ],
          ),
        ) : const SizedBox() : const MainSliderShimmer();
      },
    );
  }
}
class MainSliderShimmer extends StatelessWidget {
  const MainSliderShimmer({super.key});


  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 300,
      child: Padding(
        padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
        child: Shimmer(
          duration: const Duration(seconds: 1),
          interval: const Duration(seconds: 1),
          enabled: Provider.of<BannerProvider>(context).bannerList == null,
          child:  Container(
            decoration: BoxDecoration(
              color: Theme.of(context).shadowColor,
              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall)),
            ),
            height: 400,


          ),
        ),
      ),
    );
  }
}