import 'package:flutter/material.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class SupportItemWidget extends StatelessWidget {
  final String? label;
  final String? info;
  final IconData? iconData;
  final Function()? onTap;
  const SupportItemWidget({super.key, this.label, this.info, this.iconData, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(width: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.15)),
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
        boxShadow: [BoxShadow(
          color: Theme.of(context).hintColor.withValues(alpha: 0.05),
          offset: const Offset(2, 10),
          blurRadius: 30
        )]
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
        
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label ?? '', style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          Text(info ?? '', style: rubikBold),
        ]),

        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1)
            ),
            child: Icon(iconData, color: Theme.of(context).primaryColor),
          ),
        )

      ]),
    );
  }
}
