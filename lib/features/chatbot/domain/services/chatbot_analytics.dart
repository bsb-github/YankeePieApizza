import 'package:flutter/foundation.dart';

class ChatBotAnalytics {
  void logActionReceived(String action) {
    debugPrint('[ChatBotAnalytics] Action received: $action');
    // TODO: Wire up to Mixpanel, Firebase, Datadog etc.
  }

  void logActionSuccess(String action, Map<String, dynamic>? data) {
    debugPrint('[ChatBotAnalytics] Action success: $action | Data: $data');
    // TODO: Send success event
  }

  void logActionFailure(String action, String errorDescription) {
    debugPrint('[ChatBotAnalytics] Action failed: $action | Error: $errorDescription');
    // TODO: Send failure event with stacktrace
  }
}
