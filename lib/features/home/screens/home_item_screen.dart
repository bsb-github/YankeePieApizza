import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/product_model.dart';
import 'package:flutter_restaurant/common/providers/product_provider.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/common/widgets/no_data_widget.dart';
import 'package:flutter_restaurant/common/widgets/paginated_list_widget.dart';
import 'package:flutter_restaurant/common/widgets/product_shimmer_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_restaurant/features/home/enums/product_group_enum.dart';
import 'package:flutter_restaurant/features/home/enums/product_type_enum.dart';
import 'package:flutter_restaurant/features/home/enums/quantity_position_enum.dart';
import 'package:flutter_restaurant/features/home/widgets/home_item_type_widget.dart';
import 'package:flutter_restaurant/features/home/widgets/product_card_widget.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class HomeItemScreen extends StatefulWidget {
  final ProductType? productType;

  const HomeItemScreen({super.key, this.productType});

  @override
  State<HomeItemScreen> createState() => _HomeItemScreenState();
}

class _HomeItemScreenState extends State<HomeItemScreen> {
  final ScrollController scrollController = ScrollController();
  late ProductType? productType;



  @override
  void initState() {
    super.initState();
    
    productType = widget.productType;
    _loadData(false);
    final ProductProvider productProvider = Provider.of<ProductProvider>(context, listen: false);

    if(productType == ProductType.local) {
      productProvider.getPopularLocalProductList(1, true, isUpdate: false);

    }else if(productType == ProductType.flavorful) {
      productProvider.getFlavorfulMenuProductMenuList(1, true, isUpdate: false);
    }


  }
  @override
  void dispose() {
    super.dispose();
  }


  Future<void> _loadData(bool isReload) async {
    final ProductProvider productProvider = Provider.of<ProductProvider>(context, listen: false);

    if(productType == ProductType.local && productProvider.latestProductModel == null || isReload) {
      productProvider.getPopularLocalProductList(1, true, isUpdate: isReload);

    }else if(productType == ProductType.flavorful && productProvider.flavorfulMenuProductMenuModel == null || isReload) {
      productProvider.getFlavorfulMenuProductMenuList(1, true, isUpdate: isReload);
    }
  }


  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.sizeOf(context);


    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context) ? const PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: WebAppBarWidget(),
      ) : CustomAppBarWidget(
        title:  getTranslated( ProductType.local == productType ? 'local_eats' : 'flavorful_set', context),
        actionView: HomeItemTypeWidget(onChange: (ProductType type){
          setState(() {
            productType = type;
          });

          _loadData(true);

        }),

      )) as PreferredSizeWidget?,
      body: Center(child: CustomScrollView(controller: scrollController, slivers: [
        if(ResponsiveHelper.isDesktop(context)) SliverToBoxAdapter(child: Center(child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(getTranslated( ProductType.local == productType ? 'local_eats' : 'flavorful_set', context)!, style: rubikBold.copyWith(
                fontSize: Dimensions.fontSizeOverLarge,
              )),
              const SizedBox(width: Dimensions.paddingSizeExtraLarge),

              HomeItemTypeWidget(onChange: (ProductType type){
                setState(() {
                  productType = type;
                });

                _loadData(true);

              }),

            ],
          ),
        ))),

        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.paddingSizeSmall,
            horizontal: Dimensions.paddingSizeDefault,
          ),
          child: Column(children: [

            SizedBox(width: Dimensions.webScreenWidth, child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {

                ProductModel? productModel;
                if(productType == ProductType.local) {
                  productModel = productProvider.popularLocalProductModel;

                }else if(productType == ProductType.flavorful) {
                  productModel = productProvider.flavorfulMenuProductMenuModel;

                }

                if(productModel == null) {
                  return GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: Dimensions.paddingSizeSmall, mainAxisSpacing: Dimensions.paddingSizeSmall,
                      crossAxisCount: ResponsiveHelper.isDesktop(context) ? 5 : ResponsiveHelper.isTab(context) ? 4 : 2,
                      mainAxisExtent: !ResponsiveHelper.isDesktop(context) ? 240 : 250,
                    ),
                    itemCount: 12,
                    itemBuilder: (BuildContext context, int index) {
                      return const ProductShimmerWidget(isEnabled: true, width: double.minPositive, isList: false);
                    },
                    padding: EdgeInsets.zero,
                  );
                }

                return (productModel.products?.isNotEmpty ?? false) ? PaginatedListWidget(
                  totalSize: productModel.totalSize,
                  offset: productModel.offset,
                  limit: productModel.limit,
                  onPaginate: (int? offset) async {
                    if(productType == ProductType.local) {
                      await productProvider.getPopularLocalProductList(offset ?? 1, false);

                    }else if(productType == ProductType.flavorful) {
                      await productProvider.getFlavorfulMenuProductMenuList(offset ?? 1, false);

                    }
                  },
                  scrollController: scrollController,
                  builder:(_)=> GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: Dimensions.paddingSizeSmall, mainAxisSpacing: Dimensions.paddingSizeSmall,
                      crossAxisCount: ResponsiveHelper.isDesktop(context) ? 5 :  ResponsiveHelper.isTab(context) ? 4 : 2,
                      mainAxisExtent: ResponsiveHelper.isMobile() ? 260 :  300,
                    ),
                    itemCount: productModel?.products?.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => ProductCardWidget(
                      product: productModel!.products![index],
                      quantityPosition: ResponsiveHelper.isDesktop(context)
                          ? QuantityPosition.center : QuantityPosition.left,
                      productGroup: ProductGroup.common,
                      isShowBorder: true,
                      imageHeight: !ResponsiveHelper.isMobile() ? 200 : 160,
                      imageWidth: screenSize.width,
                    ),
                  ),

                ) :  const NoDataWidget();
              },
            )),



          ]),
        )),

        if(ResponsiveHelper.isDesktop(context)) const SliverToBoxAdapter(child: FooterWidget()),

      ])),
    );
  }
}


