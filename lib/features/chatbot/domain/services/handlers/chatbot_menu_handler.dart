import 'package:flutter_restaurant/common/enums/data_source_enum.dart';
import 'package:flutter_restaurant/common/reposotories/product_repo.dart';
import 'package:flutter_restaurant/features/category/domain/reposotories/category_repo.dart';
import 'package:flutter_restaurant/features/search/domain/reposotories/search_repo.dart';
import 'package:flutter_restaurant/features/chatbot/domain/models/chatbot_models.dart';
import 'package:flutter_restaurant/features/chatbot/domain/services/chatbot_utils.dart';

class ChatBotMenuHandler {
  final CategoryRepo categoryRepo;
  final ProductRepo productRepo;
  final SearchRepo searchRepo;

  ChatBotMenuHandler({
    required this.categoryRepo,
    required this.productRepo,
    required this.searchRepo,
  });

  Future<ChatBotActionExecutionResult> getCategories() async {
    final response = await categoryRepo.getCategoryList(
      source: DataSourceEnum.client, limit: 20, offset: 1,
    );
    final body = ChatBotUtils.responseBody(response);
    final categories = ChatBotUtils.normalizeCategories(body?['categories']);

    if (categories.isEmpty) {
      return const ChatBotActionExecutionResult(reply: 'No menu categories found right now.');
    }
    return ChatBotActionExecutionResult(
      reply: 'Here are our menu categories. Pick one and I will show the items.',
      data: {'categories': categories},
    );
  }

  Future<ChatBotActionExecutionResult> getCategoryProducts({required String userMessage, required ActionIntentData intent}) async {
    final int limit = intent.safeInt('limit') ?? 6;
    int? categoryId = intent.safeInt('category_id');
    String categoryName = intent.safeString('category_name') ?? 'this category';

    if (categoryId == null || categoryId <= 0) {
      final resolved = await _resolveCategoryFromText(userMessage);
      categoryId = resolved?.$1;
      categoryName = resolved?.$2 ?? categoryName;
    }

    if (categoryId == null || categoryId <= 0) {
      return const ChatBotActionExecutionResult(reply: 'Please tell me which category you want, for example Pizza or Burgers.');
    }

    final response = await categoryRepo.getCategoryProductList(
      categoryID: categoryId.toString(), offset: 1, limit: limit, type: 'all',
    );
    final body = ChatBotUtils.responseBody(response);
    final products = ChatBotUtils.normalizeProducts(body?['products'], limit: limit);

    if (products.isEmpty) {
      return ChatBotActionExecutionResult(reply: 'No items found in $categoryName.');
    }

    return ChatBotActionExecutionResult(
      reply: 'Found ${products.length} item(s) in $categoryName.',
      data: {
        'products': products,
        'category_name': categoryName,
      },
    );
  }

  Future<ChatBotActionExecutionResult> searchProducts({required String userMessage, required ActionIntentData intent}) async {
    final int limit = intent.safeInt('limit') ?? 5;
    final String query = (intent.safeString('name') ?? intent.safeString('product_name') ?? userMessage).trim();

    if (query.isEmpty) {
      return const ChatBotActionExecutionResult(reply: 'Tell me what item you want to search for.');
    }

    final response = await searchRepo.getSearchProductList(name: query, offset: 1, productType: 'all');
    final body = ChatBotUtils.responseBody(response);
    final products = ChatBotUtils.normalizeProducts(body?['products'], limit: limit);

    if (products.isEmpty) {
      return ChatBotActionExecutionResult(reply: "No menu items found matching '$query'.");
    }

    return ChatBotActionExecutionResult(
      reply: 'Found ${products.length} item(s): ${products.take(3).map((e) => e['name']).join(', ')}.',
      data: {'products': products},
    );
  }

  Future<ChatBotActionExecutionResult> getPopularProducts({required ActionIntentData intent}) async {
    final int limit = intent.safeInt('limit') ?? 5;
    final response = await productRepo.getPopularProductList(offset: 1, source: DataSourceEnum.client);
    final body = ChatBotUtils.responseBody(response);
    final products = ChatBotUtils.normalizeProducts(body?['products'], limit: limit);

    if (products.isEmpty) {
      return const ChatBotActionExecutionResult(reply: 'No popular items are available right now.');
    }

    return ChatBotActionExecutionResult(
      reply: 'Popular items: ${products.take(3).map((e) => e['name']).join(', ')}.',
      data: {'products': products},
    );
  }

  Future<ChatBotActionExecutionResult> getRecommendedProducts({required ActionIntentData intent}) async {
    final int limit = intent.safeInt('limit') ?? 5;
    final response = await productRepo.getRecommendedProductApi(offset: 1, source: DataSourceEnum.client);
    final body = ChatBotUtils.responseBody(response);
    final products = ChatBotUtils.normalizeProducts(body?['products'], limit: limit);

    if (products.isEmpty) {
      return const ChatBotActionExecutionResult(reply: 'No recommendations available right now.');
    }

    return ChatBotActionExecutionResult(
      reply: "Chef's picks: ${products.take(3).map((e) => e['name']).join(', ')}.",
      data: {'products': products},
    );
  }

  Future<ChatBotActionExecutionResult> getItemDetails({required String userMessage, required ActionIntentData intent}) async {
    final String query = (intent.safeString('item_name') ?? intent.safeString('name') ?? userMessage).trim();

    if (query.isEmpty) {
      return const ChatBotActionExecutionResult(reply: 'Please tell me the item name.');
    }

    final response = await searchRepo.getSearchProductList(name: query, offset: 1, productType: 'all');
    final body = ChatBotUtils.responseBody(response);
    final products = ChatBotUtils.normalizeProducts(body?['products'], limit: 1);

    if (products.isEmpty) {
      return ChatBotActionExecutionResult(reply: "Could not find '$query' in our menu.");
    }

    return ChatBotActionExecutionResult(
      reply: 'Here are details for ${products.first['name']}.',
      data: {'product': products.first},
    );
  }

  Future<ChatBotActionExecutionResult> initiateOrder({required String userMessage, required ActionIntentData intent}) async {
    final String query = (intent.safeString('product_name') ?? intent.safeString('name') ?? userMessage).trim();
    final int quantity = intent.safeInt('quantity') ?? 1;

    if (query.isEmpty) {
      return const ChatBotActionExecutionResult(reply: 'Please tell me what you want to order.');
    }

    final response = await searchRepo.getSearchProductList(name: query, offset: 1, productType: 'all');
    final body = ChatBotUtils.responseBody(response);
    final products = ChatBotUtils.normalizeProducts(body?['products'], limit: 1);

    if (products.isEmpty) {
      return ChatBotActionExecutionResult(reply: "Could not find '$query' in our menu.");
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
    final response = await categoryRepo.getCategoryList(source: DataSourceEnum.client, limit: 50, offset: 1);
    final body = ChatBotUtils.responseBody(response);
    final categories = ChatBotUtils.normalizeCategories(body?['categories']);
    if (categories.isEmpty) return null;

    final message = userMessage.toLowerCase();
    for (final category in categories) {
      final name = (ChatBotUtils.stringFrom(category['name']) ?? '').toLowerCase();
      if (name.isNotEmpty && message.contains(name)) {
        final id = ChatBotUtils.intFrom(category['id']);
        if (id != null) return (id, ChatBotUtils.stringFrom(category['name']) ?? 'this category');
      }
    }
    return null;
  }
}
