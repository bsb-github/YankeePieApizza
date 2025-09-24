import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/branch/providers/branch_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class BranchButtonWidget extends StatelessWidget {
  final Color? color;
  final bool isRow;
  final bool isPopup;

  const BranchButtonWidget({
    super.key, this.isRow = true, this.color, this.isPopup = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(builder: (context, splashProvider, _) {
        return  splashProvider.isBranchSelectDisable() ?  Consumer<BranchProvider>(
          builder: (context, branchProvider, _) {
            return branchProvider.getBranchId() != -1 ? isPopup ? const BranchPopUpButton() : InkWell(
                onTap: ()=> RouterHelper.getBranchListScreen(),
                child: isRow ? Row(children: [
                  Row(children: [
                    CustomAssetImageWidget(
                      Images.branchIcon, color: color ?? Theme.of(context).primaryColor, height: Dimensions.paddingSizeDefault,
                    ),

                    RotatedBox(quarterTurns: 1,child: Icon(Icons.sync_alt, color: color ?? Theme.of(context).primaryColor, size: Dimensions.paddingSizeDefault)),
                    const SizedBox(width: 2),

                    Text(
                      '${branchProvider.getBranch()?.name}',
                      style:  rubikRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: color ?? Theme.of(context).primaryColor),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ]),
                ]) : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Row(children: [
                      CustomAssetImageWidget(
                        Images.branchIcon, color: color ?? Theme.of(context).primaryColor, height: Dimensions.paddingSizeDefault,
                      ),
                      RotatedBox(quarterTurns: 1,child: Icon(Icons.sync_alt, color: color ?? Theme.of(context).primaryColor, size: Dimensions.paddingSizeDefault))
                    ]),
                    const SizedBox(height: 8),

                    Text(
                      '${branchProvider.getBranch()?.name}',
                      style: rubikRegular.copyWith(color: color ?? Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    )
                  ],
                )) : const SizedBox();
          },
        ) : const SizedBox();
      }
    );
  }
}
class BranchPopUpButton extends StatelessWidget {
  const BranchPopUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> RouterHelper.getBranchListScreen(),
      child: Consumer<BranchProvider>(builder: (context, branchProvider, _) {
          return Row(children: [
            Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(getTranslated('branch', context)!, style: rubikRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor,
              )),

              Text('${branchProvider.getBranch()?.name}', style: poppinsRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).primaryColor,
              ))

            ]),

            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            Icon(Icons.expand_more, size: Dimensions.paddingSizeDefault, color: Theme.of(context).hintColor),
          ]);
        }
      ),
    );
  }
}
