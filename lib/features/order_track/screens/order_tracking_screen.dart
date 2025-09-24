import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/date_converter_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
import 'package:flutter_restaurant/features/order/providers/order_provider.dart';
import 'package:flutter_restaurant/features/order_track/providers/tracker_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/order_status.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_restaurant/features/order_track/widgets/custom_stepper_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/timer_widget.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String? orderID;
  final String? phoneNumber;
  const OrderTrackingScreen({super.key, this.orderID, this.phoneNumber});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {

  @override
  void initState() {
    final OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final TrackerProvider timerProvider = Provider.of<TrackerProvider>(context, listen: false);
    final LocationProvider locationProvider = Provider.of<LocationProvider>(context, listen: false);

    if(widget.orderID != null){
      locationProvider.initAddressList();

      orderProvider.trackOrder(widget.orderID, fromTracking: true, phoneNumber: widget.phoneNumber).whenComplete(() {
        if(orderProvider.trackModel != null && mounted){
          timerProvider.getEstimateDuration(orderProvider.trackModel!, context, isStarTimer: true);
          if(orderProvider.trackModel?.deliveryMan != null ){
            orderProvider.getDeliveryManData( deliverymanId :orderProvider.trackModel?.deliveryMan?.id, orderId: orderProvider.trackModel?.id);
          }
        }
      });
    }else{
      orderProvider.clearPrevData();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final double height = MediaQuery.sizeOf(context).height;
    final configModel = Provider.of<SplashProvider>(context, listen: false).configModel;

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? const PreferredSize(
        preferredSize: Size.fromHeight(100), child: WebAppBarWidget(),
      ) : CustomAppBarWidget(
        title: getTranslated('order_tracking', context)!,
        centerTitle: false,
      ) as PreferredSizeWidget,

      body: CustomScrollView(slivers: [

        SliverToBoxAdapter(child: Container(
          margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
          constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && height < 600 ? height : height - 400),
          child: Consumer<OrderProvider>(builder: (context, orderProvider, _) {
            String? status;
            if(orderProvider.trackModel != null) {
              status = orderProvider.trackModel?.orderStatus;
            }
            return Container(
              margin: ResponsiveHelper.isDesktop(context) ? EdgeInsets.symmetric(horizontal: (width - Dimensions.webScreenWidth) / 2) : null,
              decoration: ResponsiveHelper.isDesktop(context) ? BoxDecoration(
                color: Theme.of(context).canvasColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)],
              ) : null,
              child: Column(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: Column(children: [

                    widget.orderID != null && (status == OrderStatus.pending || status == OrderStatus.confirmed
                        || status == OrderStatus.cooking || status == OrderStatus.processing || status == OrderStatus.outForDelivery)
                        ? TimerWidget(status: status)
                        : const SizedBox(height: Dimensions.paddingSizeDefault),

                    orderProvider.trackModel != null ? Column(mainAxisSize: MainAxisSize.min,children: [

                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text('${getTranslated('your_order', context)}'.toUpperCase(), style: rubikSemiBold.copyWith(color: Theme.of(context).hintColor)),

                        Text(' #${orderProvider.trackModel?.id}', style: rubikSemiBold.copyWith(
                          fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor,
                        )),
                      ]),
                      const SizedBox(height: Dimensions.paddingSizeLarge),



                      ResponsiveHelper.isDesktop(context) ? Column(children: [
                        SizedBox(height: height * 0.02),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: height * 0.03),
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                            Flexible(flex: 1, child: Column(mainAxisAlignment: MainAxisAlignment.start,children: [
                              CustomStepperWidget(
                                title: getTranslated('order_placed', context),
                                isComplete: status == OrderStatus.pending
                                    || status == OrderStatus.confirmed
                                    || status == OrderStatus.cooking
                                    || status == OrderStatus.processing
                                    || status == OrderStatus.outForDelivery
                                    || status == OrderStatus.delivered,
                                isActive: status == OrderStatus.pending,
                                haveTopBar: false,
                                statusImage: Images.orderPlaceIcon,
                                subTitle: orderProvider.trackModel?.createdAt != null
                                    ?  '${DateConverterHelper.estimatedDate(DateConverterHelper.convertStringToDatetime(orderProvider.trackModel!.createdAt!))} ${DateConverterHelper.estimatedDate(DateConverterHelper.convertStringToDatetime(orderProvider.trackModel!.createdAt!))}' : '',
                              ),

                              CustomStepperWidget(
                                title: getTranslated('confirmed', context),
                                isComplete: status == OrderStatus.confirmed
                                    || status == OrderStatus.cooking
                                    || status == OrderStatus.processing
                                    || status == OrderStatus.outForDelivery
                                    || status == OrderStatus.delivered,
                                isActive: status == OrderStatus.confirmed,
                                statusImage: Images.orderConfirmedIcon,
                                subTitle: getTranslated('restaurant_confirmed', context),
                              ),

                              CustomStepperWidget(
                                title: getTranslated('cooking', context),
                                isComplete: status == OrderStatus.cooking
                                    || status == OrderStatus.processing
                                    || status == OrderStatus.outForDelivery
                                    ||status == OrderStatus.delivered,
                                isActive: status == OrderStatus.cooking,
                                statusImage: Images.cooking,
                                subTitle: getTranslated('food_is_being_prepared', context),
                              ),
                            ])),
                            SizedBox(width: width * 0.15),

                            Flexible(flex: 1, child: Column(mainAxisAlignment: MainAxisAlignment.start,children: [
                              CustomStepperWidget(
                                title: getTranslated('preparing_for_delivery', context),
                                isComplete: status == OrderStatus.processing
                                    || status == OrderStatus.outForDelivery
                                    ||status == OrderStatus.delivered,
                                statusImage: Images.preparing,
                                isActive: status == OrderStatus.processing,
                                subTitle: getTranslated('packing_your_order', context),
                                haveTopBar: false,
                              ),

                              Consumer<LocationProvider>(builder: (context, locationProvider, _) {

                                if(locationProvider.addressList != null){
                                  for(int i = 0 ; i< locationProvider.addressList!.length; i++) {
                                    if(locationProvider.addressList![i].id == orderProvider.trackModel!.deliveryAddressId) {
                                      locationProvider.addressList![i];
                                    }
                                  }
                                }

                                final bool isOrderActive = status == OrderStatus.outForDelivery;
                                final bool isOrderComplete = status == OrderStatus.outForDelivery || status == OrderStatus.delivered;

                                return CustomStepperWidget(
                                  title: getTranslated('order_is_on_the_way', context),
                                  subTitle: getTranslated('your_delivery_is_on_the_way', context),
                                  isComplete: isOrderComplete,
                                  statusImage: Images.outForDelivery,
                                  isActive: isOrderActive,
                                  trailing: orderProvider.trackModel?.deliveryMan?.phone != null ? InkWell(
                                    onTap: () async {
                                      Uri uri = Uri.parse('tel:${orderProvider.trackModel?.deliveryMan?.phone}');
                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(uri);
                                      } else {
                                        if(context.mounted){
                                          showCustomSnackBarHelper(getTranslated('phone_number_not_found', context));
                                        }
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: (isOrderComplete || isOrderActive) ? Theme.of(context).primaryColor.withValues(alpha: 0.1) : Theme.of(context).hintColor.withValues(alpha: 0.1)
                                      ),
                                      child: Icon(Icons.phone_in_talk, color: (isOrderComplete || isOrderActive) ? Theme.of(context).primaryColor : Theme.of(context).hintColor),
                                    ),
                                  ) : const SizedBox(),

                                );
                              }),

                              CustomStepperWidget(
                                title: getTranslated('order_delivered', context),
                                subTitle: getTranslated('order_completed', context),
                                isComplete: status == OrderStatus.delivered,
                                height: orderProvider.deliveryManModel != null && configModel?.googleMapStatus == 1 ? 145 : 30,
                                isActive: status == OrderStatus.delivered,
                                statusImage: Images.orderDeliveredIcon,
                                child: orderProvider.deliveryManModel != null && configModel?.googleMapStatus == 1
                                    ? _trackMapButtonWidget(orderProvider: orderProvider)
                                    : const SizedBox.shrink(),
                              ),
                            ])),
                          ]),
                        ),
                        SizedBox(height: height * 0.07),

                      ]) : Column(children: [
                        CustomStepperWidget(
                          title: getTranslated('order_placed', context),
                          isComplete: status == OrderStatus.pending
                              || status == OrderStatus.confirmed
                              || status == OrderStatus.cooking
                              || status == OrderStatus.processing
                              || status == OrderStatus.outForDelivery
                              || status == OrderStatus.delivered,
                          isActive: status == OrderStatus.pending,
                          haveTopBar: false,
                          statusImage: Images.orderPlaceIcon,
                          subTitle: orderProvider.trackModel?.createdAt != null
                              ?  '${DateConverterHelper.estimatedDate(DateConverterHelper.convertStringToDatetime(orderProvider.trackModel!.createdAt!))} ${DateConverterHelper.estimatedDate(DateConverterHelper.convertStringToDatetime(orderProvider.trackModel!.createdAt!))}' : '',
                        ),

                        CustomStepperWidget(
                          title: getTranslated('confirmed', context),
                          isComplete: status == OrderStatus.confirmed
                              || status == OrderStatus.cooking
                              || status == OrderStatus.processing
                              || status == OrderStatus.outForDelivery
                              || status == OrderStatus.delivered,
                          isActive: status == OrderStatus.confirmed,
                          statusImage: Images.orderConfirmedIcon,
                          subTitle: getTranslated('restaurant_confirmed', context),
                        ),

                        CustomStepperWidget(
                          title: getTranslated('cooking', context),
                          isComplete: status == OrderStatus.cooking
                              || status == OrderStatus.processing
                              || status == OrderStatus.outForDelivery
                              ||status == OrderStatus.delivered,
                          isActive: status == OrderStatus.cooking,
                          statusImage: Images.cooking,
                          subTitle: getTranslated('food_is_being_prepared', context),
                        ),

                        CustomStepperWidget(
                          title: getTranslated('preparing_for_delivery', context),
                          isComplete: status == OrderStatus.processing
                              || status == OrderStatus.outForDelivery
                              ||status == OrderStatus.delivered,
                          statusImage: Images.preparing,
                          isActive: status == OrderStatus.processing,
                          subTitle: getTranslated('packing_your_order', context),
                        ),

                        Consumer<LocationProvider>(builder: (context, locationProvider, _) {

                          if(locationProvider.addressList != null){
                            for(int i = 0 ; i< locationProvider.addressList!.length; i++) {
                              if(locationProvider.addressList![i].id == orderProvider.trackModel!.deliveryAddressId) {
                                locationProvider.addressList![i];
                              }
                            }
                          }

                          final bool isOrderActive = status == OrderStatus.outForDelivery;
                          final bool isOrderComplete = status == OrderStatus.outForDelivery || status == OrderStatus.delivered;

                          return CustomStepperWidget(
                            title: getTranslated('order_is_on_the_way', context),
                            subTitle: getTranslated('your_delivery_is_on_the_way', context),
                            isComplete: status == OrderStatus.outForDelivery || status == OrderStatus.delivered,
                            statusImage: Images.outForDelivery,
                            isActive: status == OrderStatus.outForDelivery,
                            trailing: orderProvider.trackModel?.deliveryMan?.phone != null ? InkWell(
                              onTap: () async {
                                Uri uri = Uri.parse('tel:${orderProvider.trackModel?.deliveryMan?.phone}');
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                } else {
                                  if(context.mounted){
                                    showCustomSnackBarHelper(getTranslated('phone_number_not_found', context));
                                  }
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: (isOrderComplete || isOrderActive) ? Theme.of(context).primaryColor.withValues(alpha: 0.1) : Theme.of(context).hintColor.withValues(alpha: 0.1)
                                ),
                                child: Icon(Icons.phone_in_talk, color: (isOrderComplete || isOrderActive) ? Theme.of(context).primaryColor : Theme.of(context).hintColor),
                              ),
                            ) : const SizedBox(),

                          );
                        }),


                        CustomStepperWidget(
                          title: getTranslated('order_delivered', context),
                          subTitle: getTranslated('order_completed', context),
                          isComplete: status == OrderStatus.delivered,
                          height: orderProvider.deliveryManModel != null && configModel?.googleMapStatus == 1 ? 145 : 30,
                          isActive: status == OrderStatus.delivered,
                          statusImage: Images.orderDeliveredIcon,
                          child: orderProvider.deliveryManModel != null && configModel?.googleMapStatus == 1
                              ? _trackMapButtonWidget(orderProvider: orderProvider)
                              : const SizedBox.shrink(),
                        ),

                        const SizedBox(height: Dimensions.paddingSizeLarge)

                      ]),
                    ]) : widget.orderID == null ?  Column(children: [
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      Image.asset(Images.outForDelivery, color: Theme.of(context).disabledColor.withValues(alpha:0.5), width:  70),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      Text(getTranslated('enter_your_order_id', context)!, style: rubikRegular.copyWith(
                        color: Theme.of(context).disabledColor,
                      ), maxLines: 2,  textAlign: TextAlign.center),
                      const SizedBox(height: 100),

                    ]) : const Center(child: Padding(
                      padding: EdgeInsets.all(50.0),
                      child: CircularProgressIndicator(),
                    )),
                  ]),
                ),
              ]),
            );
          }),
        )),

        if(ResponsiveHelper.isDesktop(context)) const SliverToBoxAdapter(
          // hasScrollBody: false,
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            SizedBox(height: Dimensions.paddingSizeLarge),

            FooterWidget(),
          ]),
        ),
      ]),

    );
  }

  Widget _trackMapButtonWidget({required OrderProvider orderProvider}){
    return Container(
      height: 120, width: ResponsiveHelper.isDesktop(context) ? Dimensions.webMaxWidth * 0.4 : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusSeven),
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        image: const DecorationImage(
          image: AssetImage(Images.mapBg), // Load from assets
          fit: BoxFit.cover, // Adjust how the image fits
        ),
      ),
      margin: const EdgeInsets.only(top: 10),
      child: Center(
        child: SizedBox(
          width: 170, height: 40,
          child: CustomButtonWidget(
            btnTxt: getTranslated("view_on_map", context),
            onTap: (){
              RouterHelper.getTrackMapScreen(
                order: orderProvider.trackModel,
                deliverymanId: orderProvider.trackModel?.deliveryManId,
                orderId: orderProvider.trackModel?.id,
              );
            },
          ),
        ),
      ),
    );
  }
}