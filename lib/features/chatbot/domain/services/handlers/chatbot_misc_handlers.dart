import 'package:flutter_restaurant/features/chatbot/domain/models/chatbot_models.dart';

class ChatBotMiscHandlers {
  // --- Delivery & Address ---
  Future<ChatBotActionExecutionResult> setDeliveryType({required ActionIntentData intent}) async {
    final String? type = intent.safeString('type');
    if (type == null || (type != 'delivery' && type != 'takeaway')) {
      return const ChatBotActionExecutionResult(reply: 'Please specify delivery or takeaway.');
    }
    return ChatBotActionExecutionResult(reply: 'Delivery type set to $type.', data: {'delivery_type': type});
  }

  Future<ChatBotActionExecutionResult> getDeliveryTimeSlots() async {
    return const ChatBotActionExecutionResult(reply: 'Here are the available delivery times.');
  }

  Future<ChatBotActionExecutionResult> setDeliveryTime({required ActionIntentData intent}) async {
    final String? slot = intent.safeString('slot');
    if (slot == null) return const ChatBotActionExecutionResult(reply: 'Please provide a valid time slot.');
    return ChatBotActionExecutionResult(reply: 'Delivery time set.', data: {'slot': slot});
  }

  Future<ChatBotActionExecutionResult> getSavedAddresses() async {
    return const ChatBotActionExecutionResult(reply: 'Here are your saved addresses.');
  }

  Future<ChatBotActionExecutionResult> setDeliveryAddress({required ActionIntentData intent}) async {
    final int? addressId = intent.safeInt('address_id');
    if (addressId == null) return const ChatBotActionExecutionResult(reply: 'Please specify an address.');
    return ChatBotActionExecutionResult(reply: 'Delivery address updated.', data: {'address_id': addressId});
  }

  // --- Payment ---
  Future<ChatBotActionExecutionResult> getPaymentMethods() async {
    return const ChatBotActionExecutionResult(reply: 'Here are the available payment methods.');
  }

  Future<ChatBotActionExecutionResult> selectPaymentMethod({required ActionIntentData intent}) async {
    final String? method = intent.safeString('method');
    if (method == null) return const ChatBotActionExecutionResult(reply: 'Please provide a payment method.');
    return ChatBotActionExecutionResult(reply: 'Payment method selected.', data: {'method': method});
  }

  // --- Favorites ---
  Future<ChatBotActionExecutionResult> getFavorites() async {
    return const ChatBotActionExecutionResult(reply: 'Here are your favorite items.');
  }

  Future<ChatBotActionExecutionResult> addToFavorites({required ActionIntentData intent}) async {
    final int? productId = intent.safeInt('product_id');
    if (productId == null) return const ChatBotActionExecutionResult(reply: 'Could not identify the item to favorite.');
    return ChatBotActionExecutionResult(reply: 'Item added to favorites.', data: {'product_id': productId});
  }

  Future<ChatBotActionExecutionResult> removeFromFavorites({required ActionIntentData intent}) async {
    final int? productId = intent.safeInt('product_id');
    if (productId == null) return const ChatBotActionExecutionResult(reply: 'Could not identify the item to remove.');
    return ChatBotActionExecutionResult(reply: 'Item removed from favorites.', data: {'product_id': productId});
  }

  // --- Restaurant & Support ---
  Future<ChatBotActionExecutionResult> getRestaurantInfo() async {
    return const ChatBotActionExecutionResult(reply: 'Here is info about our restaurant.');
  }

  Future<ChatBotActionExecutionResult> getOperatingHours() async {
    return const ChatBotActionExecutionResult(reply: 'We are open from 10 AM to 10 PM daily.');
  }

  Future<ChatBotActionExecutionResult> getSupportOptions() async {
    return const ChatBotActionExecutionResult(reply: 'You can reach out to support via chat or phone.');
  }
}
