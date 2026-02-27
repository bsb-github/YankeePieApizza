import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_alert_dialog_widget.dart';
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

class SocialLoginWidget extends StatefulWidget {
  const SocialLoginWidget({super.key});

  @override
  State<SocialLoginWidget> createState() => _SocialLoginWidgetState();
}

class _SocialLoginWidgetState extends State<SocialLoginWidget> {
  SocialLoginModel socialLogin = SocialLoginModel();

  void route(
      bool isRoute,
      String? token,
      String errorMessage,
      String? tempToken,
      UserInfoModel? userInfoModel,
      String? socialLoginMedium,
      SocialLoginModel? socialLoginModel) async {
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    if (isRoute) {
      if (token != null) {
        RouterHelper.getMainRoute(action: RouteAction.pushNamedAndRemoveUntil);
      } else if (tempToken != null) {
        RouterHelper.getOtpRegistrationScreen(
          tempToken,
          socialLoginModel?.email ?? '',
          userName: authProvider.googleAccount?.displayName ?? '',
        );
      } else if (userInfoModel != null) {
        ResponsiveHelper.showDialogOrBottomSheet(
          context,
          isDismissible: false,
          CustomAlertDialogWidget(
            width: ResponsiveHelper.isDesktop(context)
                ? MediaQuery.of(context).size.width * 0.3
                : null,
            child: ExistingAccountBottomSheet(
              userInfoModel: userInfoModel,
              loginMedium: socialLoginMedium!,
            ),
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
    final ConfigModel? configModel =
        Provider.of<SplashProvider>(context, listen: false).configModel;
    final socialLoginConfig =
        configModel?.customerLogin?.socialMediaLoginOptions;

    return Consumer<AuthProvider>(builder: (context, authProvider, _) {
      if (socialLoginConfig?.google == 1) {
        return Row(children: [
          Expanded(
              child: InkWell(
            onTap: () async {
              try {
                GoogleSignInAuthentication auth =
                    await authProvider.googleLogin();
                GoogleSignInAccount googleAccount = authProvider.googleAccount!;

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
            child: SocialLoginButtonWidget(
              text: getTranslated('continue_with_google', context)!,
              image: Images.google,
            ),
          )),
        ]);
      } else {
        return Container();
      }
    });
  }
}

class SocialLoginButtonWidget extends StatelessWidget {
  final String? text;
  final String image;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  const SocialLoginButtonWidget({
    super.key,
    this.text,
    required this.image,
    this.color,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        border: Border.all(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            color: color,
            height: ResponsiveHelper.isDesktop(context)
                ? 25
                : ResponsiveHelper.isTab(context)
                    ? 20
                    : 15,
            width: ResponsiveHelper.isDesktop(context)
                ? 25
                : ResponsiveHelper.isTab(context)
                    ? 20
                    : 15,
          ),
          if (text != null) ...[
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            Text(
              text!,
              style: rubikSemiBold.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            )
          ],
        ],
      ),
    );
  }
}
