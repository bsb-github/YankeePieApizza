import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_pop_scope_widget.dart';
import 'package:flutter_restaurant/common/widgets/third_party_chat_widget.dart';
import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/branch/providers/branch_provider.dart';
import 'package:flutter_restaurant/features/branch/screens/branch_list_screen.dart';
import 'package:flutter_restaurant/features/cart/providers/cart_provider.dart';
import 'package:flutter_restaurant/features/cart/screens/cart_screen.dart';
import 'package:flutter_restaurant/features/dashboard/widgets/bottom_nav_item_widget.dart';
import 'package:flutter_restaurant/features/home/screens/home_screen.dart';
import 'package:flutter_restaurant/features/menu/screens/menu_screen.dart';
import 'package:flutter_restaurant/features/order/providers/order_provider.dart';
import 'package:flutter_restaurant/features/order/screens/order_screen.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/refer_and_earn/widgets/refer_use_bottom_sheet_widget.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/features/wishlist/screens/wishlist_screen.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  const DashboardScreen({super.key, required this.pageIndex});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  PageController? _pageController;
  int _pageIndex = 0;
  late List<Widget> _screens;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _pageIndex = widget.pageIndex;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showReferUseBottomSheet();
    });

    final splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final LocationProvider locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    if (splashProvider.policyModel == null) {
      Provider.of<SplashProvider>(context, listen: false).getPolicyPage();
    }

    if (authProvider.getGuestId() != null || authProvider.isLoggedIn()) {
      Provider.of<LocationProvider>(context, listen: false).initAddressList();
    }

    if (!kIsWeb) {
      locationProvider.onSelectCurrentLocation(context);
    }

    Provider.of<OrderProvider>(context, listen: false).changeStatus(true);

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      Provider.of<BranchProvider>(context, listen: false).getBranchId() != -1
          ? const HomeScreen(false)
          : const BranchListScreen(),
      Provider.of<BranchProvider>(context, listen: false).getBranchId() != -1
          ? const WishListScreen()
          : const BranchListScreen(),
      Provider.of<BranchProvider>(context, listen: false).getBranchId() != -1
          ? const CartScreen()
          : const BranchListScreen(),
      Provider.of<BranchProvider>(context, listen: false).getBranchId() != -1
          ? const OrderScreen()
          : const BranchListScreen(),
      MenuScreen(onTap: (int pageIndex) {
        _setPage(pageIndex);
      }),
    ];
  }

  void _showReferUseBottomSheet() {
    ConfigModel? config =
        Provider.of<SplashProvider>(context, listen: false).configModel;
    final profileProvider =
        Provider.of<ProfileProvider>(Get.context!, listen: false);
    final authProvider = Provider.of<AuthProvider>(Get.context!, listen: false);

    if (authProvider.isLoggedIn() &&
        (config?.referEarnStatus ?? false) &&
        (config?.customerReferredDiscountStatus ?? false)) {
      profileProvider.getUserInfo(true, isUpdate: true).then((value) async {
        var userData = profileProvider.userInfoModel;
        double discountAmount =
            userData?.referralCustomerDetails?.customerDiscountAmount ?? 0;
        if (userData != null &&
            discountAmount > 0 &&
            userData.referralCustomerDetails != null &&
            userData.referralCustomerDetails!.isChecked == 0 &&
            userData.referralCustomerDetails!.isUsed == 0) {
          ResponsiveHelper.showDialogOrBottomSheet(
              Get.context!,
              ReferUseBottomSheetWidget(
                  referralDetails: userData.referralCustomerDetails!));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return CustomPopScopeWidget(
        isExit: _pageIndex == 0,
        onPopInvoked: () async {
          if (_pageIndex != 0) {
            _setPage(0);
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
          floatingActionButton:
              !ResponsiveHelper.isDesktop(context) && _pageIndex == 0
                  ? Container(
                      margin: const EdgeInsets.only(bottom: 80),
                      child: const ThirdPartyChatWidget())
                  : null,
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: ResponsiveHelper.isDesktop(context)
                        ? 0
                        : defaultTargetPlatform == TargetPlatform.iOS
                            ? 80
                            : 65),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _screens.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return _screens[index];
                  },
                ),
              ),
              ResponsiveHelper.isDesktop(context)
                  ? const SizedBox()
                  : Align(
                      alignment: Alignment.bottomCenter,
                      child: Consumer<SplashProvider>(
                          builder: (ctx, splashController, _) {
                        return Container(
                          width: size.width,
                          height: defaultTargetPlatform == TargetPlatform.iOS
                              ? 80
                              : 65,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(Dimensions.radiusLarge)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 5)
                            ],
                          ),
                          child: Stack(
                            children: [
                              Center(
                                heightFactor: 0.2,
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context).cardColor,
                                        width: 5),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.1),
                                          blurRadius: 2,
                                          offset: const Offset(0, -2),
                                          spreadRadius: 0)
                                    ],
                                  ),
                                  child: FloatingActionButton(
                                    shape: const CircleBorder(),
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    onPressed: () {
                                      _setPage(2);
                                    },
                                    elevation: 0,
                                    child: Consumer<CartProvider>(
                                        builder: (context, cartProvider, _) {
                                      return Stack(
                                        children: [
                                          const CustomAssetImageWidget(
                                              Images.order,
                                              color: Colors.white,
                                              height: 30),
                                          if (cartProvider.cartList.isNotEmpty)
                                            Positioned(
                                                top: -4,
                                                right: 0,
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white,
                                                  ),
                                                  child: Text(
                                                      '${cartProvider.cartList.length}',
                                                      style: rubikSemiBold
                                                          .copyWith(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontSize: Dimensions
                                                            .paddingSizeSmall,
                                                      )),
                                                )),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              ),
                              ResponsiveHelper.isDesktop(context)
                                  ? const SizedBox()
                                  : Center(
                                      child: SizedBox(
                                        width: size.width,
                                        height: 80,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              BottomNavItemWidget(
                                                title: getTranslated(
                                                    'home', context)!,
                                                imageIcon: Images.homeSvg,
                                                isSelected: _pageIndex == 0,
                                                onTap: () => _setPage(0),
                                              ),
                                              BottomNavItemWidget(
                                                title: getTranslated(
                                                        'favourite', context)!
                                                    .toCapitalized(),
                                                imageIcon: Images.favoriteSvg,
                                                isSelected: _pageIndex == 1,
                                                onTap: () => _setPage(1),
                                              ),
                                              Container(
                                                  width: size.width * 0.2),
                                              BottomNavItemWidget(
                                                title: getTranslated(
                                                    'order', context)!,
                                                imageIcon: Images.shopSvg,
                                                isSelected: _pageIndex == 3,
                                                onTap: () => _setPage(3),
                                              ),
                                              BottomNavItemWidget(
                                                title: getTranslated(
                                                    'menu', context)!,
                                                imageIcon: Images.menuSvg,
                                                isSelected: _pageIndex == 4,
                                                onTap: () => _setPage(4),
                                              ),
                                            ]),
                                      ),
                                    ),
                            ],
                          ),
                        );
                      }),
                    ),
            ],
          ),
        ));
  }

  void _setPage(int pageIndex) {
    _pageController?.jumpToPage(pageIndex);
    setState(() {
      _pageIndex = pageIndex;
    });
  }
}
