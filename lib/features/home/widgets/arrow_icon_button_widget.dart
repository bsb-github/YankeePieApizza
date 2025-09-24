import 'package:flutter/material.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';

class ArrowIconButtonWidget extends StatelessWidget {
  const ArrowIconButtonWidget({super.key, this.onTap, this.isRight = true});
  
  final void Function()? onTap;
  final bool isRight;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
      shadowColor: Theme.of(context).shadowColor,
      elevation: 20,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Icon(
            isRight ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_rounded, size: Dimensions.paddingSizeDefault,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
