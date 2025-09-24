import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/address/domain/models/address_model.dart';
import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
import 'package:flutter_restaurant/features/order/screens/order_search_screen.dart';
import 'package:flutter_restaurant/features/profile/widgets/profile_textfield_widget.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class PersonInfoWidget extends StatelessWidget {
  const PersonInfoWidget({
    super.key,
    required this.contactPersonNameController,
    required this.contactPersonNumberController,
    required this.nameNode,
    required this.numberNode,
    required this.countryCode,
    required this.isEnableUpdate,
    required this.fromCheckout,
    required this.address,
    required this.onValueChange,
  });

  final TextEditingController contactPersonNameController;
  final TextEditingController contactPersonNumberController;

  final FocusNode nameNode;
  final FocusNode numberNode;

  final String? countryCode;

  final bool isEnableUpdate;
  final bool fromCheckout;
  final AddressModel? address;

  final void Function(String) onValueChange;

  @override
  Widget build(BuildContext context) {
    // String? _countryCode = countryCode;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color:ColorResources.cardShadowColor.withValues(alpha:0.2), blurRadius: 10)],
      ),
      //margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall,vertical: Dimensions.paddingSizeLarge),
      padding: ResponsiveHelper.isDesktop(context)
          ?  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeLarge)
          : const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Consumer<LocationProvider>(
          builder: (context, locationProvider, _) {
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              if(!ResponsiveHelper.isDesktop(context)) const SizedBox(height: Dimensions.paddingSizeLarge),
              Text(
                getTranslated('contact_person_info', context)!,
                style: rubikSemiBold.copyWith(fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeLarge : Dimensions.fontSizeDefault),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              if(! ResponsiveHelper.isDesktop(context))...[
                /// for Contact Person Name
                ProfileTextFieldWidget(
                  isShowBorder: true,
                  controller: contactPersonNameController,
                  focusNode: nameNode,
                  nextFocus: numberNode,
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

                /// for Contact Person Number
                PhoneNumberFieldView(
                  onValueChange: (code){
                    // _countryCode = code;
                    onValueChange(code);
                  },
                  countryCode: countryCode,
                  phoneNumberTextController: contactPersonNumberController,
                  phoneFocusNode: numberNode,
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),
              ],

              if(ResponsiveHelper.isDesktop(context))
                Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: ProfileTextFieldWidget(
                    isShowBorder: true,
                    controller: contactPersonNameController,
                    focusNode: nameNode,
                    nextFocus: numberNode,
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
                  )),
                  const SizedBox(width: Dimensions.paddingSizeLarge),

                  Expanded(child: PhoneNumberFieldView(
                    onValueChange: (code){
                      // _countryCode = code;
                      onValueChange(code);
                    },
                    countryCode: countryCode,
                    phoneNumberTextController: contactPersonNumberController,
                    phoneFocusNode: numberNode,
                  )),
                ]),

            ]);
          }
      ),
    );
  }
}
