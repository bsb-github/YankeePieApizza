import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/response_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/common/widgets/on_hover_widget.dart';
import 'package:flutter_restaurant/features/auth/domain/enum/auth_enum.dart';
import 'package:flutter_restaurant/features/auth/domain/models/signup_model.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/profile/domain/models/userinfo_model.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/profile/widgets/profile_textfield_widget.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileWebWidget extends StatefulWidget {
  final FocusNode? firstNameFocus;
  final FocusNode? lastNameFocus;
  final FocusNode? emailFocus;
  final FocusNode? phoneNumberFocus;
  final FocusNode? passwordFocus;
  final FocusNode? confirmPasswordFocus;
  final TextEditingController? firstNameController;
  final TextEditingController? lastNameController;
  final TextEditingController? emailController;
  final TextEditingController? phoneNumberController;
  final TextEditingController? passwordController;
  final TextEditingController? confirmPasswordController;

  final Function pickImage;
  final XFile? file;
  const ProfileWebWidget({
    super.key,
    required this.firstNameFocus,
    required this.lastNameFocus,
    required this.emailFocus,
    required this.phoneNumberFocus,
    required this.passwordFocus,
    required this.confirmPasswordFocus,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneNumberController,
    required this.passwordController,
    required this.confirmPasswordController,
    //function
    required this.pickImage,
    //file
    required this.file


  });

  @override
  State<ProfileWebWidget> createState() => _ProfileWebWidgetState();
}

class _ProfileWebWidgetState extends State<ProfileWebWidget> {
  final GlobalKey<FormState> profileFormKey = GlobalKey<FormState>();
  final phoneToolTipKey = GlobalKey<State<Tooltip>>();
  final emailToolTipKey = GlobalKey<State<Tooltip>>();

