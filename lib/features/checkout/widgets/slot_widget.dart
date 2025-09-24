import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class SlotWidget extends StatelessWidget {
  final String? title;
  final bool isSelected;
  final bool showIcon;
  final Widget? icon;
  final Function onTap;
  const SlotWidget({
    super.key, required this.title, required this.isSelected, required this.onTap, this.icon, this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Theme.of(context).canvasColor,
        onTap: onTap as void Function()?,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
          child: Row(children: [

            if(showIcon) ...[
              icon ?? CustomAssetImageWidget(
                Images.schedule, width: Dimensions.paddingSizeDefault,
                color: isSelected ? Colors.white : Theme.of(context).disabledColor,
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
            ],


            Text(title!, style: rubikSemiBold.copyWith(
              color: isSelected ? Colors.white : Theme.of(context).disabledColor,
              fontSize: Dimensions.fontSizeSmall,
            )),
          ]),
        ),
      ),
    );
  }
}
