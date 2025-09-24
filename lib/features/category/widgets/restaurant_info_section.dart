import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/customizable_space_bar_widget.dart';
import 'package:flutter_restaurant/features/category/widgets/coupon_banner_widget.dart';
import 'package:flutter_restaurant/features/category/widgets/branch_info_widget.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:go_router/go_router.dart';

class RestaurantInfoSection extends StatelessWidget {
  const RestaurantInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);

    final double realSpaceNeeded = (MediaQuery.of(context).size.width - Dimensions.webScreenWidth) / 2;

    return SliverAppBar(
      expandedHeight: isDesktop ? 350 : 400,
      toolbarHeight: isDesktop ? 150 : 80,
      pinned: !isDesktop ? true : false,
      floating: false,
      elevation: 0,
      clipBehavior: Clip.hardEdge,
      backgroundColor: Theme.of(context).canvasColor,
      leading: const SizedBox(),
      flexibleSpace: Container(
        margin: isDesktop ? EdgeInsets.symmetric(horizontal: realSpaceNeeded) : EdgeInsets.zero,
        child: FlexibleSpaceBar(
          titlePadding: EdgeInsets.zero,
          centerTitle: true,
          expandedTitleScale: 1,
          title: CustomizableSpaceBarWidget(
            builder: (context, scrollingRate) {

              return !isDesktop ? Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusLarge)),
                ),
                padding: EdgeInsets.only(top: scrollingRate * 20),
                child: Column(mainAxisSize: MainAxisSize.min, children: [

                  if(scrollingRate > 0.7)
                    Row(children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).primaryColor, size: Dimensions.paddingSizeExtraLarge),
                        onPressed: () => context.pop(),
                      ),

                      Expanded(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(
                          'Dhanmondi Branch', style: rubikSemiBold.copyWith(color: Theme.of(context).primaryColor),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        Text(
                          'address address address address', maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor),
                        ),
                      ])),

                      Container(
                        width: 35, height: 35,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:0.5), width: 0.2),
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        ),
                        margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          clipBehavior: Clip.hardEdge,
                          child: const CustomAssetImageWidget(Images.logo, fit: BoxFit.contain),
                        ),
                      ),

                      Material(
                        clipBehavior: Clip.hardEdge,
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        color: Theme.of(context).cardColor,
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          child: Container(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                            child: Icon(Icons.share, size: Dimensions.paddingSizeLarge , color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeLarge),
                    ]),

                  scrollingRate < 0.7 ? BranchInfoWidget(scrollingRate: scrollingRate) : const SizedBox(),

                  scrollingRate < 0.2 ? Padding(
                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge),
                    child: CouponBannerWidget(scrollingRate: scrollingRate),
                  ) : const SizedBox(),

                ]),
              ) : Container(
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).primaryColor.withValues(alpha:0.3), width: 0.5))),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color:Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusLarge)),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.1), blurRadius: 10)],
                  ),
                  child: IntrinsicHeight(
                    child: Row(children: [

                      Container(
                        transform: Matrix4.translationValues(0, -40, 0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          border: Border.all(color: Theme.of(context).primaryColor, width: 0.2),
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withValues(alpha:0.02), blurRadius: 10)],
                        ),
                        clipBehavior: Clip.hardEdge,
                        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                        margin: const EdgeInsets.only(left: Dimensions.paddingSizeExtraLarge),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          child: CustomAssetImageWidget(
                            Images.logo,
                            height: isDesktop ? 100 : 70 - (scrollingRate * 10),
                            width: isDesktop ? 100 : 70 - (scrollingRate * 10),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      BranchInfoWidget(scrollingRate: scrollingRate),

                      VerticalDivider(color: Theme.of(context).primaryColor.withValues(alpha:0.3), thickness: 0.3),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.access_time, color: Theme.of(context).primaryColor, size: Dimensions.paddingSizeLarge),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Text('20-30 min', style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall , color: Theme.of(context).textTheme.bodyMedium!.color)),
                        ]),
                      ),
                      VerticalDivider(color: Theme.of(context).primaryColor.withValues(alpha:0.3), thickness: 0.3),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          CustomAssetImageWidget(
                            Images.order, height: Dimensions.paddingSizeLarge, width: Dimensions.paddingSizeLarge,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          Text('20\$', style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall , color: Theme.of(context).textTheme.bodyMedium!.color)),

                          Text('Minimum Start', style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall , color: Theme.of(context).hintColor)),
                        ]),
                      ),
                      VerticalDivider(color: Theme.of(context).primaryColor.withValues(alpha:0.3), thickness: 0.3),

                      InkWell(
                        onTap: () {

                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            CustomAssetImageWidget(
                              Images.locationTappedSvg,
                              height: Dimensions.paddingSizeLarge,
                              width: Dimensions.paddingSizeLarge,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            Text(
                              getTranslated('location', context)!,
                              style: rubikRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ]),
                        ),
                      ),
                      VerticalDivider(color: Theme.of(context).primaryColor.withValues(alpha:0.3), thickness: 0.3),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Row(children: [
                            Icon(Icons.star_rounded, color: Theme.of(context).primaryColor, size: Dimensions.paddingSizeLarge),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                            Text(
                              '4.5',
                              style: rubikSemiBold.copyWith(
                                fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color,
                              ),
                            ),
                          ]),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Text(
                            '1200+ Review',
                            style: rubikSemiBold.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).primaryColor,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ]),
                      ),
                      VerticalDivider(color: Theme.of(context).primaryColor.withValues(alpha:0.3), thickness: 0.3),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Expanded(child: CouponBannerWidget(scrollingRate: scrollingRate)),

                    ]),
                  ),
                ),
              );
            },
          ),
          background: Stack(children: [
            CustomAssetImageWidget(Images.branchCoverPhoto, height: isDesktop ? 250 : 180, fit: BoxFit.cover),
            SizedBox(height: isDesktop ? Dimensions.paddingSizeLarge : 0),

            Positioned(
              right: Dimensions.paddingSizeLarge, top: isDesktop ? Dimensions.paddingSizeLarge : 45,
              child: Material(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                color: Theme.of(context).cardColor.withValues(alpha:isDesktop ? 0.7 : 1),
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: Container(
                    padding: EdgeInsets.all(isDesktop ? Dimensions.paddingSizeSmall : Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                    child: Icon(Icons.share, size: Dimensions.paddingSizeLarge , color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ),

            if(!isDesktop)
              Positioned(
                left: Dimensions.paddingSizeLarge, top: 45,
                child: Material(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => context.pop(),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    child: Container(
                      padding: EdgeInsets.all(isDesktop ? Dimensions.paddingSizeSmall : Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                      child: Icon(Icons.arrow_back_ios, size: Dimensions.paddingSizeLarge , color: Theme.of(context).cardColor),
                    ),
                  ),
                ),
              ),

          ]),
        ),
      ),
    );
  }
}
