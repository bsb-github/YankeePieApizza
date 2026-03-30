import 'package:flutter_restaurant/common/enums/data_source_enum.dart';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/common/reposotories/product_repo.dart';
import 'package:flutter_restaurant/features/category/domain/reposotories/category_repo.dart';
import 'package:flutter_restaurant/features/coupon/domain/reposotories/coupon_repo.dart';
import 'package:flutter_restaurant/features/order/domain/reposotories/order_repo.dart';
import 'package:flutter_restaurant/features/search/domain/reposotories/search_repo.dart';

class ChatBotActionExecutionResult {
  final String reply;
  final Map<String, dynamic>? data;

  const ChatBotActionExecutionResult({
    required this.reply,
    this.data,
  });
}

class ChatBotActionExecutor {
  final CategoryRepo categoryRepo;
  final ProductRepo productRepo;
  final SearchRepo searchRepo;
  final CouponRepo couponRepo;
  final OrderRepo orderRepo;

  ChatBotActionExecutor({
    required this.categoryRepo,
    required this.productRepo,
    required this.searchRepo,
    required this.couponRepo,
    required this.orderRepo,
  });

  Future<ChatBotActionExecutionResult?> execute({
    required String action,
    required String userMessage,
    Map<String, dynamic>? intent,
    String? guestId,
  }) async {
    switch (action) {
      case 'get_categories':
        return _getCategories();
      case 'get_category_products':
        return _getCategoryProducts(userMessage: userMessage, intent: intent);
      case 'search_products':
        return _searchProducts(userMessage: userMessage, intent: intent);
      case 'get_popular_products':
        return _getPopularProducts(intent: intent);
      case 'get_recommended_products':
        return _getRecommendedProducts(intent: intent);
      case 'get_item_details':
        return _getItemDetails(userMessage: userMessage, intent: intent);
      case 'get_available_coupons':
        return _getAvailableCoupons(guestId: guestId);
      case 'check_coupon':
        return _checkCoupon(
          userMessage: userMessage,
          intent: intent,
          guestId: guestId,
        );
      case 'track_order':
        return _trackOrder(
            userMessage: userMessage, intent: intent, guestId: guestId);
      case 'get_order_history':
        return _getOrderHistory(userMessage: userMessage, intent: intent);
      case 'cancel_order':
        return _cancelOrder(
            userMessage: userMessage, intent: intent, guestId: guestId);
      case 'reorder':
        return _reorder(userMessage: userMessage, intent: intent);
      case 'initiate_order':
        return _initiateOrder(userMessage: userMessage, intent: intent);
      default:
        return null;
    }
  }

  Future<ChatBotActionExecutionResult> _getCategories() async {
    final response = await categoryRepo.getCategoryList(
      source: DataSourceEnum.client,
      limit: 20,
      offset: 1,
    );
    final body = _responseBody(response);
    final categories = _normalizeCategories(body?['categories']);

    if (categories.isEmpty) {
      return const ChatBotActionExecutionResult(
          reply: 'No menu categories found right now.');
    }

    return ChatBotActionExecutionResult(
      reply:
          'Here are our menu categories. Pick one and I will show the items.',
      data: {'categories': categories},
    );
  }

  Future<ChatBotActionExecutionResult> _getCategoryProducts({
    required String userMessage,
    Map<String, dynamic>? intent,
  }) async {
    final int limit = _intFrom(intent?['limit']) ?? 6;
    final int? directId = _intFrom(intent?['category_id']);
    final String? directName = _stringFrom(intent?['category_name']);

    int? categoryId = directId;
    String categoryName = directName ?? 'this category';

    if (categoryId == null || categoryId <= 0) {
      final resolved = await _resolveCategoryFromText(userMessage);
      categoryId = resolved?.$1;
      categoryName = resolved?.$2 ?? categoryName;
    }

    if (categoryId == null || categoryId <= 0) {
      return const ChatBotActionExecutionResult(
        reply:
            'Please tell me which category you want, for example Pizza or Burgers.',
      );
    }

    final response = await categoryRepo.getCategoryProductList(
      categoryID: categoryId.toString(),
      offset: 1,
      limit: limit,
      type: 'all',
    );

    final body = _responseBody(response);
    final products = _normalizeProducts(body?['products'], limit: limit);

    if (products.isEmpty) {
      return ChatBotActionExecutionResult(
          reply: 'No items found in $categoryName.');
    }

    return ChatBotActionExecutionResult(
      reply: 'Found ${products.length} item(s) in $categoryName.',
      data: {
        'products': products,
        'category_name': categoryName,
      },
    );
  }

