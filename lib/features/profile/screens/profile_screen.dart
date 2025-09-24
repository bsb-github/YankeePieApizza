
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/response_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/not_logged_in_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_restaurant/features/auth/domain/enum/auth_enum.dart';
import 'package:flutter_restaurant/features/auth/domain/models/signup_model.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/profile/domain/models/userinfo_model.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/profile/widgets/profile_custom_painter_widget.dart';
import 'package:flutter_restaurant/features/profile/widgets/profile_shimmer_widget.dart';
import 'package:flutter_restaurant/features/profile/widgets/profile_textfield_widget.dart';
import 'package:flutter_restaurant/features/profile/widgets/profile_web_widget.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class  ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FocusNode? _firstNameFocus;
  FocusNode? _lastNameFocus;
  FocusNode? _emailFocus;
  FocusNode? _phoneNumberFocus;
  FocusNode? _passwordFocus;
  FocusNode? _confirmPasswordFocus;
  TextEditingController? _firstNameController;
  TextEditingController? _lastNameController;
  TextEditingController? _emailController;
  TextEditingController? _phoneNumberController;
  TextEditingController? _passwordController;
  TextEditingController? _confirmPasswordController;

  File? file;
  XFile? data;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<FormState> profileFormKey = GlobalKey<FormState>();
  late bool _isLoggedIn;
  final phoneToolTipKey = GlobalKey<State<Tooltip>>();
  final emailToolTipKey = GlobalKey<State<Tooltip>>();

  void _choose() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50, maxHeight: 500, maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      }
    });
  }

  _pickImage() async {
    data = await picker.pickImage(source: ImageSource.gallery, imageQuality: 60);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    setProfileFormField(profileProvider, authProvider);
  }

  void setProfileFormField(ProfileProvider profileProvider, AuthProvider authProvider){
    _isLoggedIn = authProvider.isLoggedIn();
    _firstNameFocus = FocusNode();
    _lastNameFocus = FocusNode();
    _emailFocus = FocusNode(skipTraversal: true);
    _phoneNumberFocus = FocusNode();
    _passwordFocus = FocusNode();
    _confirmPasswordFocus = FocusNode();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    if(_isLoggedIn) {
      profileProvider.getUserInfo(true).then((_) {
        UserInfoModel? userInfoModel = profileProvider.userInfoModel;
        if(userInfoModel != null){
          _firstNameController!.text = userInfoModel.fName ?? '';
          _lastNameController!.text = userInfoModel.lName ?? '';
          _phoneNumberController!.text = userInfoModel.phone ?? '';
          _emailController!.text = userInfoModel.email ?? '';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final config = splashProvider.configModel;

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;


    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: (ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBarWidget())
          : !_isLoggedIn ? CustomAppBarWidget(
        context: context,
        title:  getTranslated('my_profile', context)!,
        centerTitle: true ,
      ) : null) as PreferredSizeWidget? ,
      body: _isLoggedIn ? Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {

          if(ResponsiveHelper.isDesktop(context)) {
            return ProfileWebWidget(
              file: data,
              pickImage: _pickImage,
              confirmPasswordController: _confirmPasswordController,
              confirmPasswordFocus: _confirmPasswordFocus,
              emailController: _emailController,
              firstNameController: _firstNameController,
              firstNameFocus: _firstNameFocus,
              lastNameController: _lastNameController,
              lastNameFocus: _lastNameFocus,
              emailFocus: _emailFocus,
              passwordController: _passwordController,
              passwordFocus: _passwordFocus,
              phoneNumberController: _phoneNumberController,
              phoneNumberFocus: _phoneNumberFocus
            );
          }

          return profileProvider.userInfoModel != null ? Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Column(mainAxisSize: MainAxisSize.min, children: [

              const SizedBox(width: double.infinity, height: Dimensions.paddingSizeExtraLarge),
              Container(height: 60, color: Colors.transparent, child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                    child: IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back_ios),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeDefault),

                  Text(getTranslated('my_profile', context)!, style: rubikSemiBold.copyWith(
                    fontSize: Dimensions.fontSizeLarge, color: Colors.white,
                  )),
              ])),

              const SizedBox(height: 50),
              Expanded(child: CustomPaint(
                size: Size(width, height),
                painter: ProfileCustomPainterWidget(context),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  /// for profile image
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraLarge),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ColorResources.borderColor,
                      border: Border.all(color: Colors.white54, width: 3),
                      shape: BoxShape.circle,
                    ),
                    child: InkWell(
                      onTap: ResponsiveHelper.isMobilePhone() ? _choose : _pickImage,
                      child: Stack(
                        clipBehavior: Clip.none, children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: file != null ? Image.file(file!, width: 80, height: 80, fit: BoxFit.fill) : data != null
                              ? CustomImageWidget(image: data!.path, width: 80, height: 80, fit: BoxFit.fill)
                              : CustomImageWidget(
                            placeholder: Images.placeholderUser, width: 80, height: 80, fit: BoxFit.cover,
                            image: '${splashProvider.baseUrls!.customerImageUrl}/${profileProvider.userInfoModel!.image}',
                          ),
                        ),
                        Positioned(
                          bottom: 15,
                          right: -10,
                          child: InkWell(onTap: ResponsiveHelper.isMobilePhone() ? _choose : _pickImage, child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor,
                            ),
                            child: const CustomAssetImageWidget(Images.editSvg, width: 13, color: Colors.white),
                          )),
                        ),
                      ],
                      ),
                    ),
                  ),

                  /// for profile edit section
                  Expanded(child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    child: Form(key: profileFormKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      // for first name section
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      ProfileTextFieldWidget(
                        isShowBorder: true,
                        controller: _firstNameController,
                        focusNode: _firstNameFocus,
                        nextFocus: _lastNameFocus,
                        inputType: TextInputType.name,
                        capitalization: TextCapitalization.words,
                        level: getTranslated('first_name', context)!,
                        isFieldRequired: true,
                        isShowPrefixIcon: true,
                        prefixIconUrl: Images.profileIconSvg,
                        onValidate: (value) => value!.isEmpty
                            ? '${getTranslated('please_enter', context)!} ${getTranslated('first_name', context)!}' : null,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      // for last name section
                      ProfileTextFieldWidget(
                        isShowBorder: true,
                        controller: _lastNameController,
                        focusNode: _lastNameFocus,
                        nextFocus: _phoneNumberFocus,
                        inputType: TextInputType.name,
                        capitalization: TextCapitalization.words,
                        level: getTranslated('last_name', context)!,
                        isFieldRequired: true,
                        isShowPrefixIcon: true,
                        prefixIconUrl: Images.profileIconSvg,
                        onValidate: (value) => value!.isEmpty
                            ? '${getTranslated('please_enter', context)!} ${getTranslated('last_name', context)!}' : null,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      // for email section
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, child) {
                          return ProfileTextFieldWidget(
                            isShowBorder: true,
                            controller: _emailController,
                            focusNode: _emailFocus,
                            nextFocus: _phoneNumberFocus,
                            inputType: TextInputType.emailAddress,
                            level: getTranslated('email', context)!,
                            isShowPrefixIcon: true,
                            isShowSuffixIcon: true,
                            isToolTipSuffix: config?.customerVerification?.email == 1 && _emailController!.text.isNotEmpty? true : false,
                            toolTipMessage: profileProvider.userInfoModel?.emailVerifiedAt == null ? getTranslated('email_not_verified', context)! : '',
                            toolTipKey: emailToolTipKey,
                            suffixIconUrl: config?.customerVerification?.email == 1 && profileProvider.userInfoModel?.emailVerifiedAt == null ? Images.notVerifiedSvg : Images.verifiedSvg,
                            prefixIconUrl: Images.emailSvg,
                            onSuffixTap: (){

                              if(profileProvider.userInfoModel?.emailVerifiedAt == null) {
                                final configModel = Provider.of<SplashProvider>(context, listen : false).configModel;
                                SignUpModel signUpModel = SignUpModel(
                                  email: _emailController?.text.trim(),
                                );
                                authProvider.sendVerificationCode(configModel!, signUpModel, type: 'email', fromPage: FromPage.profile.name);
                              }

                            },
                          );
                        }
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      /// for phone Number section
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, child) {
                          return ProfileTextFieldWidget(
                            isShowBorder: true,
                            isEnabled: profileProvider.userInfoModel?.isPhoneVerified == 0,
                            controller: _phoneNumberController,
                            focusNode: _phoneNumberFocus,
                            nextFocus: _passwordFocus,
                            inputType: TextInputType.phone,
                            level: getTranslated('mobile_number', context)!,
                            isShowPrefixIcon: true,
                            prefixIconUrl: Images.callSvg,
                            isShowSuffixIcon: true,
                            isToolTipSuffix: config?.customerVerification?.phone == 1 ? true : false,
                            toolTipMessage: profileProvider.userInfoModel?.isPhoneVerified == 0 ? getTranslated('phone_number_not_verified', context)! : getTranslated('cant_update_phone_number',context)!,
                            toolTipKey: phoneToolTipKey,
                            suffixIconUrl: config?.customerVerification?.phone == 1 && profileProvider.userInfoModel?.isPhoneVerified == 0 ? Images.notVerifiedSvg : Images.verifiedSvg,
                            onSuffixTap: (){

                              final configModel = Provider.of<SplashProvider>(context, listen : false).configModel;
                              SignUpModel signUpModel = SignUpModel(
                                phone: _phoneNumberController?.text.trim(),
                              );
                              authProvider.sendVerificationCode(configModel!, signUpModel, type: 'phone', fromPage: FromPage.profile.name);

                            },
                            onValidate: (value) => value!.isEmpty
                                ? '${getTranslated('please_enter', context)!} ${getTranslated('mobile_number', context)!}' : null,
                          );
                        }
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      /// for password section
                      if(config?.customerLogin?.loginOption?.manualLogin == 1)...[
                        ProfileTextFieldWidget(
                            hintText: getTranslated('password_hint', context),
                            isShowBorder: true,
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            nextFocus: _confirmPasswordFocus,
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
                          //value!.isEmpty || value.length < 6
                          //  ? '${getTranslated('please_enter', context)!} ${getTranslated('password', context)!}' : null,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                        ProfileTextFieldWidget(
                            hintText: getTranslated('password_hint', context),
                            isShowBorder: true,
                            controller: _confirmPasswordController,
                            focusNode: _confirmPasswordFocus,
                            isPassword: true,
                            isShowSuffixIcon: true,
                            inputAction: TextInputAction.done,
                            level: getTranslated('confirm_password', context)!,
                            isShowPrefixIcon: true,
                            prefixIconUrl: Images.lockerSvg,
                            onValidate: (value) {
                              if(value == null || value.isEmpty){
                                if(_passwordController?.text == null || _passwordController!.text.isEmpty){
                                  return null;
                                }
                                else{
                                  return getTranslated('enter_confirm_password', context)!;
                                }
                              }else{
                                if(value.isNotEmpty && value.length < 6){
                                  return getTranslated('password_hint', context)!;
                                }else if(value != _passwordController?.text){
                                  return '${getTranslated('password_did_not_match', context)}';
                                }else{
                                  return null;
                                }
                              }
                            }
                          //_passwordController?.text != _confirmPasswordController?.text
                          //  ? '${getTranslated('please_enter', context)!} ${getTranslated('confirm_password', context)!}' : null,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                      ],

                    ])),
                  )),

                  SafeArea(
                    child: Center(
                      child: Container(
                        width: width > 700 ? 700 : width,
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        margin: ResponsiveHelper.isDesktop(context)
                            ? const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall) : EdgeInsets.zero,
                        child: CustomButtonWidget(
                          isLoading: profileProvider.isLoading,
                          btnTxt: getTranslated('update', context),
                          onTap: () async {
                            String firstName = _firstNameController!.text.trim();
                            String lastName = _lastNameController!.text.trim();
                            String phoneNumber = _phoneNumberController!.text.trim();
                            String password = _passwordController!.text.trim();
                            String email = _emailController!.text.trim();

                            if(profileFormKey.currentState != null && profileFormKey.currentState!.validate()){

                              bool isChanged = profileProvider.userInfoModel!.fName == firstName &&
                                  profileProvider.userInfoModel!.lName == lastName &&
                                  profileProvider.userInfoModel!.phone == phoneNumber &&
                                  profileProvider.userInfoModel!.email == email && file == null && data == null;

                              bool isPasswordEmpty = password.isEmpty;


                              if ( isChanged && isPasswordEmpty) {
                                showCustomSnackBarHelper(getTranslated('change_something_to_update', context));
                              } else {
                                UserInfoModel updateUserInfoModel = UserInfoModel();
                                updateUserInfoModel.fName = firstName;
                                updateUserInfoModel.lName = lastName ;
                                updateUserInfoModel.phone = phoneNumber ;
                                updateUserInfoModel.email = email;

                                ResponseModel responseModel = await profileProvider.updateUserInfo(
                                  updateUserInfoModel, password, file, data,
                                  Provider.of<AuthProvider>(context, listen: false).getUserToken(),
                                );

                                if(responseModel.isSuccess) {
                                  profileProvider.getUserInfo(true);

                                  if(context.mounted){
                                    _passwordController?.clear();
                                    _confirmPasswordController?.clear();
                                    showCustomSnackBarHelper(getTranslated('updated_successfully', context), isError: false);
                                  }
                                }else {
                                  showCustomSnackBarHelper(responseModel.message);
                                }
                              }

                            }
                          }
                        ),
                      ),
                    ),
                  ),

                ]),
              )),

            ])) : const ProfileShimmerWidget();
        },
      ) : const NotLoggedInWidget(),
    );
  }
}
