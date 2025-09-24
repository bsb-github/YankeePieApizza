import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/notification/domain/models/notification_model.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class NotificationDialogWidget extends StatelessWidget {
  final NotificationModel notificationModel;
  const NotificationDialogWidget({super.key, required this.notificationModel});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child:  SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
              ),
            ),

            Container(
              height: 150, width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).primaryColor.withValues(alpha:0.20)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeInImage.assetNetwork(
                  placeholder: Images.placeholderBanner, height: 150, width: MediaQuery.of(context).size.width, fit: BoxFit.cover,
                  image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.notificationImageUrl}/${notificationModel.image}',
                  imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderBanner, height: 150, width: MediaQuery.of(context).size.width, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: Text(
                notificationModel.title!,
                textAlign: TextAlign.center,
                style: rubikSemiBold.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: Dimensions.fontSizeLarge,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Text(
                notificationModel.description!,
                textAlign: TextAlign.center,
                style: rubikRegular.copyWith(
                  color: ColorResources.getGreyBunkerColor(context).withValues(alpha:.75),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