  Future<ChatBotActionExecutionResult> _searchProducts({
    required String userMessage,
    Map<String, dynamic>? intent,
  }) async {
    final int limit = _intFrom(intent?['limit']) ?? 5;
    final String query = (_stringFrom(intent?['name']) ??
            _stringFrom(intent?['product_name']) ??
            userMessage)
        .trim();

    if (query.isEmpty) {
      return const ChatBotActionExecutionResult(
          reply: 'Tell me what item you want to search for.');
    }

    final response = await searchRepo.getSearchProductList(
      name: query,
      offset: 1,
      productType: 'all',
    );

    final body = _responseBody(response);
    final products = _normalizeProducts(body?['products'], limit: limit);

    if (products.isEmpty) {
      return ChatBotActionExecutionResult(
          reply: "No menu items found matching '$query'.");
    }

    return ChatBotActionExecutionResult(
      reply:
          'Found ${products.length} item(s): ${products.take(3).map((e) => e['name']).join(', ')}.',
      data: {'products': products},
    );
  }

  Future<ChatBotActionExecutionResult> _getPopularProducts(
      {Map<String, dynamic>? intent}) async {
    final int limit = _intFrom(intent?['limit']) ?? 5;
    final response = await productRepo.getPopularProductList(
      offset: 1,
      source: DataSourceEnum.client,
    );

    final body = _responseBody(response);
    final products = _normalizeProducts(body?['products'], limit: limit);

    if (products.isEmpty) {
      return const ChatBotActionExecutionResult(
          reply: 'No popular items are available right now.');
    }

    return ChatBotActionExecutionResult(
      reply:
          'Popular items: ${products.take(3).map((e) => e['name']).join(', ')}.',
      data: {'products': products},
    );
  }

  Future<ChatBotActionExecutionResult> _getRecommendedProducts(
      {Map<String, dynamic>? intent}) async {
    final int limit = _intFrom(intent?['limit']) ?? 5;
    final response = await productRepo.getRecommendedProductApi(
      offset: 1,
      source: DataSourceEnum.client,
    );

    final body = _responseBody(response);
    final products = _normalizeProducts(body?['products'], limit: limit);

    if (products.isEmpty) {
      return const ChatBotActionExecutionResult(
          reply: 'No recommendations available right now.');
    }

    return ChatBotActionExecutionResult(
      reply:
          "Chef's picks: ${products.take(3).map((e) => e['name']).join(', ')}.",
      data: {'products': products},
    );
  }

  Future<ChatBotActionExecutionResult> _getItemDetails({
    required String userMessage,
    Map<String, dynamic>? intent,
  }) async {
    final String query = (_stringFrom(intent?['item_name']) ??
            _stringFrom(intent?['name']) ??
            userMessage)
        .trim();

    if (query.isEmpty) {
      return const ChatBotActionExecutionResult(
          reply: 'Please tell me the item name.');
    }

    final response = await searchRepo.getSearchProductList(
      name: query,
      offset: 1,
      productType: 'all',
    );
    final body = _responseBody(response);
    final products = _normalizeProducts(body?['products'], limit: 1);

    if (products.isEmpty) {
      return ChatBotActionExecutionResult(
          reply: "Could not find '$query' in our menu.");
    }

    final product = products.first;
    return ChatBotActionExecutionResult(
      reply: 'Here are details for ${product['name']}.',
      data: {'product': product},
    );
  }

