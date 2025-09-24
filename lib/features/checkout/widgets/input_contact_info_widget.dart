import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/code_picker_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_dialog_shape_widget.dart';
import 'package:flutter_restaurant/features/address/domain/models/address_model.dart';
import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/checkout/providers/checkout_provider.dart';
import 'package:flutter_restaurant/features/order/screens/order_search_screen.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/profile/widgets/profile_textfield_widget.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';


class InputContactInfoWidget extends StatefulWidget {
  final AddressModel? address;
  const InputContactInfoWidget({super.key,this.address});

  @override
  State<InputContactInfoWidget> createState() => _InputContactInfoWidgetState();
}

class _InputContactInfoWidgetState extends State<InputContactInfoWidget> {
  AddressModel? selectedAddress;
  final TextEditingController _contactPersonNameController = TextEditingController();
  final TextEditingController _contactPersonNumberController = TextEditingController();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _numberNode = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey();

  String? countryCode;

  @override
  void initState() {
    super.initState();

    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(Get.context!, listen: false);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    countryCode = CountryCode.fromCountryCode(splashProvider.configModel!.countryCode!).dialCode;

   if(authProvider.isLoggedIn()){
     profileProvider.getUserInfo(false, isUpdate: false).then((value){
       String ? phoneWithCode = CountryPick.getCountryCode('${widget.address?.contactPersonNumber ?? profileProvider.userInfoModel?.phone}');
       _contactPersonNameController.text = widget.address?.contactPersonName != null ? widget.address?.contactPersonName ?? "" : "${profileProvider.userInfoModel?.fName ?? "" } ${profileProvider.userInfoModel?.lName ?? ""}";
       _contactPersonNumberController.text = phoneWithCode != null ? '${widget.address?.contactPersonNumber ?? profileProvider.userInfoModel?.phone}'.replaceAll(phoneWithCode, '') : widget.address?.contactPersonNumber?? profileProvider.userInfoModel?.phone ?? '';
       if(phoneWithCode !=null){
         setState(() {
           countryCode = phoneWithCode;
         });
       }
     });
   }else{
     String ? phoneWithCode = CountryPick.getCountryCode(widget.address?.contactPersonNumber ?? "");
     _contactPersonNameController.text = widget.address?.contactPersonName ??  "";
     _contactPersonNumberController.text =  phoneWithCode != null ? '${widget.address?.contactPersonNumber}'.replaceAll(phoneWithCode, '') : "";
     if(phoneWithCode !=null){
       countryCode = phoneWithCode;
     }
   }
  }



  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.sizeOf(context);

    return Consumer<LocationProvider>(builder: (context, locationProvider, _) {

      return CustomDialogShapeWidget(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge, vertical: Dimensions.paddingSizeLarge),
        maxHeight: size.height * 0.6, child: Form( key: formKey,
          child: Column(mainAxisSize:  MainAxisSize.min, children: [

          if(!ResponsiveHelper.isDesktop(context))  Center(child: Container(
            width: 35, height: 4, decoration: BoxDecoration(
            color: Theme.of(context).hintColor.withValues(alpha:0.3),
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ), padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          )),

          const SizedBox(height: Dimensions.paddingSizeDefault),


          Text(
            getTranslated('contact_person_info', context)!,
            style: rubikSemiBold.copyWith(fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeLarge : Dimensions.fontSizeDefault),
          ),

          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

          ProfileTextFieldWidget(
            isShowBorder: true,
            controller: _contactPersonNameController,
            focusNode: _nameNode,
            nextFocus: _numberNode,
            inputType: TextInputType.name,
            capitalization: TextCapitalization.words,
            level: getTranslated('contact_person_name', context)!,
            hintText: getTranslated('ex_john_doe', context)!,
            isFieldRequired: false,
            isShowPrefixIcon: true,
            prefixIconUrl: Images.profileIconSvg,
            inputAction: TextInputAction.next,
            onValidate: (value) => value!.isEmpty
                ? '${getTranslated('please_enter', context)!} ${getTranslated('contact_person_name', context)!}' : null,
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          PhoneNumberFieldView(
            onValueChange: (code){
              countryCode = code;
            },
            countryCode: countryCode,
            phoneNumberTextController: _contactPersonNumberController,
            phoneFocusNode: _numberNode,
          ),

          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

          CustomButtonWidget(
            btnTxt: getTranslated('save', context),
            onTap: (){
              if(formKey.currentState?.validate() ?? false){
                AddressModel addressModel = AddressModel(
                  contactPersonName: _contactPersonNameController.text,
                  contactPersonNumber: _contactPersonNumberController.text.trim().isEmpty ? ''
                      : '$countryCode${_contactPersonNumberController.text.trim()}',
                );

                if(_contactPersonNumberController.text.isEmpty){
                  showCustomSnackBarHelper('${getTranslated('enter_phone_number', context)} ', isToast: true, isError: true);

                }else{
                  Provider.of<CheckoutProvider>(context, listen: false).setSelectedAddress(addressModel);
                  Navigator.of(context).pop();
                }
              }
            },
          )

                ]),
        ),
      );
    });
  }
}