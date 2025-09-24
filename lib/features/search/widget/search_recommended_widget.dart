import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_single_child_list_widget.dart';
import 'package:flutter_restaurant/features/search/providers/search_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class SearchRecommendedWidget extends StatelessWidget {
  const SearchRecommendedWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Consumer<SearchProvider>(
        builder: (context, searchProvider, _) {
          return SingleChildScrollView(
            primary: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              /// for resent search section
              const SizedBox(height: Dimensions.paddingSizeDefault),
              if(searchProvider.historyList.isNotEmpty) ...[
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(getTranslated('recent_searches', context)!, style: rubikBold.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  )),

                  InkWell(
                    onTap: searchProvider.clearSearchAddress,
                    child: Text(getTranslated('clear_all', context)!, style: rubikSemiBold.copyWith(
                      color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall,
                    )),
                  ),
                ]),
                const SizedBox(height: Dimensions.paddingSizeDefault),
              ],

              /// for recent search list section
              if(searchProvider.historyList.isNotEmpty) ...[
                ListView.builder(
                  itemCount: min(searchProvider.historyList.length, 10),
                  primary: false,
                  shrinkWrap: true,
                  reverse: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => Column(children: [

                    InkWell(
                      onTap: () {
                        searchProvider.searchProduct(name: searchProvider.historyList[index], offset: 1, context: context,);
                        RouterHelper.getSearchResultRoute(searchProvider.historyList[index].replaceAll(' ', '-'));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                          Text(
                            searchProvider.historyList[index],
                            style: rubikSemiBold.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
                          ),

                          InkWell(
                            onTap: () {
                              searchProvider.removeHistoryItemByIndex(index);
                            },
                            child: Icon(Icons.close, size: Dimensions.fontSizeExtraLarge, color: Theme.of(context).hintColor),
                          ),

                        ]),
                      ),
                    ),

                    Divider(height: 0, color: Theme.of(context).dividerColor.withValues(alpha:0.05)),

                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),
              ],


              /// for popular tags
              _RecommendedCuisinesWidget(searchProvider: searchProvider),


              const SizedBox(height: Dimensions.paddingSizeLarge),

              /// for recommended
              _RecommendedCategoryWidget(searchProvider: searchProvider)

            ]),
          );
        }
    );
  }
}

class _RecommendedCategoryWidget extends StatelessWidget {
  const _RecommendedCategoryWidget({
    required this.searchProvider,
  });

  final SearchProvider searchProvider;

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    if(searchProvider.searchRecommendModel == null) return const _RecommendedCategoryShimmerWidget();

    if(searchProvider.searchRecommendModel?.categories.isEmpty ?? false) return const SizedBox.shrink();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(getTranslated('recommended', context)!, style: rubikBold.copyWith(
        color: Theme.of(context).textTheme.bodyLarge?.color,
      )),
      const SizedBox(height: Dimensions.paddingSizeDefault),

      GridView.builder(
        primary: false,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveHelper.isDesktop(context) ? 5 : 4,
          mainAxisSpacing: Dimensions.paddingSizeExtraSmall,
          crossAxisSpacing: Dimensions.paddingSizeExtraSmall,
          mainAxisExtent: 110,
        ),
        itemCount: searchProvider.searchRecommendModel?.categories.length,
        itemBuilder: (context, index) => Material(
          shape: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColorLight),
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: ()=> RouterHelper.getCategoryRoute(searchProvider.searchRecommendModel!.categories[index]),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Card(
                color: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
                shadowColor: Theme.of(context).shadowColor.withValues(alpha:0.1),
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: CustomImageWidget(
                    image: '${splashProvider.baseUrls?.categoryImageUrl}/${searchProvider.searchRecommendModel?.categories[index].image}',
                    placeholder: Images.placeholderImage,
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Text(
                    '${searchProvider.searchRecommendModel?.categories[index].name}',
                    style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

            ]),
          ),
        ),
      ),
      const SizedBox(height: Dimensions.paddingSizeLarge),

    ]);
  }
}

