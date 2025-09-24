import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/features/cart/providers/cart_provider.dart';
import 'package:flutter_restaurant/helper/branch_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/features/branch/providers/branch_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_shadow_widget.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:provider/provider.dart';

class BranchItemWidget extends StatelessWidget {
  final BranchValue? branchesValue;
  final bool isItemChange;

  const BranchItemWidget({super.key, this.branchesValue, required this.isItemChange});

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Consumer<BranchProvider>(
      builder: (context, branchProvider, _) {
        return Material(
          type: MaterialType.transparency,
          child: InkWell(

            onTap: () async {

              if(!branchesValue!.branches!.status!){
                showCustomSnackBarHelper('${branchesValue!.branches!.name} ${getTranslated('close_now', context)}');
              }
              else if(branchesValue?.branches?.id != branchProvider.getBranchId() && cartProvider.cartList.isNotEmpty) {
                BranchHelper.dialogOrBottomSheet(
                  context,
                  onPressRight: (){
                    branchProvider.updateBranchId(branchesValue!.branches!.id);
                    BranchHelper.setBranch(context);
                    cartProvider.getCartData(context);
                  },
                  title: getTranslated('you_have_some_food', context)!,
                );
              }else if(branchesValue?.branches?.id == branchProvider.getBranchId()){
                showCustomSnackBarHelper(getTranslated('this_is_your_current_branch', context));
              }
              else if(branchesValue!.branches!.status!) {

                BranchHelper.dialogOrBottomSheet(
                  context,
                  onPressRight: (){
                    branchProvider.updateBranchId(branchesValue!.branches!.id);
                    BranchHelper.setBranch(context);
                    cartProvider.getCartData(context);
                  },
                  title: getTranslated('switch_branch_effect', context)!,
                );
              }else{
                showCustomSnackBarHelper('${branchesValue!.branches!.name} ${getTranslated('close_now', context)}');
              }

            },
            child: ResponsiveHelper.isDesktop(context) ? SizedBox(
              width: 370,
              child: Stack(clipBehavior: Clip.hardEdge, children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                    margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      color: branchProvider.selectedBranchId == branchesValue!.branches!.id
                          ? Theme.of(context).primaryColor.withValues(alpha:0.1)
                          : Theme.of(context).cardColor,
                      border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:branchProvider.selectedBranchId == branchesValue!.branches!.id ? 0.8 : 0.1),width: 2),
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),

                    child: Column(children: [

                        Expanded(flex: 2, child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(Dimensions.radiusDefault),
                            topLeft: Radius.circular(Dimensions.radiusDefault),
                          ),
                          child: Container(
                            color: Theme.of(context).canvasColor,
                            child: Stack(children: [
                              CustomImageWidget(
                                placeholder: Images.branchBanner,
                                fit: BoxFit.cover,
                                width: Dimensions.webScreenWidth,
                                image: '${splashProvider.baseUrls!.branchImageUrl}/${branchesValue!.branches!.coverImage}',
                              ),

                              if(!branchesValue!.branches!.status!) Container(color: Colors.black.withValues(alpha:0.6)),

                              if(!branchesValue!.branches!.status!)  Positioned.fill(
                                child: Opacity(opacity: 0.7, child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:0.1),width: 2),
                                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),


                                    ),
                                    child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                      const Icon(
                                        Icons.schedule_outlined,
                                        color: Colors.white,
                                        size: Dimensions.paddingSizeDefault,
                                      ),
                                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                      Text(
                                        getTranslated('temporary_closed', context)!,
                                        style: poppinsRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color: Colors.white,
                                        ),
                                      ),

                                    ]),
                                  ),
                                )),
                              ),
                            ]),
                          ),
                        )),

                        Expanded(child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(Dimensions.radiusDefault), bottomRight: Radius.circular(Dimensions.radiusDefault),
                            ),
                          ),
                          child: const SizedBox(),

                        )),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                      ]),

                  ),

                Positioned(
                  bottom: Dimensions.paddingSizeDefault,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        BranchLogoView(branchesValue: branchesValue),
                        const SizedBox(width: Dimensions.paddingSizeDefault),

                        Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(branchesValue!.branches!.name!, style: rubikSemiBold),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          Row(children: [
                            Icon(Icons.location_on, size: Dimensions.paddingSizeLarge, color: Theme.of(context).primaryColor),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                            Text(
                              branchesValue!.branches!.address != null
                                  ? branchesValue!.branches!.address!.length > 20
                                  ? '${branchesValue!.branches!.address!.substring(0, 20)}...'
                                  : branchesValue!.branches!.address! : branchesValue!.branches!.name!,
                              style: rubikRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),

                          ]),
                        ]),
                      ],
                    ),
                  ),
                ),

                if(branchesValue!.distance != -1) Positioned.fill(
                  bottom: Dimensions.paddingSizeDefault,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                    child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text(
                        '${branchesValue!.distance.toStringAsFixed(3)} ${getTranslated('km', context)}',
                        style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                      Text(getTranslated('away', context)!, style: rubikSemiBold.copyWith(
                        fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor,
                      )),

                    ]),
                  ),
                ),
              ]),
            ) : BranchItemViewMobile(branchesValue: branchesValue),
          ),
        );
      }
    );
  }
}

class BranchItemViewMobile extends StatelessWidget {
  final BranchValue? branchesValue;
  const BranchItemViewMobile({super.key, required this.branchesValue});

  @override
  Widget build(BuildContext context) {

    return CustomShadowWidget(
      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
      margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
      borderRadius: Dimensions.radiusDefault,

      child: Row( children: [

        Column(children: [
          Stack(children: [


            BranchLogoView(branchesValue: branchesValue),

            if(!branchesValue!.branches!.status!) Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                color: Colors.black.withValues(alpha:0.7),
              ),
              width: 82, height: 82,
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.schedule,size: Dimensions.paddingSizeDefault, color: Colors.white),

                Text('${getTranslated('temporary', context)!.toCapitalized()}\n${getTranslated('closed', context)!.toCapitalized()}', textAlign: TextAlign.center, style: rubikRegular.copyWith(
                  color: Colors.white, fontSize: Dimensions.fontSizeSmall,
                )),
              ]),
            ),

          ]),


        ]),
        const SizedBox(width: Dimensions.paddingSizeDefault),

        Flexible(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${branchesValue?.branches?.name}', style: rubikSemiBold, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          Text(
            '${branchesValue?.branches?.address}',
            style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.displayLarge?.color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        ]))

      ]),
    );
  }
}

class BranchLogoView extends StatelessWidget {
  const BranchLogoView({
    super.key,
    required this.branchesValue,
  });

  final BranchValue? branchesValue;

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:0.3)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          child: CustomImageWidget(
            placeholder: Images.placeholderImage,
            height: 80, width: 80,
            fit: BoxFit.cover,
            image: '${splashProvider.baseUrls!.branchImageUrl}/${branchesValue?.branches!.image}',
          ),

        ),
      );
  }
}
