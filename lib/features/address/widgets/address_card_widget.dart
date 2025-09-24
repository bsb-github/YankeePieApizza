import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_alert_dialog_widget.dart';
import 'package:flutter_restaurant/features/address/domain/models/address_model.dart';
import 'package:flutter_restaurant/features/address/enum/route_tyep_enum.dart';
import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
import 'package:flutter_restaurant/features/address/widgets/delete_confirmation_dialog_widget.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AddressCardWidget extends StatelessWidget {
  final AddressModel addressModel;
  final int index;
  const AddressCardWidget({super.key, required this.addressModel, required this.index});

  @override
  Widget build(BuildContext context) {

    final LocationProvider locationProvider = Provider.of<LocationProvider>(context, listen: false);


    return InkWell(
      hoverColor: Colors.transparent,
      onTap: () {
        RouterHelper.getMapRoute(addressModel);
      },
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).primaryColor.withValues(alpha:0.1), borderRadius: BorderRadius.circular(10)),
        child: Stack(children: [

          Positioned(
            top: 0, bottom: 0, right: 20,
            child: Icon(Icons.delete, color: Theme.of(context).primaryColor, size: Dimensions.paddingSizeLarge),
          ),

          Dismissible(
            key: UniqueKey(),
            confirmDismiss: (value) async{
              ResponsiveHelper.showDialogOrBottomSheet(
                  context, CustomAlertDialogWidget(
                rightButtonText: getTranslated('yes', context),
                leftButtonText: getTranslated('no', context),
                //description: '',
                icon: Icons.contact_support,
                title: getTranslated('want_to_delete', context),
                onPressRight: (){
                  showDialog(context: context, barrierDismissible: false, builder: (context) => Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                    ),
                  ));
                  Provider.of<LocationProvider>(context, listen: false).deleteUserAddressByID(addressModel.id, index, (bool isSuccessful, String message) {
                    context.pop();
                    showCustomSnackBarHelper(message, isError: !isSuccessful);
                    context.pop();
                  });
                },
                onPressLeft: ()=> context.pop(),
                // child: DeleteConfirmationDialogWidget(addressModel: addressModel, index: index)),
              ));
              return null;
            },
            
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                boxShadow: [BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha:0.5),
                  blurRadius: Dimensions.radiusDefault, spreadRadius: Dimensions.radiusSmall,
                )],
              ),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(
                  addressModel.addressType!.toLowerCase() == "home"
                      ? Icons.home_filled
                      : addressModel.addressType!.toLowerCase() == "workplace"
                      ? Icons.work_outline
                      : Icons.list_alt_outlined,
                  color: Theme.of(context).primaryColor.withValues(alpha:0.8),
                  size: Dimensions.paddingSizeLarge,
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(addressModel.addressType!, style: rubikSemiBold),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Text(
                    addressModel.address!,
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: rubikRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
                  ),
                ])),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                PopupMenuButton<String>(
                  icon: Icon(Icons.edit, size: Dimensions.fontSizeLarge, color: Theme.of(context).indicatorColor),
                  padding: EdgeInsets.zero,
                  onSelected: (String result) {
                    if (result == 'delete') {
                      showDialog(context: context, barrierDismissible: false, builder: (context) => DeleteConfirmationDialogWidget(addressModel: addressModel,index: index));
                    } else {
                      locationProvider.updateAddressStatusMessage(message: '');

                      RouterHelper.getAddAddressRoute(page: 'address',action:  'update', addressModel:  addressModel, routeType: RouteTypeEnum.address);
                    }
                  },
                  itemBuilder: (BuildContext c) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Text(getTranslated('edit', context)!, style: Theme.of(context).textTheme.displayMedium),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Text(getTranslated('delete', context)!, style: Theme.of(context).textTheme.displayMedium),
                    ),
                  ],
                ),
              ]),
            ),
          ),

          // Positioned(
          //   top: 0, left: 0, bottom: 0, right: 0,
          //   child: Container(
          //     alignment: Alignment.center,
          //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black.withValues(alpha:0.5)),
          //     child: Text(
          //       getTranslated('out_of_coverage_for_this_branch', context)!,
          //       textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
          //       style: rubikRegular.copyWith(color: Colors.white, fontSize: 10),
          //     ),
          //   ),
          // )

        ]),
      ),
    );
  }
}
