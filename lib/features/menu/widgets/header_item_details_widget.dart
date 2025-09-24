import 'package:flutter/material.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class HeaderItemDetailsWidget extends StatelessWidget {
  const HeaderItemDetailsWidget({super.key, required this.title, this.subTitle, this.showDivider = true});
  final String title;
  final String? subTitle;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: rubikSemiBold),


        if(subTitle != null && subTitle!.isNotEmpty)...[
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Text(subTitle ?? '', style: rubikRegular),
        ],

      ]),

      if(showDivider)
      Container(height: 30, padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
        child: VerticalDivider(color: Theme.of(context).primaryColor, thickness: 1),
      ),
    ]);
  }
}
