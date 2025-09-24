import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_dialog_shape_widget.dart';
import 'package:flutter_restaurant/features/address/domain/models/address_model.dart';
import 'package:flutter_restaurant/features/address/enum/route_tyep_enum.dart';
import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/branch/providers/branch_provider.dart';
import 'package:flutter_restaurant/features/checkout/providers/checkout_provider.dart';
import 'package:flutter_restaurant/features/profile/domain/models/userinfo_model.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/checkout_helper.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class SelectedAddressListWidget extends StatefulWidget {
  const SelectedAddressListWidget({
    super.key, required this.currentBranch, this.isFromAppbar = false,  this.isFreeDelivery = false,
  });

  final Branches? currentBranch;
  final bool isFromAppbar;
  final bool isFreeDelivery ;


  @override
  State<SelectedAddressListWidget> createState() => _SelectedAddressListWidgetState();
}

class _SelectedAddressListWidgetState extends State<SelectedAddressListWidget> {
  AddressModel? selectedAddress;
  @override

  void initState() {
    super.initState();
    final CheckoutProvider checkoutProvider = Provider.of<CheckoutProvider>(context, listen: false);
    final LocationProvider locationProvider = Provider.of< LocationProvider>(context, listen: false);

    if(locationProvider.addressList == null) {
      locationProvider.initAddressList();
    }

    selectedAddress = widget.isFromAppbar ? locationProvider.currentAddress : checkoutProvider.selectedAddress;
  }