  Future<ChatBotActionExecutionResult> _getAvailableCoupons(
      {String? guestId}) async {
    final response = await couponRepo.getCouponList(guestId: guestId);
    final body = _responseBody(response);
    final coupons = _normalizeCoupons(body?['available']);

    if (coupons.isEmpty) {
      return const ChatBotActionExecutionResult(
          reply: 'No active coupons are available right now.');
    }

    return ChatBotActionExecutionResult(
      reply: '${coupons.length} coupon(s) available.',
      data: {'coupons': coupons},
    );
  }

  Future<ChatBotActionExecutionResult> _checkCoupon({
    required String userMessage,
    Map<String, dynamic>? intent,
    String? guestId,
  }) async {
    final String? code =
        _stringFrom(intent?['code']) ?? _extractCouponCode(userMessage);

    if (code == null || code.isEmpty) {
      return const ChatBotActionExecutionResult(
          reply: 'Please provide a coupon code.');
    }

    final response = await couponRepo.applyCoupon(code, guestId: guestId);
    final body = _responseBody(response);

    if (body == null) {
      return ChatBotActionExecutionResult(
        reply: 'Coupon $code is not valid.',
        data: {
          'coupon': {
            'valid': false,
            'code': code,
            'message': 'This coupon is invalid or expired.',
          }
        },
      );
    }

    final coupon = _normalizeCoupon(body);
    if (coupon == null) {
      return ChatBotActionExecutionResult(
        reply: 'Coupon $code is not valid.',
        data: {
          'coupon': {
            'valid': false,
            'code': code,
            'message': 'This coupon is invalid or expired.',
          }
        },
      );
    }

    return ChatBotActionExecutionResult(
      reply: 'Coupon ${coupon['code']} is valid.',
      data: {'coupon': coupon},
    );
  }

  Future<ChatBotActionExecutionResult> _trackOrder({
    required String userMessage,
    Map<String, dynamic>? intent,
    String? guestId,
  }) async {
    final int? orderId =
        _intFrom(intent?['order_id']) ?? _extractOrderId(userMessage);
    if (orderId == null || orderId <= 0) {
      return const ChatBotActionExecutionResult(
          reply: 'Please provide a valid order ID.');
    }

    final response = await orderRepo.trackOrder('$orderId', guestId: guestId);
    final body = _responseBody(response);
    final order = _asMap(body);

    if (order == null || order.isEmpty) {
      return ChatBotActionExecutionResult(
          reply: 'Order #$orderId was not found.');
    }

    final status = _stringFrom(order['order_status']) ??
        _stringFrom(order['orderStatus']) ??
        'unknown';
    return ChatBotActionExecutionResult(
      reply: 'Order #$orderId is currently ${status.replaceAll('_', ' ')}.',
      data: {
        'order': order,
        'status': status,
      },
    );
  }

  Future<ChatBotActionExecutionResult> _getOrderHistory({
    required String userMessage,
    Map<String, dynamic>? intent,
  }) async {
    final String filter = _orderFilter(userMessage, intent);
    final response =
        await orderRepo.getOrderList(orderFilter: filter, offset: 1);
    final body = _responseBody(response);
    final orders = _normalizeOrders(body?['orders'] ?? body?['order_list']);

    if (orders.isEmpty) {
      return const ChatBotActionExecutionResult(reply: 'No orders found.');
    }

    final latest = orders.first;
    return ChatBotActionExecutionResult(
      reply:
          'You have ${orders.length} order(s). Most recent is #${latest['id']}.',
      data: {'orders': orders},
    );
  }

  Future<ChatBotActionExecutionResult> _cancelOrder({
    required String userMessage,
    Map<String, dynamic>? intent,
    String? guestId,
  }) async {
    final int? orderId =
        _intFrom(intent?['order_id']) ?? _extractOrderId(userMessage);
    if (orderId == null || orderId <= 0) {
      return const ChatBotActionExecutionResult(
          reply: 'Please provide a valid order ID to cancel.');
    }

    final response = await orderRepo.cancelOrder('$orderId', guestId);
    final body = _responseBody(response);
    final message =
        _stringFrom(body?['message']) ?? 'Could not cancel this order.';
    final success = message.toLowerCase().contains('success') ||
        message.toLowerCase().contains('cancel');

    return ChatBotActionExecutionResult(
      reply: message,
      data: {
        'success': success,
        'order_id': orderId,
        'message': message,
      },
    );
  }

