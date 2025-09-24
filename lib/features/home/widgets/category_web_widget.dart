import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/category/providers/category_provider.dart';
import 'package:flutter_restaurant/features/home/widgets/category_page_widget.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CategoryWebWidget extends StatefulWidget {
  const CategoryWebWidget({super.key});

  @override
  State<CategoryWebWidget> createState() => _CategoryWebWidgetState();
}

class _CategoryWebWidgetState extends State<CategoryWebWidget> {


  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);

    return Consumer<CategoryProvider>(builder: (context, category, _) {
      return category.categoryList == null ? const _CategoryShimmer() :
      category.categoryList!.isNotEmpty ?  Container(
        decoration: BoxDecoration(
          color: ColorResources.getTertiaryColor(context),
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        ),
        height: isDesktop ? 300 : null,
        child: CategoryPageWidget(
          categoryProvider: category,
        ),
      ) :
      const SizedBox();
    });
  }
}

class _CategoryShimmer extends StatelessWidget {
  const _CategoryShimmer();

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);

    return SizedBox(height: 260, width: Dimensions.webScreenWidth, child: Center(child: Column(children: [

      Container(
        margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
        alignment: Alignment.center,
        child: Shimmer(
          duration: const Duration(seconds: 2),
          enabled: categoryProvider.categoryList == null,
          child: Container(
            height: Dimensions.paddingSizeLarge,
            width: 150,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Theme.of(context).shadowColor.withValues(alpha:0.2),
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
          ),
        ),
      ),
      SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeSmall),

      Expanded(child: GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveHelper.isDesktop(context) ? 5 : ResponsiveHelper.isTab(context) ? 8 : 4,
          mainAxisExtent: ResponsiveHelper.isDesktop(context) ? 110 : 100,
        ),
        itemCount: 7,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault), child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: categoryProvider.categoryList == null,
            child: Column(children: [
              Container(
                height: 50, width: 50,
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  color: Theme.of(context).shadowColor.withValues(alpha:0.3),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Container(height: 10, width: 50, color: Theme.of(context).shadowColor.withValues(alpha:0.5)),
            ]),
          ));
        },
      )),

    ])));
  }
}

