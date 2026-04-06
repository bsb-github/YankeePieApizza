import 'package:flutter_restaurant/common/reposotories/product_repo.dart';
import 'package:flutter_restaurant/features/order/domain/reposotories/order_repo.dart';
import 'package:flutter_restaurant/features/chatbot/domain/models/chatbot_models.dart';
import 'package:flutter_restaurant/features/chatbot/domain/services/chatbot_utils.dart';

class ChatBotOrderHandler {
  final OrderRepo orderRepo;
  final ProductRepo productRepo;

  ChatBotOrderHandler({
    required this.orderRepo,
    required this.productRepo,
  });

  Future<ChatBotActionExecutionResult> trackOrder({required String userMessage, required ActionIntentData intent, String? guestId}) async {
    final int? orderId = intent.safeInt('order_id') ?? _extractOrderId(userMessage);
    if (orderId == null || orderId <= 0) {
      return const ChatBotActionExecutionResult(reply: 'Please provide a valid order ID.');
    }

    final response = await orderRepo.trackOrder('$orderId', guestId: guestId);
    final body = ChatBotUtils.responseBody(response);
    final order = ChatBotUtils.asMap(body);

    if (order == null || order.isEmpty) {
      return ChatBotActionExecutionResult(reply: 'Order #$orderId was not found.');
    }

    final status = ChatBotUtils.stringFrom(order['order_status']) ?? ChatBotUtils.stringFrom(order['orderStatus']) ?? 'unknown';
    return ChatBotActionExecutionResult(
      reply: 'Order #$orderId is currently ${status.replaceAll('_', ' ')}.',
      data: {'order': order, 'status': status},
    );
  }

  Future<ChatBotActionExecutionResult> getOrderHistory({required String userMessage, required ActionIntentData intent}) async {
    final String filter = _orderFilter(userMessage, intent);
    final response = await orderRepo.getOrderList(orderFilter: filter, offset: 1);
    final body = ChatBotUtils.responseBody(response);
    final orders = ChatBotUtils.normalizeOrders(body?['orders'] ?? body?['order_list']);

    if (orders.isEmpty) {
      return const ChatBotActionExecutionResult(reply: 'No orders found.');
    }

    final latest = orders.first;
    return ChatBotActionExecutionResult(
      reply: 'You have ${orders.length} order(s). Most recent is #${latest['id']}.',
      data: {'orders': orders},
    );
  }

  Future<ChatBotActionExecutionResult> cancelOrder({required String userMessage, required ActionIntentData intent, String? guestId}) async {
    final int? orderId = intent.safeInt('order_id') ?? _extractOrderId(userMessage);
    if (orderId == null || orderId <= 0) {
      return const ChatBotActionExecutionResult(reply: 'Please provide a valid order ID to cancel.');
    }

    final response = await orderRepo.cancelOrder('$orderId', guestId);
    final body = ChatBotUtils.responseBody(response);
    final message = ChatBotUtils.stringFrom(body?['message']) ?? 'Could not cancel this order.';
    final success = message.toLowerCase().contains('success') || message.toLowerCase().contains('cancel');

    return ChatBotActionExecutionResult(
      reply: message,
      data: {'success': success, 'order_id': orderId, 'message': message},
    );
  }

  Future<ChatBotActionExecutionResult> reorder({required String userMessage, required ActionIntentData intent}) async {
    final int? orderId = intent.safeInt('order_id') ?? _extractOrderId(userMessage);
    if (orderId == null || orderId <= 0) {
      return const ChatBotActionExecutionResult(reply: 'Please provide a valid order ID to reorder from.');
    }
    
    final response = await productRepo.getReorderProductApi(orderId);
    final body = ChatBotUtils.responseBody(response);
    final products = ChatBotUtils.normalizeProducts(body?['products'] ?? body?['data']);

    if (products.isEmpty) {
      return const ChatBotActionExecutionResult(reply: 'No items found for reorder.');
    }

    return ChatBotActionExecutionResult(
      reply: 'Found ${products.length} item(s) from your previous order.',
      data: {
        'products': products,
        'order_id': orderId,
      },
    );
  }

  String _orderFilter(String userMessage, ActionIntentData intent) {
    final explicit = intent.safeString('filter')?.toLowerCase();
    if (explicit == 'history' || explicit == 'ongoing' || explicit == 'all') {
      return explicit!;
    }

    final text = userMessage.toLowerCase();
    if (text.contains('ongoing') || text.contains('current') || text.contains('active')) {
      return 'ongoing';
    }
    if (text.contains('history') || text.contains('past') || text.contains('previous')) {
      return 'history';
    }
    return 'all';
  }

  int? _extractOrderId(String text) {
    final match = RegExp(r'\b\d{1,10}\b').firstMatch(text);
    if (match == null) return null;
    return int.tryParse(match.group(0)!);
  }
}
