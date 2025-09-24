import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/enums/data_source_enum.dart';
import 'package:flutter_restaurant/common/providers/product_provider.dart';
import 'package:flutter_restaurant/common/widgets/branch_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/branch_list_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/customizable_space_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/common/widgets/paginated_list_widget.dart';
import 'package:flutter_restaurant/common/widgets/sliver_delegate_widget.dart';
import 'package:flutter_restaurant/common/widgets/title_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/branch/providers/branch_provider.dart';
import 'package:flutter_restaurant/features/cart/providers/cart_provider.dart';
import 'package:flutter_restaurant/features/cart/providers/frequently_bought_provider.dart';
import 'package:flutter_restaurant/features/category/providers/category_provider.dart';
import 'package:flutter_restaurant/features/checkout/widgets/selected_address_list_widget.dart';
import 'package:flutter_restaurant/features/home/providers/banner_provider.dart';
import 'package:flutter_restaurant/features/home/widgets/banner_widget.dart';
import 'package:flutter_restaurant/features/home/widgets/category_web_widget.dart';
import 'package:flutter_restaurant/features/home/widgets/chefs_recommendation_widget.dart';
import 'package:flutter_restaurant/features/home/widgets/home_local_eats_widget.dart';
import 'package:flutter_restaurant/features/home/widgets/home_set_menu_widget.dart';
import 'package:flutter_restaurant/features/home/widgets/product_view_widget.dart';
import 'package:flutter_restaurant/features/home/widgets/sorting_button_widget.dart';
import 'package:flutter_restaurant/features/menu/widgets/options_widget.dart';
import 'package:flutter_restaurant/features/order/providers/order_provider.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/search/providers/search_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/features/wishlist/providers/wishlist_provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final bool fromAppBar;
  const HomeScreen(this.fromAppBar, {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  static Future<void> loadData(bool reload, {bool isFcmUpdate = false }) async {
    final ProductProvider productProvider = Provider.of<ProductProvider>(Get.context!, listen: false);
    final CategoryProvider categoryProvider = Provider.of<CategoryProvider>(Get.context!, listen: false);
    final SplashProvider splashProvider = Provider.of<SplashProvider>(Get.context!, listen: false);
    final BannerProvider bannerProvider = Provider.of<BannerProvider>(Get.context!, listen: false);
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(Get.context!, listen: false);
    final WishListProvider wishListProvider = Provider.of<WishListProvider>(Get.context!, listen: false);
    final SearchProvider searchProvider = Provider.of<SearchProvider>(Get.context!, listen: false);
    final FrequentlyBoughtProvider frequentlyBoughtProvider = Provider.of<FrequentlyBoughtProvider>(Get.context!, listen: false);

    final isLogin = Provider.of<AuthProvider>(Get.context!, listen: false).isLoggedIn();

    if(isLogin){
      profileProvider.getUserInfo(reload, isUpdate: reload);
      if(isFcmUpdate){
        Provider.of<AuthProvider>(Get.context!, listen: false).updateToken();
      }
    }else{
      profileProvider.setUserInfoModel = null;
    }
     wishListProvider.initWishList();

    if(productProvider.latestProductModel == null || reload) {
      productProvider.getLatestProductList(1, reload);
    }


    if(reload || productProvider.popularLocalProductModel == null){
      productProvider.getPopularLocalProductList(1,  true, isUpdate: false);
    }

    if(reload) {
       splashProvider.getPolicyPage();
    }
     categoryProvider.getCategoryList(reload, source: DataSourceEnum.local);

    if(productProvider.flavorfulMenuProductMenuModel == null || reload) {
      productProvider.getFlavorfulMenuProductMenuList(1, reload);
    }

    if(productProvider.recommendedProductModel == null || reload) {
      productProvider.getRecommendedProductList(1, reload);
    }

     bannerProvider.getBannerList(reload);
     searchProvider.getCuisineList(isReload: reload);
     searchProvider.getSearchRecommendedData(isReload: reload);
     frequentlyBoughtProvider.getFrequentlyBoughtProduct(1, reload);

  }
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> drawerGlobalKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _localEatsScrollController = ScrollController();
  final ScrollController _setMenuScrollController = ScrollController();
  final ScrollController _branchListScrollController = ScrollController();


  @override
  void initState() {
    final BranchProvider branchProvider = Provider.of<BranchProvider>(Get.context!, listen: false);
    branchProvider.getBranchValueList(context);
    HomeScreen.loadData(false);
    super.initState();
  }
  @override
  void dispose() {
    _scrollController.dispose();
    _localEatsScrollController.dispose();
    _setMenuScrollController.dispose();
    _branchListScrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);
    final BranchProvider branchProvider = Provider.of<BranchProvider>(context, listen: false);

    return Scaffold(
      key: drawerGlobalKey,
      endDrawerEnableOpenDragGesture: false,
      drawer: ResponsiveHelper.isTab(context) ? const Drawer(child: OptionsWidget(onTap: null)) : const SizedBox(),
      appBar: isDesktop ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBarWidget()) : null,
      body: RefreshIndicator(
        onRefresh: () async {
          Provider.of<OrderProvider>(context, listen: false).changeStatus(true, notify: true);
          Provider.of<SplashProvider>(context, listen: false).initConfig(context, DataSourceEnum.client).then((value) {
            if(value != null) {
              HomeScreen.loadData(true);
            }
          });
        },
        backgroundColor: Theme.of(context).primaryColor,
        color: Theme.of(context).cardColor,
        child: Consumer<ProductProvider>(builder: (context, productProvider, _)=> PaginatedListWidget(
          scrollController: _scrollController,
          onPaginate: (int? offset) async {
            await productProvider.getLatestProductList(offset ?? 1, false);
          },
          totalSize: productProvider.latestProductModel?.totalSize,
          offset: productProvider.latestProductModel?.offset,
          limit: productProvider.latestProductModel?.limit,
          isDisableWebLoader: !ResponsiveHelper.isDesktop(context),
          builder: (loaderWidget) {
            return Expanded(child: CustomScrollView(controller: _scrollController, slivers: [

              if(!isDesktop) SliverAppBar(
                pinned: true, toolbarHeight: Dimensions.paddingSizeDefault,
                automaticallyImplyLeading: false,
                expandedHeight: kIsWeb ? 90 : 70,
                floating: false, elevation: 0,
                backgroundColor: isDesktop ? Colors.transparent : Theme.of(context).primaryColor,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.zero, centerTitle: true, expandedTitleScale: 1,
                  title: CustomizableSpaceBarWidget(builder: (context, scrollingRate)=> Center(child: Container(
                    width: Dimensions.webScreenWidth,
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                    margin: const EdgeInsets.symmetric(horizontal:  Dimensions.paddingSizeDefault),
                    child: Opacity(
                      opacity: (1 - scrollingRate),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start,   children: [
                        if(scrollingRate < 0.01)
                          Column(crossAxisAlignment: CrossAxisAlignment.start,  children: [
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            Text(getTranslated('current_location', context)!, style: rubikSemiBold.copyWith(
                              color: ColorResources.white,
                            )),

                            GestureDetector(
                              onTap: () => ResponsiveHelper.showDialogOrBottomSheet(context, SelectedAddressListWidget(
                                currentBranch: branchProvider.getBranch(),
                                isFromAppbar: true,
                              )),
                              child: Row(children: [
                                Consumer<LocationProvider>(builder: (context, locationProvider, _) => Text(
                                  _getDisplayLocationText(locationProvider.currentAddress?.address, context),
                                  style: rubikRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                )),
                                const SizedBox(width: Dimensions.fontSizeExtraSmall),

                                const Icon(Icons.expand_more, color: Colors.white),
                              ]),
                            ),
                          ]),

                        if(scrollingRate < 0.01)
                          Row( children: [
                            const Padding(
                              padding: EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                              child: BranchButtonWidget(isRow: false, color: Colors.white),
                            ),

                            ResponsiveHelper.isTab(context) ? InkWell(
                              onTap: () => RouterHelper.getDashboardRoute('cart'),
                              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                const SizedBox(height: Dimensions.paddingSizeSmall),
                                CountIconView(
                                  count: Provider.of<CartProvider>(context).cartList.length.toString(),
                                  icon: Icons.shopping_cart_outlined,
                                  color: ColorResources.white,
                                ),
                                const SizedBox(height: 3),

                                Text(
                                  getTranslated('cart', context)!,
                                  style:  rubikRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                ),
                              ]),
                            ) : const SizedBox(),
                          ]),
                      ]),
                    ),
                  ))),
                ),
              ),

              /// Search Button
              if(!isDesktop) SliverPersistentHeader(pinned: true, delegate: SliverDelegateWidget(
                child: Center(child: Stack(children: [
                  Container(
                    transform: Matrix4.translationValues(0, -2, 0),
                    height: 60, width: Dimensions.webScreenWidth,
                    color: Colors.transparent,
                    child: Column(children: [
                      Expanded(child: Container(color: Theme.of(context).primaryColor)),

                      Expanded(child: Container(color: Colors.transparent)),
                    ]),
                  ),

                  Positioned(
                    left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
                    top: Dimensions.paddingSizeExtraSmall, bottom: Dimensions.paddingSizeExtraSmall,
                    child: InkWell(
                      onTap: () => RouterHelper.getSearchRoute(),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                        height: 50, width: Dimensions.webScreenWidth,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                        ),
                        child: Row(children: [
                          Padding(
                            padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeSmall),
                            child: CustomAssetImageWidget(
                              Images.search, color: Theme.of(context).hintColor,
                              height: Dimensions.paddingSizeDefault,
                            ),
                          ),
                          Expanded(child: Text(getTranslated('are_you_hungry', context)!, style: rubikRegular.copyWith(
                            color: Theme.of(context).hintColor,
                          ))),
                        ]),
                      ),
                    ),
                  ),
                ])),
              )),

              /// for Web banner and category
              if(isDesktop)  SliverToBoxAdapter(child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
                  child: SizedBox(/*height: 300,*/ width: Dimensions.webScreenWidth, child: IntrinsicHeight(
                    child: Consumer<BannerProvider>(
                        builder: (context, bannerProvider, _) {
                          return Consumer<CategoryProvider>(
                              builder: (context, categoryProvider, _) {
                                return Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                                  (bannerProvider.bannerList?.isEmpty ?? false) ? const SizedBox() : (categoryProvider.categoryList?.isNotEmpty ?? false) ?
                                  const Expanded(flex: 6, child: SizedBox(child: BannerWidget())):
                                  const SizedBox(width: Dimensions.webScreenWidth / 1.5, child: BannerWidget()),




                                  const SizedBox(width: Dimensions.paddingSizeDefault),
                                  (categoryProvider.categoryList?.isNotEmpty ?? true) ?
                                  const Expanded(flex: 4, child: Center(child: CategoryWebWidget()))
                                      : const SizedBox(),
                                ]);
                              }
                          );
                        }
                    ),
                  )),
                ),
              )),

              /// for App banner and category
              if(!isDesktop) SliverToBoxAdapter(child: Column(children: [
                const BannerWidget(),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Container(
                  decoration: BoxDecoration(color: ColorResources.getTertiaryColor(context)),
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  child: const CategoryWebWidget(),
                ),
              ])),

              /// for Local eats
              SliverToBoxAdapter(child: Consumer<ProductProvider>(
                  builder: (context, productProvider, _) {
                    return (productProvider.popularLocalProductModel?.products?.isEmpty ?? false) ? const SizedBox() :  HomeLocalEatsWidget(controller: _localEatsScrollController);
                  }
              )),

              /// for Set menu
              SliverToBoxAdapter(child: Consumer<ProductProvider>(
                  builder: (context, productProvider,_) {
                    return (productProvider.flavorfulMenuProductMenuModel?.products?.isEmpty ?? false) ? const SizedBox() : HomeSetMenuWidget(controller: _setMenuScrollController);
                  }
              )),

              /*SliverToBoxAdapter(child: Center(child: Container(
                      width: Dimensions.webScreenWidth,
                      color: Theme.of(context).cardColor,
                      // padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        isDesktop? const SetMenuWebWidget() :  const SetMenuWidget(),
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                      ]),
                    ))),*/

              /// for web Chefs recommendation banner
              if(isDesktop) ...[
                SliverToBoxAdapter(child: Consumer<ProductProvider>(
                    builder: (context, productProvider, _) {
                      return (productProvider.recommendedProductModel?.products?.isEmpty ?? false) ? const SizedBox() : const ChefsRecommendationWidget();
                    }
                )),
                const SliverToBoxAdapter(child: SizedBox(height: Dimensions.paddingSizeLarge)),
              ],

              /// for Branch list
              SliverToBoxAdapter(child: Consumer<BranchProvider>(
                  builder: (context, branchProvider, _) {
                    return (branchProvider.branchValueList?.isEmpty ?? false) ? const SizedBox() : Center(child: SizedBox(
                      width: Dimensions.webScreenWidth,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : Dimensions.paddingSizeSmall),
                        child: BranchListWidget(controller: _branchListScrollController),
                      ),
                    ));
                  }
              )),

              /// for app Chefs recommendation banner
              if(!isDesktop)  SliverToBoxAdapter(child: Consumer<ProductProvider>(
                  builder: (context, productProvider,_) {
                    return (productProvider.recommendedProductModel?.products?.isEmpty ?? false) ? const SizedBox() : const ChefsRecommendationWidget();
                  }
              )),

              if(productProvider.latestProductModel == null || (productProvider.latestProductModel?.products?.isNotEmpty ?? false))
                SliverToBoxAdapter(child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                    width: Dimensions.webMaxWidth,
                    child: TitleWidget(
                      title: getTranslated(isDesktop ? 'latest_item' : 'all_foods', context),
                      trailingIcon: const SortingButtonWidget(),
                      isShowTrailingIcon: true,
                    ),
                  ),
                )),


              const ProductViewWidget(),

              if(ResponsiveHelper.isDesktop(context)) SliverToBoxAdapter(child: loaderWidget),


              if(isDesktop) const SliverToBoxAdapter(child: FooterWidget()),

            ]));
          },
        )),
      ),
    );
  }
  String _getDisplayLocationText(String? address, BuildContext context) {
    const maxLength = 35; // Define the maximum length for the address

    if (address?.isNotEmpty ?? false) {
      // If the address is not empty, truncate it if necessary
      return address!.length > maxLength
          ? '${address.substring(0, maxLength)}...'
          : address;
    } else {
      // If the address is empty, return a fallback text
      return getTranslated('no_location_selected', context)!;
    }
  }

}



