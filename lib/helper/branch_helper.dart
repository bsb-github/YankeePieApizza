import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_alert_dialog_widget.dart';
import 'package:flutter_restaurant/features/branch/providers/branch_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'custom_snackbar_helper.dart';

class BranchHelper{

  static void setBranch(BuildContext context) {

    final branchProvider = Provider.of<BranchProvider>(context, listen: false);
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);

    if(branchProvider.getBranchId() != branchProvider.selectedBranchId) {
      branchProvider.setBranch(branchProvider.selectedBranchId!, splashProvider);

      if(RouterHelper.dashboard == GoRouter.of(Get.context!).routeInformationProvider.value.uri.path){
        RouterHelper.getMainRoute(action: RouteAction.pushReplacement);

      }else{
        RouterHelper.getMainRoute(action: RouteAction.pushNamedAndRemoveUntil);
      }

      showCustomSnackBarHelper(getTranslated('branch_successfully_selected', context), isError: false);
    }else{
      showCustomSnackBarHelper(getTranslated('this_is_your_current_branch', context));
    }

  }



  static void dialogOrBottomSheet (BuildContext context, {required Function() onPressRight, required String title}){
    ResponsiveHelper.showDialogOrBottomSheet(context, CustomAlertDialogWidget(
      rightButtonText: getTranslated('yes', context),
      leftButtonText: getTranslated('no', context),
      icon: Icons.question_mark,
      title: title ,
      onPressRight: onPressRight,
      onPressLeft: ()=> context.pop(),
    ));
  }


}




