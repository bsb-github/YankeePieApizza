import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/menu/widgets/menu_web_widget.dart';
import 'package:flutter_restaurant/features/menu/widgets/options_widget.dart';
import 'package:flutter_restaurant/features/menu/widgets/theme_switch_button_widget.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class MenuScreen extends StatefulWidget {
  final Function? onTap;
  const MenuScreen({super.key,  this.onTap});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  @override
  Widget build(BuildContext context) {

    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Change as needed
      statusBarIconBrightness: Brightness.dark, // Change as needed
    ));

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBarWidget()) : null,
      body: ResponsiveHelper.isDesktop(context) ? const MenuWebWidget() : Consumer<AuthProvider>(
        builder: (context, authProvider, _) {

          final bool isLoggedIn = authProvider.isLoggedIn();

          return Column(children: [

            Consumer<ProfileProvider>(
              builder: (context, profileProvider, child) => Container(
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: Dimensions.paddingSizeExtraLarge, right: Dimensions.paddingSizeExtraLarge,
                    top: 50, bottom: Dimensions.paddingSizeExtraLarge,
                  ),
                  child: Row(children: [

                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(1),
                      child: ClipOval(
                        child: isLoggedIn ? CustomImageWidget(
                          placeholder: Images.placeholderUser, height: 80, width: 80, fit: BoxFit.cover,
                          image: '${splashProvider.baseUrls!.customerImageUrl}/'
                              '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel!.image : ''}',
                        ) : const CustomAssetImageWidget(Images.placeholderUserSvg, height: 80, width: 80, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                        isLoggedIn && profileProvider.userInfoModel == null ? Shimmer(
                          duration: const Duration(seconds: 2),
                          enabled: true,
                          child: Container(
                            height: Dimensions.paddingSizeDefault, width: 200,
                            decoration: BoxDecoration(
                              color: Theme.of(context).shadowColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            ),
                          ),
                        ) : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isLoggedIn ? '${profileProvider.userInfoModel?.fName} ${profileProvider.userInfoModel?.lName}' : getTranslated('guest', context)!,
                              style: rubikSemiBold,
                            ),

                            if(!isLoggedIn) TextButton(
                              onPressed: () => RouterHelper.getLoginRoute(),
                              style: TextButton.styleFrom(
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  padding: EdgeInsets.zero, foregroundColor: Colors.transparent
                              ),
                              child: Text(getTranslated('sign_up_or_login', context)!, style: rubikRegular.copyWith(
                              color: Theme.of(context).primaryColor,
                            ))),

                            if(isLoggedIn) Text(
                              profileProvider.userInfoModel?.email ?? '',
                              style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                            ) ,
                          ],
                        ),
                        // const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      ]),
                    ),

                    const ThemeSwitchButtonWidget(fromWebBar: false),

                  ]),
                ),
              ),
            ),

            Expanded(child: OptionsWidget(onTap: widget.onTap)),

          ]);
        }
      ),
    );
  }
}
