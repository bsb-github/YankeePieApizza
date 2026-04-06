import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/chatbot/domain/models/chatbot_message_model.dart';
import 'package:flutter_restaurant/features/chatbot/providers/chatbot_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

/// Opens the AI chatbot as a persistent bottom sheet.
void showChatBotBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _ChatBotSheet(),
  );
}

class _ChatBotSheet extends StatefulWidget {
  const _ChatBotSheet();

  @override
  State<_ChatBotSheet> createState() => _ChatBotSheetState();
}

class _ChatBotSheetState extends State<_ChatBotSheet>
    with TickerProviderStateMixin {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _fabPulseController;

  @override
  void initState() {
    super.initState();
    _fabPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _fabPulseController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send(ChatBotProvider bot, String? guestId) async {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    _inputController.clear();
    await bot.sendMessage(text, guestId: guestId);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final String? guestId = authProvider.getGuestId();
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final screenH = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        height: screenH * 0.82,
        margin: EdgeInsets.only(bottom: bottomInset),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(Dimensions.radiusExtraLarge),
          ),
        ),
        child: Column(
          children: [
            _SheetHandle(),
            _ChatHeader(),
            const Divider(height: 1),
            Expanded(
              child: Consumer<ChatBotProvider>(
                builder: (context, bot, _) {
                  _scrollToBottom();
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault,
                      vertical: Dimensions.paddingSizeSmall,
                    ),
                    itemCount: bot.messages.isEmpty
                        ? 1
                        : bot.messages.length + (bot.isLoading ? 1 : 0),
                    itemBuilder: (ctx, i) {
                      // Empty state
                      if (bot.messages.isEmpty) {
                        return const _WelcomeCard();
                      }
                      // Typing indicator
                      if (bot.isLoading && i == bot.messages.length) {
                        return const _TypingIndicator();
                      }
                      final msg = bot.messages[i];
                      return _MessageBubble(message: msg);
                    },
                  );
                },
              ),
            ),
            _InputRow(
              controller: _inputController,
              onSend: () {
                final bot =
                    Provider.of<ChatBotProvider>(context, listen: false);
                _send(bot, guestId);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sheet Handle
// ---------------------------------------------------------------------------
class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Theme.of(context).dividerColor,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Chat Header
// ---------------------------------------------------------------------------
class _ChatHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeDefault,
        vertical: Dimensions.paddingSizeSmall,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withValues(alpha: 0.6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
            child: const Icon(Icons.smart_toy_rounded,
                color: Colors.white, size: 24),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Assistant',
                  style: rubikSemiBold.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Online',
                      style: rubikRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Consumer<ChatBotProvider>(
            builder: (ctx, bot, _) => IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Clear chat',
              onPressed:
                  bot.messages.isEmpty ? null : () => bot.clearMessages(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Welcome card (empty state)
// ---------------------------------------------------------------------------
class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard();

  static const _suggestions = [
    '📋  Browse menu categories',
    '🍕  What\'s popular today?',
    '⭐  What do you recommend?',
    '🎟️  Any coupons available?',
    '📦  Where is my order?',
    '🛒  I want to order a pizza',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: Column(
        children: [
          const SizedBox(height: Dimensions.paddingSizeDefault),
          Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor.withValues(alpha: 0.15),
                  Theme.of(context).primaryColor.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
            ),
            child: Icon(Icons.smart_toy_rounded,
                size: 56, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),
          Text(
            'Hi there! 👋',
            style: rubikSemiBold.copyWith(
              fontSize: Dimensions.fontSizeExtraLarge,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          Text(
            'I can help you explore the menu, track orders,\nand place new ones.',
            textAlign: TextAlign.center,
            style: rubikRegular.copyWith(
              color: Theme.of(context).hintColor,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),
          ..._suggestions.map((s) => _SuggestionChip(label: s)),
        ],
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final String label;
  const _SuggestionChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      child: InkWell(
        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
        onTap: () {
          final text = label.replaceAll(RegExp(r'^[\S]+\s+'), '');
          final bot = Provider.of<ChatBotProvider>(context, listen: false);
          final auth = Provider.of<AuthProvider>(context, listen: false);
          bot.sendMessage(text, guestId: auth.getGuestId());
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeDefault,
            vertical: Dimensions.paddingSizeSmall,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            border: Border.all(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            ),
          ),
          child: Text(label, style: rubikRegular),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Typing Indicator
// ---------------------------------------------------------------------------
class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          _BotAvatar(),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(2),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, __) => Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) {
                  final double offset = math.sin(
                      (_controller.value * 2 * math.pi) - (i * math.pi / 3));
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Transform.translate(
                      offset: Offset(0, -4 * ((offset + 1) / 2)),
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withValues(
                              alpha: 0.6 + 0.4 * ((offset + 1) / 2)),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Message Bubble
// ---------------------------------------------------------------------------
class _MessageBubble extends StatefulWidget {
  final ChatBotMessage message;
  const _MessageBubble({required this.message});

  @override
  State<_MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<_MessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnim = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    final isUser = widget.message.role == 'user';
    _slideAnim = Tween<Offset>(
      begin: Offset(isUser ? 0.2 : -0.2, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isUser = widget.message.role == 'user';
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            crossAxisAlignment:
                isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment:
                    isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  if (!isUser) ...[_BotAvatar(), const SizedBox(width: 8)],
                  Flexible(child: _BubbleContent(message: widget.message)),
                  if (isUser) ...[const SizedBox(width: 8), _UserAvatar()],
                ],
              ),
              if (widget.message.action != null)
                Padding(
                  padding: EdgeInsets.only(
                    top: 6,
                    left: isUser ? 0 : 40,
                    right: isUser ? 40 : 0,
                  ),
                  child: _ActionCard(
                    action: widget.message.action!,
                    data: widget.message.data,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BubbleContent extends StatelessWidget {
  final ChatBotMessage message;
  const _BubbleContent({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isUser
            ? Theme.of(context).primaryColor
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(isUser ? 18 : 2),
          bottomRight: Radius.circular(isUser ? 2 : 18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        message.content,
        style: rubikRegular.copyWith(
          color: isUser
              ? Colors.white
              : Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bot Avatar
// ---------------------------------------------------------------------------
class _BotAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 16),
    );
  }
}

// ---------------------------------------------------------------------------
// User Avatar
// ---------------------------------------------------------------------------
class _UserAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: ColorResources.getSearchBg(context),
        borderRadius: BorderRadius.circular(8),
      ),
      child:
          Icon(Icons.person, color: Theme.of(context).primaryColor, size: 16),
    );
  }
}

// ---------------------------------------------------------------------------
// Action Card — renders rich UI for each action type
// ---------------------------------------------------------------------------
class _ActionCard extends StatelessWidget {
  final String action;
  final Map<String, dynamic>? data;

  const _ActionCard({required this.action, this.data});

  @override
  Widget build(BuildContext context) {
    switch (action) {
      case 'search_products':
      case 'get_popular_products':
        return _ProductListCard(
          products:
              (data?['products'] as List?)?.cast<Map<String, dynamic>>() ?? [],
        );
      case 'track_order':
        return _OrderTrackCard(
          order: data?['order'] as Map<String, dynamic>?,
          status: data?['status'] as String?,
        );
      case 'get_order_history':
        return _OrderHistoryCard(
          orders:
              (data?['orders'] as List?)?.cast<Map<String, dynamic>>() ?? [],
        );
      case 'initiate_order':
        final initiation = data?['order_initiation'] as Map<String, dynamic>?;
        return _InitiateOrderCard(initiation: initiation);
      case 'get_categories':
        return _CategoriesCard(
          categories:
              (data?['categories'] as List?)?.cast<Map<String, dynamic>>() ??
                  [],
        );
      case 'get_category_products':
      case 'get_recommended_products':
      case 'reorder':
        return _ProductListCard(
          products:
              (data?['products'] as List?)?.cast<Map<String, dynamic>>() ?? [],
        );
      case 'get_item_details':
        return _ItemDetailCard(
          product: data?['product'] as Map<String, dynamic>?,
        );
      case 'get_available_coupons':
        return _CouponsCard(
          coupons:
              (data?['coupons'] as List?)?.cast<Map<String, dynamic>>() ?? [],
        );
      case 'check_coupon':
        return _CouponResultCard(
          coupon: data?['coupon'] as Map<String, dynamic>?,
        );
      case 'add_to_cart':
        return _AddToCartResultCard(data: data);
      default:
        return const SizedBox.shrink();
    }
  }
}

// ---------------------------------------------------------------------------
// Product List Card
// ---------------------------------------------------------------------------
class _ProductListCard extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  const _ProductListCard({required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: Dimensions.paddingSizeSmall),
        itemBuilder: (_, i) => _ProductCard(product: products[i]),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final name = product['name'] as String? ?? '';
    final price = product['price'];
    final rawImage = product['image'] as String? ?? '';
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final String fullImageUrl =
        '${splashProvider.baseUrls?.productImageUrl ?? ''}/$rawImage';

    return Container(
      width: 130,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(Dimensions.radiusDefault)),
              child: Image.network(
                fullImageUrl,
                height: 80,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _imagePlaceholder(context),
              )),
          Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: rubikMedium.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      '\$${price ?? '–'}',
                      style: rubikSemiBold.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
      child: Icon(Icons.fastfood_rounded,
          color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
          size: 32),
    );
  }
}

// ---------------------------------------------------------------------------
// Order Track Card
// ---------------------------------------------------------------------------
class _OrderTrackCard extends StatelessWidget {
  final Map<String, dynamic>? order;
  final String? status;

  const _OrderTrackCard({this.order, this.status});

  static const _statusSteps = [
    'pending',
    'confirmed',
    'processing',
    'out_for_delivery',
    'delivered',
  ];

  static const _statusLabels = {
    'pending': 'Pending',
    'confirmed': 'Confirmed',
    'processing': 'Preparing',
    'out_for_delivery': 'On the way',
    'delivered': 'Delivered',
    'canceled': 'Canceled',
    'failed': 'Failed',
  };

  static const _statusIcons = {
    'pending': Icons.access_time_rounded,
    'confirmed': Icons.check_circle_outline,
    'processing': Icons.soup_kitchen_rounded,
    'out_for_delivery': Icons.delivery_dining_rounded,
    'delivered': Icons.done_all_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final currentStatus = status ?? order?['order_status'] as String? ?? '';
    final orderId = order?['id'];
    final currentStep = _statusSteps.indexOf(currentStatus);

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long_rounded,
                  color: Theme.of(context).primaryColor, size: 18),
              const SizedBox(width: 6),
              Text(
                'Order #${orderId ?? '–'}',
                style: rubikSemiBold.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                ),
              ),
              const Spacer(),
              _StatusBadge(status: currentStatus),
            ],
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),
          Row(
            children: List.generate(_statusSteps.length * 2 - 1, (i) {
              if (i.isOdd) {
                final stepIndex = i ~/ 2;
                final filled = stepIndex < currentStep;
                return Expanded(
                  child: Container(
                    height: 3,
                    color: filled
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).dividerColor,
                  ),
                );
              }
              final stepIndex = i ~/ 2;
              final isDone = stepIndex <= currentStep;
              final isCurrent = stepIndex == currentStep;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: isCurrent ? 28 : 22,
                height: isCurrent ? 28 : 22,
                decoration: BoxDecoration(
                  color: isDone
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).dividerColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _statusIcons[_statusSteps[stepIndex]] ?? Icons.circle,
                  color: Colors.white,
                  size: isCurrent ? 14 : 11,
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _statusSteps.map((s) {
              final active = _statusSteps.indexOf(s) <= currentStep;
              return Expanded(
                child: Text(
                  _statusLabels[s] ?? s,
                  textAlign: TextAlign.center,
                  style: rubikRegular.copyWith(
                    fontSize: 9,
                    color: active
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).hintColor,
                  ),
                ),
              );
            }).toList(),
          ),
          if (orderId != null) ...[
            const SizedBox(height: Dimensions.paddingSizeDefault),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  RouterHelper.getOrderTrackingRoute(orderId is int
                      ? orderId
                      : int.tryParse(orderId.toString()));
                },
                icon: const Icon(Icons.map_outlined, size: 16),
                label: const Text('Track on Map'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final bg =
        ColorResources.buttonBackgroundColorMap[status] ?? Colors.grey.shade100;
    final fg = ColorResources.buttonTextColorMap[status] ?? Colors.grey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.replaceAll('_', ' ').toUpperCase(),
        style: rubikMedium.copyWith(color: fg, fontSize: 9),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Order History Card
// ---------------------------------------------------------------------------
class _OrderHistoryCard extends StatelessWidget {
  final List<Map<String, dynamic>> orders;
  const _OrderHistoryCard({required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) return const SizedBox.shrink();
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Row(
              children: [
                Icon(Icons.history_rounded,
                    color: Theme.of(context).primaryColor, size: 18),
                const SizedBox(width: 6),
                const Text('Recent Orders', style: rubikSemiBold),
              ],
            ),
          ),
          const Divider(height: 1),
          ...orders.take(4).map((o) => _OrderHistoryTile(order: o)),
        ],
      ),
    );
  }
}

class _OrderHistoryTile extends StatelessWidget {
  final Map<String, dynamic> order;
  const _OrderHistoryTile({required this.order});

  @override
  Widget build(BuildContext context) {
    final id = order['id'];
    final status = order['order_status'] as String? ?? '';
    final amount = order['order_amount'];
    final date = order['created_at'] as String? ?? '';

    return InkWell(
      onTap: () {
        Navigator.pop(context);
        RouterHelper.getOrderDetailsRoute(id?.toString());
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeSmall,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.receipt_outlined,
                  color: Theme.of(context).primaryColor, size: 18),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order #$id',
                    style: rubikMedium.copyWith(
                        fontSize: Dimensions.fontSizeSmall),
                  ),
                  Text(
                    date.length > 10 ? date.substring(0, 10) : date,
                    style: rubikRegular.copyWith(
                      fontSize: 11,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$$amount',
                  style: rubikSemiBold.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                _StatusBadge(status: status),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Initiate Order Card
// ---------------------------------------------------------------------------
class _InitiateOrderCard extends StatelessWidget {
  final Map<String, dynamic>? initiation;
  const _InitiateOrderCard({this.initiation});

  @override
  Widget build(BuildContext context) {
    if (initiation == null) return const SizedBox.shrink();
    final name = initiation!['name'] as String? ?? '';
    final price = initiation!['price'];
    final imageUrl = initiation!['image'] as String? ?? '';

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withValues(alpha: 0.12),
            Theme.of(context).primaryColor.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(context),
                  )
                : _placeholder(context),
          ),
          const SizedBox(width: Dimensions.paddingSizeDefault),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: rubikSemiBold),
                const SizedBox(height: 2),
                Text(
                  '\$$price',
                  style: rubikSemiBold.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (name.isNotEmpty) {
                RouterHelper.getSearchResultRoute(name);
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
            ),
            child: Text(
              'Order',
              style: rubikSemiBold.copyWith(
                color: Colors.white,
                fontSize: Dimensions.fontSizeSmall,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      child: Icon(Icons.fastfood_rounded,
          color: Theme.of(context).primaryColor, size: 28),
    );
  }
}

// ---------------------------------------------------------------------------
// Categories Card
// ---------------------------------------------------------------------------
class _CategoriesCard extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  const _CategoriesCard({required this.categories});

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.grid_view_rounded,
                color: Theme.of(context).primaryColor, size: 16),
            const SizedBox(width: 6),
            const Text('Menu Categories', style: rubikSemiBold),
          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((cat) {
              final name = cat['name'] as String? ?? '';
              return InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  final bot =
                      Provider.of<ChatBotProvider>(context, listen: false);
                  final auth =
                      Provider.of<AuthProvider>(context, listen: false);
                  bot.sendMessage('Show me items in the $name category',
                      guestId: auth.getGuestId());
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          Theme.of(context).primaryColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    name,
                    style: rubikMedium.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Item Detail Card
// ---------------------------------------------------------------------------
class _ItemDetailCard extends StatelessWidget {
  final Map<String, dynamic>? product;
  const _ItemDetailCard({this.product});

  @override
  Widget build(BuildContext context) {
    if (product == null) return const SizedBox.shrink();
    final name = product!['name'] as String? ?? '';
    final price = product!['price'];
    final description = product!['description'] as String? ?? '';
    final imageUrl = product!['image'] as String? ?? '';
    final rating = product!['rating'];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(Dimensions.radiusDefault)),
            child: imageUrl.isNotEmpty
                ? Image.network(imageUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(context))
                : _placeholder(context),
          ),
          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(name,
                            style: rubikSemiBold.copyWith(
                                fontSize: Dimensions.fontSizeLarge))),
                    if (rating != null)
                      Row(children: [
                        const Icon(Icons.star_rounded,
                            color: Colors.amber, size: 16),
                        const SizedBox(width: 2),
                        Text('$rating',
                            style: rubikMedium.copyWith(
                                fontSize: Dimensions.fontSizeSmall)),
                      ]),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '\$$price',
                  style: rubikSemiBold.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontSize: Dimensions.fontSizeLarge,
                  ),
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(description,
                      style: rubikRegular.copyWith(
                          color: Theme.of(context).hintColor,
                          fontSize: Dimensions.fontSizeSmall),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis),
                ],
                const SizedBox(height: Dimensions.paddingSizeSmall),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      RouterHelper.getSearchResultRoute(name);
                    },
                    icon: const Icon(Icons.shopping_cart_outlined,
                        size: 16, color: Colors.white),
                    label: Text('Order Now',
                        style: rubikSemiBold.copyWith(
                            color: Colors.white,
                            fontSize: Dimensions.fontSizeSmall)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusDefault)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      height: 140,
      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
      child: Center(
          child: Icon(Icons.fastfood_rounded,
              color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
              size: 48)),
    );
  }
}

