import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/not_logged_in_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/order/providers/order_provider.dart';
import 'package:flutter_restaurant/features/order/widgets/order_list_widget.dart';
import 'package:flutter_restaurant/features/order/widgets/order_web_widget.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late bool _isLoggedIn;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 2, initialIndex: _selectedIndex, vsync: this);
    _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (_isLoggedIn) {
      Provider.of<OrderProvider>(context, listen: false)
          .getOrderList(context, orderFilter: "ongoing");
      Provider.of<OrderProvider>(context, listen: false)
          .getOrderList(context, orderFilter: "history");
    }

    _tabController.addListener(() {
      _selectedIndex = _tabController.index;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(100), child: WebAppBarWidget())
          : CustomAppBarWidget(
              context: context,
              title: getTranslated('my_order', context),
              isBackButtonExist: !ResponsiveHelper.isMobile(),
            )) as PreferredSizeWidget?,
      body: _isLoggedIn
          ? Consumer<OrderProvider>(
              builder: (context, order, child) {
                return ResponsiveHelper.isDesktop(context)
                    ? const OrderWebWidget()
                    : Column(children: [
                        Expanded(
                            child: Center(
                                child: SizedBox(
                                    width: Dimensions.webScreenWidth,
                                    child: Column(children: [
                                      Center(
                                        child: Container(
                                          //width: 320,
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).canvasColor,
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .hintColor
                                                    .withValues(alpha: 0.2)),
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.radiusDefault),
                                          ),
                                          padding: const EdgeInsets.all(
                                              Dimensions.paddingSizeExtraSmall),
                                          margin: const EdgeInsets.symmetric(
                                              vertical:
                                                  Dimensions.paddingSizeDefault,
                                              horizontal:
                                                  Dimensions.paddingSizeLarge),
                                          child: TabBar(
                                            padding: EdgeInsets.zero,
                                            labelPadding: EdgeInsets.zero,
                                            controller: _tabController,
                                            dividerHeight: 0,
                                            indicator:
                                                const UnderlineTabIndicator(
                                                    borderSide:
                                                        BorderSide.none),
                                            onTap: (int index) {
                                              OrderProvider orderProvider =
                                                  Provider.of<OrderProvider>(
                                                      context,
                                                      listen: false);
                                              if (index == 0) {
                                                orderProvider.getOrderList(
                                                    context,
                                                    orderFilter: "ongoing");
                                              } else {
                                                orderProvider.getOrderList(
                                                    context,
                                                    orderFilter: "history");
                                              }
                                            },
                                            tabs: [
                                              Tab(
                                                  iconMargin: EdgeInsets.zero,
                                                  child: Container(
                                                    height: double.maxFinite,
                                                    width: double.maxFinite,
                                                    margin: EdgeInsets.zero,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(Dimensions
                                                              .radiusDefault),
                                                      color: _selectedIndex == 0
                                                          ? Theme.of(context)
                                                              .primaryColor
                                                          : Theme.of(context)
                                                              .canvasColor,
                                                    ),
                                                    child: Center(
                                                        child: Text(
                                                      getTranslated(
                                                          'ongoing', context)!,
                                                      style:
                                                          rubikRegular.copyWith(
                                                        color: _selectedIndex ==
                                                                0
                                                            ? Colors.white
                                                            : Theme.of(context)
                                                                .primaryColor,
                                                        fontWeight:
                                                            _selectedIndex == 0
                                                                ? FontWeight
                                                                    .w700
                                                                : FontWeight
                                                                    .w400,
                                                      ),
                                                    )),
                                                  )),
                                              Tab(
                                                  iconMargin: EdgeInsets.zero,
                                                  child: Container(
                                                    height: double.maxFinite,
                                                    width: double.maxFinite,
                                                    margin: EdgeInsets.zero,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(Dimensions
                                                              .radiusDefault),
                                                      color: _selectedIndex == 1
                                                          ? Theme.of(context)
                                                              .primaryColor
                                                          : Theme.of(context)
                                                              .canvasColor,
                                                    ),
                                                    child: Center(
                                                        child: Text(
                                                      getTranslated(
                                                          'history', context)!,
                                                      style:
                                                          rubikRegular.copyWith(
                                                        color: _selectedIndex ==
                                                                1
                                                            ? Theme.of(context)
                                                                .cardColor
                                                            : Theme.of(context)
                                                                .primaryColor,
                                                        fontWeight:
                                                            _selectedIndex == 0
                                                                ? FontWeight
                                                                    .w700
                                                                : FontWeight
                                                                    .w400,
                                                      ),
                                                    )),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(child: Consumer<OrderProvider>(
                                          builder: (ctx, orderProvider, _) {
                                        return TabBarView(
                                          controller: _tabController,
                                          children: [
                                            OrderListWidget(
                                              orderModel:
                                                  orderProvider.ongoingOrder,
                                              filterType: "ongoing",
                                            ),
                                            OrderListWidget(
                                              orderModel:
                                                  orderProvider.historyOrder,
                                              filterType: "history",
                                            ),
                                          ],
                                        );
                                      })),
                                    ])))),
                      ]);
              },
            )
          : const NotLoggedInWidget(),
    );
  }
}
