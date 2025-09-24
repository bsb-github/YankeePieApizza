import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/common/widgets/no_data_widget.dart';
import 'package:flutter_restaurant/common/widgets/not_logged_in_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/refer_and_earn/widgets/refer_and_earn_web_widget.dart';
import 'package:flutter_restaurant/features/refer_and_earn/widgets/refer_hint_view.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({super.key});

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  final List<String?> hintList = [
    getTranslated('invite_your_friends', Get.context!),
    '${getTranslated('they_register', Get.context!)} ${AppConstants.appName} ${getTranslated('with_special_offer', Get.context!)}',
    getTranslated('you_made_your_earning', Get.context!),
  ];
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    final ConfigModel configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;

    return Scaffold(
      backgroundColor: ResponsiveHelper.isDesktop(context) || !_isLoggedIn ? Theme.of(context).canvasColor : Theme.of(context).primaryColor,
      appBar: (ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBarWidget())
          : CustomAppBarWidget(
                context: context,
                title: getTranslated('refer_and_earn', context),
                isTransparent: _isLoggedIn,
                titleColor: _isLoggedIn ? Colors.white : null,
                centerTitle: true,
              )) as PreferredSizeWidget?,

      body: _isLoggedIn ? configModel.referEarnStatus!
        ? Center(child: ExpandableBottomSheet(
          background: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.zero : const EdgeInsets.symmetric(
              // horizontal: Dimensions.paddingSizeDefault,
              vertical: Dimensions.paddingSizeExtraSmall,
            ),
            child: Column(
              children: [
                SizedBox(
                  width: ResponsiveHelper.isDesktop(context) ?  Dimensions.webScreenWidth : double.maxFinite,
                  child: Consumer<ProfileProvider>(
                    builder: (context, profileProvider, _) {
                      return profileProvider.userInfoModel != null ? ResponsiveHelper.isDesktop(context)
                        ? ReferAndEarnWebWidget(hintList: hintList) : Column(children: [

                          ///Header Section
                          SizedBox(
                            height: size.height * 0.3,
                            child: Row(children: [

                              Expanded(child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                child: Text(
                                  '${getTranslated('help_your_friends', context)!}\n${getTranslated('discover_efood', context)!}',
                                  textAlign: TextAlign.left,
                                  style: rubikSemiBold.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                    color: Colors.white ,
                                  ),
                                ),
                              )),

                              const Expanded(child: CustomAssetImageWidget(Images.referBanner, fit: BoxFit.contain)),

                            ]),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          ///Body Section
                          Container(
                            height: size.height * 0.7,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(Dimensions.radiusDefault),
                                topRight: Radius.circular(Dimensions.radiusDefault),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start , children: [

                                ///Middle Card
                                Container(
                                  transform: Matrix4.translationValues(0, -35, 0),
                                  margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                                    boxShadow: [BoxShadow(
                                      color: Theme.of(context).shadowColor.withValues(alpha:0.5),
                                      blurRadius: 10, spreadRadius: 1,
                                      offset: const Offset(2, 2),
                                    )],
                                  ),
                                  child: Row(children: [

                                    const ClipOval(child: SizedBox(
                                      height: 55, width: 45,
                                      child: CustomAssetImageWidget(Images.copyReferralCodeSvg),
                                    )),
                                    const SizedBox(width: Dimensions.paddingSizeDefault),

                                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text(
                                        getTranslated('copy_your_code', context)!,
                                        style: rubikSemiBold.copyWith(
                                          fontSize: Dimensions.fontSizeLarge,
                                        ),
                                      ),
                                      const SizedBox(height: Dimensions.paddingSizeSmall),
                                      Text(
                                        '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel!.referCode : ''}',
                                        style: rubikRegular.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ])),
                                    const SizedBox(width: Dimensions.paddingSizeDefault),

                                    IconButton(
                                      onPressed: (){
                                        if(profileProvider.userInfoModel!.referCode != null && profileProvider.userInfoModel!.referCode  != ''){
                                          Clipboard.setData(ClipboardData(text: '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel!.referCode : ''}'));
                                          showCustomSnackBarHelper(getTranslated('referral_code_copied', context), isError: false);
                                        }
                                      },
                                      icon: CustomAssetImageWidget(Images.copySvg, color: Theme.of(context).primaryColor),
                                    ),

                                  ]),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                                ///Share Section
                                Center(child: Text(
                                  getTranslated('or_share', context)!,
                                  style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                                )),
                                const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                                Center(child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () => Share.share(profileProvider.userInfoModel!.referCode!, subject: profileProvider.userInfoModel!.referCode!),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                    child: Image.asset(
                                      Images.share, height: 50, width: 50,
                                    ),
                                  ),
                                )),

                                if(ResponsiveHelper.isDesktop(context))
                                  Column(children: [
                                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                                    ReferHintView(hintList: hintList),
                                  ]),

                            ]),
                          ),
                        ),

                        /*DottedBorder(
                          padding: const EdgeInsets.all(4),
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(20),
                          dashPattern: const [5, 5],
                          color: Theme.of(context).primaryColor.withValues(alpha:0.5),
                          strokeWidth: 2,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                  child: Text(profileProvider.userInfoModel!.referCode ?? '',
                                    style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                                  ),
                                ),

                                InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () {

                                    if(profileProvider.userInfoModel!.referCode != null && profileProvider.userInfoModel!.referCode  != ''){
                                      Clipboard.setData(ClipboardData(text: '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel!.referCode : ''}'));
                                      showCustomSnackBarHelper(getTranslated('referral_code_copied', context), isError: false);
                                    }
                                  },
                                  child: Container(
                                    width: 85,
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(60),
                                    ),
                                    child: Text(getTranslated('copy', context)!,style: rubikRegular.copyWith(
                                      fontSize: Dimensions.fontSizeExtraLarge, color: Colors.white.withValues(alpha:0.9),
                                    )),
                                  ),
                                ),

                              ]),
                        ),*/

                      ]) : const SizedBox();
                    }
                  ),
                ),

                if(ResponsiveHelper.isDesktop(context)) const FooterWidget(),
              ],
            ),
          ),
          persistentContentHeight: size.height * 0.2,
          expandableContent: ResponsiveHelper.isDesktop(context) ? const SizedBox() : ReferHintView(hintList: hintList),
        )) : const NoDataWidget()
        : const NotLoggedInWidget(),
    );
  }
}
