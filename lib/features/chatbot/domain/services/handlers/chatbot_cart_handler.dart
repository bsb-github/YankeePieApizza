import 'package:flutter/foundation.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/common/models/cart_model.dart';
import 'package:flutter_restaurant/common/models/product_model.dart';
import 'package:flutter_restaurant/common/reposotories/product_repo.dart';
import 'package:flutter_restaurant/features/cart/providers/cart_provider.dart';
import 'package:flutter_restaurant/features/chatbot/domain/models/chatbot_models.dart';

class ChatBotCartHandler {
  final ProductRepo productRepo;
  final CartProvider cartProvider;

  ChatBotCartHandler({
    required this.productRepo,
    required this.cartProvider,
  });

  Future<ChatBotActionExecutionResult> addToCart({required ActionIntentData intent}) async {
    final int? productId = intent.safeInt('product_id');
    if (productId == null || productId <= 0) {
      return const ChatBotActionExecutionResult(reply: 'Sorry, I could not identify which item to add. Please try again.');
    }

    final int quantity = (intent.safeInt('quantity') ?? 1).clamp(1, 99);
    final ApiResponseModel response = await productRepo.getProductDetails(productId);

    if (!response.isSuccess) {
      return const ChatBotActionExecutionResult(reply: 'Could not fetch the product details. Please try again.');
    }

    Product? product;
    try {
      final rawData = response.response?.data;
      final map = rawData is Map<String, dynamic> ? rawData : (rawData as Map?)?.map((k, v) => MapEntry(k.toString(), v));
      if (map != null) product = Product.fromJson(map);
    } catch (e) {
      debugPrint('[ChatBotCartHandler] Parse error — $e');
    }

    if (product == null || product.id == null) {
      return const ChatBotActionExecutionResult(reply: 'Could not load the item. Please try again.');
    }

    final double basePrice = product.price ?? 0.0;
    final double discount = product.discount ?? 0.0;
    final String discountType = product.discountType ?? 'percent';
    final double discountAmount = discountType == 'percent' ? (basePrice * discount) / 100 : discount;
    final double discountedPrice = (basePrice - discountAmount).clamp(0, double.infinity);
    
    final double taxRate = product.tax ?? 0.0;
    final String taxType = product.taxType ?? 'percent';
    final double taxAmount = taxType == 'percent' ? (discountedPrice * taxRate) / 100 : taxRate;

    final CartModel cartModel = CartModel(
      basePrice, discountedPrice, <Variation>[], discountAmount, quantity, taxAmount, <AddOn>[], product, <List<bool?>>[],
    );

    try {
      final int existingIndex = cartProvider.isExistInCart(product.id, null);
      cartProvider.addToCart(cartModel, existingIndex == -1 ? null : existingIndex);
      return ChatBotActionExecutionResult(
        reply: '${product.name} has been added to your cart!',
        data: {
          'added': true,
          'product_id': productId,
          'product_name': product.name ?? '',
          'quantity': quantity,
          'price': discountedPrice,
        },
      );
    } catch (e) {
      return ChatBotActionExecutionResult(
        reply: 'Failed to add ${product.name} to cart. Please try again.',
        data: {'added': false, 'product_id': productId},
      );
    }
  }

  Future<ChatBotActionExecutionResult> viewCart() async {
    final int count = cartProvider.cartList.length;
    if (count == 0) {
      return const ChatBotActionExecutionResult(reply: 'Your cart is empty.');
    }
    return ChatBotActionExecutionResult(
      reply: 'You have $count item(s) in your cart.',
      data: {'cart_items_count': count, 'action': 'open_cart'},
    );
  }

  Future<ChatBotActionExecutionResult> updateCartItem({required ActionIntentData intent}) async {
    final int? productId = intent.safeInt('product_id');
    final int? quantity = intent.safeInt('quantity');

    if (productId == null || quantity == null || quantity < 1) {
      return const ChatBotActionExecutionResult(reply: 'Cannot update: invalid product or quantity.');
    }

    try {
      final int index = cartProvider.isExistInCart(productId, null);
      if (index == -1) {
        return const ChatBotActionExecutionResult(reply: 'That item is not in your cart.');
      }
      cartProvider.setQuantity(isIncrement: true, cart: cartProvider.cartList[index], productIndex: index, fromProductView: false);
      return ChatBotActionExecutionResult(reply: 'Successfully updated item quantity to $quantity.');
    } catch (_) {
      return const ChatBotActionExecutionResult(reply: 'Failed to update item quantity.');
    }
  }

  Future<ChatBotActionExecutionResult> removeFromCart({required ActionIntentData intent}) async {
    final int? productId = intent.safeInt('product_id');

    if (productId == null) {
      return const ChatBotActionExecutionResult(reply: 'Please specify which item to remove.');
    }

    try {
      final int index = cartProvider.isExistInCart(productId, null);
      if (index == -1) {
        return const ChatBotActionExecutionResult(reply: 'That item is already not in your cart.');
      }
      cartProvider.removeFromCart(index);
      return const ChatBotActionExecutionResult(reply: 'Item removed from your cart.');
    } catch (_) {
      return const ChatBotActionExecutionResult(reply: 'Failed to remove the item from your cart.');
    }
  }

  Future<ChatBotActionExecutionResult> clearCart() async {
    try {
      cartProvider.clearCartList();
      return const ChatBotActionExecutionResult(reply: 'Your cart has been cleared.');
    } catch (_) {
      return const ChatBotActionExecutionResult(reply: 'Failed to clear your cart.');
    }
  }
}
