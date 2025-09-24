import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_single_child_list_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_slider_list_widget.dart';
import 'package:flutter_restaurant/common/widgets/product_shimmer_widget.dart';
import 'package:flutter_restaurant/common/widgets/title_widget.dart';
import 'package:flutter_restaurant/features/home/enums/product_group_enum.dart';
import 'package:flutter_restaurant/features/home/enums/product_type_enum.dart';
import 'package:flutter_restaurant/features/home/enums/quantity_position_enum.dart';
import 'package:flutter_restaurant/features/home/widgets/product_card_widget.dart';
import 'package:flutter_restaurant/features/language/providers/localization_provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/common/providers/product_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:provider/provider.dart';

class HomeLocalEatsWidget extends StatelessWidget {
  const HomeLocalEatsWidget({super.key, required this.controller});
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveHelper.isDesktop(context);
    final LocalizationProvider localizationProvider = Provider.of<LocalizationProvider>(context, listen: false);

    return Center(child: Container(
      width: Dimensions.webScreenWidth,
      color: isDesktop ?  Theme.of(context).canvasColor : Theme.of(context).cardColor,
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
      child: Consumer<ProductProvider>(
        builder: (context, productProvider, _) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            productProvider.popularLocalProductModel == null ? Container(
              padding: EdgeInsets.only(left: !isDesktop ? Dimensions.paddingSizeLarge : 0),
              child: ProductShimmerWidget(
                isEnabled: productProvider.popularLocalProductModel == null,
                isList: true,
              ),
            ) : Column(children: [
              Padding(padding: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : Dimensions.paddingSizeLarge), child: TitleWidget(
                title: getTranslated('local_eats', context),
                subTitle: getTranslated('discover_all', context),
                onTap: (){
                  RouterHelper.getHomeItem(productType: ProductType.local);
                },
              )),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              SizedBox(height: isDesktop ? 290 : 250, width: Dimensions.webScreenWidth, child: CustomSliderListWidget(
                controller: controller,
                verticalPosition: 100,
                horizontalPosition: 5,
                isShowForwardButton: isDesktop,
                child: CustomSingleChildListWidget(
                  controller: controller,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: (productProvider.popularLocalProductModel?.products?.length ?? 0) > 12 ? 12 : productProvider.popularLocalProductModel?.products?.length ?? 0,
                  itemBuilder: (index) => Container(
                    width: isDesktop ? 200 : 160,
                    margin: EdgeInsets.only(
                      left: index == 0 ? isDesktop ? localizationProvider.isLtr ? 0 : Dimensions.paddingSizeLarge  : Dimensions.paddingSizeLarge
                          : isDesktop ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeLarge,


                    ),
                    child: ProductCardWidget(
                      product: productProvider.popularLocalProductModel!.products![index],
                      productGroup: ProductGroup.localEats,
                      quantityPosition: isDesktop ? QuantityPosition.center : QuantityPosition.left,
                      imageHeight: isDesktop ? 190 : 150,
                    ),
                  ),
                ),
              )),
            ]),

          ]);
        },
      ),
    ));
  }
}
