import 'package:flutter_restaurant/features/coupon/domain/reposotories/coupon_repo.dart';
import 'package:flutter_restaurant/features/chatbot/domain/models/chatbot_models.dart';
import 'package:flutter_restaurant/features/chatbot/domain/services/chatbot_utils.dart';

class ChatBotCheckoutHandler {
  final CouponRepo couponRepo;

  ChatBotCheckoutHandler({
    required this.couponRepo,
  });

  Future<ChatBotActionExecutionResult> getAvailableCoupons({String? guestId}) async {
    final response = await couponRepo.getCouponList(guestId: guestId);
    final body = ChatBotUtils.responseBody(response);
    final coupons = ChatBotUtils.normalizeCoupons(body?['available']);

    if (coupons.isEmpty) {
      return const ChatBotActionExecutionResult(reply: 'No active coupons are available right now.');
    }

    return ChatBotActionExecutionResult(
      reply: '${coupons.length} coupon(s) available.',
      data: {'coupons': coupons},
    );
  }

  Future<ChatBotActionExecutionResult> checkCoupon({required String userMessage, required ActionIntentData intent, String? guestId}) async {
    final String? code = intent.safeString('code') ?? _extractCouponCode(userMessage);

    if (code == null || code.isEmpty) {
      return const ChatBotActionExecutionResult(reply: 'Please provide a coupon code.');
    }

    final response = await couponRepo.applyCoupon(code, guestId: guestId);
    final body = ChatBotUtils.responseBody(response);

    if (body == null) {
      return ChatBotActionExecutionResult(
        reply: 'Coupon $code is not valid.',
        data: {'coupon': {'valid': false, 'code': code, 'message': 'This coupon is invalid or expired.'}},
      );
    }

    final coupon = _normalizeCoupon(body);
    if (coupon == null) {
      return ChatBotActionExecutionResult(
        reply: 'Coupon $code is not valid.',
        data: {'coupon': {'valid': false, 'code': code, 'message': 'This coupon is invalid or expired.'}},
      );
    }

    return ChatBotActionExecutionResult(
      reply: 'Coupon ${coupon['code']} is valid.',
      data: {'coupon': coupon},
    );
  }

  Future<ChatBotActionExecutionResult> applyCoupon({required ActionIntentData intent}) async {
    final String? code = intent.safeString('code');
    if (code == null || code.isEmpty) {
      return const ChatBotActionExecutionResult(reply: 'Please provide a coupon code to apply.');
    }
    // Stub: Normally we'd apply this to the CartProvider or CheckoutProvider state
    return ChatBotActionExecutionResult(reply: 'Coupon applied successfully.', data: {'applied_coupon': code});
  }

  Future<ChatBotActionExecutionResult> removeCoupon() async {
    // Stub
    return const ChatBotActionExecutionResult(reply: 'Coupon removed from your cart.');
  }

  Future<ChatBotActionExecutionResult> getCheckoutSummary() async {
    // Stub
    return const ChatBotActionExecutionResult(reply: 'Here is your checkout summary. Please proceed to payment to finalize your order.');
  }

  Future<ChatBotActionExecutionResult> placeOrder({required ActionIntentData intent}) async {
    // Stub
    final note = intent.safeString('note');
    return ChatBotActionExecutionResult(reply: 'Order placed successfully!', data: {'note_attached': note});
  }

  Map<String, dynamic>? _normalizeCoupon(dynamic source) {
    final map = ChatBotUtils.asMap(source);
    if (map == null || map.isEmpty) return null;
    final code = ChatBotUtils.stringFrom(map['code']);
    if (code == null || code.isEmpty) return null;

    return {
      'valid': true,
      'code': code,
      'title': ChatBotUtils.stringFrom(map['title']) ?? '',
      'discount': map['discount'] ?? 0,
      'discount_type': ChatBotUtils.stringFrom(map['discount_type']) ?? 'percent',
      'min_purchase': map['min_purchase'] ?? 0,
      'max_discount': map['max_discount'] ?? 0,
      'expire_date': ChatBotUtils.stringFrom(map['expire_date']) ?? '',
      'message': 'Valid coupon',
    };
  }

  String? _extractCouponCode(String text) {
    final match = RegExp(r'\b[A-Za-z0-9_-]{4,20}\b').allMatches(text).toList();
    if (match.isEmpty) return null;
    return match.last.group(0)?.toUpperCase();
  }
}
