import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_single_child_list_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_slider_list_widget.dart';
import 'package:flutter_restaurant/common/widgets/product_shimmer_widget.dart';
import 'package:flutter_restaurant/common/widgets/title_widget.dart';
import 'package:flutter_restaurant/features/cart/providers/frequently_bought_provider.dart';
import 'package:flutter_restaurant/features/home/enums/product_group_enum.dart';
import 'package:flutter_restaurant/features/home/enums/quantity_position_enum.dart';
import 'package:flutter_restaurant/features/home/widgets/product_card_widget.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class FrequentlyBoughtWidget extends StatelessWidget {
  const FrequentlyBoughtWidget({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);

    return Container(
      width: Dimensions.webScreenWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).indicatorColor.withValues(alpha:0.04),
      ),
      clipBehavior: Clip.hardEdge,
      child: Consumer<FrequentlyBoughtProvider>(
        builder: (context, frequentlyBoughtProvider, _) {
          return frequentlyBoughtProvider.frequentlyBoughtProductModel != null ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            const SizedBox(height: Dimensions.paddingSizeSmall),
            Padding(padding: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : Dimensions.paddingSizeLarge, ),
                child: TitleWidget(
                  title: getTranslated('frequently_bought', context),
                  subTitle: getTranslated('discover_all', context),
                  subTitleTextStyle: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                  /// todo - Setup routing according to your need
                  onTap: ()=> RouterHelper.getAllCategoryRoute(),
                )),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            SizedBox(
              width: Dimensions.webScreenWidth,
              height: isDesktop ? 290 : 250,
              child: CustomSliderListWidget(
                controller: scrollController,
                verticalPosition: 100,
                horizontalPosition: 5,
                isShowForwardButton: isDesktop,
                child: CustomSingleChildListWidget(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  scrollDirection: Axis.horizontal,
                  itemCount: (frequentlyBoughtProvider.frequentlyBoughtProductModel?.products?.length ?? 0) > 12
                      ? 12 : frequentlyBoughtProvider.frequentlyBoughtProductModel?.products?.length ?? 0,
                  itemBuilder: (int index)=> Container(
                    width: isDesktop ? 220 : 170,
                    margin: EdgeInsets.only(
                      right: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeDefault,
                      left: index == 0 && !isDesktop ? Dimensions.paddingSizeLarge : 0,
                    ),
                    padding: isDesktop ? EdgeInsets.zero : const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                      color: Theme.of(context).cardColor,
                      boxShadow: [BoxShadow(
                        offset: const Offset(12, 12),
                        blurRadius: 30,
                        color: Theme.of(context).hintColor.withValues(alpha:0.1),
                      )],
                    ),
                    child: ProductCardWidget(
                      product: frequentlyBoughtProvider.frequentlyBoughtProductModel!.products![index],
                      imageWidth: double.maxFinite,
                      imageHeight: isDesktop ? 170 : 120, productGroup: ProductGroup.frequentlyBought,
                      quantityPosition: QuantityPosition.center,
                    ),
                  ),
                ),
              ),
            ),

          ]) : SizedBox(height:  300, child: ProductShimmerWidget(
            isEnabled: frequentlyBoughtProvider.frequentlyBoughtProductModel?.products == null,
            isList: true,
          ));
        },
      ),
    );
  }
}