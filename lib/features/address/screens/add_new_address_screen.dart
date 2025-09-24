import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/models/delivery_info_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_restaurant/features/address/domain/models/address_model.dart';
import 'package:flutter_restaurant/features/address/domain/models/input_model.dart';
import 'package:flutter_restaurant/features/address/enum/route_tyep_enum.dart';
import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
import 'package:flutter_restaurant/features/address/widgets/address_input_web_widget.dart';
import 'package:flutter_restaurant/features/address/widgets/app_address_widget.dart';
import 'package:flutter_restaurant/features/address/widgets/person_info_widget.dart';
import 'package:flutter_restaurant/features/address/widgets/save_button_widget.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/common/widgets/code_picker_widget.dart';
import 'package:flutter_restaurant/features/checkout/providers/checkout_provider.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/checkout_helper.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';


class AddNewAddressScreen extends StatefulWidget {
  final bool isEnableUpdate;
  final bool fromCheckout;
  final RouteTypeEnum routeType;
  final AddressModel? address;
  final bool isCurrentLocation;
  const AddNewAddressScreen({super.key, this.isEnableUpdate = false, this.address, this.fromCheckout = false, this.isCurrentLocation = false, required this.routeType});

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final TextEditingController _contactPersonNameController = TextEditingController();
  final TextEditingController _contactPersonNumberController = TextEditingController();
  final TextEditingController _locationTextController = TextEditingController();
  final TextEditingController _streetNumberController = TextEditingController();
  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _florNumberController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final FocusNode _addressNode = FocusNode();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _numberNode = FocusNode();
  final FocusNode _stateNode = FocusNode();
  final FocusNode _houseNode = FocusNode();
  final FocusNode _floorNode = FocusNode();
  DeliveryInfoModel? _deliveryInfoModel;

  final List<Branches?> _branches = [];
  bool _updateAddress = true;
  bool _isInteractingWithMap = false;
  String? countryCode;

  GlobalKey<FormState> addressFormKey = GlobalKey();

