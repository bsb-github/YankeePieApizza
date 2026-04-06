import 'package:flutter_restaurant/common/models/api_response_model.dart';

class ChatBotUtils {
  static Map<String, dynamic>? responseBody(ApiResponseModel response) {
    if (!response.isSuccess) return null;
    final dynamic rawResponse = response.response;
    if (rawResponse == null) return null;

    final int? status = rawResponse.statusCode as int?;
    if (status != null && (status < 200 || status >= 300)) {
      return null;
    }

    return asMap(rawResponse.data);
  }

  static Map<String, dynamic>? asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), val));
    }
    return null;
  }

  static String? stringFrom(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static int? intFrom(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static double? doubleFrom(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    return double.tryParse(value.toString());
  }

  static String? extractImage(Map<String, dynamic> map) {
    final direct = stringFrom(map['image']);
    if (direct != null && direct.isNotEmpty) return direct;

    final imageFullUrl = map['image_full_url'];
    if (imageFullUrl is String && imageFullUrl.isNotEmpty) return imageFullUrl;
    if (imageFullUrl is Map) {
      final path =
          stringFrom(imageFullUrl['path']) ?? stringFrom(imageFullUrl['url']);
      if (path != null && path.isNotEmpty) return path;
    }

    return null;
  }

  static List<Map<String, dynamic>> normalizeProducts(dynamic source, {int limit = 10}) {
    if (source is! List) return [];

    final List<Map<String, dynamic>> products = source
        .map((e) {
          final map = asMap(e) ?? <String, dynamic>{};
          return {
            'id': map['id'],
            'name': stringFrom(map['name']) ?? '',
            'price': map['price'] ?? map['price_with_tax'] ?? 0,
            'description': stringFrom(map['description']) ?? '',
            'image': extractImage(map),
            'rating': map['avg_rating'] ?? map['rating'] ?? map['average_review'],
          };
        })
        .where((e) => (e['name'] as String).isNotEmpty)
        .toList();

    if (products.length <= limit) return products;
    return products.sublist(0, limit);
  }

  static List<Map<String, dynamic>> normalizeCategories(dynamic source) {
    if (source is! List) return [];
    return source
        .map((e) {
          final map = asMap(e) ?? <String, dynamic>{};
          return {
            'id': map['id'],
            'name': stringFrom(map['name']) ?? '',
            'image': extractImage(map),
          };
        })
        .where((e) => (e['name'] as String).isNotEmpty)
        .toList();
  }

  static List<Map<String, dynamic>> normalizeOrders(dynamic source) {
    if (source is! List) return [];
    return source
        .map((e) {
          final map = asMap(e) ?? <String, dynamic>{};
          return {
            'id': map['id'],
            'order_status': stringFrom(map['order_status']) ??
                stringFrom(map['orderStatus']) ??
                '',
            'order_amount': map['order_amount'] ?? map['orderAmount'] ?? 0,
            'created_at': stringFrom(map['created_at']) ??
                stringFrom(map['createdAt']) ??
                '',
          };
        })
        .where((e) => e['id'] != null)
        .toList();
  }

  static List<Map<String, dynamic>> normalizeCoupons(dynamic source) {
    if (source is! List) return [];
    return source
        .map((e) {
          final map = asMap(e) ?? <String, dynamic>{};
          return {
            'id': map['id'],
            'title': stringFrom(map['title']) ?? '',
            'code': stringFrom(map['code']) ?? '',
            'discount': map['discount'] ?? 0,
            'discount_type': stringFrom(map['discount_type']) ?? 'percent',
            'min_purchase': map['min_purchase'] ?? 0,
            'max_discount': map['max_discount'] ?? 0,
            'expire_date': stringFrom(map['expire_date']) ?? '',
          };
        })
        .where((e) => (e['code'] as String).isNotEmpty)
        .toList();
  }
}
