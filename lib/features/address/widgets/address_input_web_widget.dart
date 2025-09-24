import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/features/address/domain/models/input_model.dart';
import 'package:flutter_restaurant/features/address/enum/address_type_enum.dart';
import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
import 'package:flutter_restaurant/features/address/screens/select_location_screen.dart';
import 'package:flutter_restaurant/features/profile/widgets/profile_textfield_widget.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/common/providers/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AddressInputWebWidget extends StatefulWidget {
  final InputModel inputModel;
  final void Function(bool) onUpdateAddress;
  final Function(bool)? onValueChanged;
  final TextEditingController searchController;
  final int? areaID;

  const AddressInputWebWidget({
    super.key,
    required this.onUpdateAddress,
    required this.inputModel,
    required this.searchController,
    this.areaID, this.onValueChanged
  });



  @override
  State<AddressInputWebWidget> createState() => _AddressInputWebWidgetState();
}

class _AddressInputWebWidgetState extends State<AddressInputWebWidget> {
  GoogleMapController? controller;

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final configModel = Provider.of<SplashProvider>(context, listen: false).configModel;



    return Consumer<LocationProvider>(
      builder: (context, locationProvider, _) {


        if(widget.inputModel.locationTextController.text.isEmpty){
          Future.delayed(const Duration(milliseconds: 100), () {
            widget.inputModel.locationTextController.text = locationProvider.address ?? '';
          });
        }

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            boxShadow: [BoxShadow(color:ColorResources.cardShadowColor.withValues(alpha:0.2), blurRadius: 10)],
          ),
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeLarge),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [

              Text(getTranslated('delivery_address', context)!,
                style: rubikSemiBold.copyWith(fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeLarge : Dimensions.fontSizeDefault),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text(getTranslated('address_type', context)!, style: rubikRegular.copyWith(color: Theme.of(context).hintColor)),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              SizedBox(height: 40, child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: locationProvider.getAllAddressType.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () => locationProvider.updateAddressIndex(index, true),
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      border: Border.all(color: locationProvider.selectAddressIndex == index
                          ? Theme.of(context).primaryColor : ColorResources.borderColor),
                      color: locationProvider.selectAddressIndex == index ? Theme.of(context).primaryColor
                          : themeProvider.darkTheme ? Theme.of(context).cardColor : Colors.white.withValues(alpha:0.8),
                    ),
                    child: Row(children: [

                      CustomAssetImageWidget(
                        locationProvider.getAllAddressType[index].toLowerCase() == AddressType.home.name ? Images.houseSvg
                            : locationProvider.getAllAddressType[index].toLowerCase() == AddressType.workplace.name
                            ? Images.buildingSvg : Images.buildingsSvg,
                        width: Dimensions.fontSizeSmall,
                        height: Dimensions.fontSizeSmall,
                        color: locationProvider.selectAddressIndex == index ? Colors.white : Theme.of(context).hintColor,
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Text(getTranslated(locationProvider.getAllAddressType[index].toLowerCase(), context)!,
                        style: rubikRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: locationProvider.selectAddressIndex == index ? Colors.white : Theme.of(context).hintColor,
                        ),
                      ),

                    ]),
                  ),
                ),
              )),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),

              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  /// for Address Field
                Expanded(child: ProfileTextFieldWidget(
                  isShowBorder: true,
                  controller: widget.inputModel.locationTextController,
                  focusNode: widget.inputModel.addressNode,
                  nextFocus: widget.inputModel.stateNode,
                  inputType: TextInputType.streetAddress,
                  capitalization: TextCapitalization.words,
                  level: getTranslated('delivery_address', context)!,
                  hintText: getTranslated('afghanistan', context)!,
                  isFieldRequired: false,
                  isShowPrefixIcon: true,
                  prefixIconUrl: Images.locationPlacemarkSvg,
                  onValidate: (value) => value!.isEmpty
                      ? '${getTranslated('please_enter', context)!} ${getTranslated('delivery_address', context)!}' : null,
                )),
                const SizedBox(width: Dimensions.paddingSizeLarge),

                  /// for Street Field
                Expanded(child: ProfileTextFieldWidget(
                  isShowBorder: true,
                  controller: widget.inputModel.streetNumberController,
                  focusNode: widget.inputModel.stateNode,
                  nextFocus: widget.inputModel.houseNode,
                  inputType: TextInputType.streetAddress,
                  inputAction: TextInputAction.next,
                  capitalization: TextCapitalization.words,
                  level: getTranslated('street_number', context)!,
                  hintText: getTranslated('address_line_02', context)!,
                  isFieldRequired: false,
                  isShowPrefixIcon: true,
                  prefixIconUrl: Images.streetSvg,
                )),

              ]),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),


              Text('${getTranslated('building', context)}/ ${getTranslated('floor', context)} ${getTranslated('number', context)}',
                style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  /// for House Field
                Expanded(child: ProfileTextFieldWidget(
                  isShowBorder: true,
                  controller: widget.inputModel.houseNumberController,
                  inputType: TextInputType.streetAddress,
                  inputAction: TextInputAction.next,
                  capitalization: TextCapitalization.words,
                  level: getTranslated('house_no', context)!,
                  isFieldRequired: false,
                  hintText: getTranslated('ex_2', context),
                  focusNode: widget.inputModel.houseNode,
                  nextFocus: widget.inputModel.floorNode,
                )),
                const SizedBox(width: Dimensions.paddingSizeLarge),
                  /// for Floor Field
                Expanded(child: ProfileTextFieldWidget(
                  isShowBorder: true,
                  inputType: TextInputType.streetAddress,
                  inputAction: TextInputAction.next,
                  capitalization: TextCapitalization.words,
                  level: getTranslated('floor_no', context)!,
                  isFieldRequired: false,
                  hintText: getTranslated('ex_2b', context),
                  focusNode: widget.inputModel.floorNode,
                  nextFocus: widget.inputModel.nameNode,
                  controller: widget.inputModel.florNumberController,
                )),
              ]),

            ])),
            const SizedBox(width: Dimensions.paddingSizeLarge),

            if(configModel?.googleMapStatus == 1 && ((locationProvider.pickedAddressLatitude != null && locationProvider.pickedAddressLongitude != null) ||  widget.inputModel.address == null))
              Expanded(child: Column(children: [
                /// Map section
                SizedBox(height: 320, width: MediaQuery.of(context).size.width, child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                    child: AbsorbPointer(absorbing: false,
                      child: Listener(
                        onPointerSignal: (event) {
                          if (event is PointerScrollEvent) {
                            return;
                          }
                        },

                        onPointerDown: (event) {
                          return;
                        },
                        onPointerMove: (event) {
                          return;
                        },

                        onPointerUp: (event){
                          return;
                        },

                        child: Stack(clipBehavior: Clip.none, children: [

                         MouseRegion(
                           onEnter: (event) => _onPanStart(),
                           onExit: (event) => _onPanEnd(),
                            child: GoogleMap(
                              mapType: MapType.normal,
                              initialCameraPosition: CameraPosition(
                                target: widget.inputModel.isEnableUpdate
                                    ? LatLng(double.parse(locationProvider.pickedAddressLatitude!), double.parse(locationProvider.pickedAddressLongitude!))
                                    : LatLng(locationProvider.position.latitude  == 0.0 ? widget.inputModel.branches[0]!.latitude!
                                    : locationProvider.position.latitude, locationProvider.position.longitude == 0.0
                                    ? widget.inputModel.branches[0]!.longitude! : locationProvider.position.longitude),
                                zoom: 8,
                              ),
                              zoomControlsEnabled: false,
                              compassEnabled: false,
                              indoorViewEnabled: true,
                              mapToolbarEnabled: false,
                              minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                              onCameraIdle: () async {
                                if(widget.inputModel.address != null && !widget.inputModel.fromCheckout) {
                                  await locationProvider.updatePosition(locationProvider.cameraPosition, true, null, context, true);
                                  // updateAddress = true;
                                }else if(widget.inputModel.updateAddress) {
                                  await locationProvider.updatePosition(locationProvider.cameraPosition, true, null, context, true);
                                }

                                widget.onUpdateAddress(true);
                              },
                              onCameraMove: ((position) {
                                //cameraPosition = position;
                                locationProvider.cameraPosition = position;
                              }),
                              onMapCreated: (GoogleMapController createdController) {
                                controller = createdController;
                                if (!widget.inputModel.isEnableUpdate) {
                                  locationProvider.checkPermission(() {
                                    locationProvider.getCurrentLocation(context, true, mapController: controller);
                                  });
                                }
                              },
                            ),
                          ),

                          locationProvider.loading
                              ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)))
                              : const SizedBox(),

                          Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height,
                            child: const CustomAssetImageWidget(Images.marker, width: Dimensions.paddingSizeExtraLarge, height: 35),
                          ),

                          Positioned(
                            bottom: ResponsiveHelper.isMobile() ? 10 : 70,
                            right: ResponsiveHelper.isMobile() ? 0 : -10,
                            child: InkWell(
                              onTap: () => locationProvider.checkPermission(() {
                                locationProvider.getCurrentLocation(context, true, mapController: controller);
                              }),
                              child: Container(
                                width: ResponsiveHelper.isDesktop(context) ? 40 : 30,
                                height: ResponsiveHelper.isDesktop(context) ? 40 : 30,
                                margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                  color: Colors.white,
                                ),
                                child: Icon(
                                  Icons.my_location,
                                  color: Theme.of(context).primaryColor,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),

                          Positioned(top: Dimensions.paddingSizeSmall, right: 0, child: InkWell(
                            onTap:()=> Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SelectLocationScreen(googleMapController: controller),
                            )),
                            child: Container(
                              width: 30,
                              height: 30,
                              margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                color: Colors.white,
                              ),
                              child: Icon(Icons.fullscreen, color: Theme.of(context).primaryColor, size: 20),
                            ),
                          )),
                        ]),
                      ),
                    ),
                  ),
                )),
              ])),

            if(configModel?.googleMapStatus == 1 && ((locationProvider.pickedAddressLatitude == null && locationProvider.pickedAddressLongitude == null) &&  widget.inputModel.address != null))
              Expanded(child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                child: Stack(clipBehavior: Clip.none, children: [

                  CustomAssetImageWidget(
                    Images.noMapBackground,
                    fit: BoxFit.cover,
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black.withValues(alpha:0.5),
                    colorBlendMode: BlendMode.darken,
                  ),

                  Positioned.fill(child: Center(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                        child: Text(getTranslated('add_location_from_map_your_precise_location', context)!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: robotoRegular.copyWith(
                              color: Theme.of(context).cardColor,
                              fontSize: Dimensions.fontSizeLarge
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      Row(children: [

                        Expanded(child: Container()),

                        Expanded(
                          child: CustomButtonWidget(
                            isLoading: locationProvider.isLoading,
                            btnTxt: getTranslated('go_to_map', context)!,
                            onTap: ()async{

                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SelectLocationScreen(),
                              ));
                              // await locationProvider.getCurrentLocation(context, true);
                              // ResponsiveHelper.showDialogOrBottomSheet(context,
                              //   CustomAlertDialogWidget(
                              //     width: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.width * 0.6 : null,
                              //     height: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.width * 0.4 : null,
                              //     child: Container(
                              //       decoration: BoxDecoration(
                              //         borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              //       ),
                              //       child: Stack(children: <Widget>[
                              //
                              //         ClipRRect(
                              //           borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                              //           child: GoogleMap(
                              //             mapType: MapType.normal,
                              //             initialCameraPosition: CameraPosition(
                              //               target: widget.inputModel.isEnableUpdate
                              //                   ? LatLng(double.parse(locationProvider.position.latitude.toString()), double.parse(locationProvider.position.longitude.toString()))
                              //                   : LatLng(locationProvider.position.latitude  == 0.0 ? double.parse(widget.inputModel.branches[0]!.latitude!)
                              //                   : locationProvider.position.latitude, locationProvider.position.longitude == 0.0
                              //                   ? double.parse(widget.inputModel.branches[0]!.longitude!): locationProvider.position.longitude),
                              //               zoom: 8,
                              //             ),
                              //             zoomControlsEnabled: false,
                              //             compassEnabled: false,
                              //             indoorViewEnabled: true,
                              //             mapToolbarEnabled: false,
                              //             minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                              //             onCameraIdle: () {
                              //               if(widget.inputModel.address != null && !widget.inputModel.fromCheckout) {
                              //                 locationProvider.updatePosition(locationProvider.cameraPosition, true, null, context, true);
                              //                 // updateAddress = true;
                              //                 widget.onUpdateAddress(true);
                              //               }else {
                              //                 if(widget.inputModel.updateAddress) {
                              //                   locationProvider.updatePosition(locationProvider.cameraPosition, true, null, context, true);
                              //                 }else {
                              //                   // updateAddress = true;
                              //                   widget.onUpdateAddress(true);
                              //                 }
                              //               }
                              //             },
                              //             onCameraMove: ((position) {
                              //               locationProvider.cameraPosition = position;
                              //             }),
                              //             onMapCreated: (GoogleMapController createdController) {
                              //               controller = createdController;
                              //               locationProvider.setMapInitialized();
                              //             },
                              //           ),
                              //         ),
                              //
                              //         locationProvider.loading
                              //             ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)))
                              //             : const SizedBox(),
                              //
                              //         Container(
                              //           width: MediaQuery.of(context).size.width,
                              //           alignment: Alignment.center,
                              //           height: MediaQuery.of(context).size.height,
                              //           child: const CustomAssetImageWidget(Images.marker, width: Dimensions.paddingSizeExtraLarge, height: 35),
                              //         ),
                              //
                              //         Positioned(
                              //           bottom: 10, left: 0, right: 0,
                              //           child: SafeArea(child: Center(
                              //             child: SizedBox(
                              //               width: ResponsiveHelper.isDesktop(context) ? 450 : 1170,
                              //               child: Padding(
                              //                 padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                              //                 child: CustomButtonWidget(
                              //                   btnTxt: getTranslated('select_location', context),
                              //                   onTap: locationProvider.loading ? null : () {
                              //                     if(controller != null) {
                              //                       controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
                              //                         locationProvider.pickPosition.latitude, locationProvider.pickPosition.longitude,
                              //                       ), zoom: 16)));
                              //                     }
                              //                     context.pop();
                              //                     },
                              //                   ),
                              //                 ),
                              //               ),
                              //             ),
                              //           ),
                              //         ),
                              //
                              //         // Positioned(bottom: Dimensions.paddingSizeSmall, right: 0, child: InkWell(
                              //         //   onTap: () => locationProvider.checkPermission(() {
                              //         //     locationProvider.getCurrentLocation(context, true, mapController: controller);
                              //         //   }),
                              //         //   child: Container(
                              //         //     width: 30,
                              //         //     height: 30,
                              //         //     margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                              //         //     decoration: BoxDecoration(
                              //         //       borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                              //         //       color: Colors.white,
                              //         //     ),
                              //         //     child: Icon(
                              //         //       Icons.my_location,
                              //         //       color: Theme.of(context).primaryColor,
                              //         //       size: 20,
                              //         //     ),
                              //         //   ),
                              //         // )),
                              //
                              //         // Positioned(top: Dimensions.paddingSizeSmall, right: 0, child: InkWell(
                              //         //   onTap:()=> Navigator.of(context).push(MaterialPageRoute(
                              //         //     builder: (context) => SelectLocationScreen(googleMapController: controller),
                              //         //   )),
                              //         //   child: Container(
                              //         //     width: 30,
                              //         //     height: 30,
                              //         //     margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                              //         //     decoration: BoxDecoration(
                              //         //       borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                              //         //       color: Colors.white,
                              //         //     ),
                              //         //     child: Icon(Icons.fullscreen, color: Theme.of(context).primaryColor, size: 20),
                              //         //   ),
                              //         // )),
                              //
                              //
                              //
                              //         Consumer<LocationProvider>(
                              //           builder: (context, locationProvider, child){
                              //             return locationProvider.isMapInitialized ?
                              //             Positioned(
                              //             left: 0, right: 0,
                              //             top: Dimensions.paddingSizeSmall,
                              //             child: LocationSearchDialogWidget(mapController: controller, margin: EdgeInsets.zero),
                              //             ): const SizedBox.shrink();
                              //           },
                              //         )
                              //
                              //
                              //       ],),
                              //     ),
                              //   ),
                              // );
                            },
                            backgroundColor: Theme.of(context).cardColor,
                            textStyle: rubikBold.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),

                        Expanded(child: Container()),
                      ]),


                    ],),
                  ),)

                ]),
              )),
          ]),
        );
      },
    );
  }


  void _onPanStart() {
    if(widget.onValueChanged != null){
      setState(() {
        widget.onValueChanged!(true);
      });
    }
  }
  void _onPanEnd() {
    if(widget.onValueChanged != null){
      setState(() {
        widget.onValueChanged!(false);
      });
    }
  }

}