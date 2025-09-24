import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/on_hover_widget.dart';
import 'package:flutter_restaurant/features/checkout/providers/checkout_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class CutleryWidget extends StatefulWidget {
  const CutleryWidget({
    super.key,
  });

  @override
  State<CutleryWidget> createState() => _CutleryWidgetState();
}

class _CutleryWidgetState extends State<CutleryWidget> {
  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return (splashProvider.configModel?.cutleryStatus ?? false) ? SizedBox(height: 60, child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

      const CustomAssetImageWidget(Images.cutlerySvg),
      const SizedBox(width: Dimensions.paddingSizeDefault),

      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(getTranslated('add_cutlery', context)!, style: rubikSemiBold.copyWith(
          fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeDefault : Dimensions.fontSizeSmall,
        )),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        Expanded(child: Text('Don’t have cutlery? Restaurant will provide your', style: rubikRegular.copyWith(
          fontSize: Dimensions.fontSizeSmall,
          color: Theme.of(context).hintColor,
        ))),

      ])),



      Consumer<CheckoutProvider>(builder: (context, checkoutProvider, _) {
        return Theme(
          data: ThemeData(useMaterial3: false),
          child: OnHoverWidget(
            builder: (isHovered) {
              return Switch(
                thumbColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                  if(states.contains(WidgetState.hovered)){
                    return Colors.grey.shade200;
                  }else{
                    return Colors.white;
                  }
                }),
                hoverColor: Colors.transparent,
                value: checkoutProvider.isCutlerySelected,
                activeColor: Theme.of(context).primaryColor,
                inactiveTrackColor: Theme.of(context).shadowColor,
                onChanged: (value) {
                  checkoutProvider.updateCutleryStatus(value);
                },
              );
            }
          ),
        );
      }),

    ])) : const SizedBox();
  }
}
