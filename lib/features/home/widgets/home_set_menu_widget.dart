import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_single_child_list_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_slider_list_widget.dart';
import 'package:flutter_restaurant/common/widgets/product_shimmer_widget.dart';
import 'package:flutter_restaurant/common/widgets/title_widget.dart';
import 'package:flutter_restaurant/features/home/enums/product_group_enum.dart';
import 'package:flutter_restaurant/features/home/enums/product_type_enum.dart';
import 'package:flutter_restaurant/features/home/enums/quantity_position_enum.dart';
import 'package:flutter_restaurant/features/home/widgets/product_card_widget.dart';
import 'package:flutter_restaurant/features/home/widgets/web_card_shimmer_widget.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/common/providers/product_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:provider/provider.dart';

class HomeSetMenuWidget extends StatelessWidget {
  const HomeSetMenuWidget({super.key, required this.controller});
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveHelper.isDesktop(context);

    return Center(child: Container(
      width: Dimensions.webScreenWidth,
      color: isDesktop ?  Theme.of(context).canvasColor : Theme.of(context).cardColor,
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
      child: Consumer<ProductProvider>(
        builder: (context, productProvider, _) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            productProvider.flavorfulMenuProductMenuModel == null ? Container(
              padding: EdgeInsets.only(left: !isDesktop ? Dimensions.paddingSizeLarge : 0),
              child: isDesktop ? const WebCardShimmerWidget(isEnabled: true)
                  : const ProductShimmerWidget(isEnabled: true, isList: true),
            ) : (productProvider.flavorfulMenuProductMenuModel?.products?.isNotEmpty ?? false) ?
            Column(children: [
              Padding(padding: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : Dimensions.paddingSizeLarge), child: TitleWidget(
                title: getTranslated('flavorful_set', context),
                subTitle: getTranslated('discover_all', context),
                onTap: () => RouterHelper.getHomeItem(productType: ProductType.flavorful),
              )),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              SizedBox(height: isDesktop ? 150 : 250, width: Dimensions.webScreenWidth, child: CustomSliderListWidget(
                controller: controller,
                verticalPosition: 50,
                horizontalPosition: 5,
                isShowForwardButton: isDesktop,
                child: CustomSingleChildListWidget(
                  controller: controller,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: (productProvider.flavorfulMenuProductMenuModel?.products?.length ?? 0) > 12 ? 12 : productProvider.flavorfulMenuProductMenuModel?.products?.length ?? 0,
                  itemBuilder: (index) => Container(
                    width: isDesktop ? 380 : 160,
                    margin: EdgeInsets.only(
                      left: index == 0 ? isDesktop ? 0 : Dimensions.paddingSizeLarge
                          : isDesktop ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeSmall,
                    ),
                    child: ProductCardWidget(
                      product: productProvider.flavorfulMenuProductMenuModel!.products![index],
                      productGroup: ProductGroup.setMenu,
                      quantityPosition: QuantityPosition.center,
                      imageHeight: isDesktop ? 130 : 190,
                      imageWidth: isDesktop ? 160 : 200,
                    ),
                  ),
                ),
              )),
            ]) : Center(child: Text(getTranslated('no_set_menu_available', context)!)),

          ]);
        },
      ),
    ));
  }
}
