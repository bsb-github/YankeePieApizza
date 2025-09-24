import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/helper/custom_extension_helper.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class CustomStepperWidget extends StatelessWidget {
  final bool isActive;
  final bool isComplete;
  final bool haveTopBar;
  final String? title;
  final String? subTitle;
  final Widget? child;
  final double height;
  final String? statusImage;
  final Widget? trailing;
  const CustomStepperWidget({super.key,
    required this.title, required this.isActive,
    this.child, this.haveTopBar = true, this.height = 30,
    this.statusImage = Images.order, this.subTitle,
    required this.isComplete, this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      if(haveTopBar) Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 35),
            height: height,
            child: CustomPaint(
              size: const Size(2, double.infinity),
              painter: _DashedLineVerticalPainter(isActive: isComplete),
            ),
          ),
          child ?? const SizedBox(),
        ],
      ),



      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: const EdgeInsets.all(7),
          margin: const EdgeInsets.only(left: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            color: Theme.of(context).disabledColor.withValues(alpha:0.2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: CustomAssetImageWidget(
              statusImage!, width: 25,
              color: context.customThemeColors.ongoingCardColor.withValues(alpha:isComplete ? 1 : 0.5),
            ),
          ),
        ),
        title: Text(title!, style: rubikRegular.copyWith(
          fontSize: Dimensions.paddingSizeLarge,
          color: isComplete ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).disabledColor,
        )),
        subtitle: (subTitle != null && isComplete) ? Text(subTitle!, style: rubikRegular.copyWith(color: Theme.of(context).disabledColor)) : null,
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          if(trailing != null) trailing!,
          if((isActive || isComplete) && trailing == null) const CustomAssetImageWidget(Images.checkCircle, height: 25,),
        ]),
      ),

    ]);
  }
}


class _DashedLineVerticalPainter extends CustomPainter {
  final bool? isActive;
  _DashedLineVerticalPainter({this.isActive = false});

  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 4, dashSpace = 3, startY = 0;
    final paint = Paint()
      ..color = isActive! ?  Get.context!.customThemeColors.ongoingCardColor : Theme.of(Get.context!).disabledColor.withValues(alpha: 0.5)
      ..strokeWidth = size.width;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}