import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/features/branch/providers/branch_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class BranchCardWidget extends StatelessWidget {
  final BranchValue? branchModel;
  final List<BranchValue>? branchModelList;
  final VoidCallback? onTap;
  const BranchCardWidget({
    super.key, this.branchModel, this.onTap, this.branchModelList,
  });

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return Consumer<BranchProvider>(
      builder: (context, branchProvider, _) {
        return GestureDetector(onTap: branchModel!.branches!.status! ? () {
          branchProvider.updateBranchId(branchModel!.branches!.id);
          onTap!();
        } : null, child: Container(
          width: 320,
          //margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            border: branchProvider.selectedBranchId == branchModel!.branches!.id
                ? Border.all(color: Theme.of(context).primaryColor) : null,
            // boxShadow: [BoxShadow(
            //   color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha:0.1),
            //   blurRadius: 30, offset: const Offset(0, 3),
            // )],
          ),
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:0.2)),
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: CustomImageWidget(
                    placeholder: Images.placeholderRectangle,
                    image: '${splashProvider.baseUrls!.branchImageUrl}/${branchModel!.branches!.image}',
                    width: 60, fit: BoxFit.cover, height: 60,
                  ),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text(branchModel!.branches!.name ?? '', style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Row(children: [
                  CustomAssetImageWidget(Images.branchIconSvg, width: 20, height: 20, color: Theme.of(context).primaryColor),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                  Text(
                    branchModel!.branches!.address != null ? branchModel!.branches!.address!.length > 20
                        ? '${branchModel!.branches!.address!.substring(0, 20)}...' : branchModel!.branches!.address!
                        : branchModel!.branches!.name!,
                    style: rubikSemiBold.copyWith(color: Theme.of(context).primaryColor),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ]),
              ]),
            ]),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
              Row(children: [
                Icon(
                  Icons.schedule_outlined,
                  color:branchModel!.branches!.status! ? Theme.of(context).secondaryHeaderColor : Theme.of(context).colorScheme.error,
                  size: Dimensions.paddingSizeLarge,
                ),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                Text(
                  getTranslated(branchModel!.branches!.status! ? 'open_now' : 'close_now', context)!,
                  style: rubikRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color:branchModel!.branches!.status! ? Theme.of(context).secondaryHeaderColor : Theme.of(context).colorScheme.error,
                  ),
                ),
              ]),

              if(branchModel!.distance != -1 && splashProvider.configModel?.googleMapStatus == 1) Row(children: [
                Text('${branchModel!.distance.toStringAsFixed(3)} ${getTranslated('km', context)}',
                  style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
                const SizedBox(width: 3),

                Text(getTranslated('away', context)!, style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
              ]),
            ]),

          ]),
        ));
      },
    );
  }
}