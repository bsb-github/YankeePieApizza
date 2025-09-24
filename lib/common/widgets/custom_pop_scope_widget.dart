import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/common/widgets/custom_alert_dialog_widget.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/images.dart';


class CustomPopScopeWidget extends StatefulWidget {
  final Widget child;
  final Function()? onPopInvoked;
  final bool isExit;

  const CustomPopScopeWidget({super.key, required this.child, this.onPopInvoked, this.isExit = true});

  @override
  State<CustomPopScopeWidget> createState() => _CustomPopScopeWidgetState();
}

class _CustomPopScopeWidgetState extends State<CustomPopScopeWidget> {

  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: ResponsiveHelper.isDesktop(context),
      onPopInvokedWithResult: (didPop, result) {

        if (widget.onPopInvoked != null) {
          widget.onPopInvoked!();
        }

        if(didPop) {
          return;
        }

        if(!Navigator.canPop(context) && widget.isExit) {
          ResponsiveHelper.showDialogOrBottomSheet(
              context, CustomAlertDialogWidget(
            title: getTranslated('close_the_app', context),
            subTitle: getTranslated('do_you_want_to_close_and', context),
            rightButtonText: getTranslated('exit', context),
            image: Images.logOut,
            onPressRight: () {
              SystemNavigator.pop();
            },
          ));
        }else {
          if(Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        }



      },
      child: widget.child,
    );
  }
}
