import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/models/response_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_pop_scope_widget.dart';
import 'package:flutter_restaurant/features/auth/domain/enum/auth_enum.dart';
import 'package:flutter_restaurant/helper/number_checker_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController? _userInputController;
  String? _countryCode;

  @override
  void initState() {
    super.initState();
    _userInputController = TextEditingController();

    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    authProvider.clearVerificationMessage();
    authProvider.setIsLoading = false;
    authProvider.setIsPhoneVerificationButttonLoading = false;
    authProvider.toggleIsNumberLogin(value: false, isUpdate: false);

    _countryCode = CountryCode.fromCountryCode(Provider.of<SplashProvider>(context, listen: false).configModel!.countryCode!).dialCode;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final ConfigModel configModel =  Provider.of<SplashProvider>(context, listen: false).configModel!;

    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBarWidget()) : CustomAppBarWidget(
        context: context,
        title: getTranslated('forgot_password', context),
        onBackPressed: (){
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          authProvider.toggleIsNumberLogin(value: false);
          _userInputController?.clear();
          context.pop();
        },
      )) as PreferredSizeWidget?,
      body: CustomPopScopeWidget(
        onPopInvoked: (){
          _userInputController?.clear();
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          authProvider.toggleIsNumberLogin(value: false);
        },
        child: Center(child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(children: [
            Center(child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: Container(
                width: width > 700 ? 500 : width,
                padding: width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
                decoration: width > 700 ? BoxDecoration(
                  color: Theme.of(context).canvasColor, borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)],
                ) : null,
                child: Consumer<AuthProvider>(
                  builder: (context, auth, child) {


                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 55),

                        const Center(
                          child: CustomAssetImageWidget(
                            Images.forgetPasswordBackgroundSvg,
                            width: 142,
                            height: 142,
                          ),
                        ),
                        const SizedBox(height: 40),

                        configModel.phoneVerification!?
                        Center(child: Text(
                          getTranslated('do_not_worry_give_email_phone_update_password', context)!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorResources.getHintColor(context)),
                        )):
                        Center(
                          child: Text(
                            getTranslated('please_enter_your_number_to', context)!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorResources.getHintColor(context)),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 80),

                              Selector<AuthProvider, bool>(
                                selector: (context, authProvider) => authProvider.isNumberLogin,
                                builder: (_, isNumberLogin, ___) {
                                  return CustomTextFieldWidget(
                                    countryDialCode: isNumberLogin ? _countryCode : null,
                                    onCountryChanged: (CountryCode value) {
                                      _countryCode = value.dialCode;
                                    },

                                    onChanged: (String text){

                                      final numberRegExp = RegExp(r'^-?[0-9]+$');

                                      if(text.isEmpty && auth.isNumberLogin){
                                        auth.toggleIsNumberLogin();
                                      }
                                      if(text.startsWith(numberRegExp) && !auth.isNumberLogin){
                                        auth.toggleIsNumberLogin();
                                      }

                                      final emailRegExp = RegExp(r'@');

                                      if(text.contains(emailRegExp) && auth.isNumberLogin){
                                        auth.toggleIsNumberLogin();
                                      }

                                    },
                                    hintText: '',
                                    isShowBorder: true,
                                    controller: _userInputController,
                                    inputType: TextInputType.text,
                                    label: getTranslated('email/phone', context),
                                  );
                                },
                              ),
                              const SizedBox(height: 24),

                              !auth.isForgotPasswordLoading && !auth.isPhoneNumberVerificationButtonLoading ? CustomButtonWidget(
                                btnTxt: getTranslated('send', context),
                                onTap: () async {

                                  if (_userInputController!.text.isEmpty) {
                                    showCustomSnackBarHelper(getTranslated('enter_email_or_phone', context));
                                  }else{
                                    String userInput = _userInputController!.text.trim();
                                    bool isNumber = NumberCheckerHelper.isNumber(userInput);

                                    if(isNumber) {
                                      userInput = _countryCode! + userInput;
                                    }

                                    ResponseModel? response =  await auth.forgetPassword(config: configModel, phoneOrEmail: userInput, type: isNumber ? 'phone' : 'email');

                                    if(response != null && response.isSuccess) {
                                      RouterHelper.getVerifyRoute(FromPage.forget.name, userInput);

                                    }else if(response != null && !response.isSuccess) {
                                      showCustomSnackBarHelper(response.message);
                                    }
                                  }
                                },
                              ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            )),

            if(ResponsiveHelper.isDesktop(context)) const FooterWidget()
          ]),
        )),
      ),
    );
  }
}
