import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/features/address/domain/models/address_model.dart';
import 'package:flutter_restaurant/features/address/enum/route_tyep_enum.dart';
import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/cart/widgets/delivery_option_widget.dart';
import 'package:flutter_restaurant/features/checkout/domain/enum/delivery_type_enum.dart';
import 'package:flutter_restaurant/features/checkout/providers/checkout_provider.dart';
import 'package:flutter_restaurant/features/checkout/widgets/input_contact_info_widget.dart';
import 'package:flutter_restaurant/features/checkout/widgets/selected_address_list_widget.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/checkout_helper.dart';
import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

import '../../../common/models/delivery_info_model.dart';

class DeliveryDetailsWidget extends StatelessWidget {
  const DeliveryDetailsWidget({
    super.key,
    required this.currentBranch,
    required this.kmWiseCharge,
    required this.deliveryCharge, this.amount,
    required this.dropdownKey,
    required this.isFreeDelivery,
  });

  final Branches? currentBranch;
  final bool kmWiseCharge;
  final bool isFreeDelivery;
  final double? deliveryCharge;
  final double? amount;
  final GlobalKey dropdownKey;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveHelper.isDesktop(context);
    final ConfigModel? configModel = Provider.of<SplashProvider>(context, listen: false).configModel;
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    final TextEditingController searchController = TextEditingController();

