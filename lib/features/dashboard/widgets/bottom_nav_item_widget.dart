import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class BottomNavItemWidget extends StatelessWidget {
  final String imageIcon;
  final String title;
  final Function? onTap;
  final bool isSelected;
  const BottomNavItemWidget({super.key,  this.onTap, this.isSelected = false, required this.title, required this.imageIcon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap as void Function()?,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CustomAssetImageWidget(
             imageIcon, height: 25, width: 25,
            color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).hintColor,
          ),


          SizedBox(height: isSelected ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeSmall),

         if(isSelected) Text(
            title,
            style: rubikBold.copyWith(color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyMedium!.color!, fontSize: 12),
          ),

        ]),
      ),
    );
  }
}
