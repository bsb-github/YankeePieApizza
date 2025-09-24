import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/models/product_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/common/widgets/product_shimmer_widget.dart';
import 'package:flutter_restaurant/common/widgets/sliver_delegate_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
import 'package:flutter_restaurant/features/branch/providers/branch_provider.dart';
import 'package:flutter_restaurant/features/category/widgets/restaurant_info_section.dart';
import 'package:flutter_restaurant/features/home/enums/product_group_enum.dart';
import 'package:flutter_restaurant/features/home/enums/quantity_position_enum.dart';
import 'package:flutter_restaurant/features/home/widgets/product_card_widget.dart';
import 'package:flutter_restaurant/features/menu/widgets/options_widget.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/common/providers/product_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class BranchScreen extends StatefulWidget {
  const BranchScreen({super.key, });

  @override
  State<BranchScreen> createState() => _BranchScreenState();
}

class _BranchScreenState extends State<BranchScreen> {
  final GlobalKey<ScaffoldState> drawerGlobalKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  List<BranchValue>? branchValueList;

  @override
  void initState() {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    final branchProvider = Provider.of<BranchProvider>(Get.context!, listen: false);

    locationProvider.checkPermission(()=> locationProvider.getCurrentLocation(context, false).then((currentAddress) {
      locationProvider.onChangeCurrentAddress(currentAddress);
    }));
    getBranchValue(branchProvider);
    productProvider.getLatestProductList(1, true, isUpdate: false);

    _searchFocus.addListener(() {
      if(!_searchFocus.hasFocus){
        branchProvider.updateSearchBox(false);
      }
    });
    super.initState();
  }

