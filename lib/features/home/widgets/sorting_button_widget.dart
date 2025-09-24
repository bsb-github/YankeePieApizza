import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/enums/product_sort_type_enum.dart';
import 'package:flutter_restaurant/common/providers/product_provider.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/features/home/enums/view_change_to_enum.dart';
import 'package:flutter_restaurant/features/home/providers/sorting_provider.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class SortingButtonWidget extends StatelessWidget {
  const SortingButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductProvider productProvider = Provider.of<ProductProvider>(context, listen: false);

    return Consumer<ProductSortProvider>(
      builder: (context, sortingProvider, child) {
        return Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.end, children: [
          Tooltip(
            message: getTranslated('grid_view', context),
            child: Material(
              color: sortingProvider.viewChangeTo == ViewChangeTo.gridView ? Theme.of(context).primaryColor.withValues(alpha:0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: () {
                  sortingProvider.updateViewChange(ViewChangeTo.gridView);
                },
                child: Padding(
                  padding: EdgeInsets.all(sortingProvider.viewChangeTo == ViewChangeTo.gridView ? Dimensions.paddingSizeExtraSmall : 0),
                  child: CustomAssetImageWidget(
                    Images.gridSvg,
                    width: sortingProvider.viewChangeTo == ViewChangeTo.gridView ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeLarge,
                    height: sortingProvider.viewChangeTo == ViewChangeTo.gridView ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeLarge,
                    color: sortingProvider.viewChangeTo == ViewChangeTo.gridView ? Theme.of(context).colorScheme.primary : Theme.of(context).hintColor,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Tooltip(
            message: getTranslated('list_view', context),
            child: Material(
              color: sortingProvider.viewChangeTo == ViewChangeTo.listView ? Theme.of(context).primaryColor.withValues(alpha:0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: () {
                  sortingProvider.updateViewChange(ViewChangeTo.listView);
                },
                child: Padding(
                  padding: EdgeInsets.all(sortingProvider.viewChangeTo == ViewChangeTo.listView ? Dimensions.paddingSizeExtraSmall : 0),
                  child: CustomAssetImageWidget(
                    Images.listIcon,
                    width: sortingProvider.viewChangeTo == ViewChangeTo.listView ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeDefault + 2,
                    height: sortingProvider.viewChangeTo == ViewChangeTo.listView ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeLarge,
                    color: sortingProvider.viewChangeTo == ViewChangeTo.listView ? Theme.of(context).colorScheme.primary : Theme.of(context).hintColor,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          PopupMenuButton<ProductSortType>(
            tooltip: getTranslated('sort_by', context),
            padding: const EdgeInsets.all(0),

            onSelected: (ProductSortType result) {
              sortingProvider.onChangeProductShortType(result);
              productProvider.getLatestProductList(1, true);
              sortingProvider.toggleSortingButtonClicked(true);
            },
            itemBuilder: (BuildContext c) => <PopupMenuEntry<ProductSortType>>[

              PopupMenuItem<ProductSortType>(
                value: ProductSortType.defaultType,
                child: _PopUpItem(title: getTranslated('default', context)!, type: ProductSortType.defaultType),
              ),

              PopupMenuItem<ProductSortType>(
                // padding: EdgeInsets.zero,
                value: ProductSortType.popular,
                child: _PopUpItem(title: getTranslated('popular', context)!, type: ProductSortType.popular),
              ),

              PopupMenuItem<ProductSortType>(
                // padding: EdgeInsets.zero,
                value: ProductSortType.priceLowToHigh,
                child: _PopUpItem(title: getTranslated('low_to_high_price', context)!, type: ProductSortType.priceLowToHigh),
              ),

              PopupMenuItem<ProductSortType>(
                // padding: EdgeInsets.zero,
                value: ProductSortType.priceHighToLow,
                child: _PopUpItem(title: getTranslated('high_to_low_price', context)!, type: ProductSortType.priceHighToLow),
              ),

            ],
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              clipBehavior: Clip.hardEdge,
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                child: CustomAssetImageWidget(
                  Images.sortSvg,
                  width: sortingProvider.isSortingButtonClicked ? Dimensions.paddingSizeLarge :  Dimensions.paddingSizeLarge,
                  height: sortingProvider.isSortingButtonClicked ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeLarge,
                  color: sortingProvider.isSortingButtonClicked ? Theme.of(context).colorScheme.primary : Theme.of(context).hintColor,
                ),
              ),
            ),
          ),

        ]);
      },
    );
  }
}

class _PopUpItem extends StatelessWidget {
  final String title;
  final ProductSortType type;
  const _PopUpItem({
    required this.title, required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductSortProvider>(
        builder: (context, productSortProvider, _) {
          return Container(
            decoration: BoxDecoration(
              color: type == productSortProvider.selectedShotType ? Theme.of(context).primaryColor.withValues(alpha:0.1) : null,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  child: Text(title, style: rubikSemiBold.copyWith(
                    color: type == productSortProvider.selectedShotType ? Theme.of(context).primaryColor : null,
                    fontSize: type == productSortProvider.selectedShotType ? Dimensions.fontSizeLarge : null,
                  )),
                ),
              ],
            ),
          );
        }
    );
  }
}
