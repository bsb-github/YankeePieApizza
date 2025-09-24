import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/notification_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_directionality_widget.dart';
import 'package:go_router/go_router.dart';

class NotificationPopUpDialogWidget extends StatefulWidget {
  final PayloadModel payloadModel;
  const NotificationPopUpDialogWidget(this.payloadModel, {super.key});

  @override
  State<NotificationPopUpDialogWidget> createState() => _NewRequestDialogState();
}

class _NewRequestDialogState extends State<NotificationPopUpDialogWidget> {

  @override
  void initState() {
    super.initState();

    _startAlarm();
  }

  void _startAlarm() async {
    AudioPlayer audio = AudioPlayer();
    audio.play(AssetSource('notification.wav'));
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      //insetPadding: EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Icon(Icons.notifications_active, size: 60, color: Theme.of(context).primaryColor),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: CustomDirectionalityWidget(child: Text(
                '${widget.payloadModel.title} ${widget.payloadModel.orderId != '' ? '(${widget.payloadModel.orderId})': ''}',
                textAlign: TextAlign.center,
                style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
              )),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Column(
              children: [
                Text(
                  widget.payloadModel.body!, textAlign: TextAlign.center,
                  style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                ),
                if(widget.payloadModel.image != 'null')
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall,),

                if(widget.payloadModel.image != 'null')
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FadeInImage.assetNetwork(
                      image: widget.payloadModel.image!,
                      height: 100,
                      width: 500,
                      placeholder: Images.placeholderImage,
                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholderImage, height: 70, width: 80, fit: BoxFit.cover),
                    ),
                  ),


              ],
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Row(mainAxisAlignment: MainAxisAlignment.center, children: [

            Flexible(
              child: SizedBox(width: 120, height: 40,child: TextButton(
                onPressed: () => context.pop(),
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).disabledColor.withValues(alpha:0.3), padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
                ),
                child: Text(
                  getTranslated('cancel', context)!, textAlign: TextAlign.center,
                  style: poppinsRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
                ),
              )),
            ),


            const SizedBox(width: 20),

            if(widget.payloadModel.orderId != null || widget.payloadModel.type == 'message') Flexible(
              child: SizedBox(
                width: 120,
                height: 40,
                child: CustomButtonWidget(
                  // textColor: Colors.white,
                  btnTxt: getTranslated('go', context),
                  onTap: () {
                    context.pop();

                    try{
                      if(widget.payloadModel.type == 'message') {
                        RouterHelper.getChatRoute(orderId: int.tryParse(widget.payloadModel.orderId ?? ''));
                      }else if(widget.payloadModel.type == 'general'){
                        RouterHelper.getNotificationRoute();
                      }else if(widget.payloadModel.type == 'referral'){
                        RouterHelper.getWalletRoute();
                      }else{
                        RouterHelper.getOrderDetailsRoute(widget.payloadModel.orderId!, phoneNumber: null);
                        // Get.navigator!.push(MaterialPageRoute(
                        //   builder: (context) => OrderDetailsScreen(
                        //       orderModel: null,
                        //       orderId:  ,
                        //   ),
                        // ));
                      }

                    }catch (e) {
                      debugPrint('error ===> $e');
                    }

                  },
                ),
              ),
            ),

          ]),

        ]),
      ),
    );
  }
}