    return Consumer<CheckoutProvider>(builder:(context, checkoutProvider, _){
      return Consumer<LocationProvider>(
        builder: (context, locationProvider, _) {
          final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

          AddressModel? deliveryAddress = CheckOutHelper.getDeliveryAddress(
            addressList: locationProvider.addressList,
            selectedAddress: checkoutProvider.selectedAddress,
            lastOrderAddress: null,
            orderType: checkoutProvider.orderType
          );

          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withValues(alpha:0.5), blurRadius: Dimensions.radiusDefault)],
            ),
            padding:  const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Row(children: [

                Image.asset(Images.deliveryInfo, width: 17),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Text(getTranslated('delivery_information', context)!, style: rubikBold.copyWith(
                  fontSize: isDesktop ? Dimensions.fontSizeLarge : Dimensions.fontSizeDefault,
                  fontWeight: isDesktop ? FontWeight.w700 : FontWeight.w600,
                )),

                const Spacer(),

                TextButton(
                  onPressed: () {
                    if(checkoutProvider.orderType == OrderType.takeAway){
                      ResponsiveHelper.showDialogOrBottomSheet(
                        context,  InputContactInfoWidget(
                        address: deliveryAddress,
                      ));
                    }
                    else if((locationProvider.addressList?.isEmpty ?? false) ){
                      RouterHelper.getAddAddressRoute(
                        page: 'checkout',
                        action: 'add',
                        addressModel: deliveryAddress ?? AddressModel(address: ""),
                        isCurrentLocation: _canSaveAddressToProfile(deliveryAddress, authProvider.isLoggedIn()),
                        routeType: RouteTypeEnum.checkout,
                      );
                    }else{
                      ResponsiveHelper.showDialogOrBottomSheet(
                        context, SelectedAddressListWidget(currentBranch: currentBranch, isFreeDelivery: isFreeDelivery,),
                      );
                    }


                  },
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 5, vertical: 10)),
                    minimumSize: WidgetStateProperty.all(const Size(0, 0)), // Remove minimum constraints
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduce tap target size
                  ),
                  child: Text(getTranslated( deliveryAddress == null ? 'add' : 'update_info', context)!, style: rubikBold.copyWith(
                    color: ColorResources.getSecondaryColor(context),
                  )),
                ),
              ]),

              Divider(thickness: 0.5, color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),

              _ContactInfoWidget(deliveryAddress: deliveryAddress),

              Divider(thickness: 0.5, color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),

              if(checkoutProvider.orderType == OrderType.delivery)
                _AddressInfoWidget(deliveryAddress: deliveryAddress,),

              if(checkoutProvider.orderType == OrderType.delivery)
                Divider(thickness: 0.5, color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),

              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              if(checkoutProvider.orderType != OrderType.takeAway && splashProvider.deliveryInfoModel != null && (splashProvider.deliveryInfoModel!.deliveryChargeByArea?.isNotEmpty ?? false) && splashProvider.deliveryInfoModel?.deliveryChargeSetup?.deliveryChargeType == 'area')...[

                Text(
                  getTranslated('zip_area', context)!,
                  style: rubikSemiBold.copyWith(fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeLarge : Dimensions.fontSizeDefault),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),


                Consumer<SplashProvider>(
                    builder: (context, splashProvider, child) {


                      return Row(children: [

                        Expanded(child: DropdownButtonHideUnderline(child: DropdownButton2<String>(

                          key: dropdownKey,
                          iconStyleData: IconStyleData(icon: Icon(Icons.keyboard_arrow_down_rounded, color: Theme.of(context).hintColor)),
                          isExpanded: true,
                          hint: Text(
                            getTranslated('search_or_select_zip_code_area', context)!,
                            style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                          ),
                          selectedItemBuilder: (BuildContext context) {
                            return splashProvider.deliveryInfoModel!.deliveryChargeByArea!
                                .map((DeliveryChargeByArea item) {
                              return Row(
                                children: [
                                  Text(
                                    item.areaName ?? "",
                                    style: rubikRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: Theme.of(context).textTheme.bodyMedium?.color,
                                    ),
                                  ),
                                  Text(
                                    " (${PriceConverterHelper.convertPrice(item.deliveryCharge ?? 0)})",
                                    style: rubikRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                ],
                              );
                            }).toList();
                          },

                          items: splashProvider.deliveryInfoModel!.deliveryChargeByArea!.map((DeliveryChargeByArea item) => DropdownMenuItem<String>(
                            value: item.id.toString(),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                              Text(item.areaName ?? "", style: rubikRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                              )),

                              Text(" (${PriceConverterHelper.convertPrice(item.deliveryCharge ?? 0)})",
                                style: rubikRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),

                            ]),
                          )).toList(),

                          value: locationProvider.selectedAreaID == -1 ? null
                              : splashProvider.deliveryInfoModel!.deliveryChargeByArea!.firstWhere((area) => area.id == locationProvider.selectedAreaID).id.toString(),

                          onChanged: (String? value) {
                            locationProvider.setAreaID(areaID: int.parse(value!));
                            double deliveryCharge;
                            deliveryCharge = CheckOutHelper.getDeliveryCharge(
                                splashProvider : splashProvider,
                                googleMapStatus: configModel!.googleMapStatus!,
                                distance: checkoutProvider.distance,
                                minimumDistanceForFreeDelivery: splashProvider.deliveryInfoModel?.deliveryChargeSetup?.minimumDistanceForFreeDelivery?.toDouble() ?? 0,
                                shippingPerKm: splashProvider.deliveryInfoModel?.deliveryChargeSetup?.deliveryChargePerKilometer?.toDouble() ?? 0,
                                minShippingCharge: splashProvider.deliveryInfoModel?.deliveryChargeSetup?.minimumDeliveryCharge?.toDouble() ?? 0,
                                defaultDeliveryCharge: splashProvider.deliveryInfoModel?.deliveryChargeSetup?.fixedDeliveryCharge?.toDouble() ?? 0,
                                isTakeAway: checkoutProvider.orderType == OrderType.takeAway,
                                areaID : int.parse(value),
                                isFreeDelivery: isFreeDelivery
                            );
                            checkoutProvider.setDeliveryCharge(deliveryCharge: deliveryCharge);
                          },

                          dropdownSearchData: DropdownSearchData(
                            searchController: searchController,
                            searchInnerWidgetHeight: 50,
                            searchInnerWidget: Container(
                              height: 50,
                              padding: const EdgeInsets.only(
                                top: Dimensions.paddingSizeSmall,
                                left: Dimensions.paddingSizeSmall,
                                right: Dimensions.paddingSizeSmall,
                              ),
                              child: TextFormField(
                                controller: searchController,
                                expands: true,
                                maxLines: null,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                  hintText: getTranslated('search_zip_area_name', context)!,
                                  hintStyle: const TextStyle(fontSize: Dimensions.fontSizeSmall),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  ),
                                ),
                              ),
                            ),
                            searchMatchFn: (item, searchValue) {
                              DeliveryChargeByArea areaItem = splashProvider.deliveryInfoModel!.deliveryChargeByArea!
                                  .firstWhere((element) => element.id.toString() == item.value);
                              return areaItem.areaName?.toLowerCase().contains(searchValue.toLowerCase()) ?? false;
                            },
                          ),
                          buttonStyleData: ButtonStyleData(
                            decoration: BoxDecoration(
                              border: Border.all(color: Theme.of(context).hintColor),
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),),
                            padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                          ),

                        ))),


                      ]);
                    }
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraLarge),
              ],



              Text(getTranslated('delivery_type', context)!, style: rubikBold.copyWith(
                fontSize: isDesktop ? Dimensions.fontSizeLarge : Dimensions.fontSizeDefault,
                fontWeight: isDesktop ? FontWeight.w700 : FontWeight.w600,
              )),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Consumer<CheckoutProvider>(
                  builder: (context, checkoutProvider, _) {
                    if (isDesktop) {
                      return Row(children: [
                        Expanded(
                          child: (splashProvider.configModel?.homeDelivery ?? false) ? DeliveryOptionWidget(
                            value: OrderType.delivery,
                            title: getTranslated('delivery', context)!,
                            deliveryCharge: checkoutProvider.deliveryCharge,
                          ) : Padding(
                            padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall,top: Dimensions.paddingSizeLarge),
                            child: Row(children: [
                              Icon(Icons.remove_circle_outline_sharp,color: Theme.of(context).hintColor,),
                              const SizedBox(width: Dimensions.paddingSizeExtraLarge),

                              Text(getTranslated('home_delivery_not_available', context)!,style: TextStyle(fontSize: Dimensions.fontSizeDefault,color: Theme.of(context).primaryColor)),
                            ]),
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        if(splashProvider.configModel?.selfPickup ?? false) Expanded(
                          child: DeliveryOptionWidget(
                            value: OrderType.takeAway,
                            title: getTranslated('take_away', context)!,
                            deliveryCharge: checkoutProvider.deliveryCharge,
                          ),
                        ),
                      ]);
                    } else {
                      return Column( children: [
                        (splashProvider.configModel?.homeDelivery ?? false) ? DeliveryOptionWidget(
                          value: OrderType.delivery,
                          title: getTranslated('delivery', context)!,
                          deliveryCharge: checkoutProvider.deliveryCharge,
                        ) : Padding(
                          padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall,top: Dimensions.paddingSizeLarge),
                          child: Row(children: [
                            Icon(Icons.remove_circle_outline_sharp,color: Theme.of(context).hintColor,),
                            const SizedBox(width: Dimensions.paddingSizeExtraLarge),

                            Text(getTranslated('home_delivery_not_available', context)!,style: TextStyle(fontSize: Dimensions.fontSizeDefault,color: Theme.of(context).primaryColor)),
                          ]),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        if(splashProvider.configModel?.selfPickup ?? false) DeliveryOptionWidget(
                          value: OrderType.takeAway,
                          title: getTranslated('take_away', context)!,
                          deliveryCharge: checkoutProvider.deliveryCharge,
                        ),

                      ]);
                    }
                  }
              ),

            ]),
          );
        },
      );
    });
  }

  bool _canSaveAddressToProfile(AddressModel? deliveryAddress, bool isLoggedIn) => deliveryAddress != null && !isLoggedIn;
}

