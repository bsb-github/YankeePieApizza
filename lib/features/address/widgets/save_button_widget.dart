import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/features/address/domain/models/address_model.dart';
import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:provider/provider.dart';

class SaveButtonWidget extends StatelessWidget {
  const SaveButtonWidget({super.key, this.isEnableUpdate = false, this.address, this.fromCheckout = false, this.onTap});

  final bool isEnableUpdate;
  final bool fromCheckout;
  final AddressModel? address;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
        builder: (context, locationProvider, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeExtraSmall),
            child: !locationProvider.isLoading ? CustomButtonWidget(
              width: 180,
              height: 50.0,
              btnTxt: isEnableUpdate ? getTranslated('update_address', context) : getTranslated('save_info', context),
              onTap: locationProvider.loading ? null : onTap,
            ) : Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                )),
          );
        }
    );
  }
}
