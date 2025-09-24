import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/features/wallet/providers/wallet_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_restaurant/common/widgets/no_data_widget.dart';
import 'package:flutter_restaurant/common/widgets/not_logged_in_widget.dart';
import 'package:flutter_restaurant/common/widgets/title_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_restaurant/features/loyalty_screen/widgets/tab_button_widget.dart';
import 'package:flutter_restaurant/features/wallet/screens/wallet_screen.dart';
import 'package:flutter_restaurant/features/wallet/widgets/convert_money_widget.dart';
import 'package:flutter_restaurant/features/wallet/widgets/history_item_widget.dart';
import 'package:provider/provider.dart';

class LoyaltyScreen extends StatefulWidget {
  const LoyaltyScreen({super.key,});

  @override
  State<LoyaltyScreen> createState() => _LoyaltyScreenState();
}

class _LoyaltyScreenState extends State<LoyaltyScreen> {
  final ScrollController scrollController = ScrollController();
  final bool _isLoggedIn = Provider.of<AuthProvider>(Get.context!, listen: false).isLoggedIn();

  @override
  void initState() {
    super.initState();
    final walletProvide = Provider.of<WalletProvider>(context, listen: false);

    walletProvide.setCurrentTabButton(
      0,
      isUpdate: false,
    );

    if(_isLoggedIn){
      Provider.of<ProfileProvider>(Get.context!, listen: false).getUserInfo(false, isUpdate: false);
      walletProvide.getLoyaltyTransactionList('1', false, false, isEarning: walletProvide.selectedTabButtonIndex == 1);

      scrollController.addListener(() {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent
            && walletProvide.transactionList != null
            && !walletProvide.isLoading) {

          int pageSize = (walletProvide.popularPageSize! / 10).ceil();
          if (walletProvide.offset < pageSize) {
            walletProvide.setOffset = walletProvide.offset + 1;
            walletProvide.updatePagination(true);


            walletProvide.getLoyaltyTransactionList(
              walletProvide.offset.toString(), false, false, isEarning: walletProvide.selectedTabButtonIndex == 1,
            );
          }
        }
      });
    }

  }
  @override
  void dispose() {
    super.dispose();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark, // dark text for status bar
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
    ));


    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ConfigModel configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).cardColor,
      appBar: ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBarWidget()) :
      CustomAppBarWidget(
        title: getTranslated("loyalty_points", context)!,
        centerTitle: true,
      ) as PreferredSizeWidget?,

      body: !configModel.loyaltyPointStatus! ? const NoDataWidget() : Consumer<ProfileProvider>(
          builder: (context, profileProvider, _) {
            return _isLoggedIn ? (!profileProvider.isLoading && profileProvider.userInfoModel != null) ? Consumer<WalletProvider>(builder: (context, walletProvider, _) {
              return Stack(children: [
                Column(children: [
                  Center(child: Container(
                    width: Dimensions.webScreenWidth,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30)),
                      color: Theme.of(context).primaryColor.withValues(alpha:0.2),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                    child: SafeArea(child: Column(children: [
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Image.asset(Images.loyal, width: 40, height: 40),
                          const SizedBox(width: Dimensions.paddingSizeDefault,),

                          profileProvider.isLoading ? const SizedBox() : CustomDirectionalityWidget(child: Text(
                            '${profileProvider.userInfoModel?.point ?? 0}', style: rubikBold.copyWith(
                            fontSize: Dimensions.fontSizeOverLarge,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                          )),
                        ],),
                        const SizedBox(height: Dimensions.paddingSizeDefault,),

                        Text(getTranslated('loyalty_point', context)!,
                          style: rubikBold.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault,),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: tabButtonList.map((tabButtonModel) =>
                                  TabButtonWidget(tabButtonModel: tabButtonModel,)).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge,),
                      ])),
                  )),

                  Expanded(child: RefreshIndicator(
                    color: Theme.of(context).cardColor,
                    backgroundColor: Theme.of(context).primaryColor,
                    onRefresh: () async{
                      walletProvider.getLoyaltyTransactionList('1', true,false, isEarning: walletProvider.selectedTabButtonIndex == 1);
                      profileProvider.getUserInfo(true);
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: scrollController,
                      child: Column(
                        children: [

                          SizedBox( width: Dimensions.webScreenWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [


                                if(walletProvider.selectedTabButtonIndex == 0)
                                  const ConvertMoneyWidget(),

                                if(walletProvider.selectedTabButtonIndex != 0)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                    child: Center(
                                      child: SizedBox(
                                        width: Dimensions.webScreenWidth,
                                        child: Consumer<WalletProvider>(
                                            builder: (context, walletProvider, _) {
                                              return Column(children: [

                                                Padding(
                                                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraLarge),
                                                  child: TitleWidget(title: getTranslated(
                                                    walletProvider.selectedTabButtonIndex == 0
                                                        ? 'enters_point_amount' : walletProvider.selectedTabButtonIndex == 1
                                                        ? 'point_earning_history' : 'point_converted_history', context,

                                                  )),
                                                ),

                                                walletProvider.transactionList != null ? walletProvider.transactionList!.isNotEmpty ? GridView.builder(
                                                  key: UniqueKey(),
                                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisSpacing: 20,
                                                    mainAxisExtent: 100,
                                                    crossAxisCount: ResponsiveHelper.isMobile() ? 1 : 2,
                                                  ),
                                                  physics:  const NeverScrollableScrollPhysics(),
                                                  shrinkWrap:  true,
                                                  itemCount: walletProvider.transactionList!.length ,
                                                  //padding: EdgeInsets.only(top: ResponsiveHelper.isDesktop(context) ? 28 : 25),
                                                  itemBuilder: (context, index) {
                                                    return Stack(
                                                      children: [
                                                        HistoryItemWidget(
                                                          index: index,formEarning: walletProvider.selectedTabButtonIndex == 1,
                                                          data: walletProvider.transactionList,
                                                        ),

                                                        if(walletProvider.paginationLoader && walletProvider.transactionList!.length == index + 1)
                                                          const Center(child: CircularProgressIndicator()),
                                                      ],
                                                    );
                                                  },
                                                ) : const NoDataWidget(isFooter: false) : WalletShimmer(walletProvider: walletProvider),

                                                walletProvider.isLoading ? const Center(child: Padding(
                                                  padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                                  child: CircularProgressIndicator(),
                                                )) : const SizedBox(),
                                              ]);
                                            }
                                        ),
                                      ),
                                    ),
                                  ),


                              ],
                            ),
                          ),

                          if(ResponsiveHelper.isDesktop(context)) Padding(
                            padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
                            child: const FooterWidget(),
                          ),
                        ],
                      ),
                    ),
                  )),
                ]),

              ]);
            }) : const Center(child: CircularProgressIndicator()) : const NotLoggedInWidget();
          }
      ),
    );
  }
}


