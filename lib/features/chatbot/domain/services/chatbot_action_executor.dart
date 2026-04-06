
import 'package:flutter_restaurant/features/cart/providers/cart_provider.dart';
import 'package:flutter_restaurant/features/category/domain/reposotories/category_repo.dart';
import 'package:flutter_restaurant/features/coupon/domain/reposotories/coupon_repo.dart';
import 'package:flutter_restaurant/features/order/domain/reposotories/order_repo.dart';
import 'package:flutter_restaurant/features/search/domain/reposotories/search_repo.dart';
import 'package:flutter_restaurant/common/reposotories/product_repo.dart';

import 'package:flutter_restaurant/features/chatbot/domain/models/chatbot_models.dart';
import 'package:flutter_restaurant/features/chatbot/domain/services/chatbot_analytics.dart';
import 'package:flutter_restaurant/features/chatbot/domain/services/handlers/chatbot_menu_handler.dart';
import 'package:flutter_restaurant/features/chatbot/domain/services/handlers/chatbot_cart_handler.dart';
import 'package:flutter_restaurant/features/chatbot/domain/services/handlers/chatbot_order_handler.dart';
import 'package:flutter_restaurant/features/chatbot/domain/services/handlers/chatbot_checkout_handler.dart';
import 'package:flutter_restaurant/features/chatbot/domain/services/handlers/chatbot_misc_handlers.dart';

export 'package:flutter_restaurant/features/chatbot/domain/models/chatbot_models.dart' show ChatBotActionExecutionResult;

class ChatBotActionExecutor {
  final CategoryRepo categoryRepo;
  final ProductRepo productRepo;
  final SearchRepo searchRepo;
  final CouponRepo couponRepo;
  final OrderRepo orderRepo;
  final CartProvider cartProvider;

  ChatBotActionExecutor({
    required this.categoryRepo,
    required this.productRepo,
    required this.searchRepo,
    required this.couponRepo,
    required this.orderRepo,
    required this.cartProvider,
  });

  Future<ChatBotActionExecutionResult?> execute({
    required String action,
    required String userMessage,
    Map<String, dynamic>? intent,
    String? guestId,
  }) async {
    final analytics = ChatBotAnalytics();
    analytics.logActionReceived(action);

    final intentData = ActionIntentData(intent);

    final menuHandler = ChatBotMenuHandler(
        categoryRepo: categoryRepo, productRepo: productRepo, searchRepo: searchRepo);
    final cartHandler = ChatBotCartHandler(
        productRepo: productRepo, cartProvider: cartProvider);
    final orderHandler = ChatBotOrderHandler(
        orderRepo: orderRepo, productRepo: productRepo);
    final checkoutHandler = ChatBotCheckoutHandler(couponRepo: couponRepo);
    final miscHandlers = ChatBotMiscHandlers();

    ChatBotActionExecutionResult? result;

    try {
      switch (action) {
        // Menu and discovery
        case 'get_categories':
          result = await menuHandler.getCategories();
          break;
        case 'get_category_products':
          result = await menuHandler.getCategoryProducts(userMessage: userMessage, intent: intentData);
          break;
        case 'search_products':
          result = await menuHandler.searchProducts(userMessage: userMessage, intent: intentData);
          break;
        case 'get_popular_products':
          result = await menuHandler.getPopularProducts(intent: intentData);
          break;
        case 'get_recommended_products':
          result = await menuHandler.getRecommendedProducts(intent: intentData);
          break;
        case 'get_item_details':
          result = await menuHandler.getItemDetails(userMessage: userMessage, intent: intentData);
          break;
        case 'initiate_order':
          result = await menuHandler.initiateOrder(userMessage: userMessage, intent: intentData);
          break;

        // Cart
        case 'add_to_cart':
          result = await cartHandler.addToCart(intent: intentData);
          break;
        case 'view_cart':
          result = await cartHandler.viewCart();
          break;
        case 'update_cart_item':
          result = await cartHandler.updateCartItem(intent: intentData);
          break;
        case 'remove_from_cart':
          result = await cartHandler.removeFromCart(intent: intentData);
          break;
        case 'clear_cart':
          result = await cartHandler.clearCart();
          break;

        // Coupons and checkout
        case 'get_available_coupons':
          result = await checkoutHandler.getAvailableCoupons(guestId: guestId);
          break;
        case 'check_coupon':
          result = await checkoutHandler.checkCoupon(userMessage: userMessage, intent: intentData, guestId: guestId);
          break;
        case 'apply_coupon':
          result = await checkoutHandler.applyCoupon(intent: intentData);
          break;
        case 'remove_coupon':
          result = await checkoutHandler.removeCoupon();
          break;
        case 'get_checkout_summary':
          result = await checkoutHandler.getCheckoutSummary();
          break;
        case 'place_order':
          result = await checkoutHandler.placeOrder(intent: intentData);
          break;

        // Delivery
        case 'set_delivery_type':
          result = await miscHandlers.setDeliveryType(intent: intentData);
          break;
        case 'get_delivery_time_slots':
          result = await miscHandlers.getDeliveryTimeSlots();
          break;
        case 'set_delivery_time':
          result = await miscHandlers.setDeliveryTime(intent: intentData);
          break;
        case 'get_saved_addresses':
          result = await miscHandlers.getSavedAddresses();
          break;
        case 'set_delivery_address':
          result = await miscHandlers.setDeliveryAddress(intent: intentData);
          break;

        // Payment
        case 'get_payment_methods':
          result = await miscHandlers.getPaymentMethods();
          break;
        case 'select_payment_method':
          result = await miscHandlers.selectPaymentMethod(intent: intentData);
          break;

        // Orders
        case 'track_order':
          result = await orderHandler.trackOrder(userMessage: userMessage, intent: intentData, guestId: guestId);
          break;
        case 'get_order_history':
          result = await orderHandler.getOrderHistory(userMessage: userMessage, intent: intentData);
          break;
        case 'cancel_order':
          result = await orderHandler.cancelOrder(userMessage: userMessage, intent: intentData, guestId: guestId);
          break;
        case 'reorder':
          result = await orderHandler.reorder(userMessage: userMessage, intent: intentData);
          break;

        // Favorites
        case 'get_favorites':
          result = await miscHandlers.getFavorites();
          break;
        case 'add_to_favorites':
          result = await miscHandlers.addToFavorites(intent: intentData);
          break;
        case 'remove_from_favorites':
          result = await miscHandlers.removeFromFavorites(intent: intentData);
          break;

        // Restaurant & Support
        case 'get_restaurant_info':
          result = await miscHandlers.getRestaurantInfo();
          break;
        case 'get_operating_hours':
          result = await miscHandlers.getOperatingHours();
          break;
        case 'get_support_options':
          result = await miscHandlers.getSupportOptions();
          break;

        default:
          analytics.logActionFailure(action, 'Unknown action requested');
          return null; // Graceful degradation for unknown action
      }

      analytics.logActionSuccess(action, result.data);
      return result;

    } catch (e) {
      analytics.logActionFailure(action, e.toString());
      return const ChatBotActionExecutionResult(reply: 'Something went wrong processing your request. Please try again later.');
    }
  }
}
