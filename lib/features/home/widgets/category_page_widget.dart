import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/providers/theme_provider.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/on_hover_widget.dart';
import 'package:flutter_restaurant/features/category/providers/category_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class CategoryPageWidget extends StatefulWidget {
  final CategoryProvider categoryProvider;

  const CategoryPageWidget({super.key, required this.categoryProvider});

  @override
  State<CategoryPageWidget> createState() => _CategoryPageWidgetState();
}

class _CategoryPageWidgetState extends State<CategoryPageWidget> {
  int categoryLength = 0;

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    categoryLength = widget.categoryProvider.categoryList!.length;

    final SplashProvider splashProvider =
        Provider.of<SplashProvider>(context, listen: false);

    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: Dimensions.paddingSizeDefault),
          Center(
              child: Text(getTranslated('dish_discoveries', context)!,
                  textAlign: TextAlign.center,
                  style: rubikBold.copyWith(
                      fontSize: isDesktop
                          ? Dimensions.fontSizeExtraLarge
                          : Dimensions.fontSizeDefault,
                      color: themeProvider.darkTheme
                          ? Theme.of(context).primaryColor
                          : ColorResources.homePageSectionTitleColor))),
          SizedBox(
              height: isDesktop
                  ? Dimensions.paddingSizeLarge
                  : Dimensions.paddingSizeSmall),
          categoryLength < 4
              ? Padding(
                  padding: const EdgeInsets.only(
                      bottom: Dimensions.paddingSizeLarge),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: Dimensions.paddingSizeLarge,
                    children:
                        widget.categoryProvider.categoryList!.map((element) {
                      String? name = element.name;
                      int index = widget.categoryProvider.categoryList!
                          .indexOf(element);
                      return _categoryItem(
                          index: index,
                          isDesktop: isDesktop,
                          context: context,
                          splashProvider: splashProvider,
                          name: name);
                    }).toList(),
                  ),
                )
              : GridView.builder(
                  itemCount: categoryLength > 8 ? 8 : categoryLength,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isDesktop
                        ? 4
                        : ResponsiveHelper.isTab(context)
                            ? 8
                            : 4,
                    mainAxisExtent: 110,
                  ),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    String? name =
                        widget.categoryProvider.categoryList![index].name;
                    return _categoryItem(
                        index: index,
                        isDesktop: isDesktop,
                        context: context,
                        splashProvider: splashProvider,
                        name: name);
                  },
                ),
        ]);
  }

  Column _categoryItem(
      {required int index,
      required bool isDesktop,
      required BuildContext context,
      required SplashProvider splashProvider,
      String? name}) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      InkWell(
        onTap: () {
          if (index == 7) {
            RouterHelper.getAllCategoryRoute();
          } else {
            RouterHelper.getCategoryRoute(
                widget.categoryProvider.categoryList![index]);
          }
        },
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        child: isDesktop
            ? OnHoverWidget(builder: (isHoverActive) {
                return Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Dimensions.radiusDefault),
                    color: Colors.white,
                    border: isHoverActive
                        ? Border.all(color: Theme.of(context).primaryColor)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .shadowColor
                            .withValues(alpha: 0.2),
                        spreadRadius: Dimensions.radiusSmall,
                        blurRadius: Dimensions.radiusLarge,
                      )
                    ],
                  ),
                  child: index == 7
                      ? Image.asset(
                          Images.cutlery,
                          width: 45,
                          height: 45,
                        )
                      : CustomImageWidget(
                          // height: 45, width: 45,
                          image: splashProvider.baseUrls != null
                              ? '${splashProvider.baseUrls!.categoryImageUrl}/${widget.categoryProvider.categoryList![index].image}'
                              : '',
                        ),
                );
              })
            : Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  color: Theme.of(context).cardColor.withValues(alpha: 0.5),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Theme.of(context).shadowColor.withValues(alpha: 0.2),
                      spreadRadius: Dimensions.radiusSmall,
                      blurRadius: Dimensions.radiusLarge,
                    )
                  ],
                ),
                child: index == 7
                    ? Image.asset(
                        Images.cutlery,
                        width: 45,
                        height: 45,
                      )
                    : CustomImageWidget(
                        height: 45,
                        width: 45,
                        image: splashProvider.baseUrls != null
                            ? '${splashProvider.baseUrls!.categoryImageUrl}/${widget.categoryProvider.categoryList![index].image}'
                            : '',
                      ),
              ),
      ),
      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
      index == 7
          ? Text(
              getTranslated("More", context)!,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: rubikSemiBold.copyWith(
                fontSize: isDesktop
                    ? Dimensions.fontSizeDefault
                    : Dimensions.fontSizeSmall,
                color: Theme.of(context).primaryColor,
              ),
            )
          : Text(name!,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: rubikSemiBold.copyWith(
                fontSize: isDesktop
                    ? Dimensions.fontSizeDefault
                    : Dimensions.fontSizeSmall,
              )),
    ]);
  }
}
