import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_alert_dialog_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/features/auth/domain/enum/auth_enum.dart';
import 'package:flutter_restaurant/features/auth/domain/models/signup_model.dart';
import 'package:flutter_restaurant/common/enums/app_mode_enum.dart';
import 'package:flutter_restaurant/features/auth/domain/models/user_log_data.dart';
import 'package:flutter_restaurant/features/auth/widgets/existing_account_bottom_sheet.dart';
import 'package:flutter_restaurant/features/profile/domain/models/userinfo_model.dart';
import 'package:flutter_restaurant/helper/email_checker_helper.dart';
import 'package:flutter_restaurant/helper/number_checker_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';


class VerificationScreen extends StatefulWidget {

  final String userInput;
  final String fromPage;
  final String? session;

  const VerificationScreen(
      {super.key,
      required this.userInput,
      required this.fromPage,
      this.session});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  @override
  void initState() {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.updateVerificationCode('', isUpdate: false);
    authProvider.startVerifyTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final Size size = MediaQuery.of(context).size;
    final isPhone = EmailCheckerHelper.isNotValid(widget.userInput);

    final ConfigModel config = Provider.of<SplashProvider>(context, listen: false).configModel!;
    final bool isFirebaseOTP = config.customerVerification!.status! && config.customerVerification?.firebase == 1;

    String userInput = widget.userInput;
    if(!userInput.contains('+') && isPhone) {
      userInput = '+${widget.userInput.replaceAll(' ', '')}';
    }

    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBarWidget())
          : CustomAppBarWidget(
          context: context,
          title: getTranslated('otp_verification', context),
      )) as PreferredSizeWidget?,
      body: SafeArea(
        child: Center(child: CustomScrollView(slivers: [

          SliverToBoxAdapter(child: SizedBox(height: size.height * 0.05)),

          SliverToBoxAdapter(
            child: Center(child: Container(
              width: width > 700 ? 450 : width,
              margin: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
              padding: width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
              decoration: width > 700 ? BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.07),
                      blurRadius: 30,
                      spreadRadius: 0,
                      offset: const Offset(0,10)
                  )
                ],
              ) : null,
              child: Consumer<AuthProvider>(
                builder: (context, authProvider, child) => Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

                  if(ResponsiveHelper.isDesktop(context))...[
                    SizedBox(height: size.height * 0.05),
                  ],

                  CustomAssetImageWidget(
                    isPhone ? Images.otpVerificationSvg : Images.emailOtpVerificationSvg,
                    height: 120,
                  ),
                  const SizedBox(height: 40),


                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [

                        TextSpan(
                          text: getTranslated('we\'ve_sent_verification_code', context),
                          style: rubikRegular.copyWith(
                            color: Theme.of(context).hintColor,
                            fontSize: Dimensions.fontSizeDefault,
                          ),
                        ),

                        TextSpan(
                          text: " $userInput ",
                          style: rubikRegular.copyWith(
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                            fontSize: Dimensions.fontSizeDefault,
                          ),
                        ),

                        TextSpan(
                          text: getTranslated('your_otp_expired_within', context),
                          style: rubikRegular.copyWith(
                            color: Theme.of(context).hintColor,
                            fontSize: Dimensions.fontSizeDefault,
                          ),
                        ),

                        TextSpan(
                          text: " ${getTranslated('1_min', context)}",
                          style: rubikRegular.copyWith(
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                            fontSize: Dimensions.fontSizeDefault,
                          ),
                        ),

                      ]),
                    ),
                  ),

                  if (AppMode.demo == AppConstants.appMode && !isFirebaseOTP)
                    Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Text(getTranslated('for_demo_purpose_use', context)!,
                        style: rubikSemiBold.copyWith(
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                    ),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.height * 0.04),
                    child: PinCodeTextField(
                      cursorColor: Theme.of(context).textTheme.bodyMedium?.color,
                      length: 6,
                      appContext: context,
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      animationType: AnimationType.fade,

                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        fieldHeight: 40,
                        fieldWidth: 40,
                        borderWidth: 1,
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        selectedColor:Theme.of(context).colorScheme.onSurface,
                        selectedFillColor: Colors.white,
                        inactiveFillColor: ColorResources.getSearchBg(context),
                        inactiveColor: Theme.of(context).hintColor,
                        activeColor: Theme.of(context).colorScheme.onSurface,
                        activeFillColor: ColorResources.getSearchBg(context),
                      ),
                      animationDuration: const Duration(milliseconds: 300),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: true,
                      onChanged: authProvider.updateVerificationCode,
                      beforeTextPaste: (text) {
                        return true;
                      },
                    ),
                  ),

                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  authProvider.isEnableVerificationCode && !authProvider.resendButtonLoading ?
                  !authProvider.isPhoneNumberVerificationButtonLoading ?
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.height * 0.04),
                    child: CustomButtonWidget(
                      btnTxt: getTranslated('verify', context),
                      onTap: () {
                        if (widget.fromPage == FromPage.login.name) {
                          if(config.customerVerification!.status!){
                            if(isPhone && isFirebaseOTP){
                              authProvider.firebaseOtpLogin(
                                phoneNumber: userInput,
                                session: '${widget.session}',
                                otp: authProvider.verificationCode,
                              );
                            }else if(isPhone && config.customerVerification?.phone == 1){
                              authProvider.verifyPhone(userInput.trim()).then((value) {
                                if (value.isSuccess) {
                                  RouterHelper.getMainRoute(action: RouteAction.pushNamedAndRemoveUntil);
                                }
                              });
                            }else if(!isPhone && config.customerVerification?.email == 1){
                              authProvider.verifyEmail(userInput).then((value) {
                                if (value.isSuccess) {
                                  RouterHelper.getMainRoute(action: RouteAction.pushNamedAndRemoveUntil);
                                }
                              });
                            }
                          }
                        }else if(widget.fromPage == FromPage.otp.name){

                          if(isPhone && isFirebaseOTP){
                            authProvider.firebaseOtpLogin(
                              phoneNumber: userInput,
                              session: '${widget.session}',
                              otp: authProvider.verificationCode,
                            );
                          }else if(isPhone && config.customerVerification?.phone == 1){
                            authProvider.verifyPhoneForOtp(userInput).then((value){
                              final (responseModel, tempToken, userInfoModel) = value;
                              if((responseModel != null && responseModel.isSuccess) && tempToken == null) {

                                if(responseModel.message == 'user' && context.mounted){
                                  ResponsiveHelper.showDialogOrBottomSheet(context,
                                    isDismissible: false,
                                    CustomAlertDialogWidget(
                                      width: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.width * 0.3 : null,
                                      child: ExistingAccountBottomSheet(
                                        userInfoModel: userInfoModel ?? UserInfoModel(),
                                        loginMedium: FromPage.otp.name,
                                      ),
                                    ),
                                  );
                                }else{
                                  if (authProvider.isActiveRememberMe) {

                                    String userCountryCode = NumberCheckerHelper.getCountryCode(userInput)!;
                                    authProvider.saveUserNumberAndPassword(UserLogData(
                                      countryCode:  userCountryCode,
                                      phoneNumber: userInput.substring(userCountryCode.length),
                                      email: null,
                                      password: null,
                                    ));
                                  } else {
                                    authProvider.clearUserLogData();
                                  }

                                  RouterHelper.getDashboardRoute('home', action: RouteAction.pushNamedAndRemoveUntil);

                                }
                              }else if((responseModel != null && responseModel.isSuccess) && tempToken != null){
                                RouterHelper.getOtpRegistrationScreen(tempToken, userInput, action: RouteAction.pushReplacement);

                              }
                            });
                          }
                        }else if(widget.fromPage == FromPage.profile.name){

                          String type = isPhone ? 'phone': 'email';
                          authProvider.verifyProfileInfo(userInput,type).then((value){
                            if(value.isSuccess) {
                              RouterHelper.getProfileRoute(action: RouteAction.pushReplacement);
                            }
                          });

                        }else{
                          if (isFirebaseOTP && isPhone) {authProvider.firebaseOtpLogin(
                            phoneNumber: userInput,
                            session: '${widget.session}',
                            otp: authProvider.verificationCode,
                            isForgetPassword: true,
                          );
                          } else {
                            authProvider.verifyToken(userInput).then((value) {
                              if (value.isSuccess) {
                                RouterHelper.getNewPassRoute(userInput, authProvider.verificationCode);
                              } else {
                                showCustomSnackBarHelper(value.message!);
                              }
                            });
                          }
                        }
                      },
                    ),
                  ): Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)))
                      : const SizedBox.shrink(),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.height * 0.04),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Text(getTranslated('did_not_receive_the_code', context)!,
                          style: rubikSemiBold.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                        ),

                        authProvider.resendButtonLoading ? const CircularProgressIndicator() : TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: authProvider.currentTime! > 0 ? null : () async {
                            if (widget.fromPage != FromPage.forget.name) {
                              await authProvider.sendVerificationCode(config,
                                SignUpModel(
                                  phone: userInput,
                                  email: userInput,
                                ),
                                type: isPhone ? 'phone' : 'email',
                              );
                            } else {
                              bool isNumber = NumberCheckerHelper.isNumber(userInput);
                              await authProvider.forgetPassword(
                                config: config,
                                  phoneOrEmail: userInput,
                                  type: isNumber ? 'phone' : 'email'
                              ).then((value) {
                                authProvider.startVerifyTimer();

                                if (value!.isSuccess && context.mounted) {
                                  showCustomSnackBarHelper(getTranslated('resend_code_successful', context), isError: false);
                                } else {
                                  showCustomSnackBarHelper(value.message!);
                                }

                              });
                            }
                          },
                          child: Builder(builder: (context) {
                            int? days, hours, minutes, seconds;
                            Duration duration = Duration(seconds: authProvider.currentTime ?? 0);

                            days = duration.inDays;
                            hours = duration.inHours - days * 24;
                            minutes = duration.inMinutes - (24 * days * 60) - (hours * 60);
                            seconds = duration.inSeconds - (24 * days * 60 * 60) - (hours * 60 * 60) - (minutes * 60);

                            return CustomDirectionalityWidget(
                              child: Text(
                                (authProvider.currentTime != null && authProvider.currentTime! > 0)
                                     ? '${getTranslated('resend', context)} (${minutes > 0 ? '${minutes}m :' : ''}${seconds}s)'
                                    : getTranslated('resend_it', context)!,

                                textAlign: TextAlign.end,
                                style: rubikSemiBold.copyWith(
                                  color: authProvider.currentTime != null && authProvider.currentTime! > 0 ?
                                  Theme.of(context).colorScheme.onSurface : Theme.of(context).indicatorColor,
                                )),
                            );

                          }),
                        ),
                      ]),
                  ),
                  const SizedBox(height: 48),
                ]),
              )),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: size.height * 0.05)),

          if(ResponsiveHelper.isDesktop(context)) const SliverFillRemaining(
            hasScrollBody: false,
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              SizedBox(height: Dimensions.paddingSizeLarge),

              FooterWidget(),
            ]),
          ),

        ]))
      ),
    );
  }
}