class _ContactInfoWidget extends StatelessWidget {
  final AddressModel? deliveryAddress;
  const _ContactInfoWidget({
    this.deliveryAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      child: deliveryAddress?.contactPersonNumber != null  && deliveryAddress?.contactPersonName != null ?  Column(spacing: Dimensions.paddingSizeExtraSmall, children: [
        contactItem(context: context, icon: Icons.person, title: deliveryAddress?.contactPersonName ?? ''),
        contactItem(context: context, icon: Icons.call, title: deliveryAddress?.contactPersonNumber ?? ''),
      ]) : Center(
        child: Column( spacing: Dimensions.paddingSizeSmall, children: [
          Icon(Icons.person, color: Theme.of(context).disabledColor),
          Text(getTranslated('no_contact_info_added', context)!, style: rubikRegular.copyWith(color: Theme.of(context).disabledColor)),
        ]),
      ),
    );
  }

  Widget contactItem({required IconData icon,String? title, required BuildContext context}){
    return Row(children: [
      Icon(icon, color: Theme.of(context).disabledColor, size: 20,),
      const SizedBox(width: Dimensions.paddingSizeSmall),

      Flexible(
        child: Text(
          title ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: rubikRegular,
        ),
      ),
    ]);
  }
}


class _AddressInfoWidget extends StatelessWidget {
  final AddressModel? deliveryAddress;
  const _AddressInfoWidget({this.deliveryAddress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      child: deliveryAddress?.address != null ?  Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(spacing: Dimensions.paddingSizeSmall, children: [
          Icon(Icons.location_on_rounded, color: Theme.of(context).disabledColor, size: 17,),
          Flexible(child: Text(deliveryAddress?.address ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: rubikRegular)),
        ]),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Padding( padding: const EdgeInsets.symmetric(horizontal: 27),
          child: Column( spacing: Dimensions.paddingSizeExtraSmall, children: [
            Row(spacing: Dimensions.paddingSizeExtraSmall, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

              if(deliveryAddress?.houseNumber?.isNotEmpty ?? false) Flexible(
                child: otherInfoWidget(context: context, title: "house", subtitle: deliveryAddress?.houseNumber),
              ),

              if(deliveryAddress?.floorNumber?.isNotEmpty ?? false) Flexible(
                child: otherInfoWidget(context: context, title: "floor", subtitle: deliveryAddress?.floorNumber),
              ),

              if(((deliveryAddress?.floorNumber?.isEmpty ?? true) || (deliveryAddress?.houseNumber?.isEmpty ?? true)) && (deliveryAddress?.streetNumber?.isNotEmpty ?? false))Flexible(
                child: otherInfoWidget(context: context, title: "street", subtitle: deliveryAddress?.streetNumber),
              ),
            ]),

            if((deliveryAddress?.floorNumber?.isNotEmpty ?? false) && (deliveryAddress?.houseNumber?.isNotEmpty ?? false) && (deliveryAddress?.streetNumber?.isNotEmpty ?? false))
              otherInfoWidget(context: context, title: "street", subtitle: deliveryAddress?.streetNumber),
          ]),
        ),
      ]) : Row(spacing: Dimensions.paddingSizeSmall, children: [
        Icon(Icons.location_on_rounded, color: Theme.of(context).disabledColor, size: 17,),
        Flexible(
          child: Text(
            "${getTranslated("no_location_added", context)}", maxLines: 1, overflow: TextOverflow.ellipsis,
            style: rubikRegular.copyWith(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ]),
    );
  }

  Widget otherInfoWidget({String? title, String? subtitle,  required BuildContext context}){
    return Row( spacing: Dimensions.paddingSizeExtraSmall, children: [
      Text( '${getTranslated(title, context)} : ',
        maxLines: 1, overflow: TextOverflow.ellipsis,
        style: rubikRegular.copyWith(color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6)),
      ),
      Flexible(child: Text(subtitle ?? "", maxLines: 1, overflow: TextOverflow.ellipsis, style: rubikRegular),
      )
    ]);
  }
}