class _RecommendedCuisinesWidget extends StatelessWidget {
  const _RecommendedCuisinesWidget({
    required this.searchProvider,
  });

  final SearchProvider searchProvider;

  @override
  Widget build(BuildContext context) {

    if (searchProvider.searchRecommendModel == null) {
      return const _RecommendedCuisinesShimmerWidget();
    }

    return (searchProvider.searchRecommendModel?.cuisines.isNotEmpty ?? false) ?  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          getTranslated('popular_cuisines', context)!,
          style: rubikBold.copyWith(
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        CustomSingleChildListWidget(
          isWrap: true,
          wrapSpacing: Dimensions.paddingSizeSmall,
          itemCount: min(searchProvider.searchRecommendModel?.cuisines.length ?? 0, 8),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
              child: InkWell(
                onTap: () {
                  searchProvider.searchProduct(
                    name: searchProvider.searchRecommendModel?.cuisines[index] ?? '',
                    offset: 1,
                    context: context,
                  );
                  RouterHelper.getSearchResultRoute(
                    searchProvider.searchRecommendModel?.cuisines[index].replaceAll(' ', '-') ?? '',
                  );
                },
                highlightColor: Colors.transparent,
                child: Chip(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  backgroundColor: Colors.transparent,
                  label: Text(
                    searchProvider.searchRecommendModel?.cuisines[index] ?? '',
                    style: rubikRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  surfaceTintColor: Colors.transparent,
                  side: BorderSide(
                    color: Theme.of(context).hintColor.withValues(alpha:0.2),
                    width: 0.5,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    ) : const SizedBox.shrink();
  }
}

class _RecommendedCuisinesShimmerWidget extends StatelessWidget {
  const _RecommendedCuisinesShimmerWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Shimmer effect for the title
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Shimmer(
            interval: const Duration(seconds: 1),
            // color: Theme.of(context).shadowColor.withValues(alpha:0.05),
            colorOpacity: 0.1,
            enabled: true,
            child: Container(
              height: 20.0,
              width: 150.0,
              color: Theme.of(context).shadowColor.withValues(alpha:0.2),
            ),
          ),
        ),

        const SizedBox(height: Dimensions.paddingSizeSmall),

        // Shimmer effect for the list items
        Row(children: List.generate(4, (_)=> Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            interval: const Duration(seconds: 1),
            colorOpacity: 0.1,
            enabled: true,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
              height: 40.0,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                color: Theme.of(context).shadowColor.withValues(alpha:0.2),
              ),
            ),
          ),
        )).toList()),
      ],
    );
  }
}


class _RecommendedCategoryShimmerWidget extends StatelessWidget {
  const _RecommendedCategoryShimmerWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Shimmer for the header text
        Shimmer(
          interval: const Duration(seconds: 1), // Delay between shimmers
          color: Theme.of(context).shadowColor.withValues(alpha:0.2), // Base color
          colorOpacity: 0.1, // Opacity of shimmer
          enabled: true, // Enable shimmer effect
          child: Container(
            height: 20,
            width: 150,
            color: Theme.of(context).shadowColor.withValues(alpha:0.2),
            margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
          ),
        ),

        // Shimmer for the grid items
        GridView.builder(
          primary: false,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveHelper.isDesktop(context) ? 5 : 4,
            mainAxisExtent: 110,
            crossAxisSpacing: Dimensions.paddingSizeDefault,
            mainAxisSpacing: Dimensions.paddingSizeDefault,
          ),
          itemCount: 8, // Fixed number of shimmer items
          itemBuilder: (context, index) => Shimmer(
            duration: const Duration(seconds: 2),
            interval: const Duration(milliseconds: 300),
            color: Theme.of(context).shadowColor.withValues(alpha:0.2),
            colorOpacity: 0.5,
            enabled: true,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).shadowColor.withValues(alpha:0.01),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              margin: const EdgeInsets.all(Dimensions.paddingSizeDefault / 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).shadowColor.withValues(alpha:0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Container(
                    height: 15,
                    width: 60,
                    color: Theme.of(context).shadowColor.withValues(alpha:0.2),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

