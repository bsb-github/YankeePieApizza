import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/features/chatbot/domain/models/chatbot_message_model.dart';

class ChatBotRepo {
  final DioClient dioClient;

  static const String _chatUri = '/api/v1/chatbot/chat';

  ChatBotRepo({required this.dioClient});

  Future<ApiResponseModel> sendMessage({
    required String message,
    required List<ChatBotMessage> history,
    String? guestId,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'message': message,
        'conversation_history': history.map((m) => m.toJson()).toList(),
      };
      if (guestId != null) {
        body['guest_id'] = guestId;
      }

      log('╔══ ChatBot REQUEST ══════════════════════════════════════',
          name: 'ChatBotRepo');
      log('║  URL  : ${dioClient.baseUrl}$_chatUri', name: 'ChatBotRepo');
      log('║  BODY : ${const JsonEncoder.withIndent('  ').convert(body)}',
          name: 'ChatBotRepo');
      log('╚════════════════════════════════════════════════════════',
          name: 'ChatBotRepo');

      // The backend makes two sequential OpenAI calls for tool-use messages
      // (initial call + narration follow-up), which can easily exceed the
      // default 30-second DioClient timeout. Use 90 seconds here via the
      // underlying Dio instance so headers/baseUrl are still inherited.
      final response = await dioClient.dio!.post(
        _chatUri,
        data: body,
        options: Options(
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 90),
        ),
      );

      log('╔══ ChatBot RESPONSE ═════════════════════════════════════',
          name: 'ChatBotRepo');
      log('║  STATUS : ${response.statusCode}', name: 'ChatBotRepo');
      log('║  DATA   : ${const JsonEncoder.withIndent('  ').convert(response.data)}',
          name: 'ChatBotRepo');
      log('╚════════════════════════════════════════════════════════',
          name: 'ChatBotRepo');

      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      log('╔══ ChatBot ERROR ════════════════════════════════════════',
          name: 'ChatBotRepo');
      log('║  $e', name: 'ChatBotRepo');
      if (e is DioException && e.response != null) {
        log('║  STATUS : ${e.response!.statusCode}', name: 'ChatBotRepo');
        log('║  BODY   : ${const JsonEncoder.withIndent('  ').convert(e.response!.data)}',
            name: 'ChatBotRepo');
      }
      log('╚════════════════════════════════════════════════════════',
          name: 'ChatBotRepo');
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
