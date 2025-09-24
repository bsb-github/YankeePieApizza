import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/features/order/domain/models/order_model.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:provider/provider.dart';

class OrderedProductImageWidget extends StatelessWidget {
  const OrderedProductImageWidget({
    super.key,
    required this.orderItem,
  });

  final Order orderItem;

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: (orderItem.productImageList?.length ?? 0) > 1 ? 2 : 1,
        crossAxisSpacing: Dimensions.paddingSizeExtraSmall,
        mainAxisSpacing: Dimensions.paddingSizeExtraSmall,
        childAspectRatio: (orderItem.productImageList?.length ?? 0) == 2 ? 0.8 : 1,
      ),
    itemCount: min((orderItem.productImageList?.length ?? 0), 4),
      itemBuilder: (context, index) => (index < 3 ) || (orderItem.productImageList?.length ?? 0) == 4  ? ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        child: CustomImageWidget(
          image: '${splashProvider.configModel?.baseUrls?.productImageUrl}/${orderItem.productImageList?[index]}',
          height: 30, width: 30,
        ),
      ) : const Card(
        margin: EdgeInsets.zero,
        elevation: 0.5,
        child: SizedBox(height: 30, width: 30, child: Center(child: Text('+4'))),
      ),
    );
  }
}