import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/refer_and_earn/widgets/refer_hint_view.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ReferAndEarnWebWidget extends StatelessWidget {
  const ReferAndEarnWebWidget({super.key, required this.hintList});

  final List<String?> hintList;

  @override
  Widget build(BuildContext context) {

    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraLarge),
      child: Column(children: [

        ///Header Section
        const CustomAssetImageWidget(Images.referBanner, width: 150, height: 160, fit: BoxFit.contain),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        Text(
          '${getTranslated('help_your_friends', context)!} ${getTranslated('discover_efood', context)!}',
          textAlign: TextAlign.center,
          style: rubikSemiBold.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            // color: Theme.of(context).cardColor,
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        ///Middle Card
        SizedBox(
          width: 600,
          child: DottedBorder(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            borderType: BorderType.RRect,
            radius: const Radius.circular(Dimensions.radiusDefault),
            dashPattern: const [2, 2],
            color: Theme.of(context).primaryColor.withValues(alpha:0.5),
            strokeWidth: 2,
            child: Row(children: [

              const ClipOval(child: SizedBox(
                height: 45, width: 45,
                child: CustomAssetImageWidget(Images.copyReferralCodeSvg),
              )),
              const SizedBox(width: Dimensions.paddingSizeDefault),

              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  getTranslated('copy_your_code', context)!,
                  style: rubikSemiBold.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Text(
                  '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel!.referCode : ''}',
                  style: rubikRegular.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ])),
              const SizedBox(width: Dimensions.paddingSizeDefault),

              IconButton(
                onPressed: (){
                  if(profileProvider.userInfoModel!.referCode != null && profileProvider.userInfoModel!.referCode  != ''){
                    Clipboard.setData(ClipboardData(text: '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel!.referCode : ''}'));
                    showCustomSnackBarHelper(getTranslated('referral_code_copied', context), isError: false);
                  }
                },
                icon: CustomAssetImageWidget(Images.copySvg, color: Theme.of(context).primaryColor),
              ),

            ]),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

        ///Share Section
        Center(child: Text(
          getTranslated('or_share', context)!,
          style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
        )),
        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

        Center(child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => Share.share(profileProvider.userInfoModel!.referCode!, subject: profileProvider.userInfoModel!.referCode!),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
            child: Image.asset(
              Images.share, height: 50, width: 50,
            ),
          ),
        )),
        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

        SizedBox(width: 700, child: ReferHintView(hintList: hintList)),
        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

      ]),
    );
  }
}