 void updateSelectedAddress({AddressModel? addressModel}){
    setState(() {
      selectedAddress = addressModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final CheckoutProvider checkoutProvider = Provider.of<CheckoutProvider>(context, listen: false);
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final bool isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    final UserInfoModel? userInfo = Provider.of<ProfileProvider>(context, listen: false).userInfoModel;

    final Size size = MediaQuery.sizeOf(context);

    return Consumer<LocationProvider>(builder: (context, locationProvider, _) {

      return CustomDialogShapeWidget(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge, vertical: Dimensions.paddingSizeLarge),
        maxHeight: size.height * 0.6, child: Column(mainAxisSize:  MainAxisSize.min, children: [

        if(!ResponsiveHelper.isDesktop(context))  Center(child: Container(
          width: 35, height: 4, decoration: BoxDecoration(
          color: Theme.of(context).hintColor.withValues(alpha:0.3),
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        )),

        const SizedBox(height: Dimensions.paddingSizeDefault),
        Text(getTranslated("select_address", context)!, style: rubikSemiBold.copyWith(
          fontSize: Dimensions.fontSizeDefault,
        )),

        locationProvider.addressList == null ? const _AddressShimmerWidget(enabled: true,) :

        (locationProvider.addressList?.isNotEmpty ?? false) ? Expanded(child: Column(children: [

          TextButton.icon(
            onPressed: locationProvider.loading ? null : () async {

              await _onActionCurrentLocation(context, isLoggedIn,  userInfo);
            },
            icon: locationProvider.loading ? const SizedBox(height: 15, width: 15, child: CircularProgressIndicator()) : Icon(Icons.gps_fixed_outlined, color: Theme.of(context).primaryColor),
            label: Text(getTranslated(locationProvider.loading ? 'loading' : 'use_my_current_location', context)!, style: rubikSemiBold.copyWith(
              color: Theme.of(context).primaryColor,
            )),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),


          Expanded(child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: locationProvider.addressList?.length ?? 0,
            itemBuilder: (context, index) {



              final bool isAvailable = splashProvider.deliveryInfoModel?.deliveryChargeSetup?.deliveryChargeType == 'distance'
                  ? CheckOutHelper.isAddressInCoverage(widget.currentBranch, locationProvider.addressList![index])
                  : true;


              final bool isActive = widget.isFromAppbar
                  ? (locationProvider.addressList?[index].id != locationProvider.currentAddress?.id)
                  : (locationProvider.addressList?[index].id != checkoutProvider.selectedAddress?.id);

              return Padding(
                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                child: _AddressDismissibleWidget(
                  isActive: isActive,
                  addressId: locationProvider.addressList?[index].id,
                  addressIndex: index,
                  child: Material(
                    color: locationProvider.addressList?[index].id == selectedAddress?.id ?  Theme.of(context).primaryColor.withValues(alpha:0.07) : Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      side: locationProvider.addressList?[index].id == selectedAddress?.id ? BorderSide(color: Theme.of(context).primaryColor, width: 1) : BorderSide.none,
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: isAvailable ? (){
                        updateSelectedAddress(addressModel: locationProvider.addressList?[index]);
                      } : null,
                      child: Stack(children: [
                        Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault), child: Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.transparent,
                                border: Border.all(color: locationProvider.addressList?[index].id == selectedAddress?.id ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, width: 2)
                            ),
                            padding: const EdgeInsets.all(2),
                            margin: const EdgeInsets.only(top: 3),
                            child:  Icon(Icons.circle, color: locationProvider.addressList?[index].id == selectedAddress?.id ? Theme.of(context).primaryColor : Colors.transparent , size: 10) ,
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                              Text(locationProvider.addressList![index].addressType!, style: rubikSemiBold.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                              )),
                              const SizedBox(height: 3),

                              Text(locationProvider.addressList![index].address!, style: rubikRegular, maxLines: 1, overflow: TextOverflow.ellipsis),
                            ]),
                          ),

                        ])),

                        !isAvailable ? Positioned(
                          top: 0, left: 0, bottom: 0, right: 0,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black.withValues(alpha:0.6)),
                            child: Text(
                              getTranslated('out_of_coverage_for_this_branch', context)!,
                              textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
                              style: rubikRegular.copyWith(color: Colors.white, fontSize: 10),
                            ),
                          ),
                        ) : const SizedBox(),
                      ]),
                    ),
                  ),
                ),
              );
            },
          )),


          if((locationProvider.addressList?.isNotEmpty ?? false) && isLoggedIn) TextButton.icon(
            onPressed: () async {
              Navigator.pop(context);
              RouterHelper.getAddAddressRoute(
              page: 'checkout',
                action: 'add',
                addressModel: AddressModel(),
                routeType: widget.isFromAppbar ? RouteTypeEnum.appbar : RouteTypeEnum.checkout,
              );

            },
            icon: Icon(Icons.add_circle_outline_sharp, color: Theme.of(context).primaryColor),
            label: Text(getTranslated('add_new_address', context)!, style: rubikSemiBold.copyWith()),
          )])) :

        _AddressListEmptyWidget(size: size, isLoggedIn: isLoggedIn, isFromAppbar: widget.isFromAppbar),

        const SizedBox(height: Dimensions.paddingSizeDefault),

        if((locationProvider.addressList?.isNotEmpty ?? false)) CustomButtonWidget(
          btnTxt: getTranslated("select", context),
          backgroundColor: Theme.of(context).primaryColor,
          onTap: selectedAddress?.id != null ? ()  async {

            if(widget.isFromAppbar) {
              locationProvider.onChangeCurrentAddress(selectedAddress, isUpdate: true);
            }

            CheckOutHelper.selectDeliveryAddress(
              splashProvider: splashProvider,
              isAvailable: true,
              address: selectedAddress,
              configModel: splashProvider.configModel!,
              locationProvider: locationProvider,
              checkoutProvider: checkoutProvider,
              shouldResetPaymentAndShowDeliveryDialog: true,
              enableChargeCalculation: !widget.isFromAppbar,
              isFreeDelivery: widget.isFreeDelivery
            );

            if(context.mounted) {
              context.pop();
            }
          } : null,
        ),

      ]),
      );
    });
  }

  Future<void> _onActionCurrentLocation(BuildContext context, bool isLoggedIn, UserInfoModel? userInfo) async {
    final CheckoutProvider checkoutProvider = Provider.of<CheckoutProvider>(context, listen: false);
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final LocationProvider locationProvider = Provider.of<LocationProvider>(context, listen: false);
    final BranchProvider branchProvider = Provider.of<BranchProvider>(context, listen: false);


    if(widget.isFromAppbar) {
     final bool isSuccess = await locationProvider.checkPermission(() async => locationProvider.onChangeCurrentAddress(
        await locationProvider.getCurrentLocation(context, true),
      ));

      ///to pop the bottomSheet
      if(isSuccess && context.mounted) {
        context.pop();
      }

    }else {
      if(isLoggedIn) {

        await locationProvider.checkPermission(() async {
          final AddressModel? address =  await locationProvider.getCurrentLocation(context, true);


          if(context.mounted) {
            ///to pop the bottomSheet
            context.pop();

            if(address != null) {
              await CheckOutHelper.selectDeliveryAddress(
                isAvailable: CheckOutHelper.isAddressInCoverage(branchProvider.getBranch(), address),
                splashProvider: splashProvider,
                address: address.copyWith(
                  contactPhoneNumber: userInfo?.phone,
                  contactName: '${userInfo?.fName} ${userInfo?.lName}',
                ),
                configModel: splashProvider.configModel!,
                locationProvider: locationProvider,
                checkoutProvider: checkoutProvider,
                shouldResetPaymentAndShowDeliveryDialog: true,
                enableChargeCalculation: true,
                isFreeDelivery: widget.isFreeDelivery
              );
            }


          }



        });




      }else {
        ///to pop the bottomSheet
        context.pop();

        RouterHelper.getAddAddressRoute(
          page: 'checkout',
          routeType: RouteTypeEnum.checkout,
          action: 'add',
          addressModel: checkoutProvider.selectedAddress?.id == null
              ? checkoutProvider.selectedAddress
              ?? AddressModel() : AddressModel(),
          isCurrentLocation: true,
        );
      }
    }
  }

}

