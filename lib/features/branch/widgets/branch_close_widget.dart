import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class BranchCloseWidget extends StatelessWidget {
  const BranchCloseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,children: [

                const CustomAssetImageWidget(Images.branchClose),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Text(
                  getTranslated('all_our_branches', context)!,
                  style: rubikSemiBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge),
                ),

              ]),
            ),
          ),
          if(ResponsiveHelper.isDesktop(context)) const FooterWidget(),
        ],
      ),
    );
  }
}