  _initLoading() async {
    final LocationProvider locationProvider = Provider.of<LocationProvider>(context, listen: false);
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    _deliveryInfoModel = splashProvider.deliveryInfoModel;

    countryCode = CountryCode.fromCountryCode(splashProvider.configModel!.countryCode!).code;
    final userModel =  Provider.of<ProfileProvider>(context, listen: false).userInfoModel;

    _branches.addAll(splashProvider.configModel?.branches ?? []);
    locationProvider.initializeAllAddressType(context: context);
    locationProvider.updateAddressStatusMessage(message: '');
    locationProvider.updateErrorMessage(message: '');
    locationProvider.setPickedAddressLatLon(null, null, isUpdate: false);

    ///update the save profile checkbox status
    locationProvider.onChangeSaveAddressStatus(!widget.isCurrentLocation, isUpdate: false);


    if ( widget.address != null) {
      String? code = CountryPick.getCountryCode('${widget.address!.contactPersonNumber}');

      if(code != null){
        countryCode =  CountryCode.fromDialCode(code).code;
      }
      _updateAddress = true;

      locationProvider.setPickedAddressLatLon(widget.address!.latitude, widget.address!.longitude, isUpdate: false);

      if(splashProvider.configModel?.googleMapStatus == 1){
        if(widget.address?.latitude != null && widget.address?.longitude != null){
          locationProvider.updatePosition(CameraPosition(
            target: LatLng(double.parse(widget.address!.latitude!), double.parse(widget.address!.longitude!)),
          ), true, widget.address!.address, context, false, isUpdate: false);
        }
      }


      _contactPersonNameController.text = widget.address?.contactPersonName ?? '';
      _contactPersonNumberController.text = code != null ? '${widget.address?.contactPersonNumber}'.replaceAll(code, '') : widget.address?.contactPersonNumber ?? '';
      _streetNumberController.text = widget.address?.streetNumber ?? '';
      _houseNumberController.text = widget.address?.houseNumber ?? '';
      _florNumberController.text = widget.address?.floorNumber ?? '';

      if (widget.address?.addressType == 'Home') {
        locationProvider.updateAddressIndex(0, false);

      } else if (widget.address?.addressType == 'Workplace') {
        locationProvider.updateAddressIndex(1, false);

      } else {
        locationProvider.updateAddressIndex(2, false);

      }

    }else {
      if(authProvider.isLoggedIn()){
        String? code = CountryPick.getCountryCode(userModel?.phone);

        if(code != null){
          countryCode = CountryCode.fromDialCode(code).code;
        }
        _contactPersonNameController.text = '${userModel?.fName ?? ''}'' ${userModel?.lName ?? ''}';
        _contactPersonNumberController.text = (code != null ? (userModel?.phone ?? '').replaceAll(code, '') : userModel?.phone ?? '');
        _streetNumberController.text = widget.address?.streetNumber ?? '';
        _houseNumberController.text = widget.address?.houseNumber ?? '';
        _florNumberController.text = widget.address?.floorNumber ?? '';

      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initLoading();
    if(widget.address != null && !widget.fromCheckout) {
      _locationTextController.text = widget.address!.address!;
    }
  }

  void _handleInteractingWithMap(bool value) {
    setState(() {
      _isInteractingWithMap = value;
    });
    if (kDebugMode) {
      print("Is Moving $value");
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;


    return Scaffold(
      appBar:(ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBarWidget())
          : CustomAppBarWidget(
              context: context,
              title:  getTranslated(widget.isEnableUpdate ? 'update_address' : 'add_delivery_info', context),
              centerTitle: true,
            )) as PreferredSizeWidget?,
      body: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          return Form(key: addressFormKey, child: Column(children: [

            Expanded(child: SingleChildScrollView(
              physics: _isInteractingWithMap ? const NeverScrollableScrollPhysics() : const ClampingScrollPhysics(),
              child: Column(children: [
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && height < 600 ? height : height - 400),
                  child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeLarge), child: Center(child: SizedBox(
                    width: Dimensions.webScreenWidth,
                    child: Column(children: [

                      if(!ResponsiveHelper.isDesktop(context)) PersonInfoWidget(
                        contactPersonNameController: _contactPersonNameController,
                        contactPersonNumberController: _contactPersonNumberController,
                        address: widget.address,
                        fromCheckout: widget.fromCheckout,
                        isEnableUpdate: widget.isEnableUpdate,
                        nameNode: _nameNode,
                        numberNode: _numberNode,
                        countryCode: countryCode,
                        onValueChange: (code) {
                          countryCode = code;
                        },
                      ),
                      if(!ResponsiveHelper.isDesktop(context)) const SizedBox(height: Dimensions.paddingSizeDefault),

                      if(!ResponsiveHelper.isDesktop(context)) AppAddressWidget(
                        inputModel: InputModel(
                          nameNode: _nameNode,
                          addressNode: _addressNode,
                          floorNode: _floorNode,
                          houseNode: _houseNode,
                          stateNode: _stateNode,
                          florNumberController: _florNumberController,
                          houseNumberController: _houseNumberController,
                          locationTextController: _locationTextController,
                          streetNumberController: _streetNumberController,
                          branches: _branches,
                          isEnableUpdate: widget.isEnableUpdate,
                          fromCheckout: widget.fromCheckout,
                          address: widget.address,
                          countryCode: countryCode,
                          updateAddress: _updateAddress,
                        ),
                        onUpdateAddress: (status) {
                          _updateAddress = status;
                          _locationTextController.text = locationProvider.address ?? '';
                        },
                        deliveryInfoModel: _deliveryInfoModel,
                        searchController: _searchController,
                      ),

                      if(!ResponsiveHelper.isDesktop(context) && !widget.isEnableUpdate && widget.fromCheckout) Row(children: [
                        const _DefaultAddressStatusWidget(),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                        Text(
                          getTranslated('also_save_in_my_profile', context)!,
                          textAlign: TextAlign.center,
                          style: rubikRegular.copyWith(
                            fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeDefault : Dimensions.fontSizeSmall,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ]),

                      if(ResponsiveHelper.isDesktop(context)) IntrinsicHeight(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          PersonInfoWidget(
                            contactPersonNameController: _contactPersonNameController,
                            contactPersonNumberController: _contactPersonNumberController,
                            address: widget.address,
                            fromCheckout: widget.fromCheckout,
                            isEnableUpdate: widget.isEnableUpdate,
                            nameNode: _nameNode,
                            numberNode: _numberNode,
                            countryCode: countryCode,
                            onValueChange: (code) {
                              countryCode = code;
                            },
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                          AddressInputWebWidget(
                            inputModel: InputModel(
                              nameNode: _nameNode,
                              addressNode: _addressNode,
                              floorNode: _floorNode,
                              houseNode: _houseNode,
                              stateNode: _stateNode,
                              florNumberController: _florNumberController,
                              houseNumberController: _houseNumberController,
                              locationTextController: _locationTextController,
                              streetNumberController: _streetNumberController,
                              branches: _branches,
                              isEnableUpdate: widget.isEnableUpdate,
                              fromCheckout: widget.fromCheckout,
                              address: widget.address,
                              countryCode: countryCode,
                              updateAddress: _updateAddress,
                            ),
                            onUpdateAddress: (status) {
                              setState(() {
                                _updateAddress = status;
                              });
                              _locationTextController.text = locationProvider.address ?? '';
                            },
                            onValueChanged: _handleInteractingWithMap,
                            searchController: _searchController,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          Row(children: [
                            Expanded(flex: 8, child: widget.fromCheckout && !widget.isEnableUpdate && widget.routeType != RouteTypeEnum.appbar ? Row(children: [
                              const _DefaultAddressStatusWidget(),
                              const SizedBox(width: Dimensions.paddingSizeSmall),

                              Text(
                                getTranslated('also_save_in_my_profile', context)!,
                                textAlign: TextAlign.center,
                                style: rubikRegular.copyWith(
                                  fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeDefault : Dimensions.fontSizeSmall,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ]) : const SizedBox()),

                            SaveButtonWidget(
                              address: widget.address,
                              fromCheckout: widget.fromCheckout,
                              isEnableUpdate: widget.isEnableUpdate,
                              onTap: () => _saveAddress(locationProvider),
                            ),

                          ]),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                        ]),
                      ),

                    ]),
                  ))),
                ),

                if(ResponsiveHelper.isDesktop(context)) const FooterWidget(),
              ]),),),

            if(!ResponsiveHelper.isDesktop(context)) Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: Column(children: [
                locationProvider.addressStatusMessage != null
                    ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        locationProvider.addressStatusMessage!.isNotEmpty
                            ? const CircleAvatar(backgroundColor: Colors.green, radius: Dimensions.radiusSmall)
                            : const SizedBox.shrink(),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(child: Text(
                          locationProvider.addressStatusMessage ?? "",
                          style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.green, height: 1),
                        )),
                      ])
                    : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      locationProvider.errorMessage!.isNotEmpty
                          ? CircleAvatar(backgroundColor: Theme.of(context).primaryColor, radius: Dimensions.radiusSmall)
                          : const SizedBox.shrink(),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Expanded(child: Text(
                        locationProvider.errorMessage ?? "",
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor, height: 1,
                        ),
                      )),
                    ]),

                SaveButtonWidget(
                  address: widget.address,
                  fromCheckout: widget.fromCheckout,
                  isEnableUpdate: widget.isEnableUpdate,
                  onTap: () => _saveAddress(locationProvider),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),
              ]),
            ),

          ]));
        },
      ),
    );
  }

  Future<void> _saveAddress(LocationProvider locationProvider) async {
    final ConfigModel? configModel = Provider.of<SplashProvider>(context, listen: false).configModel;
    final CheckoutProvider checkoutProvider = Provider.of<CheckoutProvider>(context, listen: false);


    if(addressFormKey.currentState != null && addressFormKey.currentState!.validate()){
      List<Branches?> branches = configModel!.branches!;
      bool isAvailable = branches.length == 1 && (branches[0]!.latitude == null);
      if(!isAvailable) {
        for (Branches? branch in branches) {
          double distance = Geolocator.distanceBetween(
            branch!.latitude!, branch.longitude!,
            locationProvider.position.latitude, locationProvider.position.longitude,
          ) / 1000;
          if (distance < branch.coverage!) {
            isAvailable = true;
            break;
          }
        }
      }

      if(!isAvailable && configModel.googleMapStatus == 1) {
        showCustomSnackBarHelper(getTranslated(_isAddressNotFetched(locationProvider.position) ? 'please_select_your_address_from_map' : 'service_is_not_available', context));
      }else {

        String? latitude;
        String? longitude;

        if(configModel.googleMapStatus == 1){
          latitude = locationProvider.position.latitude.toString();
          longitude = locationProvider.position.longitude.toString();
        }else{
          latitude = null;
          longitude = null;
        }


        AddressModel addressModel = AddressModel(
          addressType: locationProvider.getAllAddressType[locationProvider.selectAddressIndex],
          contactPersonName: _contactPersonNameController.text,
          contactPersonNumber: _contactPersonNumberController.text.trim().isEmpty ? ''
              : '${CountryCode.fromCountryCode(countryCode!).dialCode}${_contactPersonNumberController.text.trim()}',
          address: _locationTextController.text,
          latitude: latitude,
          longitude: longitude,
          floorNumber: _florNumberController.text,
          houseNumber: _houseNumberController.text,
          streetNumber: _streetNumberController.text,
        );


        if (widget.isEnableUpdate && widget.address?.id != null) {
          addressModel.id = widget.address!.id;
          addressModel.userId = widget.address!.userId;
          addressModel.method = 'put';
          locationProvider.updateAddress(context, addressModel: addressModel, addressId: addressModel.id).then((value) {
            if(value.isSuccess){
              if(Get.context!.canPop()) {
                Get.context!.pop();
              }
            }
            showCustomSnackBarHelper(value.message, isError: !value.isSuccess);


          });
        } else {
          final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);


          if(widget.fromCheckout && !locationProvider.isSaveAddressToProfile){
            if(Get.context!.canPop()) {
              Get.context!.pop();
            }

            await CheckOutHelper.selectDeliveryAddress(
              isAvailable: true,
              splashProvider: splashProvider,
              address: addressModel,
              configModel: splashProvider.configModel!,
              locationProvider: locationProvider,
              checkoutProvider: checkoutProvider,
              shouldResetPaymentAndShowDeliveryDialog: true,
              enableChargeCalculation: true,
            );

          }else{

            locationProvider.addAddress(addressModel).then((value) async {
              if (value.isSuccess) {
                if(Get.context!.canPop()) {
                  Get.context!.pop();
                }


                if (!widget.fromCheckout ||! Get.context!.canPop()) {
                  showCustomSnackBarHelper(value.message, isError: false);
                }

                if(widget.fromCheckout) {

                  if(widget.routeType == RouteTypeEnum.appbar) {
                    locationProvider.onChangeCurrentAddress(locationProvider.addressList?.first, isUpdate: true);

                  }else {
                    CheckOutHelper.selectDeliveryAddressAuto(
                      pickedAddress: locationProvider.addressList?.first,
                      orderType: checkoutProvider.orderType,
                      isLoggedIn: true,
                      shouldResetPaymentAndShowDeliveryDialog: true,
                    );
                  }
                }

              } else {
                showCustomSnackBarHelper(value.message);
              }
           });
          }
        }
      }
    }
  }

  bool _isAddressNotFetched(Position position) => position.latitude == 0 && position.longitude == 0;

}

class _DefaultAddressStatusWidget extends StatelessWidget {
  const _DefaultAddressStatusWidget();

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, _) {
        return Checkbox(
          value: locationProvider.isSaveAddressToProfile,
          activeColor: Theme.of(context).primaryColor,
          checkColor: Theme.of(context).cardColor,
          side: WidgetStateBorderSide.resolveWith((states) {
            if(states.contains(WidgetState.pressed)){
              return BorderSide(color:  Theme.of(context).primaryColor);
            }
            else{
              return BorderSide(color: Theme.of(context).primaryColor );
            }
          }),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
          onChanged:(bool? value) {
            locationProvider.onChangeSaveAddressStatus(value ?? false);
          },
          visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
        );
      }
    );
  }
}