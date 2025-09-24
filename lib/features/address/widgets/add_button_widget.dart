import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/common/widgets/on_hover_widget.dart';
class AddButtonWidget extends StatelessWidget {
  final Function onTap;
  const AddButtonWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric( vertical: Dimensions.paddingSizeExtraSmall),
      child: OnHoverWidget(
        builder: (onHover) {
          return InkWell(
            onTap: onTap as void Function()?,
            hoverColor: Colors.transparent,
            child: Container(
              // width: 130,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeExtraSmall),
              child: IntrinsicWidth(
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.location_on, color: Colors.white),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Padding(
                      padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeDefault),
                      child: Text(getTranslated('add_address', context)!, style: rubikRegular.copyWith(color: Colors.white)),
                    )
                ]),
              ),
            ),
          );
        }
      ),
    );
  }
}