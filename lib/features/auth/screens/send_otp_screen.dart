import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_pop_scope_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_restaurant/features/auth/domain/models/user_log_data.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/auth/widgets/social_login_widget.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/number_checker_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class SendOtpScreen extends StatefulWidget {
  const SendOtpScreen({super.key});

  @override
  State<SendOtpScreen> createState() => _SendOtpScreenState();
}

class _SendOtpScreenState extends State<SendOtpScreen> {

  String? countryCode;
  TextEditingController? _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _phoneNumberController = TextEditingController();

    final ConfigModel configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;
    final AuthProvider authProvider =  Provider.of<AuthProvider>(context, listen: false);
    authProvider.toggleIsNumberLogin(value: false, isUpdate: false);

    UserLogData? userData = authProvider.getUserData();
    if(userData != null) {
      if(userData.phoneNumber != null){
        _phoneNumberController!.text = NumberCheckerHelper.getPhoneNumber(userData.phoneNumber ?? '', userData.countryCode ?? '') ?? '';
        authProvider.toggleIsNumberLogin(isUpdate: false);
      }
      countryCode ??= userData.countryCode;
    }else{
      countryCode ??= CountryCode.fromCountryCode(configModel.countryCode!).dialCode;
    }

  }

  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width;
    final Size size = MediaQuery.of(context).size;
    final ConfigModel configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;
    final SocialMediaLoginOptions? socialStatus = configModel.customerLogin?.socialMediaLoginOptions;

    return CustomPopScopeWidget(
      child: Scaffold(
        appBar: ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBarWidget()) : null,
        body: SafeArea(
          child: Center(
            child: CustomScrollView(slivers: [
      
              SliverToBoxAdapter(child: Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      
                  if(ResponsiveHelper.isDesktop(context))
                    SizedBox(height: size.width * 0.02),
      
                  Center(child: Container(
                    width: width > 700 ? 450 : width,
                    margin: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                    padding: width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
                    decoration: width > 700 ? BoxDecoration(
                      color: Theme.of(context).canvasColor, borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.07),
                          blurRadius: 30,
                          offset: const Offset(0,10),
                          spreadRadius: 0,
                        ),
                      ],
                    ) : null,
                    child: Center(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      
                        SizedBox(height: ResponsiveHelper.isDesktop(context) ? size.height * 0.08 : size.height * 0.14),
      
                        Consumer<SplashProvider>(
                          builder: (context, splash, child) {
                            return Directionality(
                              textDirection: TextDirection.ltr,
                              child: CustomImageWidget(
                                image: '${splash.baseUrls?.restaurantImageUrl}/${splash.configModel!.restaurantLogo}',
                                placeholder: Images.webAppBarLogo,
                                fit: BoxFit.contain,
                                width: 120, height: 80,
                              ),
                            );
                          }
                        ),
      
                        SizedBox(height: size.height * 0.1),
      
                        Row(children: [
      
                          Expanded(child: Container()),
      
                          Expanded(flex: 7, child: Column(children: [
                                    
                            CustomTextFieldWidget(
                              countryDialCode: countryCode,
                              onCountryChanged: (CountryCode value) {
                                countryCode = value.dialCode;
                              },
                              hintText: getTranslated('number_hint', context),
                              isShowBorder: true,
                              controller: _phoneNumberController,
                              inputType: TextInputType.phone,
                              label: getTranslated('mobile_number', context),
                            ),
                            SizedBox(height: size.height * 0.03),
                                    
                            Consumer<AuthProvider>(builder: (context, authProvider, child) {
                              return InkWell(
                                onTap: ()=> authProvider.toggleRememberMe(),
                                child: Row(children: [
      
                                  Container(width: 18, height: 18,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Theme.of(context).secondaryHeaderColor),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: authProvider.isActiveRememberMe
                                        ? Icon(Icons.done, color: Theme.of(context).secondaryHeaderColor, size: 14)
                                        : const SizedBox.shrink(),
                                    ),
                                  const SizedBox(width: Dimensions.paddingSizeSmall),
      
                                  Text(getTranslated('remember_me', context)!,
                                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: ColorResources.getHintColor(context),
                                    ),
                                  ),
                                  const SizedBox(height: Dimensions.paddingSizeSmall),
      
                                ]),
                              );
                            }),
                            SizedBox(height: size.height * 0.03),
      
                            Consumer<AuthProvider>(builder: (context, authProvider, child) {
                              return !authProvider.isPhoneNumberVerificationButtonLoading? CustomButtonWidget(
                                btnTxt: getTranslated('get_otp', context),
                                onTap: () async {
      
                                  if (_phoneNumberController!.text.isEmpty) {
                                    showCustomSnackBarHelper(getTranslated('enter_phone_number', context));
                                  }else {
                                    String phoneWithCountryCode = countryCode! + _phoneNumberController!.text.trim();
                                    if(configModel.customerVerification?.firebase == 1) {
                                      await authProvider.firebaseVerifyPhoneNumber(phoneWithCountryCode);
                                    } else if(configModel.customerVerification?.phone == 1){
                                      await authProvider.checkPhoneForOtp(phoneWithCountryCode);
                                    }
                                  }
      
                                },
                              ) : Center(child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                              ),);
                            }),
                            const SizedBox(height: Dimensions.paddingSizeExtraLarge),
      
                            if(_isShowSocialLoginButton(configModel, socialStatus))...[
                              Center(child: Text(
                                  getTranslated('or', context)!,
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeDefault),
      
                              const SocialLoginWidget(),
                              const SizedBox(height: Dimensions.paddingSizeLarge),
                            ],
      
                          ])),
      
                          Expanded(child: Container()),
      
                        ]),
      
      
      
                        if(configModel.isGuestCheckout == true && !Navigator.canPop(context))...[
                          Center(child: InkWell(
                            onTap: () => RouterHelper.getDashboardRoute('home', ),
                            child: RichText(text: TextSpan(children: [
                              TextSpan(text: '${getTranslated('continue_as_a', context)} ',
                                style: poppinsRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              TextSpan(text: getTranslated('guest', context),
                                style: poppinsRegular.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],),),
                          )),
      
                        ],
      
                        if(ResponsiveHelper.isDesktop(context)) SizedBox(height: size.height * 0.02),
      
      
                      ]),
                    ),
                  )),
      
                  if(ResponsiveHelper.isDesktop(context))
                    SizedBox(height: size.width * 0.02),
      
                ]),
              )),
      
              if(ResponsiveHelper.isDesktop(context)) const SliverFillRemaining(
                hasScrollBody: false,
                child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  SizedBox(height: Dimensions.paddingSizeLarge),
      
                  FooterWidget(),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}


bool _isShowSocialLoginButton (ConfigModel configModel, SocialMediaLoginOptions? socialStatus){
  return (configModel.customerLogin?.loginOption?.socialMediaLogin == 1)
      && (configModel.customerLogin?.loginOption?.manualLogin != 1)
      && ( (socialStatus?.apple == 1 && defaultTargetPlatform == TargetPlatform.iOS)
          || socialStatus?.google == 1
          || socialStatus?.facebook == 1
      );
}