  getBranchValue(BranchProvider branchProvider) async {
    branchValueList = await branchProvider.getBranchValueList(context);
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    // final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    final double webMargin = (width - Dimensions.webScreenWidth) / 2;


    return Scaffold(
      key: drawerGlobalKey,
      endDrawerEnableOpenDragGesture: false,
      drawer: ResponsiveHelper.isTab(context) ? const Drawer(child: OptionsWidget(onTap: null)) : const SizedBox(),
      appBar: isDesktop ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBarWidget()) : null,
      body: RefreshIndicator(
        onRefresh: () async {
          final productProvider = Provider.of<ProductProvider>(context, listen: false);
          productProvider.getLatestProductList(1, true);
        },
        backgroundColor: Theme.of(context).primaryColor,
        color: Theme.of(context).cardColor,
        child: CustomScrollView(controller: _scrollController, slivers: [

          const RestaurantInfoSection(),

          SliverPersistentHeader(
            pinned: true,
            delegate: SliverDelegateWidget(height: isDesktop ? 90 : 110, child: Consumer<BranchProvider>(
              builder: (context, branch, _) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: isDesktop ? webMargin : 0),
                  padding: EdgeInsets.symmetric(vertical: isDesktop ? Dimensions.paddingSizeLarge : 0),
                  height: isDesktop ? 90 : 110,
                  width: Dimensions.webScreenWidth,
                  decoration: BoxDecoration(color: isDesktop ? Theme.of(context).canvasColor : Theme.of(context).cardColor),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [

                    if(!isDesktop) ...[
                      SizedBox(height: 60, child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                        child: CustomTextFieldWidget(
                          radius: Dimensions.radiusSmall,
                          hintText: getTranslated('search_item', context),
                          isShowBorder: true,
                          borderColor: Theme.of(context).hintColor.withValues(alpha:0.5),
                          fillColor: Theme.of(context).cardColor,
                          isShowPrefixIcon: true,
                          prefixIconUrl: Images.search,
                          prefixIconColor: Theme.of(context).hintColor.withValues(alpha:0.7),
                          onChanged: (str){},
                          onTap: () {},
                          controller: searchController,
                          inputAction: TextInputAction.search,
                          isIcon: true,
                          onSubmit: (text) {},
                        ),
                      )),

                      SizedBox(height: 40, child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 25,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            branch.updateTabIndex(index);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: 0),
                            margin: EdgeInsets.only(left: index == 0 ? Dimensions.paddingSizeExtraLarge : Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(
                                color: index == branch.branchTabIndex ? Theme.of(context).primaryColor : Colors.transparent,
                              )),
                            ),
                            child: Text('popular', style: rubikRegular.copyWith(
                              color: index == branch.branchTabIndex ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyMedium!.color,
                            )),
                          ),
                        ),
                      )),
                    ],

                    if(isDesktop)
                      Container(
                        width: Dimensions.webScreenWidth,
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(),
                        child: Row(children: [
                          Expanded(child: SizedBox(height: 35, child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 25,
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                branch.updateTabIndex(index);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(
                                    color: index == branch.branchTabIndex ? Theme.of(context).primaryColor : Colors.transparent,
                                  )),
                                ),
                                child: Text('popular', style: rubikRegular.copyWith(
                                  color: index == branch.branchTabIndex ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyMedium!.color,
                                )),
                              ),
                            ),
                          ))),

                          branch.showSearchBox ? Container(
                            width: 370, height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              color: Theme.of(context).primaryColor.withValues(alpha:0.1),
                            ),
                            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            child: CustomTextFieldWidget(
                              focusNode: _searchFocus,
                              radius: Dimensions.radiusSmall,
                              hintText: getTranslated('search_item', context),
                              fillColor: Theme.of(context).cardColor,
                              isShowPrefixIcon: true,
                              prefixIconUrl: Images.search,
                              prefixIconColor: Theme.of(context).hintColor.withValues(alpha:0.7),
                              onChanged: (str){},
                              onTap: () {},
                              controller: searchController,
                              inputAction: TextInputAction.search,
                              isIcon: true,
                              onSubmit: (text) {},
                            ),
                          ) :
                            Container(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                color: Theme.of(context).primaryColor.withValues(alpha:0.1),
                                boxShadow: [BoxShadow(
                                  color: Theme.of(context).canvasColor, spreadRadius: 50, blurRadius: 50,
                                  offset: const Offset(-10, 0),
                                )],
                              ),
                              child: InkWell(
                                onTap: () {
                                  branch.updateSearchBox(true);
                                  _searchFocus.requestFocus();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                    color: Theme.of(context).cardColor,
                                    border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:0.2), width: 0.5),
                                  ),
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                  child: CustomAssetImageWidget(
                                    Images.search,
                                    height: Dimensions.paddingSizeDefault, width: Dimensions.paddingSizeDefault,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ),
                            ),
                        ]),
                      ),

                  ]),
                );
              }
            )),
          ),

          SliverToBoxAdapter(child: Center(child: SizedBox(width: Dimensions.webScreenWidth, child: Consumer<ProductProvider>(
            builder: (context, prodProvider, child){
              List<Product>? productList = prodProvider.latestProductModel?.products;

              return productList == null && (productList?.isEmpty ?? true) ? GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: Dimensions.paddingSizeSmall,
                  mainAxisSpacing: Dimensions.paddingSizeSmall,
                  crossAxisCount: isDesktop ? 5 : ResponsiveHelper.isTab(context) ? 3 : 2,
                  mainAxisExtent: 250,
                ),
                itemCount: 12,
                itemBuilder: (BuildContext context, int index) {
                  return ProductShimmerWidget(isEnabled: productList == null, width: 220, isList: false);
                },
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              ) : Container(
                padding: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : Dimensions.paddingSizeSmall),
                color: isDesktop ? Theme.of(context).canvasColor : Theme.of(context).cardColor,
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: Dimensions.paddingSizeSmall,
                    mainAxisSpacing: Dimensions.paddingSizeSmall,
                    crossAxisCount: isDesktop ? 5 : ResponsiveHelper.isTab(context) ? 3 : 2,
                    mainAxisExtent: 290,
                  ),
                  itemCount: productList?.length ?? 0,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return ProductCardWidget(
                      imageHeight: isDesktop ? 185 : 150,
                      product: productList![index], quantityPosition: QuantityPosition.center, productGroup: ProductGroup.branchProduct,
                    );
                  },
                ),
              );
            },
          )))),
          const SliverToBoxAdapter(child: SizedBox(height: Dimensions.paddingSizeExtraLarge)),

          if(isDesktop) const SliverToBoxAdapter(child: FooterWidget()),

        ]),
      ),
    );
  }
}