// ---------------------------------------------------------------------------
// Coupons Card
// ---------------------------------------------------------------------------
class _CouponsCard extends StatelessWidget {
  final List<Map<String, dynamic>> coupons;
  const _CouponsCard({required this.coupons});

  @override
  Widget build(BuildContext context) {
    if (coupons.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
          child: Row(children: [
            Icon(Icons.local_offer_rounded,
                color: Theme.of(context).primaryColor, size: 16),
            const SizedBox(width: 6),
            const Text('Available Coupons', style: rubikSemiBold),
          ]),
        ),
        ...coupons.map((c) => _CouponTile(coupon: c)),
      ],
    );
  }
}

class _CouponTile extends StatelessWidget {
  final Map<String, dynamic> coupon;
  const _CouponTile({required this.coupon});

  @override
  Widget build(BuildContext context) {
    final code = coupon['code'] as String? ?? '';
    final title = coupon['title'] as String? ?? '';
    final discount = coupon['discount'];
    final discountType = coupon['discount_type'] as String? ?? 'percent';
    final expiry = coupon['expire_date'] as String? ?? '';
    final discountLabel =
        discountType == 'percent' ? '$discount% off' : '\$$discount off';

    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withValues(alpha: 0.12),
            Theme.of(context).primaryColor.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
              child: Text(code,
                  style: rubikBold.copyWith(
                      color: Colors.white,
                      fontSize: Dimensions.fontSizeSmall,
                      letterSpacing: 1.5)),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title.isNotEmpty ? title : discountLabel,
                      style: rubikMedium.copyWith(
                          fontSize: Dimensions.fontSizeSmall)),
                  if (expiry.isNotEmpty)
                    Text('Expires: $expiry',
                        style: rubikRegular.copyWith(
                            fontSize: 10, color: Theme.of(context).hintColor)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(discountLabel,
                  style: rubikSemiBold.copyWith(
                      color: Colors.green, fontSize: Dimensions.fontSizeSmall)),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Coupon Result Card
// ---------------------------------------------------------------------------
class _CouponResultCard extends StatelessWidget {
  final Map<String, dynamic>? coupon;
  const _CouponResultCard({this.coupon});

  @override
  Widget build(BuildContext context) {
    if (coupon == null) return const SizedBox.shrink();
    final valid = coupon!['valid'] as bool? ?? false;
    final code = coupon!['code'] as String? ?? '';
    final discount = coupon!['discount'];
    final discountType = coupon!['discount_type'] as String? ?? 'percent';
    final minPurchase = coupon!['min_purchase'];
    final expiry = coupon!['expire_date'] as String? ?? '';
    final message = coupon!['message'] as String? ?? '';
    final discountLabel =
        discountType == 'percent' ? '$discount% off' : '\$$discount off';

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: valid
            ? Colors.green.withValues(alpha: 0.08)
            : Colors.red.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(
          color: valid
              ? Colors.green.withValues(alpha: 0.4)
              : Colors.red.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(
              valid ? Icons.check_circle_rounded : Icons.cancel_rounded,
              color: valid ? Colors.green : Colors.red,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              valid ? 'Valid Coupon!' : 'Invalid Coupon',
              style: rubikSemiBold.copyWith(
                  color: valid ? Colors.green : Colors.red),
            ),
          ]),
          if (valid) ...[
            const SizedBox(height: 8),
            Row(children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
                child: Text(code,
                    style: rubikBold.copyWith(
                        color: Colors.white,
                        fontSize: Dimensions.fontSizeSmall,
                        letterSpacing: 1.5)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(discountLabel,
                    style: rubikSemiBold.copyWith(
                        color: Colors.green,
                        fontSize: Dimensions.fontSizeSmall)),
              ),
            ]),
            if (minPurchase != null && minPurchase.toString() != '0') ...[
              const SizedBox(height: 4),
              Text('Min. purchase: \$$minPurchase',
                  style: rubikRegular.copyWith(
                      fontSize: 11, color: Theme.of(context).hintColor)),
            ],
            if (expiry.isNotEmpty) ...[
              Text('Expires: $expiry',
                  style: rubikRegular.copyWith(
                      fontSize: 11, color: Theme.of(context).hintColor)),
            ],
          ] else ...[
            const SizedBox(height: 4),
            Text(message,
                style: rubikRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Colors.red.shade700)),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Input Row
// ---------------------------------------------------------------------------
class _InputRow extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _InputRow({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeSmall,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Consumer<ChatBotProvider>(
          builder: (ctx, bot, _) => Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  textInputAction: TextInputAction.send,
                  maxLines: null,
                  enabled: !bot.isLoading,
                  onSubmitted: (_) {
                    if (!bot.isLoading) onSend();
                  },
                  decoration: InputDecoration(
                    hintText: 'Ask me anything…',
                    hintStyle: rubikRegular.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                    filled: true,
                    fillColor: ColorResources.getSearchBg(context),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault,
                      vertical: Dimensions.paddingSizeSmall,
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusExtraLarge),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: bot.isLoading
                    ? Container(
                        key: const ValueKey('loading'),
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .primaryColor
                              .withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : InkWell(
                        key: const ValueKey('send'),
                        onTap: onSend,
                        borderRadius: BorderRadius.circular(22),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.send_rounded,
                              color: Colors.white, size: 20),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Add to Cart Result Card
// ---------------------------------------------------------------------------
class _AddToCartResultCard extends StatelessWidget {
  final Map<String, dynamic>? data;
  const _AddToCartResultCard({this.data});

  @override
  Widget build(BuildContext context) {
    if (data == null) return const SizedBox.shrink();

    final bool added = data!['added'] as bool? ?? false;
    final String productName = data!['product_name'] as String? ?? '';
    final int quantity = data!['quantity'] as int? ?? 1;
    final dynamic price = data!['price'];

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(
          color: added
              ? Colors.green.withValues(alpha: 0.4)
              : Colors.red.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Status icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: added
                  ? Colors.green.withValues(alpha: 0.12)
                  : Colors.red.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              added ? Icons.check_circle_rounded : Icons.error_outline_rounded,
              color: added ? Colors.green : Colors.red,
              size: 20,
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          // Product info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  added ? 'Added to cart' : 'Failed to add',
                  style: rubikSemiBold.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: added ? Colors.green : Colors.red,
                  ),
                ),
                if (productName.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    '$productName × $quantity',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: rubikRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Price + view cart
          if (added) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (price != null)
                  Text(
                    '\$${(price as double).toStringAsFixed(2)}',
                    style: rubikSemiBold.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    RouterHelper.getDashboardRoute('cart');
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'View Cart',
                      style: rubikMedium.copyWith(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
