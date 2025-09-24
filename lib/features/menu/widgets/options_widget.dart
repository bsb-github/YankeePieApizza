import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_alert_dialog_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/menu/widgets/card_button_widget.dart';
import 'package:flutter_restaurant/features/menu/widgets/portion_widget.dart';
import 'package:flutter_restaurant/features/scaner/screens/scaner_screen.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class OptionsWidget extends StatelessWidget {
  final Function? onTap;
  const OptionsWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {

    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final bool isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    return Consumer<AuthProvider>(builder: (context, authProvider, _)=> SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Ink(
        padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
        child: Column(children: [

          SizedBox(height: MediaQuery.sizeOf(context).height * 0.13,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              child: Row(children: [

                Expanded(
                  child: CardButtonWidget(
                    title: getTranslated('favourite', context)!,
                    image: Images.favoriteSvg,
                    onTap: () => RouterHelper.getDashboardRoute('favourite'),
                  ),
                ),

                if(splashProvider.configModel?.walletStatus ?? false) Expanded(
                  child: CardButtonWidget(
                    title: getTranslated('wallet', context)!,
                    image: Images.walletSvg,
                    onTap: () => RouterHelper.getWalletRoute(),
                  ),
                ),


                if(splashProvider.configModel?.loyaltyPointStatus ?? false) Expanded(
                  child: CardButtonWidget(
                    title: getTranslated('loyalty_point', context)!,
                    image: Images.loyaltyPointsSvg,
                    onTap: () => RouterHelper.getLoyaltyScreen(),
                  ),
                )],
              ),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: Text(getTranslated('general', context)!, style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
            ),

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
              ),
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
              margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(children: [
                PortionWidget(imageIcon: Images.profileSvg, title: getTranslated('profile', context)!, onRoute:()=> RouterHelper.getProfileRoute()),
                PortionWidget(imageIcon: Images.ordersSvg , title: getTranslated('my_order', context)!, onRoute:()=> RouterHelper.getDashboardRoute('order')),
                PortionWidget(imageIcon: Images.trackOrder, title: getTranslated('order_details', context)!, onRoute:()=> RouterHelper.getOrderSearchScreen()),
                PortionWidget(imageIcon: Images.notification, title: getTranslated('notification', context)!, onRoute:()=> RouterHelper.getNotificationRoute()),
                if(!kIsWeb) PortionWidget(imageIcon: Images.scanner, title: getTranslated('qr_scan', context)!, onRoute:()=> Get.navigator!.push(MaterialPageRoute(builder: (context) => const ScannerScreen()))),
                PortionWidget(imageIcon: Images.addressSvg, title: getTranslated('address', context)!, onRoute:()=> RouterHelper.getAddressRoute()),
                PortionWidget(imageIcon: Images.messageSvg, title: getTranslated('message', context)!, onRoute:()=> RouterHelper.getChatRoute()),
                PortionWidget(imageIcon: Images.couponSvg, title: getTranslated('coupon', context)!, onRoute:()=> RouterHelper.getCouponRoute()),
                if(splashProvider.configModel?.referEarnStatus ?? false)
                PortionWidget(imageIcon: Images.usersSvg, title: getTranslated('refer_and_earn', context)!, onRoute:()=> RouterHelper.getReferAndEarnRoute()),
                PortionWidget(imageIcon: Images.languageSvg, title: getTranslated('language', context)!, onRoute:()=> RouterHelper.getLanguageRoute(true), hideDivider: true),
              ]),
            )
          ]),


          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: Text(getTranslated('menu_more', context)!, style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
            ),

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
              ),
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
              margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(children: [
                PortionWidget(imageIcon: Images.supportSvg, title: getTranslated('help_and_support', context)!, onRoute:()=> RouterHelper.getSupportRoute()),
                PortionWidget(imageIcon: Images.documentSvg, title: getTranslated('privacy_policy', context)!, onRoute:()=> RouterHelper.getPolicyRoute()),
                PortionWidget(imageIcon: Images.documentAltSvg, title: getTranslated('terms_and_condition', context)!, onRoute:()=> RouterHelper.getTermsRoute()),
                if(splashProvider.policyModel?.returnPage?.status ?? false)
                  PortionWidget(imageIcon: Images.invoiceSvg, title: getTranslated('return_policy', context)!, onRoute:()=> RouterHelper.getReturnPolicyRoute()),

                if(splashProvider.policyModel?.refundPage?.status ?? false)
                  PortionWidget(imageIcon: Images.refundSvg, title: getTranslated('refund_policy', context)!, onRoute:()=> RouterHelper.getRefundPolicyRoute()),

                if(splashProvider.policyModel?.cancellationPage?.status ?? false)
                  PortionWidget(imageIcon: Images.cancellationSvg, title: getTranslated('cancellation_policy', context)!, onRoute:()=> RouterHelper.getCancellationPolicyRoute()),

                PortionWidget(imageIcon: Images.infoSvg, title: getTranslated('about_us', context)!, onRoute:()=> RouterHelper.getAboutUsRoute()),

                isLoggedIn ? PortionWidget(
                  iconColor: Theme.of(context).primaryColor,
                  icon: Icons.delete,
                  imageIcon: null,
                  title: getTranslated('delete_account', context)!,
                  onRoute:()=> ResponsiveHelper.showDialogOrBottomSheet(context, Consumer<AuthProvider>(
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
                  )),
                ): const SizedBox(),

                InkWell(
                  onTap: (){
                    if(authProvider.isLoggedIn()) {
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
                                    RouterHelper.getLoginRoute(action: RouteAction.popAndPush);
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

                    }else {
                      RouterHelper.getLoginRoute();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                    child: Row(children: [
                      Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                        margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor.withValues(alpha:0.1),
                        ),
                        child: CustomAssetImageWidget(
                          isLoggedIn ? Images.logoutSvg : Images.login, height: 16, width: 16,
                          color: isLoggedIn ? null : Theme.of(context).primaryColor,
                        ),
                      ),

                      Text(getTranslated(isLoggedIn ? 'logout' : 'login', context)!, style: rubikRegular)
                    ]),
                  ),
                ),

              ]),
            )
          ]),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          Text('${getTranslated('v', context)} ${AppConstants.appVersion}', style: rubikRegular.copyWith(
            color: Theme.of(context).textTheme.titleMedium?.color?.withValues(alpha:0.4),
          )),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

        ]),
      ),
    ));
  }
}