class _AddressListEmptyWidget extends StatelessWidget {
  const _AddressListEmptyWidget({
    required this.size,
    required this.isLoggedIn,
    required this.isFromAppbar,

  });

  final Size size;
  final bool isLoggedIn;
  final bool isFromAppbar;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column( mainAxisSize: MainAxisSize.min, children: [

      const SizedBox(height: Dimensions.paddingSizeLarge, width: Dimensions.webScreenWidth),
        const CustomAssetImageWidget(Images.selectAddressBottomSheetIcon,
            height: 150, width: 220, fit: BoxFit.contain
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge, width: Dimensions.webScreenWidth),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.fontSizeExtraSmall),
          child: Text(
            getTranslated('you_dont_have_any_saved_address_yet', context)!,
            style: rubikRegular.copyWith(color: Theme.of(context).hintColor),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),


      SizedBox(
        width: size.width * 0.7,
        child: Consumer<LocationProvider>(builder: (context, locationProvider, _) {
            return CustomButtonWidget(
              isLoading: locationProvider.loading,
              btnTxt: getTranslated("use_my_current_location", context),
              iconData: Icons.gps_fixed,
              backgroundColor: Theme.of(context).primaryColor,
              onTap: () async {
                final isSuccess = await locationProvider.checkPermission(
                      () async {
                    final currentLocation = await locationProvider.getCurrentLocation(context, true);
                    locationProvider.onChangeCurrentAddress(currentLocation);
                  },
                );

                if (isSuccess && context.mounted) {
                  context.pop();
                }
              },
            );
          }
        ),
      ),

      const SizedBox(height: Dimensions.paddingSizeLarge),


      if(isLoggedIn) TextButton.icon(
        onPressed: () async {
          Navigator.pop(context);
          RouterHelper.getAddAddressRoute(
            page: 'checkout', action: 'add', addressModel: AddressModel(),
            routeType: isFromAppbar ? RouteTypeEnum.appbar : RouteTypeEnum.checkout,
          );

        },
        icon: Icon(Icons.add_circle_outline_sharp, color: Theme.of(context).primaryColor),
        label: Text(getTranslated('add_new_address', context)!, style: rubikSemiBold.copyWith(
          color: Theme.of(context).primaryColor,
        )),
      ),

      ]),
    );
  }
}

class _AddressShimmerWidget extends StatelessWidget {
  const _AddressShimmerWidget({
    required this.enabled,
  });

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) => Shimmer(enabled: enabled, child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).hintColor.withValues(alpha:0.2),
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        ),
        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
        child: Row(children: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall), child: Container(
            width: Dimensions.paddingSizeLarge, height: Dimensions.paddingSizeLarge,
            color: Theme.of(context).hintColor.withValues(alpha:0.3),
          )),

          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 200, height: Dimensions.paddingSizeLarge,
                color: Theme.of(context).hintColor.withValues(alpha:0.3),
                margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
              ),

              Container(
                width: 150, height: Dimensions.paddingSizeLarge,
                color: Theme.of(context).hintColor.withValues(alpha:0.3),
              ),
            ]),
          ),
        ]),
      )),
    );
  }
}


class _AddressDismissibleWidget extends StatelessWidget {
  final Widget child;
  final int? addressId;
  final int addressIndex;
  final bool isActive;
  const _AddressDismissibleWidget({required this.child, required this.addressId, required this.addressIndex, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return !isActive ? child : ClipRRect(
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault), // Match the dialog's border radius
      child: Dismissible(
        key: UniqueKey(), // Unique key
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (context) => Consumer<LocationProvider>(
                builder: (context, locationProvider, _) {
                  return AlertDialog(
                    title: Text(getTranslated('delete_address', context)!),
                    content: Text(getTranslated('are_you_sure_to_delete_this_address', context)!),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(getTranslated('cancel', context)!),
                      ),
                      TextButton(
                        onPressed: locationProvider.isLoading ? null : () async {
                          await locationProvider.deleteUserAddressByID(addressId, addressIndex, (bool isSuccessful, String message) {

                            ///need to pop the bottomSheet if user have no other address
                            if(locationProvider.addressList?.isEmpty ?? false) {
                              context.pop();
                            }

                            showCustomSnackBarHelper(message, isError: !isSuccessful);

                          });

                          if(context.mounted) {
                            Navigator.of(context).pop(true);
                          }
                        },
                        child: locationProvider.isLoading
                            ? const SizedBox(height: Dimensions.paddingSizeLarge, width: Dimensions.paddingSizeLarge, child: CircularProgressIndicator())
                            : Text(getTranslated('delete', context)!),
                      ),
                    ],
                  );
                }
            ),
          );
        },
        background: Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault), // Match the child's border radius
          ),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault), // Match the background's border radius
          ),
          child: child, // Ensure the child has the same styling as the background
        ),
      ),
    );
  }
}