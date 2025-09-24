import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_alert_dialog_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/language/providers/localization_provider.dart';
import 'package:flutter_restaurant/features/menu/domain/models/menu_model.dart';
import 'package:flutter_restaurant/features/menu/widgets/header_item_details_widget.dart';
import 'package:flutter_restaurant/features/menu/widgets/menu_item_web_widget.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MenuWebWidget extends StatelessWidget {
  const MenuWebWidget({super.key});

  @override
  Widget build(BuildContext context) {

    final splashProvider =  Provider.of<SplashProvider>(context, listen: false);
    final bool isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    final LocalizationProvider localizationProvider = Provider.of<LocalizationProvider>(context, listen: false);


    final List<MenuModel> menuList = [
      MenuModel(icon: Images.profileSvg, title: getTranslated('profile', context), route:()=>  RouterHelper.getProfileRoute()),
      MenuModel(icon: Images.ordersSvg, title: getTranslated('my_order', context), route: ()=> RouterHelper.getDashboardRoute('order')),
      MenuModel(icon: Images.trackOrder, title: getTranslated('order_details', context), route:()=> RouterHelper.getOrderSearchScreen()),

      MenuModel(icon: Images.favoriteSvg, title: getTranslated('favourite', context), route: ()=> RouterHelper.getDashboardRoute('favourite')),
      MenuModel(icon: Images.notification, title: getTranslated('notification', context), route: ()=> RouterHelper.getNotificationRoute()),
      if(splashProvider.configModel!.walletStatus!)
        MenuModel(icon: Images.walletSvg, title: getTranslated('wallet', context), route:()=>  RouterHelper.getWalletRoute()),

      if(splashProvider.configModel!.loyaltyPointStatus!)
        MenuModel(icon: Images.loyaltyPointsSvg, title: getTranslated('loyalty_point', context), route:()=> RouterHelper.getLoyaltyScreen()),

      MenuModel(icon: Images.couponSvg, title: getTranslated('coupon', context), route:()=>  RouterHelper.getCouponRoute()),
      if(splashProvider.configModel!.referEarnStatus!)
        MenuModel(icon: Images.usersSvg, title: getTranslated('refer_and_earn', context), route:()=>  RouterHelper.getReferAndEarnRoute()),

      MenuModel(icon: Images.addressSvg, title: getTranslated('address', context), route:()=>  RouterHelper.getAddressRoute()),
      MenuModel(icon: Images.messageSvg, title: getTranslated('message', context), route:()=>  RouterHelper.getChatRoute()),
      MenuModel(icon: Images.infoSvg, title: getTranslated('about_us', context), route:()=>  RouterHelper.getAboutUsRoute()),
      MenuModel(icon: Images.supportSvg, title: getTranslated('help_and_support', context), route:()=>  RouterHelper.getSupportRoute()),

      MenuModel(icon: Images.documentSvg, title: getTranslated('privacy_policy', context), route:()=> RouterHelper.getPolicyRoute()),
      MenuModel(icon: Images.documentAltSvg, title: getTranslated('terms_and_condition', context), route:()=>  RouterHelper.getTermsRoute()),
      if(splashProvider.policyModel != null
          && splashProvider.policyModel!.returnPage != null
          && splashProvider.policyModel!.returnPage!.status!
      ) MenuModel(icon: Images.invoiceSvg, title: getTranslated('return_policy', context), route: ()=>  RouterHelper.getReturnPolicyRoute()),

      if(splashProvider.policyModel != null
          && splashProvider.policyModel!.refundPage != null
          && splashProvider.policyModel!.refundPage!.status!
      ) MenuModel(icon: Images.refundSvg, title: getTranslated('refund_policy', context), route: ()=>  RouterHelper.getRefundPolicyRoute()),

      if(splashProvider.policyModel != null
          && splashProvider.policyModel!.cancellationPage != null
          && splashProvider.policyModel!.cancellationPage!.status!
      ) MenuModel(icon: Images.cancellationSvg, title: getTranslated('cancellation_policy', context)?.replaceAll(' ', '\n'), route:()=>  RouterHelper.getCancellationPolicyRoute()),

      MenuModel(
        icon: isLoggedIn ? Images.logoutSvg : Images.login, title: getTranslated(isLoggedIn ? 'logout' : 'login', context),
        route: isLoggedIn ? (){
          ResponsiveHelper.showDialogOrBottomSheet(context, Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                return CustomAlertDialogWidget(
                  isLoading: authProvider.isLoading,
                  title: getTranslated('want_to_sign_out', context),
                  icon: Icons.contact_support,
                  isSingleButton: authProvider.isLoading,
                  leftButtonText: getTranslated('yes', context),
                  rightButtonText: getTranslated('no', context),
                  onPressLeft: () {
                    authProvider.clearSharedData(context).then((condition) {
                     if(context.mounted){
                       if(ResponsiveHelper.isWeb()) {
                         RouterHelper.getLoginRoute(action: RouteAction.pushNamedAndRemoveUntil);
                       }else {
                         context.pop();
                         RouterHelper.getMainRoute();
                       }
                     }
                    });
                  },

                );
              }
          ));
        } : ()=> RouterHelper.getLoginRoute(),
        showActive: true,
      ),
    ];

    return SingleChildScrollView(child: Column(children: [

      Center(child: Consumer<ProfileProvider>(builder: (context, profileProvider, child) {
        return SizedBox(width: 1170, child: Column(children: [

          Stack(children: [
            Transform.translate(offset: const Offset(0, -1), child: Container(
              height: 150,
              decoration: BoxDecoration(
                color:  ColorResources.getProfileMenuHeaderColor(context),
                border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:0.2), width: 1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(Dimensions.radiusDefault),
                  bottomRight: Radius.circular(Dimensions.radiusDefault),
                ),
              ),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
              child: Row(children: [

                Container(
                  height: 100, width: 100,
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [BoxShadow(color: Colors.white.withValues(alpha:0.1), blurRadius: 22, offset: const Offset(0, 8.8) )]),
                  child: ClipOval(
                    child: isLoggedIn ? CustomImageWidget(
                      placeholder: Images.placeholderUser, height: 100, width: 100, fit: BoxFit.cover,
                      image: '${splashProvider.baseUrls?.customerImageUrl}/''${profileProvider.userInfoModel?.image ?? '' }',
                    ) : Image.asset(Images.placeholderUser, height: 100, width: 100, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                if(!isLoggedIn)
                  HeaderItemDetailsWidget(title: getTranslated('guest', context)!, showDivider: false),

                if(isLoggedIn)...[
                  if(profileProvider.userInfoModel != null)
                    HeaderItemDetailsWidget(
                      title: '${profileProvider.userInfoModel?.fName ?? ''} ${profileProvider.userInfoModel?.lName ?? ''}',
                      subTitle: profileProvider.userInfoModel?.email ?? '',
                    ),

                  if(splashProvider.configModel?.loyaltyPointStatus ?? false) HeaderItemDetailsWidget(
                    title: '${(profileProvider.userInfoModel?.point ?? 0)}',
                    subTitle: getTranslated('loyalty_point', context)!,
                  ),

                  if(splashProvider.configModel?.walletStatus ?? false) HeaderItemDetailsWidget(
                    title: PriceConverterHelper.convertPrice(profileProvider.userInfoModel?.walletBalance ?? 0),
                    subTitle: getTranslated('wallet_balance', context)!,
                  ),

                  HeaderItemDetailsWidget(title: '${profileProvider.userInfoModel?.ordersCount ?? 0}', subTitle: getTranslated('total_order', context)!),

                  HeaderItemDetailsWidget(title: '${profileProvider.userInfoModel?.wishListCount ?? 0}', subTitle: getTranslated('favourite', context)!, showDivider: false),
                ]

              ],
              ),
            )),

            Positioned(
                right: localizationProvider.isLtr ?  0 : null,
                top: Dimensions.paddingSizeSmall,
                left: localizationProvider.isLtr ? null : 0,
                child: isLoggedIn ? Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: InkWell(
                    onTap: (){
                      ResponsiveHelper.showDialogOrBottomSheet(context, Consumer<AuthProvider>(
                          builder: (context, authProvider, _) {
                            return CustomAlertDialogWidget(
                              isLoading: authProvider.isLoading,
                              title: getTranslated('are_you_sure_to_delete_account', context),
                              subTitle: getTranslated('it_will_remove_your_all_information', context),
                              icon: Icons.question_mark_sharp,
                              isSingleButton: authProvider.isLoading,
                              leftButtonText: getTranslated('yes', context),
                              rightButtonText: getTranslated('no', context),
                              onPressLeft: () => authProvider.deleteUser(),
                            );
                          }
                          ));
                      },

                child: Row(children: [
                  Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                    child: Icon(Icons.delete, color: Theme.of(context).primaryColor, size: 16),
                  ),

                  Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                    child: Text(getTranslated('delete_account', context)!),
                  ),
                ],),
              ),

            ) : const SizedBox()),
          ]),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              crossAxisSpacing: Dimensions.paddingSizeExtraLarge,
              mainAxisSpacing: Dimensions.paddingSizeExtraLarge,
            ),
            itemCount: menuList.length,
            itemBuilder: (context, index) => MenuItemWebWidget(menu: menuList[index]),
          ),
          const SizedBox(height: 50),

          Text('${getTranslated('version', context)} ${ AppConstants.appVersion}'),
          const SizedBox(height: 50),

        ]));
      })),

      const FooterWidget(),

    ]));
  }
}