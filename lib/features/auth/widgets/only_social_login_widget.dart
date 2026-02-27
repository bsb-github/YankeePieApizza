import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_alert_dialog_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_pop_scope_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_restaurant/features/auth/domain/models/social_login_model.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/auth/widgets/existing_account_bottom_sheet.dart';
import 'package:flutter_restaurant/features/profile/domain/models/userinfo_model.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class OnlySocialLoginWidget extends StatefulWidget {
  const OnlySocialLoginWidget({super.key});

  @override
  State<OnlySocialLoginWidget> createState() => _OnlySocialLoginWidgetState();
}

class _OnlySocialLoginWidgetState extends State<OnlySocialLoginWidget> {
  void route(
      bool isRoute,
      String? token,
      String errorMessage,
      String? tempToken,
      UserInfoModel? userInfoModel,
      String? socialLoginMedium) async {
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    if (isRoute) {
      if (token != null) {
        RouterHelper.getMainRoute(action: RouteAction.pushNamedAndRemoveUntil);
      } else if (tempToken != null) {
        RouterHelper.getOtpRegistrationScreen(
          tempToken,
          authProvider.googleAccount?.email ?? '',
          userName: authProvider.googleAccount?.displayName ?? '',
        );
      } else if (userInfoModel != null) {
        ResponsiveHelper.showDialogOrBottomSheet(
          context,
          CustomAlertDialogWidget(
            width: ResponsiveHelper.isDesktop(context)
                ? MediaQuery.of(context).size.width * 0.3
                : null,
            child: ExistingAccountBottomSheet(
                userInfoModel: userInfoModel, loginMedium: socialLoginMedium!),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage), backgroundColor: Colors.red));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final Size size = MediaQuery.of(context).size;
    final configModel =
        Provider.of<SplashProvider>(context, listen: false).configModel;
    final socialLogin = configModel?.customerLogin?.socialMediaLoginOptions;

    return CustomPopScopeWidget(
      child: Scaffold(
        appBar: ResponsiveHelper.isDesktop(context)
            ? const PreferredSize(
                preferredSize: Size.fromHeight(100), child: WebAppBarWidget())
            : null,
        body: SafeArea(
            child: Center(
                child: CustomScrollView(slivers: [
          SliverToBoxAdapter(
              child: Column(children: [
            SizedBox(
                height: ResponsiveHelper.isDesktop(context)
                    ? size.height * 0.05
                    : size.height * 0.08),
            Center(
                child: Container(
              width: width > 700 ? 450 : width,
              margin: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
              padding: width > 700
                  ? const EdgeInsets.all(Dimensions.paddingSizeDefault)
                  : null,
              decoration: width > 700
                  ? BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .color!
                              .withValues(alpha: 0.07),
                          blurRadius: 30,
                          spreadRadius: 0,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    )
                  : null,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: ResponsiveHelper.isDesktop(context)
                          ? size.height * 0.03
                          : size.height * 0.05,
                    ),
                    const Directionality(
                      textDirection: TextDirection.ltr,
                      child: CustomAssetImageWidget(Images.logoEfoodSvg,
                          height: 120, fit: BoxFit.scaleDown),
                    ),
                    SizedBox(height: size.height * 0.07),
                    Text(
                      getTranslated('welcome_to_eFood', context)!,
                      style: rubikRegular.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                    if (socialLogin?.google == 1) ...[
                      Row(children: [
                        Expanded(child: Container()),
                        Expanded(
                          flex: 4,
                          child: Consumer<AuthProvider>(
                              builder: (context, authProvider, child) {
                            return InkWell(
                              onTap: () async {
                                try {
                                  GoogleSignInAuthentication auth =
                                      await authProvider.googleLogin();
                                  GoogleSignInAccount googleAccount =
                                      authProvider.googleAccount!;

                                  authProvider.socialLogin(
                                      SocialLoginModel(
                                        email: googleAccount.email,
                                        token: auth.accessToken,
                                        uniqueId: googleAccount.id,
                                        medium: 'google',
                                      ),
                                      route);
                                } catch (er) {
                                  debugPrint('access token error is : $er');
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: Dimensions.paddingSizeDefault),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .hintColor
                                      .withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall),
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withValues(alpha: 0.1)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      Images.google,
                                      height:
                                          ResponsiveHelper.isDesktop(context)
                                              ? 20
                                              : ResponsiveHelper.isTab(context)
                                                  ? 20
                                                  : 15,
                                      width: ResponsiveHelper.isDesktop(context)
                                          ? 20
                                          : ResponsiveHelper.isTab(context)
                                              ? 20
                                              : 15,
                                    ),
                                    const SizedBox(
                                        width:
                                            Dimensions.paddingSizeExtraSmall),
                                    Text(
                                      getTranslated(
                                          "continue_with_google", context)!,
                                      style: rubikSemiBold.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                        Expanded(child: Container()),
                      ]),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                    ],
                    if (configModel?.isGuestCheckout == true &&
                        !Navigator.canPop(context)) ...[
                      Center(
                          child: Text(
                        getTranslated('or', context)!,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: Theme.of(context).hintColor,
                        ),
                      )),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Center(
                          child: InkWell(
                        onTap: () => RouterHelper.getDashboardRoute(
                          'home',
                        ),
                        child: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: '${getTranslated('continue_as_a', context)} ',
                            style: poppinsRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          TextSpan(
                            text: getTranslated('guest', context),
                            style: poppinsRegular.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ])),
                      )),
                      SizedBox(height: size.height * 0.03),
                    ],
                  ]),
            )),
            if (ResponsiveHelper.isDesktop(context)) const SizedBox(height: 50),
          ])),
          if (ResponsiveHelper.isDesktop(context))
            const SliverFillRemaining(
              hasScrollBody: false,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                SizedBox(height: Dimensions.paddingSizeLarge),
                FooterWidget(),
              ]),
            ),
        ]))),
      ),
    );
  }
}