  Future<ChatBotActionExecutionResult> _reorder({
    required String userMessage,
    Map<String, dynamic>? intent,
  }) async {
    final int? orderId =
        _intFrom(intent?['order_id']) ?? _extractOrderId(userMessage);
    final response = await productRepo.getReorderProductApi(orderId);
    final body = _responseBody(response);
    final products = _normalizeProducts(body?['products'] ?? body?['data']);

    if (products.isEmpty) {
      return const ChatBotActionExecutionResult(
          reply: 'No items found for reorder.');
    }

    return ChatBotActionExecutionResult(
      reply: 'Found ${products.length} item(s) from your previous order.',
      data: {
        'products': products,
        if (orderId != null) 'order_id': orderId,
      },
    );
  }

  Future<ChatBotActionExecutionResult> _initiateOrder({
    required String userMessage,
    Map<String, dynamic>? intent,
  }) async {
    final String query = (_stringFrom(intent?['product_name']) ??
            _stringFrom(intent?['name']) ??
            userMessage)
        .trim();
    final int quantity = _intFrom(intent?['quantity']) ?? 1;

    if (query.isEmpty) {
      return const ChatBotActionExecutionResult(
          reply: 'Please tell me what you want to order.');
    }

    final response = await searchRepo.getSearchProductList(
      name: query,
      offset: 1,
      productType: 'all',
    );

    final body = _responseBody(response);
    final products = _normalizeProducts(body?['products'], limit: 1);

    if (products.isEmpty) {
      return ChatBotActionExecutionResult(
          reply: "Could not find '$query' in our menu.");
    }

    final product = products.first;
    return ChatBotActionExecutionResult(
      reply: 'Found ${product['name']}. Ready to add to cart.',
      data: {
        'order_initiation': {
          'id': product['id'],
          'name': product['name'],
          'price': product['price'],
          'image': product['image'],
          'quantity': quantity,
          'action': 'open_product_page',
        }
      },
    );
  }

  Future<(int, String)?> _resolveCategoryFromText(String userMessage) async {
    final response = await categoryRepo.getCategoryList(
      source: DataSourceEnum.client,
      limit: 50,
      offset: 1,
    );

    final body = _responseBody(response);
    final categories = _normalizeCategories(body?['categories']);
    if (categories.isEmpty) return null;

    final message = userMessage.toLowerCase();
    for (final category in categories) {
      final name = (_stringFrom(category['name']) ?? '').toLowerCase();
      if (name.isNotEmpty && message.contains(name)) {
        final id = _intFrom(category['id']);
        if (id != null) {
          return (id, _stringFrom(category['name']) ?? 'this category');
        }
      }
    }

    return null;
  }

  String _orderFilter(String userMessage, Map<String, dynamic>? intent) {
    final explicit = _stringFrom(intent?['filter'])?.toLowerCase();
    if (explicit == 'history' || explicit == 'ongoing' || explicit == 'all') {
      return explicit!;
    }

    final text = userMessage.toLowerCase();
    if (text.contains('ongoing') ||
        text.contains('current') ||
        text.contains('active')) {
      return 'ongoing';
    }
    if (text.contains('history') ||
        text.contains('past') ||
        text.contains('previous')) {
      return 'history';
    }
    return 'all';
  }

  String? _extractCouponCode(String text) {
    final match = RegExp(r'\b[A-Za-z0-9_-]{4,20}\b').allMatches(text).toList();
    if (match.isEmpty) return null;
    final token = match.last.group(0);
    return token?.toUpperCase();
  }

  int? _extractOrderId(String text) {
    final match = RegExp(r'\b\d{1,10}\b').firstMatch(text);
    if (match == null) return null;
    return int.tryParse(match.group(0)!);
  }

