import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/features/auth/domain/enum/auth_enum.dart';
import 'package:flutter_restaurant/features/auth/domain/models/user_log_data.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/profile/domain/models/userinfo_model.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/custom_mask_info_helper.dart';
import 'package:flutter_restaurant/helper/number_checker_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class ExistingAccountBottomSheet extends StatefulWidget {
  final UserInfoModel userInfoModel;
  final String loginMedium;
  const ExistingAccountBottomSheet({
    super.key,
    required this.userInfoModel,
    required this.loginMedium
  });


  @override
  State<ExistingAccountBottomSheet> createState() => _ExistingAccountBottomSheetState();
}

class _ExistingAccountBottomSheetState extends State<ExistingAccountBottomSheet> {
  @override
  Widget build(BuildContext context) {

    final ConfigModel configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;
    final Size size = MediaQuery.of(context).size;

    return Column(mainAxisSize: MainAxisSize.min, children: [

      SizedBox(height: ResponsiveHelper.isDesktop(context) ? size.height * 0.08 : size.height * 0.015),

      CircleAvatar(
        radius: size.height * 0.05,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ResponsiveHelper.isDesktop(context) ? size.height * 0.1 : 40),
          child: CustomImageWidget(
            image: widget.userInfoModel.image != null ? "${configModel.baseUrls?.customerImageUrl}/${widget.userInfoModel.image}" : '',
            fit: BoxFit.fill,
          ),
        ),
      ),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      Text("${widget.userInfoModel.fName} ${widget.userInfoModel.lName}",
        style: rubikRegular.copyWith(
          fontSize: Dimensions.fontSizeDefault,
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

      Text(getTranslated('is_it_you', context)!,
        style: rubikBold.copyWith(
          fontSize: Dimensions.fontSizeLarge,
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.isDesktop(context) ? size.width * 0.03 : size.height * 0.02,
        ),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children:[

            TextSpan(
              text: getTranslated(widget.loginMedium == FromPage.otp.name ?
              'it_looks_like_the_phone' : 'it_looks_like_the_email', context)!,
              style: rubikRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context).hintColor.withValues(alpha:0.5),
              ),
            ),

            TextSpan(
              text: widget.loginMedium == FromPage.otp.name ?
              ' ${CustomMaskInfo.maskedPhone(widget.userInfoModel.phone ?? '')} '
                  : ' ${CustomMaskInfo.maskedPhone(widget.userInfoModel.email ?? '')} ',
              style: rubikSemiBold.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context).hintColor,
              ),
            ),

            TextSpan(
              text: getTranslated('already_used_existing_account', context)!,
              style: rubikRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context).hintColor.withValues(alpha:0.5),
              ),
            ),

          ],),),
      ),
      SizedBox(height: ResponsiveHelper.isDesktop(context) ? size.height * 0.03 : size.height * 0.02),

      Row(children: [

        Expanded(child: Container()),

        Expanded(flex: 3, child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return CustomButtonWidget(
              backgroundColor: Theme.of(context).hintColor,
              isLoading: authProvider.isPhoneNumberVerificationButtonLoading,
              btnTxt: getTranslated('no', context)!,
              onTap: (){

                if(authProvider.isPhoneNumberVerificationButtonLoading){

                }else{
                  Navigator.pop(context);
                  authProvider.existingAccountCheck(
                    email: widget.userInfoModel.email,
                    phone: widget.userInfoModel.phone!,
                    userResponse: 0,
                    medium: widget.loginMedium
                  ).then((value){

                    final (responseModel, tempToken) = value;
                    if(responseModel != null && responseModel.isSuccess && responseModel.message == 'tempToken'){
                      RouterHelper.getOtpRegistrationScreen(
                        tempToken!,
                        widget.loginMedium == FromPage.otp.name ? widget.userInfoModel.phone! :
                        widget.userInfoModel.email!,
                        userName: "${widget.userInfoModel.fName} ${widget.userInfoModel.lName}",
                      );
                    }

                  });
                }

              },
            );
          }
        ),),

        Expanded(child: Container()),

        Expanded(flex: 3,child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return CustomButtonWidget(
              isLoading: authProvider.isPhoneNumberVerificationButtonLoading,
              btnTxt: getTranslated('yes_its_me', context)!,
              onTap: (){

                if(authProvider.isPhoneNumberVerificationButtonLoading){

                }else{
                  Navigator.pop(context);
                  authProvider.existingAccountCheck(
                    email: widget.userInfoModel.email,
                    phone: widget.userInfoModel.phone!,
                    userResponse: 1,
                    medium: widget.loginMedium,
                  ).then((value){

                    final (responseModel, tempToken) = value;
                    if(responseModel != null && responseModel.isSuccess && responseModel.message == 'token') {

                      String? countryCode = NumberCheckerHelper.getCountryCode(widget.userInfoModel.phone);

                      authProvider.saveUserNumberAndPassword(
                        UserLogData(
                          phoneNumber: widget.userInfoModel.phone,
                          email: widget.userInfoModel.email,
                          password: null,
                          countryCode: countryCode,
                        ),
                      );

                      RouterHelper.getDashboardRoute('home', action: RouteAction.pushNamedAndRemoveUntil);

                    }
                  });
                }

              },
            );
          }
        ),),

        Expanded(child: Container()),

      ],),
      SizedBox(height: ResponsiveHelper.isDesktop(context) ? size.height * 0.04 : Dimensions.paddingSizeLarge),


    ],);
  }
}