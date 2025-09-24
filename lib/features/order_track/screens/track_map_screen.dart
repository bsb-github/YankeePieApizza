import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/order_track/providers/tracker_provider.dart';
import 'package:flutter_restaurant/features/order_track/screens/track_map_screen_web.dart';
import 'package:flutter_restaurant/features/order_track/widgets/location_timeline_widget.dart';
import 'package:flutter_restaurant/features/order_track/widgets/track_map_deliveryman_info.dart';
import 'package:flutter_restaurant/features/order_track/widgets/track_map_timer_widget.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../order/domain/models/order_model.dart';


class TrackMapScreen extends StatefulWidget {
  final Order? order;
  final int? deliverymanId;
  final int? orderId;
  const TrackMapScreen({super.key, this.order,this.deliverymanId, this.orderId});

  @override
  State<TrackMapScreen> createState() => _TrackMapScreenState();
}

class _TrackMapScreenState extends State<TrackMapScreen> {

  TrackerProvider? _trackerProvider;
  GoogleMapController? _mapController;
  double _bottomSheetMinSize = 0.1;
  double _bottomSheetMaxSize = 0.4;
  static const double _bottomSheetBottomMargin = 20;

  final GlobalKey _maxContentKey = GlobalKey();
  final GlobalKey _minContentKey = GlobalKey();
  LatLng  _initialUserLocation = const LatLng(23, 90);
  final Completer<GoogleMapController> _controller = Completer();
  final DraggableScrollableController _draggableScrollableController = DraggableScrollableController();


  @override
  void initState() {
    super.initState();

    _setInitialPosition();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getMaxChildSize(); /// Get bottom sheet Max height
      _getMinChildSize(); /// Get bottom sheet Min height
      _animateCameraWithDragBottomSheet(); /// Expand or minimize bottom sheet with auto movement camera position
    });
    Future.microtask(() => _trackerProvider?.getDeliveryManData(deliverymanId : widget.deliverymanId, orderId : widget.orderId));

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBarWidget(
        title: getTranslated("order_tracking", context), context: context,
        centerTitle: false, subTitle: RichText(text: TextSpan(text: getTranslated('your_delivery_is', context),
        style: robotoRegular.copyWith(
          fontSize: Dimensions.fontSizeSmall,
          color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.7),
        ),
        children: <TextSpan>[
          const TextSpan(text: "  "),
          TextSpan(
            text: getTranslated("on_the_way", context),
            style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
          )
        ],
      )),
      ),
      body: Consumer<TrackerProvider>(builder: (ctx, timerProvider,_){

        return ResponsiveHelper.isDesktop(context) ? TrackMapScreenWeb(
          order: widget.order,
          orderId: widget.orderId,
          deliverymanId: widget.deliverymanId,
          initialUserLocation: _initialUserLocation,
        ) : Stack( children: [

          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(target: _initialUserLocation, zoom: 16),
            onMapCreated: (GoogleMapController mapController) {
              _controller.complete(mapController);
              _mapController = mapController;
              timerProvider.getEstimateDuration(widget.order, context, isStarTimer: true);
              timerProvider.startLocationService(
                deliverymanId: widget.deliverymanId,
                orderId: widget.orderId,
                mapController: _mapController,
                userLocation: _initialUserLocation,
              );
            },
            zoomControlsEnabled: true,
            myLocationButtonEnabled: false,
            markers: timerProvider.markers,
          ),

          DraggableScrollableSheet(
            controller: _draggableScrollableController,
            initialChildSize: _bottomSheetMinSize, minChildSize: _bottomSheetMinSize, maxChildSize: _bottomSheetMaxSize,
            snap: true,
            builder: (context, scrollController) {
              return Container(
                decoration:  BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                ),
                margin: const EdgeInsets.only(left: 15, right: 15, bottom: _bottomSheetBottomMargin),

                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const ClampingScrollPhysics(),
                  child: Padding(
                    key: _maxContentKey,
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: Column(mainAxisSize: MainAxisSize.min, spacing: Dimensions.paddingSizeSmall, children: [

                      Container(
                        width: 30, height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).disabledColor.withValues(alpha: 0.5),
                        ),
                      ),

                      TrackMapDeliverymanInfo(
                        key: _minContentKey,
                        deliveryMan: widget.order?.deliveryMan, oderId: widget.orderId,
                      ),
                      const SizedBox(),

                      Row(spacing: Dimensions.paddingSizeSmall, crossAxisAlignment: CrossAxisAlignment.start ,children: [
                        const LocationTimeline(),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                            Text(getTranslated("address", context) ?? "",
                              style: rubikMedium.copyWith(color: Theme.of(context).hintColor),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(widget.order?.deliveryAddress?.address  ?? "",
                              style: rubikMedium, overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            const SizedBox(height: Dimensions.paddingSizeDefault,),

                            Text(getTranslated("delivery_time", context) ?? "",
                              style: rubikMedium.copyWith(color: Theme.of(context).hintColor),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const TrackMapTimerWidget(),
                          ]),
                        )
                      ]),

                      const SizedBox(),

                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: CustomButtonWidget(
                          btnTxt: "${getTranslated("order_details", context)}",
                          onTap: (){
                            AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
                            String? phoneNumber = !authProvider.isLoggedIn() ? widget.order?.deliveryAddress?.contactPersonNumber : null;
                            RouterHelper.getOrderDetailsRoute('${widget.orderId}', phoneNumber: phoneNumber,  action: RouteAction.pushReplacement);
                          },
                        ),
                      ),
                    ]),
                  ),
                ),
              );
            },
          ),
        ]);
      }),
    );
  }

  void _setInitialPosition(){
    _initialUserLocation = LatLng(widget.order?.deliveryAddress?.latitude ?? 0, widget.order?.deliveryAddress?.longitude ?? 0);
  }

  void _getMaxChildSize() {
    final RenderBox? box = _maxContentKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      setState(() {
        bool isIos = Platform.isIOS;
        _bottomSheetMaxSize = (box.size.height + _bottomSheetBottomMargin * (isIos ? 1 : 4)  + MediaQuery.of(context).padding.bottom) / MediaQuery.of(context).size.height;
      });
    }
    if (kDebugMode) {
      print("Bottom Sheet max size -------> $_bottomSheetMaxSize");
    }
  }

  void _getMinChildSize() {
    final RenderBox? box = _minContentKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      setState(() {
        bool isIos = Platform.isIOS;
        _bottomSheetMinSize = (box.size.height + _bottomSheetBottomMargin * ( isIos ? 2.5 :  4.5)  + MediaQuery.of(context).padding.bottom) / MediaQuery.of(context).size.height;
      });
    }
    if (kDebugMode) {
      print("Bottom Sheet min size -------> $_bottomSheetMinSize");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _trackerProvider = Provider.of<TrackerProvider>(context, listen: false);
  }

  void _animateCameraWithDragBottomSheet(){
    _draggableScrollableController.addListener((){
      _trackerProvider?.setSouthwestPadding(
        isExpanded: _draggableScrollableController.size == _bottomSheetMaxSize ,
        mapController: _mapController, userLocation: _initialUserLocation
      );
    });

  }

  @override
  void dispose() {
    _trackerProvider?.stopLocationService();
    _draggableScrollableController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

}



