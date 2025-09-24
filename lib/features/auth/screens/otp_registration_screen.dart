import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_restaurant/features/auth/domain/models/signup_model.dart';
import 'package:flutter_restaurant/features/auth/domain/models/user_log_data.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/number_checker_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class OtpRegistrationScreen extends StatefulWidget {
  final String tempToken;
  final String userInput;
  final String? userName;
  const OtpRegistrationScreen({super.key, required this.tempToken, required this.userInput, this.userName});

  @override
  State<OtpRegistrationScreen> createState() => _OtpRegistrationScreenState();
}

class _OtpRegistrationScreenState extends State<OtpRegistrationScreen> {

  TextEditingController? _emailController;
  TextEditingController? _nameController;
  TextEditingController? _phoneNumberController;
  String? countryCode;


  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _phoneNumberController = TextEditingController();

    final configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;
    countryCode ??= CountryCode.fromCountryCode(configModel.countryCode!).dialCode;

    if(widget.userName != null && widget.userName!.isNotEmpty){
      _nameController?.text = widget.userName!;
    }

  }


  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width;
    final Size size = MediaQuery.of(context).size;

    bool isNumber = NumberCheckerHelper.isNumber(widget.userInput.trim().replaceAll('+', ''));
    final configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;



    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBarWidget()) : null,
      body: SafeArea(
        child: Center(
          child: CustomScrollView(
            slivers: [

              SliverToBoxAdapter(
                child: SizedBox(height: size.height * 0.05),
              ),

              SliverToBoxAdapter(
                child: Center(
                  child: Container(
                    width: width > 600 ? 400 : width,
                    margin: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                    padding: width > 600 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
                    decoration: width > 600 ? BoxDecoration(
                      color: Theme.of(context).canvasColor, borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.07),
                          blurRadius: 30,
                          spreadRadius: 0,
                          offset: const Offset(0,10)
                        )],
                    ) : null,
                    child: Center(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                        SizedBox(
                          height: ResponsiveHelper.isDesktop(context) ? size.height * 0.05 : size.height * 0.14,
                        ),

                        Consumer<SplashProvider>(
                          builder: (context, splash, child) {
                            return Directionality(textDirection: TextDirection.ltr,
                              child: CustomImageWidget(
                                image: '${splash.baseUrls?.restaurantImageUrl}/${splash.configModel!.restaurantLogo}',
                                placeholder: Images.webAppBarLogo,
                                fit: BoxFit.contain,
                                width: 120, height: 80,
                              ),
                            );
                          }
                        ),
                        const SizedBox(height: 30),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                          child: Center(
                            child: Column(children: [



                              Text(
                                getTranslated('just_one_step_away_will_help_make_your_profile', context)!,
                                textAlign: TextAlign.center,
                                style: rubikRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              const SizedBox(height: 30),

                              CustomTextFieldWidget(
                                //hintText: getTranslated('demo_gmail', context),
                                isShowBorder: true,
                                controller: _nameController,
                                inputType: TextInputType.emailAddress,
                                label: getTranslated('name', context)!,
                                isRequired: true,
                                prefixIconUrl: Images.userSvg,
                                isShowPrefixIcon: true,
                                prefixIconColor: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(height: Dimensions.paddingSizeLarge),


                              isNumber ? CustomTextFieldWidget(
                                //hintText: getTranslated('demo_gmail', context),
                                isShowBorder: true,
                                hintText: '',
                                controller: _emailController,
                                inputType: TextInputType.emailAddress,
                                label: getTranslated('email', context)!,
                                prefixIconUrl: Images.emailSvg,
                                isShowPrefixIcon: true,
                                prefixIconColor: Theme.of(context).primaryColor,
                              ):
                              CustomTextFieldWidget(
                                countryDialCode: countryCode,
                                onCountryChanged: (CountryCode value) {
                                  countryCode = value.dialCode;
                                },
                                //hintText: getTranslated('demo_gmail', context),
                                isShowBorder: true,
                                hintText: '',
                                controller: _phoneNumberController,
                                inputType: TextInputType.phone,
                                label: getTranslated('mobile_number', context)!,
                                prefixIconColor: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(height: Dimensions.paddingSizeLarge),

                              //const SizedBox(height: 30),


                              Consumer<AuthProvider>(
                                builder: (context, authProvider, child) {
                                  return CustomButtonWidget(
                                    isLoading: authProvider.isPhoneNumberVerificationButtonLoading,
                                    btnTxt: getTranslated('done', context)!,
                                    textStyle: rubikBold.copyWith(
                                      color: Theme.of(context).cardColor,
                                      fontSize: Dimensions.fontSizeDefault,
                                    ),
                                    onTap: (){

                                      String name = _nameController!.text.trim();
                                      String email = _emailController!.text.trim();
                                      String phone = _phoneNumberController!.text.trim();

                                      if (_nameController!.text.isEmpty) {
                                        showCustomSnackBarHelper(getTranslated('enter_your_name', context));
                                      }else if(!isNumber && phone.isEmpty){
                                        showCustomSnackBarHelper(getTranslated('enter_phone_number', context));
                                      }
                                      else{
                                        if(isNumber){

                                          authProvider.registerWithOtp(name, email: email, phone: widget.userInput).then((value){
                                            if(value.isSuccess) {
                                              if (authProvider.isActiveRememberMe) {

                                                String userCountryCode = NumberCheckerHelper.getCountryCode(widget.userInput)!;

                                                authProvider.saveUserNumberAndPassword(UserLogData(
                                                  countryCode:  userCountryCode,
                                                  phoneNumber: widget.userInput.substring(userCountryCode.length),
                                                  email: email,
                                                  password: null,
                                                ));
                                              } else {
                                                authProvider.clearUserLogData();
                                              }
                                              RouterHelper.getMainRoute(action: RouteAction.pushNamedAndRemoveUntil);
                                            }
                                          });
                                        }else{

                                          phone = countryCode! + phone;

                                          authProvider.registerWithSocialMedia(name, email: widget.userInput, phone: phone).then((value){
                                            final (responseModel, tempToken) = value;
                                            if(responseModel.isSuccess && tempToken == null) {
                                              authProvider.clearUserLogData();
                                              RouterHelper.getMainRoute(action: RouteAction.pushNamedAndRemoveUntil);
                                            }else if(responseModel.isSuccess && tempToken != null){
                                              authProvider.sendVerificationCode(configModel,
                                                SignUpModel(
                                                  phone: phone,
                                                ),
                                                type: 'phone',
                                              );
                                            }
                                          });
                                        }

                                      }
                                    },
                                  );
                                }
                              ),



                            ],),
                          ),
                        ),

                        if(ResponsiveHelper.isDesktop(context))
                          SizedBox(height: size.height * 0.05),


                      ],),
                    ),
                  ),
                ),
              ),

              if(ResponsiveHelper.isDesktop(context)) ...[
                SliverToBoxAdapter(
                  child: SizedBox(height: size.height * 0.08),
                ),
              ],

              if(ResponsiveHelper.isDesktop(context)) const SliverFillRemaining(
                hasScrollBody: false,
                child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  // SizedBox(height: Dimensions.paddingSizeLarge),

                  FooterWidget(),
                ]),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
