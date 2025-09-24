import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/helper/number_checker_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:provider/provider.dart';

class CreateNewPasswordScreen extends StatelessWidget {
  final String? resetToken;
  final String? emailOrPhone;
  CreateNewPasswordScreen({super.key, required this.resetToken, required this.emailOrPhone});

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBarWidget(context: context, title: getTranslated('create_new_password', context)),
      body: SafeArea(
       child: Center(child: CustomScrollView(slivers: [

         if(ResponsiveHelper.isDesktop(context))
           SliverToBoxAdapter(child: SizedBox(height: width * 0.02)),

         SliverToBoxAdapter(child: Center(child: Consumer<AuthProvider>(
           builder: (context, auth, child) {
             return Container(
               width: width > 700 ? 500 : width,
               padding: width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
               decoration: width > 700 ? BoxDecoration(
                 color: Theme.of(context).canvasColor, borderRadius: BorderRadius.circular(10),
                 boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)],
               ) : null,

               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   const SizedBox(height: 55),
                   const Center(
                     child: CustomAssetImageWidget(
                       Images.createNewPasswordBackgroundSvg,
                       width: 142,
                       height: 142,
                     ),
                   ),
                   const SizedBox(height: 40),
                   Center(
                       child: Text(
                         getTranslated('enter_password_to_create', context)!,
                         textAlign: TextAlign.center,
                         style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorResources.getHintColor(context)),
                       )),
                   Padding(
                     padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         // for password section

                         const SizedBox(height: 60),
                         CustomTextFieldWidget(
                           hintText: getTranslated('password_hint', context),
                           label: getTranslated('password', context),
                           isShowBorder: true,
                           isRequired: true,
                           isPassword: true,
                           isShowSuffixIcon: true,
                           focusNode: _passwordFocus,
                           controller: _passwordController,
                           inputAction: TextInputAction.done,
                           prefixIconUrl: Images.lockSvg,
                           isShowPrefixIcon: true,
                           prefixIconColor: Theme.of(context).colorScheme.error,
                         ),
                         const SizedBox(height: Dimensions.paddingSizeLarge),
                         // for confirm password section
                         CustomTextFieldWidget(
                           hintText: getTranslated('password_hint', context),
                           label: getTranslated('confirm_password', context),
                           isShowBorder: true,
                           isRequired: true,
                           isPassword: true,
                           isShowSuffixIcon: true,
                           focusNode: _confirmPasswordFocus,
                           controller: _confirmPasswordController,
                           inputAction: TextInputAction.done,
                           prefixIconUrl: Images.lockSvg,
                           isShowPrefixIcon: true,
                           prefixIconColor: Theme.of(context).colorScheme.error,
                         ),

                         const SizedBox(height: 24),
                         !auth.isForgotPasswordLoading ? CustomButtonWidget(
                           btnTxt: getTranslated('save', context),
                           onTap: () {
                             if (_passwordController.text.isEmpty) {
                               showCustomSnackBarHelper(getTranslated('enter_password', context));
                             }else if (_passwordController.text.length < 6) {
                               showCustomSnackBarHelper(getTranslated('password_should_be', context));
                             }else if (_confirmPasswordController.text.isEmpty) {
                               showCustomSnackBarHelper(getTranslated('enter_confirm_password', context));
                             }else if(_passwordController.text != _confirmPasswordController.text) {
                               showCustomSnackBarHelper(getTranslated('password_did_not_match', context));
                             }else {

                               bool isNumber = NumberCheckerHelper.isNumber(emailOrPhone!.replaceAll('+', ''));

                               auth.resetPassword(emailOrPhone, resetToken, _passwordController.text, _confirmPasswordController.text, type: isNumber ? 'phone': 'email').then((value) {
                                 if(value.isSuccess) {
                                   auth.login(emailOrPhone, _passwordController.text,isNumber ? 'phone' : 'email').then((value) async {
                                     // await Provider.of<WishListProvider>(context, listen: false).initWishList(
                                     //   Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
                                     // );
                                     if(value.isSuccess) {
                                       RouterHelper.getMainRoute();
                                     }
                                   });
                                 }else {
                                   showCustomSnackBarHelper('Failed to reset password');
                                 }
                               });
                             }
                           },
                         ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                       ],

                     ),
                   )
                 ],
               ),
             );
           }
         ))),

         if(ResponsiveHelper.isDesktop(context))
           SliverToBoxAdapter(child: SizedBox(height: width * 0.02)),

         if(ResponsiveHelper.isDesktop(context)) const SliverFillRemaining(
           hasScrollBody: false,
           child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
             SizedBox(height: Dimensions.paddingSizeLarge),

             FooterWidget(),
           ]),
         ),

       ],),),
      )
    );
  }
}
