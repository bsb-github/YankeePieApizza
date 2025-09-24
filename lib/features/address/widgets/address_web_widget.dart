import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/no_data_widget.dart';
import 'package:flutter_restaurant/features/address/domain/models/address_model.dart';
import 'package:flutter_restaurant/features/address/enum/route_tyep_enum.dart';
import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
import 'package:flutter_restaurant/features/address/widgets/add_button_widget.dart';
import 'package:flutter_restaurant/features/address/widgets/address_card_web_widget.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class AddressWebWidget extends StatelessWidget {
  const AddressWebWidget({super.key, required this.locationProvider});

  final LocationProvider locationProvider;

  @override
  Widget build(BuildContext context) {

    return Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [

      Center(
        child: Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraLarge,),
          //constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && height < 600 ? height : height - 400),
          width: Dimensions.webScreenWidth,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
            boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)],
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [

            locationProvider.addressList == null
              ? _AddressShimmerWidget(isEnabled: locationProvider.addressList == null)
              : locationProvider.addressList!.isNotEmpty
              ? Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeSmall),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(getTranslated('my_address', context)!, style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

                    AddButtonWidget(onTap: () =>   RouterHelper.getAddAddressRoute(page: 'address', action:  'add', addressModel:  AddressModel(), routeType: RouteTypeEnum.address)),
                  ]),
                ),

                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: Dimensions.paddingSizeDefault,
                    mainAxisSpacing: Dimensions.paddingSizeDefault,
                    mainAxisExtent: 200,
                  ),
                  itemCount: locationProvider.addressList!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => AddressCardWebWidget(addressModel: locationProvider.addressList![index], index: index),
                ),
              ])
            : const SizedBox(width: 250, child: NoDataWidget(isFooter: false, isAddress: true)),

          ])
        ),
      ),


    ]);
  }
}


class _AddressShimmerWidget extends StatelessWidget {
  const _AddressShimmerWidget({required this.isEnabled});
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(width: 120, height: 20, color: Theme.of(context).hintColor.withValues(alpha:0.2)),

          Container(width: 60, height: 30, color: Theme.of(context).hintColor.withValues(alpha:0.2)),
        ]),
      ),

      GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: Dimensions.paddingSizeDefault,
          mainAxisSpacing: Dimensions.paddingSizeDefault,
          mainAxisExtent: 200,
        ),
        itemCount: 5,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) => Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
          clipBehavior: Clip.hardEdge,
          child: Shimmer(enabled: isEnabled, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              color: Theme.of(context).hintColor.withValues(alpha:0.05),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(width: 200, height: 20, color: Theme.of(context).hintColor.withValues(alpha:0.2)),

                Container(width: 60, height: 20, color: Theme.of(context).hintColor.withValues(alpha:0.2)),
              ]),
            ),

            Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault), child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 200, height: 20, color: Theme.of(context).hintColor.withValues(alpha:0.2)),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Container(width: 200, height: 20, color: Theme.of(context).hintColor.withValues(alpha:0.2)),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Container(width: 200, height: 20, color: Theme.of(context).hintColor.withValues(alpha:0.2)),
              ],
            )),

          ])),
        ),
      ),

    ]);
  }
}
