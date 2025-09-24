import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class CouponBannerWidget extends StatefulWidget {
  final double scrollingRate;
  const CouponBannerWidget({super.key, required this.scrollingRate});

  @override
  State<CouponBannerWidget> createState() => _CouponBannerWidgetState();
}

class _CouponBannerWidgetState extends State<CouponBannerWidget> {
  final CarouselSliderController _mainBannerController = CarouselSliderController();
  final CarouselSliderController _subBannerController = CarouselSliderController();
  int _currentIndex = 0;
  final int _subSliderIndex = 1;

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [

      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(flex: 7, child: SizedBox(height: isDesktop ? 60 : 85, width: double.infinity, child: CarouselSlider.builder(
          disableGesture: false,
          itemCount: 5,
          carouselController: _mainBannerController,
          options: CarouselOptions(
            height: isDesktop ? 60 : 85,
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
                index == (5 - 1) ? 0 : (index + 1), duration: const Duration(milliseconds: 800),
              );
              if(mounted){
                setState(() {});
              }
            },
            scrollDirection: Axis.horizontal,
          ),
          itemBuilder: (context, index, _) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                color: ColorResources.getSecondaryColor(context).withValues(alpha:0.1),
              ),
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                  Flexible(child: Text(
                    'Enjoy 10% off',
                    style: rubikSemiBold.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color, fontSize: Dimensions.fontSizeSmall),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  )),

                  Flexible(child: Text(
                    'Minimum spend \$200 on full menu',
                    style: rubikRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color, fontSize: Dimensions.fontSizeSmall),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  )),

                ])),

                const CustomAssetImageWidget(Images.discountBannerAvatar, height: 50, width: 50),
              ]),
            );
          },
        ))),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Expanded(flex: 3, child: SizedBox(height: isDesktop ? 60 : 85, child: CarouselSlider.builder(
          disableGesture: true,
          itemCount: 5,
          carouselController: _subBannerController,
          options: CarouselOptions(
            scrollPhysics: const NeverScrollableScrollPhysics(),
            viewportFraction: 1,
            initialPage: _subSliderIndex,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: false,
            scrollDirection: Axis.horizontal,
          ),
          itemBuilder: (context, index, _) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(Dimensions.radiusSmall)),
                color: Theme.of(context).primaryColor.withValues(alpha:0.1),
              ),
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              // margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
              clipBehavior: Clip.hardEdge,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                Flexible(child: Text(
                  'Enjoy 10% off',
                  style: rubikSemiBold.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color, fontSize: Dimensions.fontSizeSmall),
                  maxLines: 1, overflow: TextOverflow.clip,
                )),

                Flexible(child: Text(
                  'Minimum spend \$200 on full menu',
                  style: rubikRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color, fontSize: Dimensions.fontSizeSmall),
                  maxLines: 1, overflow: TextOverflow.clip,
                )),

              ]),
            );
          },
        ))),
      ]),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      Center(child: SizedBox(height: 5, child: ListView.builder(
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            width: _currentIndex == index ? Dimensions.paddingSizeSmall : 5, height: 5, decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            color: Theme.of(context).primaryColor,
          ),
            margin: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
          );
        },
      ))),

    ]);
  }
}
