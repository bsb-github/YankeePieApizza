import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/product_shimmer_widget.dart';
import 'package:flutter_restaurant/features/home/enums/product_group_enum.dart';
import 'package:flutter_restaurant/features/home/enums/quantity_position_enum.dart';
import 'package:flutter_restaurant/features/home/enums/view_change_to_enum.dart';
import 'package:flutter_restaurant/features/home/providers/sorting_provider.dart';
import 'package:flutter_restaurant/features/home/widgets/product_card_widget.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/common/providers/product_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:provider/provider.dart';

class ProductViewWidget extends StatelessWidget {

  const ProductViewWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final double webPadding = (size.width - Dimensions.webScreenWidth) / 2;
    final isDesktop = ResponsiveHelper.isDesktop(context);




    return Consumer<ProductProvider>(
      builder: (context, productProvider, _) {
        return productProvider.latestProductModel != null ?  Consumer<ProductSortProvider>(builder: (context, sortingProvider, child) => SliverPadding(
          padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.symmetric(
            horizontal: webPadding,
            vertical: Dimensions.paddingSizeSmall,
          ) : const EdgeInsets.all(Dimensions.paddingSizeSmall),
          sliver: (productProvider.latestProductModel?.products?.isNotEmpty ?? false) ? SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: Dimensions.paddingSizeSmall, mainAxisSpacing: Dimensions.paddingSizeSmall,
              crossAxisCount: isDesktop ? sortingProvider.viewChangeTo == ViewChangeTo.gridView ? 5 : 2
                  : ResponsiveHelper.isTab(context) ? sortingProvider.viewChangeTo == ViewChangeTo.gridView ? 4 : 2
                  : sortingProvider.viewChangeTo == ViewChangeTo.gridView ? 2 : 1,
              mainAxisExtent: ResponsiveHelper.isMobile() ? 260 : sortingProvider.viewChangeTo == ViewChangeTo.gridView ? 300 : 165,
            ),
            itemCount: productProvider.latestProductModel!.products!.length,
            itemBuilder: (context, index) {

              return ProductCardWidget(
                product: productProvider.latestProductModel!.products![index],
                quantityPosition: sortingProvider.viewChangeTo == ViewChangeTo.listView
                    ? QuantityPosition.right : isDesktop
                    ? QuantityPosition.center : QuantityPosition.left,
                productGroup: sortingProvider.viewChangeTo == ViewChangeTo.listView
                    ? ResponsiveHelper.isMobile()
                    ? ProductGroup.common : ProductGroup.setMenu
                    : ProductGroup.common,
                isShowBorder: true,
                imageHeight: ! ResponsiveHelper.isMobile() ? sortingProvider.viewChangeTo == ViewChangeTo.listView ? 150 : 200 : 160,
                imageWidth: (isDesktop || ResponsiveHelper.isTab(context)) && sortingProvider.viewChangeTo == ViewChangeTo.listView ? 200 : size.width,
              );
            },
          ) : const SliverToBoxAdapter(),
        )) : const _ProductListShimmerWidget();
      }
    );
  }
}

class _ProductListShimmerWidget extends StatelessWidget {
  const _ProductListShimmerWidget();

  @override
  Widget build(BuildContext context) {
    final double realSpaceNeeded = (MediaQuery.sizeOf(context).width - Dimensions.webScreenWidth) / 2;
    final isDesktop = ResponsiveHelper.isDesktop(context);


    return SliverPadding(
      padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.symmetric(
        horizontal: realSpaceNeeded,
        vertical: Dimensions.paddingSizeSmall,
      ) : const EdgeInsets.all(Dimensions.paddingSizeSmall),
      sliver: SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: Dimensions.paddingSizeSmall, mainAxisSpacing: Dimensions.paddingSizeSmall,
          crossAxisCount: isDesktop ? 5 : ResponsiveHelper.isTab(context) ? 4 : 2,
          mainAxisExtent: !isDesktop ? 240 : 250,
        ),
        itemCount: 10,
        itemBuilder: (context, index) {

          return const ProductShimmerWidget(isEnabled: true, width: double.minPositive, isList: false);
        },
      ),
    );
  }
}

