import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/order_track/providers/tracker_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/order_status.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class TimerWidget extends StatefulWidget {
  final String? status;
  const TimerWidget({super.key, this.status});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TrackerProvider>(
        builder: (context, orderTimer, child) {
          int? days, hours, minutes, seconds;
          if (orderTimer.duration != null) {
            days = orderTimer.duration!.inDays;
            hours = orderTimer.duration!.inHours - days * 24;
            minutes = orderTimer.duration!.inMinutes - (24 * days * 60) - (hours * 60);
            seconds = orderTimer.duration!.inSeconds - (24 * days * 60 * 60) - (hours * 60 * 60) - (minutes * 60);
          }
          return Column( children: [
            Image.asset(Images.deliveryManGif, height: 180),

            Text(
              _getStatusText(widget.status) ?? '',
              style: widget.status == OrderStatus.delivered
                  ? rubikSemiBold.copyWith(fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : Dimensions.fontSizeLarge)
                  : rubikRegular.copyWith(
                  color: Theme.of(context).hintColor,
                  fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeLarge : Dimensions.fontSizeDefault,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            days! > 0 || hours! > 0 ?
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                if(days > 0) TimerBox(time: days, text: getTranslated('day', context), isBorder: true),
                if(days > 0) const SizedBox(width: 5),

                if(days > 0) Text(':', style: TextStyle(color: Theme.of(context).primaryColor)),
                if(days > 0) const SizedBox(width: 5),

                TimerBox(time: hours, text: getTranslated('hour', context), isBorder: true),
                const SizedBox(width: 5),

                Text(':', style: TextStyle(color: Theme.of(context).primaryColor)),
                const SizedBox(width: 5),

                TimerBox(time: minutes, text: getTranslated('min', context), isBorder: true),
                const SizedBox(width: 5),

                Text(':', style: TextStyle(color: Theme.of(context).primaryColor)),
                const SizedBox(width: 5),
                TimerBox(time: seconds,text: getTranslated('sec', context), isBorder: true,),

                const SizedBox(width: 5),
              ]),
            ) :

            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                '${minutes! < 5 ? 0 : minutes - 5} - ${minutes < 5 ? 5 : minutes}',
                style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeOverLarge),
              ),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

              Text(getTranslated('min', context)!, style: rubikRegular.copyWith(
                color: Theme.of(context).primaryColor,
                fontSize: Dimensions.fontSizeLarge,
              )),

            ],),


          ],);

        }
    );
  }

  String? _getStatusText(String? status){
    switch(status){
      case OrderStatus.pending:
        return getTranslated('order_placed_your_food_will_arrive_in', context);
      case OrderStatus.confirmed:
        return getTranslated('order_confirmed_delivery_in', context);
      case OrderStatus.cooking:
        return getTranslated('your_food_is_being_prepared_and_will_be_delivered_in', context);
      case OrderStatus.processing:
        return getTranslated('packing_your_order_it_will_be_delivered_in', context);
      case OrderStatus.outForDelivery:
        return getTranslated('your_delivery_is_on_the_way_estimated_arrival_in', context);
      case OrderStatus.delivered:
        return getTranslated('success_your_order_is_delivered', context);
    }
    return null;
  }
}


class TimerBox extends StatelessWidget {
  final int? time;
  final bool isBorder;
  final String? text;

  const TimerBox({super.key,  this.time, this.isBorder = false, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: isBorder ? null : Theme.of(context).primaryColor,
        border: isBorder ? Border.all(width: 1, color: Theme.of(context).primaryColor) : null,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(time! < 10 ? '0$time' : time.toString(),
              style: rubikSemiBold.copyWith(
                color: isBorder ? Theme.of(context).primaryColor : Theme.of(context).highlightColor,
                fontSize: Dimensions.fontSizeLarge,
              ),
            ),
            Text(text!, style: rubikRegular.copyWith(color: isBorder ?
            Theme.of(context).primaryColor : Theme.of(context).highlightColor,
              fontSize: Dimensions.fontSizeSmall,)),
          ],
        ),
      ),
    );
  }
}

