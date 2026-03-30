import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/features/chatbot/domain/models/chatbot_message_model.dart';
import 'package:flutter_restaurant/features/chatbot/domain/reposotories/chatbot_repo.dart';
import 'package:flutter_restaurant/features/chatbot/domain/services/chatbot_action_executor.dart';

class ChatBotProvider extends ChangeNotifier {
  final ChatBotRepo chatBotRepo;
  final ChatBotActionExecutor actionExecutor;

  static const Set<String> _deduplicatedActions = {'get_categories'};

  ChatBotProvider({
    required this.chatBotRepo,
    required this.actionExecutor,
  });

  final List<ChatBotMessage> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;

  bool _mergeWithLastAssistantIfDuplicate(ChatBotMessage newMessage) {
    final lastIndex = _messages.lastIndexWhere((m) => m.role == 'assistant');
    if (lastIndex == -1) return false;

    final previous = _messages[lastIndex];
    if (_shouldReplaceAssistantMessage(previous, newMessage)) {
      _messages[lastIndex] = newMessage;
      return true;
    }
    return false;
  }

  bool _shouldReplaceAssistantMessage(
      ChatBotMessage previous, ChatBotMessage next) {
    final action = next.action;
    if (action == null || previous.action != action) return false;
    if (!_deduplicatedActions.contains(action)) return false;
    if (previous.data == null || next.data == null) return false;

    return const DeepCollectionEquality().equals(previous.data, next.data);
  }

  List<ChatBotMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Sends [userText] to the API and appends response messages to the list.
  /// [guestId] is passed for unauthenticated users.
  Future<void> sendMessage(String userText, {String? guestId}) async {
    if (userText.trim().isEmpty) return;

    _errorMessage = null;

    // Append user bubble immediately
    final userMsg = ChatBotMessage(role: 'user', content: userText.trim());
    _messages.add(userMsg);
    _isLoading = true;
    notifyListeners();

    // Build history excluding the message we just added
    final history = _messages
        .sublist(0, _messages.length - 1)
        .where((m) => m.role == 'user' || m.role == 'assistant')
        .toList();
    final lastAssistant = history.lastWhereOrNull((m) => m.role == 'assistant');
    final bool awaitingCategorySelection =
        lastAssistant?.action == 'get_categories';

    final apiResponse = await chatBotRepo.sendMessage(
      message: userText.trim(),
      history: history,
      guestId: guestId,
    );

    _isLoading = false;

    if (apiResponse.isSuccess) {
      final data = apiResponse.response?.data as Map<String, dynamic>?;
      final extractedIntent = _extractIntentData(data);
      String reply = data?['reply'] as String? ?? '';
      final String? action = data?['action'] as String?;
      Map<String, dynamic>? actionData = data?['data'] as Map<String, dynamic>?;

      // Intent is detected server-side, but execution is always performed
      // client-side in Dart to avoid backend tool/runtime coupling.
      String? effectiveAction = action;
      ChatBotActionExecutionResult? localResult;
      if (effectiveAction != null && effectiveAction.isNotEmpty) {
        localResult = await actionExecutor.execute(
          action: effectiveAction,
          userMessage: userText.trim(),
          intent: extractedIntent,
          guestId: guestId,
        );
      }

      ChatBotActionExecutionResult? fallbackResult;
      final bool needsFallback = awaitingCategorySelection &&
          (effectiveAction == null ||
              effectiveAction.isEmpty ||
              effectiveAction == 'get_categories');
      if (needsFallback) {
        fallbackResult = await actionExecutor.execute(
          action: 'get_category_products',
          userMessage: userText.trim(),
          intent: extractedIntent,
          guestId: guestId,
        );

        final hasProducts =
            (fallbackResult?.data?['products'] as List?)?.isNotEmpty ?? false;
        if (!hasProducts) {
          fallbackResult = null;
        }
      }

      final ChatBotActionExecutionResult? appliedResult =
          fallbackResult ?? localResult;
      if (fallbackResult != null) {
        effectiveAction = 'get_category_products';
      }

      if (appliedResult != null) {
        if (appliedResult.reply.trim().isNotEmpty) {
          reply = appliedResult.reply;
        }
        actionData = appliedResult.data;
      }

      final assistantMsg = ChatBotMessage(
        role: 'assistant',
        content: reply,
        action: effectiveAction,
        data: actionData,
      );
      if (!_mergeWithLastAssistantIfDuplicate(assistantMsg)) {
        _messages.add(assistantMsg);
      }
    } else {
      _errorMessage = ApiErrorHandler.getMessage(apiResponse.error);
      // Still add an error bubble so the user sees feedback
      _messages.add(ChatBotMessage(
        role: 'assistant',
        content: 'Sorry, something went wrong. Please try again.',
      ));
    }

    notifyListeners();
  }

  Map<String, dynamic>? _extractIntentData(Map<String, dynamic>? payload) {
    if (payload == null) return null;

    final List<dynamic> candidates = [
      payload['intent_data'],
      payload['arguments'],
      payload['entities'],
      payload['data'],
    ];

    for (final candidate in candidates) {
      if (candidate is Map<String, dynamic>) {
        return candidate;
      }
      if (candidate is Map) {
        return candidate.map((key, value) => MapEntry(key.toString(), value));
      }
    }

    return null;
  }

  /// Clear conversation history (e.g. when closing the sheet)
  void clearMessages() {
    _messages.clear();
    _errorMessage = null;
    notifyListeners();
  }
}
