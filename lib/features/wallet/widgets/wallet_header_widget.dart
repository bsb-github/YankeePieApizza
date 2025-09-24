import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_restaurant/features/wallet/widgets/add_fund_dialogue_widget.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:provider/provider.dart';


class WalletHeaderWidget extends StatelessWidget {
  final bool webHeader;
  final JustTheController? tooltipController;

  const WalletHeaderWidget({super.key, this.webHeader = false, this.tooltipController});

  @override
  Widget build(BuildContext context) {
    bool isAddFund = Provider.of<SplashProvider>(context, listen: false).configModel?.isAddFundToWallet ?? false;

    return Container(
      decoration: BoxDecoration(
        borderRadius: webHeader ? BorderRadius.circular(Dimensions.radiusDefault) : const BorderRadius.only(
          bottomRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
        color: Theme.of(context).primaryColor,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: Dimensions.paddingSizeDefault,
        horizontal: Dimensions.paddingSizeLarge,
      ),
      child: SafeArea(
        child: Consumer<ProfileProvider>(builder: (context, profileProvider, _) {
          return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),


                  Text( getTranslated('wallet_amount', context)!,
                    style: rubikBold.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Colors.white,
                    ),
                  ),

                  profileProvider.isLoading ? const SizedBox() : Row(children: [
                    CustomDirectionalityWidget(child: Text(
                     PriceConverterHelper.convertPrice(profileProvider.userInfoModel?.walletBalance ?? 0),
                        style: rubikBold.copyWith(
                          fontSize: Dimensions.fontSizeOverLarge,
                          color: Colors.white,
                        ),
                    )),

                    const SizedBox(width: Dimensions.paddingSizeDefault),

                   if(tooltipController != null && isAddFund ) JustTheTooltip(
                      backgroundColor: Colors.black87,
                      controller: tooltipController,
                      preferredDirection: AxisDirection.right,
                      tailLength: 14,
                      tailBaseWidth: 20,
                      content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          getTranslated('by_using_the_add_fund_option', context)!,
                          style: robotoRegular.copyWith(color: Colors.white),
                        ),
                      ),
                      child: InkWell(
                        onTap: () => tooltipController?.showTooltip(),
                        child: Icon(Icons.info_outline, color: Theme.of(context).cardColor),
                      ),
                    )

                  ]),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                ]),
            ),

           isAddFund ? webHeader ? FloatingActionButton.extended(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
              backgroundColor: Colors.white,
              onPressed: (){
                showDialog(context: context, builder: (context)=> const AddFundDialogueWidget());
              },
              label: Text(
                getTranslated('add_fund', context)!,
                style: rubikRegular.copyWith(color: Theme.of(context).primaryColor),
              ),
              icon: Icon(Icons.add_circle, color: Theme.of(context).primaryColor),
            ) : FloatingActionButton.small(
              backgroundColor: Colors.white,
              onPressed: (){
                showDialog(context: context, builder: (context)=> const AddFundDialogueWidget());
              },
              child: Icon(Icons.add, color: Theme.of(context).primaryColor),
            ) : const SizedBox(width: 100),

          ]);
        }),
      ),
    );
  }
}
