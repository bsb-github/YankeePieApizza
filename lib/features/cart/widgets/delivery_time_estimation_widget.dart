import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/branch_list_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_alert_dialog_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/features/branch/providers/branch_provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class DeliveryTimeEstimationWidget extends StatelessWidget {
  const DeliveryTimeEstimationWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final BranchProvider branchProvider = Provider.of<BranchProvider>(context, listen: false);

    final bool isDesktop = ResponsiveHelper.isDesktop(context);

    return Container(
      constraints: const BoxConstraints(maxHeight: 100),
      decoration: BoxDecoration(
        color: ColorResources.getSecondaryColor(context).withValues(alpha:0.07),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      padding: const EdgeInsets.only(
        top: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(mainAxisSize: MainAxisSize.min, children: [
            const CustomAssetImageWidget(Images.restaurantLocationSvg, width: 16, height: 16),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

            Text(branchProvider.getBranch()?.name ?? '', style: rubikSemiBold.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              fontWeight: isDesktop ? FontWeight.w600 : FontWeight.w400,
            )),
          ]),

          InkWell(
            onTap: (){
              ResponsiveHelper.showDialogOrBottomSheet(context, CustomAlertDialogWidget(
                width: 500,

                child: Padding(
                  padding: isDesktop ?  const EdgeInsets.symmetric(vertical: 40, horizontal: Dimensions.paddingSizeDefault) : EdgeInsets.zero,
                  child: BranchListWidget(controller: ScrollController(), isItemChange: true),
                ),
              ));
            },
            child: Text(getTranslated('change', context)!, style: rubikSemiBold.copyWith(
              fontSize: Dimensions.fontSizeSmall, color: ColorResources.getSecondaryColor(context),
            )),
          ),
        ]),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: Divider(color: Theme.of(context).primaryColor.withValues(alpha:0.2), height: Dimensions.paddingSizeLarge, thickness: 0.3),
        ),

        Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

          const Align(alignment: Alignment.bottomLeft, child: CustomAssetImageWidget(
            Images.walkingSvg, width: 45, height: 45,
          )),

          Column(mainAxisSize: MainAxisSize.min, children: [
            Text(getTranslated('estimate_delivery_time', context)!, style: rubikRegular.copyWith(
              fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeSmall : Dimensions.fontSizeExtraSmall,
              color: Theme.of(context).hintColor,
            )),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            Text('${branchProvider.getBranch()?.preparationTime ?? 0}${getTranslated('min', context)?.toLowerCase()} - ${(branchProvider.getBranch()?.preparationTime ?? 0) + 10}${getTranslated('min', context)?.toLowerCase()}', style: rubikSemiBold.copyWith(
              fontSize: Dimensions.fontSizeLarge,
              fontWeight: ResponsiveHelper.isDesktop(context) ? FontWeight.w700 : FontWeight.w600,
            )),
          ]),

          const Align(alignment: Alignment.bottomRight, child: CustomAssetImageWidget(
            Images.drivingSvg, width: 45, height: 45,
          )),

        ])),

      ]),
    );
  }
}