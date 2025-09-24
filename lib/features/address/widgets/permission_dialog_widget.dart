import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

class PermissionDialogWidget extends StatelessWidget {
  const PermissionDialogWidget({super.key});


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: SizedBox(
          width: 500,
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            Icon(Icons.add_location_alt_rounded, color: Theme.of(context).primaryColor, size: 100),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            ResponsiveHelper.isMobilePhone() ? Text(
              getTranslated('you_denied_location_permission', context)!, textAlign: TextAlign.center,
              style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),
            ) : Text(
              getTranslated('please_enable_location_permission_from_browser_settings', context)!, textAlign: TextAlign.center,
              style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Row(children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), side: BorderSide(width: 2, color: Theme.of(context).primaryColor)),
                    minimumSize: const Size(1, 50),
                  ),
                  child: Text(getTranslated('close', context)!),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              ResponsiveHelper.isMobilePhone() ? Expanded(child: CustomButtonWidget(btnTxt: getTranslated('settings', context), onTap: () async {
                await Geolocator.openAppSettings();

                if(context.mounted) {
                  context.pop();
                }

              })) : const SizedBox(),
            ]),
          ]),
        ),
      ),
    );
  }
}
