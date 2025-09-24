import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/filter_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/common/widgets/no_data_widget.dart';
import 'package:flutter_restaurant/common/widgets/paginated_list_widget.dart';
import 'package:flutter_restaurant/common/widgets/product_shimmer_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_restaurant/features/category/providers/category_provider.dart';
import 'package:flutter_restaurant/features/home/widgets/product_card_widget.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/common/providers/product_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CategoryScreen extends StatefulWidget {
  final String categoryId;
  final String? categoryName;
  final String? categoryBannerImage;
  const CategoryScreen({super.key, required this.categoryId, this.categoryName, this.categoryBannerImage});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with TickerProviderStateMixin {
  int _tabIndex = 0;
  String _type = 'all';
  final ScrollController _scrollController = ScrollController();

 @override
  void initState() {
    super.initState();

    _loadData();
  }

  void _loadData() async {
   final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);

   categoryProvider.getCategoryList(false);
   categoryProvider.getSubCategoryList(widget.categoryId);
 }


 @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
   final productProvider = Provider.of<ProductProvider>(context, listen: false);

   final Size size = MediaQuery.sizeOf(context);
   final double realSpaceNeeded = (size.width - Dimensions.webScreenWidth) / 2;
   final isDesktop = ResponsiveHelper.isDesktop(context);

    return Scaffold(
      appBar: isDesktop ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBarWidget()) : null,
      body: Consumer<CategoryProvider>(
        builder: (context, category, child) {
          return category.isLoading || category.categoryList == null ?
          _categoryShimmer(context, size.height, category) :
          PaginatedListWidget(
            scrollController: _scrollController,
            onPaginate: (int? offset) async {
             await category.getCategoryProductList('${category.selectedSubCategoryId}', offset ?? 1, type: _type);

            },
            totalSize: category.categoryProductModel?.totalSize,
            offset: category.categoryProductModel?.offset,
            limit: category.categoryProductModel?.limit,
            isDisableWebLoader: !ResponsiveHelper.isDesktop(context),
            builder:(Widget loaderWidget)=> Expanded(child: CustomScrollView(
              controller: _scrollController,
              slivers: [

                SliverAppBar(
                  surfaceTintColor: Colors.transparent,
                  backgroundColor: Theme.of(context).cardColor,
                  expandedHeight: 200,
                  toolbarHeight: 50 + MediaQuery.of(context).padding.top,
                  pinned: true,
                  floating: false,
                  leading: isDesktop ? const SizedBox() : SizedBox(
                    width: isDesktop ? Dimensions.webMaxWidth : MediaQuery.of(context).size.width,
                    child: IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                  ),
                  flexibleSpace: Container(
                    color:Theme.of(context).canvasColor,
                    margin: isDesktop? EdgeInsets.symmetric(horizontal: realSpaceNeeded) : const EdgeInsets.symmetric(horizontal: 0),
                    width: isDesktop ? Dimensions.webScreenWidth : MediaQuery.of(context).size.width,
                    child: FlexibleSpaceBar(
                      title: Text(widget.categoryName ?? '', style: rubikSemiBold.copyWith(
                        fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).cardColor,
                      )),
                      titlePadding: EdgeInsets.only(
                        bottom: 54 + (MediaQuery.of(context).padding.top/2),
                        left: 50,
                        right: 50,
                      ),
                      background: Container(height: 50, width : isDesktop ? Dimensions.webScreenWidth : MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(bottom: 50),
                        child: CustomImageWidget(
                          placeholder: Images.categoryBanner, fit: BoxFit.cover,
                          image: '${splashProvider.baseUrls?.categoryBannerImageUrl}/${widget.categoryBannerImage}',
                        ),
                      ),
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(30.0),
                    child: category.subCategoryList != null?Container(
                      width:  isDesktop ? Dimensions.webScreenWidth : MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha:0.05),
                            blurRadius: 10,
                            spreadRadius: 0, // Adjust spread radius for shadow concentration
                            offset: const Offset(0, 10), // Shift shadow vertically downwards
                          ),
                        ],
                      ),
                      child: TabBar(
                        dividerColor: Colors.transparent,
                        controller: TabController(initialIndex: _tabIndex,
                            length: category.subCategoryList!.length+1, vsync: this),
                        isScrollable: true,
                        unselectedLabelColor: Theme.of(context).hintColor.withValues(alpha:0.7),
                        indicatorWeight: 3,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: Theme.of(context).primaryColor,
                        labelColor: Theme.of(context).textTheme.bodyLarge!.color,
                        tabs: _tabs(category),
                        onTap: (int index) {
                          _type = 'all';
                          _tabIndex = index;
                          if(index == 0) {
                            category.getCategoryProductList(widget.categoryId, 1);
                          }else {
                            category.getCategoryProductList(category.subCategoryList![index-1].id.toString(), 1);
                          }
                        },
                      ),
                    ):const SizedBox(),
                  ),
                ),

                SliverToBoxAdapter(child: FilterButtonWidget(
                  type: _type,
                  items: productProvider.productTypeList,
                  onSelected: (selected) {
                    _type = selected;
                    category.getCategoryProductList(category.selectedSubCategoryId, 1,  type: _type);
                  },
                )),

                SliverPadding(
                  padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.symmetric(
                    horizontal: realSpaceNeeded,
                    vertical: Dimensions.paddingSizeSmall,
                  ) : const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  sliver: category.categoryProductModel == null || (category.categoryProductModel?.products?.isNotEmpty ?? false) ? SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isDesktop ? 5 : ResponsiveHelper.isTab(context) ? 3 : 2,
                      crossAxisSpacing: Dimensions.paddingSizeSmall,
                      mainAxisSpacing: Dimensions.paddingSizeSmall,
                      mainAxisExtent: 260,
                    ),
                    itemCount: category.categoryProductModel == null ? 10 : category.categoryProductModel!.products!.length,
                    itemBuilder: (context, index) {
                      if(category.categoryProductModel == null) {
                        return const ProductShimmerWidget(
                        isEnabled: true,
                        isList: false,
                        width: double.maxFinite,
                      );
                      }
                      return ProductCardWidget(
                        product: category.categoryProductModel!.products![index],
                        imageWidth: 260,
                      );
                    },
                  ) : const SliverToBoxAdapter(child: NoDataWidget(isFooter: false)),
                ),


                if(ResponsiveHelper.isDesktop(context)) SliverToBoxAdapter(child: loaderWidget),



                if(isDesktop) const SliverToBoxAdapter(child: FooterWidget()),

              ],
            )),
          );
        },
      ),
    );
  }

  SingleChildScrollView _categoryShimmer(BuildContext context, double height, CategoryProvider category) {
   final isDesktop = ResponsiveHelper.isDesktop(context);

    return SingleChildScrollView(child: Column(children: [
      ConstrainedBox(
        constraints: BoxConstraints(minHeight: !isDesktop && height < 600 ? height : height - 400),
        child: Center(child: SizedBox(width: Dimensions.webScreenWidth, child: Column(children: [
          Shimmer(
            duration: const Duration(seconds: 2),
            enabled: true,
            child: Container(height: 200, width: double.infinity, color: Theme.of(context).shadowColor),
          ),
          GridView.builder(
            shrinkWrap: true,
            itemCount: 10,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: Dimensions.paddingSizeSmall, mainAxisSpacing: Dimensions.paddingSizeSmall,
              crossAxisCount: isDesktop ? 5 : ResponsiveHelper.isTab(context) ? 3 : 2,
              mainAxisExtent: isDesktop ? 260 : 260,
            ),
            itemBuilder: (context, index) {
              return ProductShimmerWidget(isEnabled: category.categoryProductModel == null, isList: false, width: double.maxFinite);
            },
          ),
        ]))),
      ),
      if(isDesktop) const FooterWidget(),
    ]));
  }

  List<Tab> _tabs(CategoryProvider category) {
    List<Tab> tabList = [];
    tabList.add(const Tab(text: 'All'));
    for (var subCategory in category.subCategoryList!) {
      tabList.add(Tab(text: subCategory.name));
    }
    return tabList;
  }
}
