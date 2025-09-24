import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/on_hover_widget.dart';
import 'package:flutter_restaurant/features/menu/domain/models/menu_model.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class MenuItemWebWidget extends StatelessWidget {
  final MenuModel menu;
  const MenuItemWebWidget({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(32.0),
      onTap: ()=> menu.route(),
      child: OnHoverWidget(
        builder: (isHoverActive) {
          return Container(
            decoration: BoxDecoration(
              color: isHoverActive ? Theme.of(context).cardColor : Theme.of(context).shadowColor.withValues(alpha:0.2),
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
              border: isHoverActive ? Border.all(color: Theme.of(context).primaryColor) : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                menu.iconWidget != null ? menu.iconWidget!
                : CustomAssetImageWidget(menu.icon, width: 50, height: 50,
                    color: menu.showActive ? Theme.of(context).primaryColor
                    : isHoverActive ? Theme.of(context).primaryColor
                    : Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Text(menu.title ?? '', textAlign: TextAlign.center, style: robotoRegular.copyWith(
                  color: isHoverActive ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge!.color,
                )),
              ],
            ),
          );
        }
      ),
    );
  }
}
