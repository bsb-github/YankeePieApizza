import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/features/notification/domain/models/notification_model.dart';
import 'package:flutter_restaurant/features/notification/domain/reposotories/notification_repo.dart';
import 'package:flutter_restaurant/helper/api_checker_helper.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepo? notificationRepo;
  NotificationProvider({required this.notificationRepo});

  List<NotificationModel>? _notificationList;
  List<NotificationModel>? get notificationList => _notificationList != null ? _notificationList?.reversed.toList() : _notificationList;

  Future<void> getNotificationList(BuildContext context) async {
    ApiResponseModel apiResponse = await notificationRepo!.getNotificationList();

    if (apiResponse.response?.statusCode == 200) {
      _notificationList = [];
      apiResponse.response!.data.forEach((notificationModel) => _notificationList!.add(NotificationModel.fromJson(notificationModel)));
      notifyListeners();
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
  }
}
