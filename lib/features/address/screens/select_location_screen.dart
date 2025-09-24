import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_restaurant/features/address/widgets/location_search_dialog_widget.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../widgets/permission_dialog_widget.dart';

class SelectLocationScreen extends StatefulWidget {
  final GoogleMapController? googleMapController;
  const SelectLocationScreen({super.key, this.googleMapController});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  GoogleMapController? _controller;
  final TextEditingController _locationController = TextEditingController();
  CameraPosition? _cameraPosition;
  late LatLng _initialPosition;

  @override
  void initState() {
    super.initState();

    final LocationProvider locationProvider = Provider.of<LocationProvider>(context, listen: false);
    //Provider.of<LocationProvider>(context, listen: false).setPickData();
    if(locationProvider.pickedAddressLatitude == null && locationProvider.pickedAddressLongitude == null){
      _initialPosition = LatLng(
        Provider.of<SplashProvider>(context, listen: false).configModel!.branches![0]!.latitude!,
        Provider.of<SplashProvider>(context, listen: false).configModel!.branches![0]!.longitude!,
      );
    }else{
      _initialPosition = LatLng(double.parse(locationProvider.pickedAddressLatitude ?? '0'), double.parse(locationProvider.pickedAddressLongitude ?? '0'));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  void _openSearchDialog(BuildContext context, GoogleMapController? mapController) async {
    showDialog(context: context, builder: (context) => LocationSearchDialogWidget(mapController: mapController));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (Provider.of<LocationProvider>(context).address != null) {
      _locationController.text = Provider.of<LocationProvider>(context).address ?? '';
    }

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)? const PreferredSize(preferredSize: Size.fromHeight(120), child: WebAppBarWidget()) :  AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white ,
          onPressed: () =>  context.pop(),
        )  ,
        title: Text(getTranslated('select_delivery_address', context)!, style: rubikSemiBold.copyWith(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        physics: ResponsiveHelper.isDesktop(context) ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : 0 ),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : 0 ),
                  decoration: ResponsiveHelper.isDesktop(context) ? BoxDecoration(
                    color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)],
                  ) : null,
                  width: Dimensions.webScreenWidth,
                  height: ResponsiveHelper.isDesktop(context) ?   height * 0.7 : height * 0.9,
                  child: Consumer<LocationProvider>(
                    builder: (context, locationProvider, child) => Stack(
                      clipBehavior: Clip.none, children: [
                      SafeArea(
                        child: _WebDisableDragWidget(
                          isEnable: kIsWeb,
                          child: GoogleMap(
                            mapType: MapType.normal,
                            initialCameraPosition:  CameraPosition(
                              target:  _initialPosition,
                              zoom: 16,
                            ),
                            zoomControlsEnabled: false,
                            myLocationButtonEnabled: false,
                            minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                            compassEnabled: false,
                            indoorViewEnabled: true,
                            mapToolbarEnabled: true,
                            onCameraIdle: (){
                              locationProvider.updatePosition(_cameraPosition, false, null, context, false);
                            },
                            onCameraMove: ((position) {
                              _cameraPosition = position;
                            }),
                            // markers: Set<Marker>.of(locationProvider.markers),
                            onMapCreated: (GoogleMapController controller) {
                              Future.delayed(const Duration(milliseconds: 500)).then((value) {
                                _controller = controller;
                                _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: locationProvider.pickPosition.longitude.toInt() == 0 &&  locationProvider.pickPosition.latitude.toInt() == 0 ? _initialPosition : LatLng(
                                  locationProvider.pickPosition.latitude , locationProvider.pickPosition.longitude,
                                ), zoom: 15)));
                              });


                            },
                          ),
                        ),
                      ),
                      locationProvider.pickAddress != null?
                      InkWell(
                        onTap: () => _openSearchDialog(context, _controller),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: 18.0),
                          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: 23.0),
                          decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                          child: Builder(
                              builder: (context) {
                                _locationController.text = locationProvider.pickAddress!;
                                // if(locationProvider.pickAddress.name != null && ResponsiveHelper.isMobilePhone()) {
                                //   locationProvider.locationController.text = '${locationProvider.pickAddress.name ?? ''} ${locationProvider.pickAddress.subAdministrativeArea ?? ''} ${locationProvider.pickAddress.isoCountryCode ?? ''}';
                                // }

                                return Row(children: [
                                  Expanded(child: Text(
                                      locationProvider.pickAddress ?? ''
                                      // locationProvider.pickAddress.name != null
                                      // ? '${locationProvider.pickAddress.name ?? ''} ${locationProvider.pickAddress.subAdministrativeArea ?? ''} ${locationProvider.pickAddress.isoCountryCode ?? ''}'
                                       , maxLines: 1, overflow: TextOverflow.ellipsis)),
                                  const Icon(Icons.search, size: 20),
                                ]);
                              }
                          ),
                        ),
                      ):const SizedBox.shrink(),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () => _checkPermission(() {
                                locationProvider.getCurrentLocation(context, true, mapController: _controller);
                              }, context),
                              child: Container(
                                width: 50,
                                height: 50,
                                margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                  color: Colors.white,
                                ),
                                child: Icon(
                                  Icons.my_location,
                                  color: Theme.of(context).primaryColor,
                                  size: 35,
                                ),
                              ),
                            ),
                            SafeArea(
                              child: Center(
                                child: SizedBox(
                                  width: ResponsiveHelper.isDesktop(context) ? 450 : 1170,
                                  child: Padding(
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                                    child: CustomButtonWidget(
                                      btnTxt: getTranslated('select_location', context),
                                      onTap: locationProvider.loading ? null : () {

                                        if(locationProvider.pickAddress != null) {
                                          locationProvider.setAddress = locationProvider.pickAddress ?? '';

                                        }

                                        locationProvider.setPickedAddressLatLon(locationProvider.pickPosition.latitude.toString(), locationProvider.pickPosition.longitude.toString());

                                        if(widget.googleMapController != null) {
                                          widget.googleMapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
                                            locationProvider.pickPosition.latitude, locationProvider.pickPosition.longitude,
                                          ), zoom: 16)));

                                        }
                                        context.pop();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height,
                          child: Image.asset(
                            Images.marker,
                            width: 25,
                            height: 35,
                          )),
                      locationProvider.loading ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))) : const SizedBox(),
                    ],
                    ),
                  ),
                ),
              ),
            ),
            if(ResponsiveHelper.isDesktop(context)) const SizedBox(height: Dimensions.paddingSizeLarge),
            if(ResponsiveHelper.isDesktop(context)) const FooterWidget(),
          ],
        ),
      ),
    );
  }
  void _checkPermission(Function callback, BuildContext context) async {
    LocationPermission permission = await Geolocator.requestPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }else if(permission == LocationPermission.deniedForever) {
      showDialog(context: Get.context!, barrierDismissible: false, builder: (context) => const PermissionDialogWidget());
    }else {
      callback();
    }
  }
}


class _WebDisableDragWidget extends StatelessWidget {
  final Widget child;
  final bool isEnable;
  const _WebDisableDragWidget({required this.child, required this.isEnable});

  @override
  Widget build(BuildContext context) {
    return isEnable ? AbsorbPointer(
      absorbing: false,
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
        child: GestureDetector(
          onScaleStart: (_){},
          onScaleUpdate: (_){},
          onScaleEnd: (_){},
          child: child,
        ),
      ),
    ) : child;
  }
}