  @override
  void initState() {
    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(true, isUpdate: true);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
     final config = Provider.of<SplashProvider>(context, listen: false).configModel!;
    // final bool isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    final splashProvider =  Provider.of<SplashProvider>(context, listen: false);


    return SingleChildScrollView(child: Column(children: [
      Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          return Center(child: SizedBox(width: Dimensions.webScreenWidth, child: Stack(children: [

            Column(children: [
              Transform.translate(offset: const Offset(0, -1), child: Container(
                height: 150,  decoration: BoxDecoration(
                color:  ColorResources.getProfileMenuHeaderColor(context),
                border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:0.2), width: 1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(Dimensions.radiusDefault),
                  bottomRight: Radius.circular(Dimensions.radiusDefault),
                ),
              ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 240.0),
              )),
              const SizedBox(height: 100),

              Container(
                constraints: const BoxConstraints(minHeight: 300),
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Padding(padding: const EdgeInsets.only(left: 240.0), child: Column(children: [
                  Form(key: profileFormKey, child: Column(/*mainAxisAlignment: MainAxisAlignment.spaceEvenly, */children: [

                    Column(children: [
                      Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Expanded(child: ProfileTextFieldWidget(
                          isShowBorder: true,
                          controller: widget.firstNameController,
                          focusNode: widget.firstNameFocus,
                          nextFocus: widget.lastNameFocus,
                          inputType: TextInputType.name,
                          capitalization: TextCapitalization.words,
                          level: getTranslated('first_name', context)!,
                          isFieldRequired: true,
                          isShowPrefixIcon: true,
                          prefixIconUrl: Images.profileIconSvg,
                          onValidate: (value) => value!.isEmpty
                              ? '${getTranslated('please_enter', context)!} ${getTranslated('first_name', context)!}'
                              : null,
                        )),
                        const SizedBox(width:  Dimensions.paddingSizeLarge),

                        Expanded(child: ProfileTextFieldWidget(
                          isShowBorder: true,
                          controller: widget.lastNameController,
                          focusNode: widget.lastNameFocus,
                          nextFocus: widget.phoneNumberFocus,
                          inputType: TextInputType.name,
                          capitalization: TextCapitalization.words,
                          level: getTranslated('last_name', context)!,
                          isFieldRequired: true,
                          isShowPrefixIcon: true,
                          prefixIconUrl: Images.profileIconSvg,
                          onValidate: (value) => value!.isEmpty
                              ? '${getTranslated('please_enter', context)!} ${getTranslated('last_name', context)!}'
                              : null,
                        )),
                      ]),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Expanded(child: Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return ProfileTextFieldWidget(
                              isShowBorder: true,
                              controller: widget.emailController,
                              focusNode: widget.emailFocus,
                              nextFocus: widget.phoneNumberFocus,
                              inputType: TextInputType.emailAddress,
                              level: getTranslated('email', context)!,
                              isShowPrefixIcon: true,
                              prefixIconUrl: Images.emailSvg,
                              isShowSuffixIcon: true,
                              isToolTipSuffix: config.customerVerification?.email == 1 && widget.emailController!.text.isNotEmpty? true : false,
                              toolTipMessage: profileProvider.userInfoModel?.emailVerifiedAt == null ? getTranslated('email_not_verified', context)! : '',
                              toolTipKey: emailToolTipKey,
                              suffixIconUrl: config.customerVerification?.email == 1 && profileProvider.userInfoModel?.emailVerifiedAt == null ? Images.notVerifiedSvg : Images.verifiedSvg,
                              onSuffixTap: (){

                                if(profileProvider.userInfoModel?.emailVerifiedAt == null) {
                                  final configModel = Provider.of<SplashProvider>(context, listen : false).configModel;
                                  SignUpModel signUpModel = SignUpModel(
                                    email: widget.emailController?.text.trim(),
                                  );
                                  authProvider.sendVerificationCode(configModel!, signUpModel, type: 'email', fromPage: FromPage.profile.name);
                                }

                              },
                            );
                          }
                        )),
                        const SizedBox(width:  Dimensions.paddingSizeLarge),

                        Expanded(child: Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return ProfileTextFieldWidget(
                              isShowBorder: true,
                              isEnabled: profileProvider.userInfoModel?.isPhoneVerified == 0,
                              controller: widget.phoneNumberController,
                              focusNode: widget.phoneNumberFocus,
                              nextFocus: widget.passwordFocus,
                              inputType: TextInputType.phone,
                              level: getTranslated('mobile_number', context)!,
                              isShowPrefixIcon: true,
                              prefixIconUrl: Images.callSvg,
                              isShowSuffixIcon: true,
                              isToolTipSuffix: config.customerVerification?.phone == 1 ? true : false,
                              toolTipMessage: profileProvider.userInfoModel?.isPhoneVerified == 0 ? getTranslated('phone_number_not_verified', context)! : getTranslated('cant_update_phone_number',context)!,
                              toolTipKey: phoneToolTipKey,
                              suffixIconUrl: config.customerVerification?.phone == 1 && profileProvider.userInfoModel?.isPhoneVerified == 0 ? Images.notVerifiedSvg : Images.verifiedSvg,
                              onSuffixTap: (){

                                final configModel = Provider.of<SplashProvider>(context, listen : false).configModel;
                                SignUpModel signUpModel = SignUpModel(
                                  phone: widget.phoneNumberController?.text.trim(),
                                );
                                authProvider.sendVerificationCode(configModel!, signUpModel, type: 'phone', fromPage: FromPage.profile.name);

                              },
                              onValidate: (value) => value!.isEmpty
                                  ? '${getTranslated('please_enter', context)!} ${getTranslated('mobile_number', context)!}'
                                  : null,
                            );
                          }
                        )),


                      ]),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      if(config.customerLogin?.loginOption?.manualLogin == 1)...[
                        Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Expanded(child: ProfileTextFieldWidget(
                              hintText: getTranslated('password_hint', context),
                              isShowBorder: true,
                              controller: widget.passwordController,
                              focusNode: widget.passwordFocus,
                              nextFocus: widget.confirmPasswordFocus,
                              isPassword: true,
                              isShowSuffixIcon: true,
                              level: getTranslated('password', context)!,
                              isFieldRequired: true,
                              isShowPrefixIcon: true,
                              prefixIconUrl: Images.lockerSvg,
                              onValidate: (value) {
                                if(value == null || value.isEmpty){
                                  return null;
                                }else{
                                  if(value.isNotEmpty && value.length < 6){
                                    return getTranslated('password_hint', context)!;
                                  }else {
                                    return null;
                                  }
                                }
                              }
                          )),
                          const SizedBox(width:  Dimensions.paddingSizeLarge),

                          Expanded(child: ProfileTextFieldWidget(
                              hintText: getTranslated('password_hint', context),
                              isShowBorder: true,
                              controller: widget.confirmPasswordController,
                              focusNode: widget.confirmPasswordFocus,
                              isPassword: true,
                              isShowSuffixIcon: true,
                              inputAction: TextInputAction.done,
                              level: getTranslated('confirm_password', context)!,
                              isShowPrefixIcon: true,
                              prefixIconUrl: Images.lockerSvg,
                              onValidate: (value) {
                                if(value == null || value.isEmpty){
                                  if(widget.passwordController?.text == null || widget.passwordController!.text.isEmpty){
                                    return null;
                                  }
                                  else{
                                    return getTranslated('enter_confirm_password', context)!;
                                  }
                                }else{
                                  if(value.isNotEmpty && value.length < 6){
                                    return getTranslated('password_hint', context)!;
                                  }else if(value != widget.passwordController?.text){
                                    return '${getTranslated('password_did_not_match', context)}';
                                  }else{
                                    return null;
                                  }
                                }
                              }
                          )),
                        ]),
                      ],

                    ]),

                  ])),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                  SizedBox(
                    width: 370,
                    child: CustomButtonWidget(
                      isLoading: profileProvider.isLoading,
                      btnTxt: getTranslated('update', context),
                      onTap: () async {
                        String firstName = widget.firstNameController!.text.trim();
                        String lastName = widget.lastNameController!.text.trim();
                        String phoneNumber = widget.phoneNumberController!.text.trim();
                        String password = widget.passwordController!.text.trim();
                        String email = widget.emailController!.text.trim();
                        //String confirmPassword = widget.confirmPasswordController!.text.trim();

                        if(profileFormKey.currentState != null && profileFormKey.currentState!.validate()){
                          bool isChanged = profileProvider.userInfoModel!.fName == firstName &&
                              profileProvider.userInfoModel!.lName == lastName &&
                              profileProvider.userInfoModel!.phone == phoneNumber &&
                              profileProvider.userInfoModel!.email == email && widget.file == null;

                          bool isPasswordEmpty = password.isEmpty;

                          if ( isChanged && isPasswordEmpty) {
                            showCustomSnackBarHelper(getTranslated('change_something_to_update', context));
                          }else {
                            UserInfoModel updateUserInfoModel = UserInfoModel();
                            updateUserInfoModel.fName = firstName;
                            updateUserInfoModel.lName = lastName;
                            updateUserInfoModel.phone = phoneNumber;
                            updateUserInfoModel.email = email;

                            ResponseModel responseModel = await profileProvider.updateUserInfo(
                              updateUserInfoModel, password, null, widget.file,
                              Provider.of<AuthProvider>(context, listen: false).getUserToken(),
                            );

                            if(responseModel.isSuccess) {
                              profileProvider.getUserInfo(true);
                              if(context.mounted){
                                widget.passwordController?.clear();
                                widget.confirmPasswordController?.clear();
                                showCustomSnackBarHelper(getTranslated('updated_successfully', context), isError: false);
                              }
                            }else {
                              showCustomSnackBarHelper(responseModel.message);
                            }
                          }
                        }
                      },
                    ),
                  ),
                ])),
              ),
            ]),

            Positioned(left: 30, top: 60, child: Stack(children: [
              Container(
                height: 150, width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2),
                  color: Theme.of(context).cardColor,
                  boxShadow: [BoxShadow(color: Colors.white.withValues(alpha:0.1), blurRadius: 22, offset: const Offset(0, 8.8) )],
                ),
                child: ClipOval(
                  child: widget.file == null ?
                  CustomImageWidget(
                    placeholder: Images.placeholderUser, height: 150, width: 150, fit: BoxFit.cover,
                    image:  '${splashProvider.baseUrls!.customerImageUrl}/'
                        '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel!.image : ''}',
                  ) : Image.network(widget.file!.path, height: 150, width: 150, fit: BoxFit.cover),
                ),
              ),

              Positioned(bottom: 10, right: 10, child: OnHoverWidget(
                builder: (isHover) {
                  return InkWell(
                    hoverColor: Colors.transparent,
                    onTap: widget.pickImage as void Function()?,
                    child: Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(width: 2, color: Theme.of(context).cardColor),
                      ),
                      child: Icon(Icons.camera_alt,color: Theme.of(context).cardColor, size: Dimensions.paddingSizeDefault),
                    ),
                  );
                })),
            ])),

          ])));
        },
      ),
      const SizedBox(height: 55),

      const FooterWidget(),
    ]));
  }
}