  Map<String, dynamic>? _responseBody(ApiResponseModel response) {
    if (!response.isSuccess) return null;
    final dynamic rawResponse = response.response;
    if (rawResponse == null) return null;

    final int? status = rawResponse.statusCode as int?;
    if (status != null && (status < 200 || status >= 300)) {
      return null;
    }

    return _asMap(rawResponse.data);
  }

  Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), val));
    }
    return null;
  }

  List<Map<String, dynamic>> _normalizeCategories(dynamic source) {
    if (source is! List) return [];
    return source
        .map((e) {
          final map = _asMap(e) ?? <String, dynamic>{};
          return {
            'id': map['id'],
            'name': _stringFrom(map['name']) ?? '',
            'image': _extractImage(map),
          };
        })
        .where((e) => (e['name'] as String).isNotEmpty)
        .toList();
  }

  List<Map<String, dynamic>> _normalizeOrders(dynamic source) {
    if (source is! List) return [];
    return source
        .map((e) {
          final map = _asMap(e) ?? <String, dynamic>{};
          return {
            'id': map['id'],
            'order_status': _stringFrom(map['order_status']) ??
                _stringFrom(map['orderStatus']) ??
                '',
            'order_amount': map['order_amount'] ?? map['orderAmount'] ?? 0,
            'created_at': _stringFrom(map['created_at']) ??
                _stringFrom(map['createdAt']) ??
                '',
          };
        })
        .where((e) => e['id'] != null)
        .toList();
  }

  List<Map<String, dynamic>> _normalizeProducts(dynamic source,
      {int limit = 10}) {
    if (source is! List) return [];

    final List<Map<String, dynamic>> products = source
        .map((e) {
          final map = _asMap(e) ?? <String, dynamic>{};
          return {
            'id': map['id'],
            'name': _stringFrom(map['name']) ?? '',
            'price': map['price'] ?? map['price_with_tax'] ?? 0,
            'description': _stringFrom(map['description']) ?? '',
            'image': _extractImage(map),
            'rating':
                map['avg_rating'] ?? map['rating'] ?? map['average_review'],
          };
        })
        .where((e) => (e['name'] as String).isNotEmpty)
        .toList();

    if (products.length <= limit) return products;
    return products.sublist(0, limit);
  }

  List<Map<String, dynamic>> _normalizeCoupons(dynamic source) {
    if (source is! List) return [];
    return source
        .map((e) {
          final map = _asMap(e) ?? <String, dynamic>{};
          return {
            'id': map['id'],
            'title': _stringFrom(map['title']) ?? '',
            'code': _stringFrom(map['code']) ?? '',
            'discount': map['discount'] ?? 0,
            'discount_type': _stringFrom(map['discount_type']) ?? 'percent',
            'min_purchase': map['min_purchase'] ?? 0,
            'max_discount': map['max_discount'] ?? 0,
            'expire_date': _stringFrom(map['expire_date']) ?? '',
          };
        })
        .where((e) => (e['code'] as String).isNotEmpty)
        .toList();
  }

  Map<String, dynamic>? _normalizeCoupon(dynamic source) {
    final map = _asMap(source);
    if (map == null || map.isEmpty) return null;
    final code = _stringFrom(map['code']);
    if (code == null || code.isEmpty) return null;

    return {
      'valid': true,
      'code': code,
      'title': _stringFrom(map['title']) ?? '',
      'discount': map['discount'] ?? 0,
      'discount_type': _stringFrom(map['discount_type']) ?? 'percent',
      'min_purchase': map['min_purchase'] ?? 0,
      'max_discount': map['max_discount'] ?? 0,
      'expire_date': _stringFrom(map['expire_date']) ?? '',
      'message': 'Valid coupon',
    };
  }

  String? _extractImage(Map<String, dynamic> map) {
    final direct = _stringFrom(map['image']);
    if (direct != null && direct.isNotEmpty) return direct;

    final imageFullUrl = map['image_full_url'];
    if (imageFullUrl is String && imageFullUrl.isNotEmpty) return imageFullUrl;
    if (imageFullUrl is Map) {
      final path =
          _stringFrom(imageFullUrl['path']) ?? _stringFrom(imageFullUrl['url']);
      if (path != null && path.isNotEmpty) return path;
    }

    return null;
  }

  String? _stringFrom(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  int? _intFrom(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}
