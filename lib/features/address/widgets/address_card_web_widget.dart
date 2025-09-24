import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_alert_dialog_widget.dart';
import 'package:flutter_restaurant/features/address/domain/models/address_model.dart';
import 'package:flutter_restaurant/features/address/enum/route_tyep_enum.dart';
import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AddressCardWebWidget extends StatelessWidget {
  const AddressCardWebWidget({super.key, required this.addressModel, required this.index});

  final AddressModel addressModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      clipBehavior: Clip.hardEdge,
      child: Stack(children: [

        Column(children: [

            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              color: Theme.of(context).primaryColor.withValues(alpha:0.05),
              child: Row(children: [
                Expanded(child: Text(addressModel.addressType!, style: rubikSemiBold)),

                IconButton(
                  onPressed: () {
                    RouterHelper.getAddAddressRoute(page: 'address', action: 'update', addressModel: addressModel, routeType: RouteTypeEnum.address);


                  },
                  icon: const Icon(Icons.edit_location_alt, size: Dimensions.paddingSizeLarge),
                ),

                IconButton(
                  onPressed: ()=> ResponsiveHelper.showDialogOrBottomSheet(context, Consumer<LocationProvider>(
                    builder: (context, locationProvider, _) {
                      return CustomAlertDialogWidget(
                        isLoading: locationProvider.isLoading,
                        title: getTranslated('want_to_delete', context)!,
                        icon: Icons.question_mark_outlined,
                        leftButtonText: getTranslated('no', context),
                        rightButtonText: getTranslated('yes', context),
                        onPressRight: () async {
                          await locationProvider.deleteUserAddressByID(addressModel.id, index, (bool isSuccessful, String message) {
                            context.pop();
                            showCustomSnackBarHelper(message, isError: !isSuccessful);
                          });
                        },
                      );
                    },
                  ),),
                  icon:  Icon(Icons.delete, size: Dimensions.paddingSizeLarge, color: Theme.of(context).colorScheme.error),
                ),
              ]),
            ),

            Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault), child: Column(children: [
              Row(children: [
                Expanded(flex: 2, child: Text(getTranslated('name', context)!, style: rubikSemiBold)),
                Expanded(
                  flex: 9,
                  child: Text(
                    addressModel.contactPersonName ?? '',
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: rubikRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
                  ),
                ),
              ]),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Row(children: [
                Expanded(flex: 2, child: Text(getTranslated('phone', context)!, style: rubikSemiBold)),

                Expanded(flex: 9, child: Text(
                  addressModel.contactPersonNumber ?? '',
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: rubikRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
                )),
              ]),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Row(children: [
                Expanded(flex: 2, child: Text(getTranslated('address', context)!, style: rubikSemiBold)),

                Expanded(flex: 9, child: Text(
                  addressModel.address ?? '',
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: rubikRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
                )),
              ]),
            ])),

          ]),


      ]),
    );
  }
}
