enum NotificationType{order, message, general, referral}

NotificationType? getNotificationTypeEnum(String? type){
  switch(type){
    case 'order_status':
      return NotificationType.order;
    case 'message':
      return NotificationType.message;
    case 'general':
      return NotificationType.general;
    case 'referral':
      return NotificationType.referral;
  }
  return null;
}