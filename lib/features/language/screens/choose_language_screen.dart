import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_pop_scope_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_restaurant/features/category/providers/category_provider.dart';
import 'package:flutter_restaurant/features/language/providers/language_provider.dart';
import 'package:flutter_restaurant/features/language/widgets/language_widget.dart';
import 'package:flutter_restaurant/features/onboarding/providers/onboarding_provider.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/language/providers/localization_provider.dart';
import 'package:flutter_restaurant/common/providers/product_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ChooseLanguageScreen extends StatefulWidget {
  final bool fromMenu;
  const ChooseLanguageScreen({super.key, this.fromMenu = false});

  @override
  State<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> {

  @override
  void initState() {
    super.initState();

    final LanguageProvider languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final LocalizationProvider localizationProvider = Provider.of<LocalizationProvider>(context, listen: false);

    languageProvider.initializeAllLanguages(context);
    languageProvider.setSelectIndex(languageProvider.getLanguageIndexByCode(localizationProvider.locale.languageCode), isUpdate: false);
  }

  @override
  Widget build(BuildContext context) {

    final OnBoardingProvider onBoardingProvider = Provider.of<OnBoardingProvider>(context, listen: false);
    final double width = MediaQuery.of(context).size.width;


    final routes = Navigator.of(context).widget.pages;

    for (var route in routes) {
      if (kDebugMode) {
        print(route.name);
      } // Print the name of each route
    }

    return CustomPopScopeWidget(
      child: Scaffold(
        appBar: ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBarWidget()) : PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: CustomAppBarWidget(
            title: '',
            isBackButtonExist: Navigator.canPop(context),
            onBackPressed: ()=> Navigator.pop(context),

          ),
        ),
        body: SafeArea(
          child: Center(
            child: Container(
              padding:width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeLarge) : EdgeInsets.zero,
              child: Container(
                width: width > 700 ? 700 : width,
                padding: width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 80),
                    const Center(child: SizedBox(width: 65, height: 65, child: CustomAssetImageWidget(Images.chooseLanguage))),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    Center(child: Text(
                      getTranslated('choose_language', context)!,
                      textAlign: TextAlign.center,
                      style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color),
                    )),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    Center(child: Text(
                      getTranslated('you_want_to_see_for_the_app', context)!,
                      textAlign: TextAlign.center,
                      style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                    )),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                    Consumer<LanguageProvider>(
                      builder: (context, languageProvider, child) => Expanded(
                        child: Scrollbar(child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Center(child: SizedBox(
                            width: 1170,
                            child: ListView.separated(
                              separatorBuilder: (context, index) => const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                              itemCount: languageProvider.languages.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) => LanguageWidget(
                                context: context, languageModel: languageProvider.languages[index],
                                languageProvider: languageProvider, index: index,
                              ),
                            ),
                          )),
                        )),
                      ),
                    ),

                    Consumer<LanguageProvider>(builder: (context, languageProvider, child) => Center(
                      child: Container(
                        width: 1170,
                        padding: const EdgeInsets.only(
                          left: Dimensions.paddingSizeLarge,
                          right: Dimensions.paddingSizeLarge,
                          bottom: Dimensions.paddingSizeLarge,
                          top: Dimensions.paddingSizeLarge,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          boxShadow: [BoxShadow(
                            color: Theme.of(context).shadowColor.withValues(alpha:0.5),
                            // offset: const Offset(0, -5),
                            spreadRadius: Dimensions.radiusDefault,
                            blurRadius: Dimensions.radiusLarge,
                          )],
                        ),
                        child: CustomButtonWidget(
                          btnTxt: getTranslated('save', context),
                          onTap: () {
                            onBoardingProvider.toggleShowOnBoardingStatus();


                            if(languageProvider.languages.isNotEmpty && languageProvider.selectIndex != -1) {
                              Provider.of<LocalizationProvider>(context, listen: false).setLanguage(Locale(
                                AppConstants.languages[languageProvider.selectIndex!].languageCode!,
                                AppConstants.languages[languageProvider.selectIndex!].countryCode,
                              ), isDataUpdate: widget.fromMenu);

                              if (widget.fromMenu) {

                                context.pop();
                                Provider.of<ProductProvider>(context, listen: false).getLatestProductList(1, true);
                                Provider.of<CategoryProvider>(context, listen: false).getCategoryList(true);
                              } else {
                                ResponsiveHelper.isWeb()
                                    ? RouterHelper.getMainRoute()
                                    : RouterHelper.getOnBoardingRoute(action: RouteAction.pushNamedAndRemoveUntil);
                              }
                            }else {
                              showCustomSnackBarHelper(getTranslated('select_a_language', context));
                            }
                          },
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
