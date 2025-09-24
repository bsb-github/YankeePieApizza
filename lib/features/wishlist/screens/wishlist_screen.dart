import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/common/widgets/no_data_widget.dart';
import 'package:flutter_restaurant/common/widgets/not_logged_in_widget.dart';
import 'package:flutter_restaurant/common/widgets/product_shimmer_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/home/widgets/product_card_widget.dart';
import 'package:flutter_restaurant/features/wishlist/providers/wishlist_provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  bool _isLoggedIn = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(_isLoggedIn) {
      Provider.of<WishListProvider>(context, listen: false).initWishList();
    }
  }
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final bool isDesktop = ResponsiveHelper.isDesktop(context);

    return Scaffold(
      appBar: (isDesktop ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBarWidget())
          : CustomAppBarWidget(
        context: context, title: getTranslated('my_favourite', context),
        centerTitle: true,
        isBackButtonExist: !ResponsiveHelper.isMobile() ,
      )) as PreferredSizeWidget?,
      body: _isLoggedIn ? Consumer<WishListProvider>(
        builder: (context, wishlistProvider, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await Provider.of<WishListProvider>(context, listen: false).initWishList();
            },
            backgroundColor: Theme.of(context).primaryColor,
            color: Theme.of(context).cardColor,
            child: SingleChildScrollView(child: Column(children: [

              Center(child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: !isDesktop && height < 600 ? height : height - 400),
                child: Padding(padding: const EdgeInsets.symmetric(vertical:  Dimensions.paddingSizeDefault), child: SizedBox(
                  width: Dimensions.webScreenWidth,
                  child: !wishlistProvider.isLoading ? !wishlistProvider.isLoading && wishlistProvider.wishIdList.isNotEmpty ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: Dimensions.paddingSizeSmall, mainAxisSpacing: Dimensions.paddingSizeSmall,
                          crossAxisCount: isDesktop ? 5 : ResponsiveHelper.isTab(context) ? 3 : 2,
                          mainAxisExtent: isDesktop ? 260 : 260,
                        ),
                        itemCount: wishlistProvider.wishList?.length ?? 0,
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return ProductCardWidget(
                            product: wishlistProvider.wishList![index],
                            imageWidth: double.maxFinite,
                          );
                        },
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      Text(getTranslated('looking_for_something_else', context)!, style: rubikRegular.copyWith(
                        color: Theme.of(context).hintColor, fontSize: isDesktop ? Dimensions.fontSizeDefault : Dimensions.fontSizeSmall,
                      )),

                      Row(mainAxisSize: MainAxisSize.min, children: [
                        Flexible(child: Text(getTranslated('try_searching_to_explore_more', context)!, style: rubikRegular.copyWith(
                          color: Theme.of(context).hintColor, fontSize: isDesktop ? Dimensions.fontSizeDefault : Dimensions.fontSizeSmall,
                        ))),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        InkWell(
                          onTap: ()=> RouterHelper.getSearchResultRoute(''),
                          child: Text(getTranslated('categories', context)!, style: rubikSemiBold.copyWith(
                            color: Theme.of(context).primaryColor, fontSize: isDesktop ? Dimensions.fontSizeDefault : Dimensions.fontSizeSmall,
                            fontWeight: isDesktop ? FontWeight.w600 : FontWeight.w400,
                          )),
                        ),
                      ]),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                    ],
                  ) : const NoDataWidget(isFooter: false)
                    : GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: Dimensions.paddingSizeSmall, mainAxisSpacing: Dimensions.paddingSizeSmall,
                      crossAxisCount: isDesktop ? 5 : ResponsiveHelper.isTab(context) ? 3 : 2,
                      mainAxisExtent: isDesktop ? 260 : 260,
                    ),
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return ProductShimmerWidget(isEnabled: wishlistProvider.isLoading, width: double.maxFinite, isList: false);
                    },
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  ),
                )),
              )),

              if(isDesktop) const FooterWidget(),

            ])),
          );
        },
      ) : const NotLoggedInWidget(),
    );
  }
}
