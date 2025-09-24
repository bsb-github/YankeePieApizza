import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_loader_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/common/widgets/not_logged_in_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/chat/providers/chat_provider.dart';
import 'package:flutter_restaurant/features/chat/widgets/chat_item_widget.dart';
import 'package:flutter_restaurant/features/chat/widgets/message_body_widget.dart';
import 'package:flutter_restaurant/features/order/domain/models/order_model.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final int? orderId;
  final DeliveryMan? deliveryManModel;
  final bool fromSplash;
  const ChatScreen({super.key, required this.orderId, this.deliveryManModel, this.fromSplash = false});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _inputMessageController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  late bool _isLoggedIn;
  bool _isFirst = true;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
   if(_isLoggedIn){
     _loadMessage();
   }
  }


  @override
  void dispose() {
    super.dispose();

    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);


    final theme = Theme.of(context);


    return Consumer<ChatProvider>(builder: (context, chatProvider, _) {
      final bool isAdmin = chatProvider.currentChatOrderId == -1 || chatProvider.currentChatOrderId == null;

      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if(widget.fromSplash) {
            RouterHelper.getMainRoute(action: RouteAction.pushNamedAndRemoveUntil);
            return;
          }

          if(didPop) return;

          if(context.mounted) {
            chatProvider.onChangeChatOrderId(null);
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          appBar: ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBarWidget())
              : AppBar(centerTitle: true, title: Text(
            chatProvider.currentChatOrderId == null
                ? getTranslated('message', context)!
                : chatProvider.currentDeliveryMan != null
                ? '${chatProvider.currentDeliveryMan?.fName} ${chatProvider.currentDeliveryMan?.lName}' : getTranslated('admin', context)!,
            style: rubikSemiBold.copyWith(
              fontSize: Dimensions.fontSizeLarge,
              color: theme.textTheme.bodyMedium!.color,
            ),
          ),
            backgroundColor: theme.cardColor,
            leading: IconButton(
              onPressed: () {
                if(widget.fromSplash) {
                  RouterHelper.getMainRoute(action: RouteAction.pushNamedAndRemoveUntil);
                }else if(chatProvider.currentChatOrderId == null) {
                  context.pop();
                }else {
                  chatProvider.onChangeChatOrderId(null);
                }
              },
              icon: Icon(Icons.arrow_back_ios, color: theme.primaryColor),
              padding: EdgeInsets.zero,
            ),
            actions: <Widget>[
              if(chatProvider.currentChatOrderId != null) Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(width: 40,height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(width: 2,color: theme.cardColor),
                    color: theme.primaryColor.withValues(alpha:0.1),
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    //todo need to add images
                    child: CustomImageWidget(
                      fit: BoxFit.contain,
                      placeholder: isAdmin ? Images.logo : Images.profile,
                      image: isAdmin
                          ? '${splashProvider.baseUrls?.restaurantImageUrl}/${splashProvider.configModel?.restaurantLogo}'
                          : '${splashProvider.baseUrls?.deliveryManImageUrl}/${chatProvider.currentDeliveryMan?.image}',
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: _isLoggedIn ? Consumer<ChatProvider>(
              builder: (context, chatProvider, _) {
                if(chatProvider.conversationModel == null) {
                  return CustomLoaderWidget(color: Theme.of(context).primaryColor);
                }
                return ResponsiveHelper.isDesktop(context) ? SingleChildScrollView(
                  child: Column(children: [

                    Container(
                      width: Dimensions.webScreenWidth,
                      constraints: const BoxConstraints(maxHeight: 600),
                      margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraLarge),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        boxShadow: [BoxShadow(color: theme.shadowColor.withValues(alpha:0.2), blurRadius: 10)],
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Row(children: [

                        /// for web left side
                        Expanded(flex: 3, child: Container(
                          color: theme.primaryColor.withValues(alpha:0.05),
                          child: MessageListWidget(searchController: _searchController, orderId: chatProvider.currentChatOrderId, fromSplash: widget.fromSplash),
                        )),

                        /// for web right side
                        Expanded(flex: 7, child: Column(children: [

                          Expanded(
                            child: MessageBodyWidget(
                              isAdmin: isAdmin,
                              authProvider: authProvider,
                              inputMessageController: _inputMessageController,
                              orderId: chatProvider.currentChatOrderId,
                            ),
                          ),

                        ])),

                      ]),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                    if(ResponsiveHelper.isDesktop(context)) const FooterWidget(),

                  ]),
                ) : chatProvider.currentChatOrderId == null ?  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: MessageListWidget(searchController: _searchController, orderId: chatProvider.currentChatOrderId, fromSplash: widget.fromSplash),
                ) : MessageBodyWidget(
                  isAdmin: isAdmin,
                  authProvider: authProvider,
                  inputMessageController: _inputMessageController,
                  orderId: chatProvider.currentChatOrderId,
                );
              }
          ) : const NotLoggedInWidget(),
        ),
      );
      }
    );
  }


  void _loadMessage() async {
    final ChatProvider chatProvider = Provider.of<ChatProvider>(context, listen: false);

    chatProvider.onChangeCurrentDeliveryMan(widget.deliveryManModel);

    await chatProvider.getAllConversationList(1, isUpdate: false);
    chatProvider.onChangeChatOrderId(widget.orderId, isUpdate: false);


    if(_isLoggedIn){
      if(_isFirst) {

        chatProvider.getMessages(Get.context!, 1, chatProvider.currentChatOrderId, true,);
      }else {
        chatProvider.getMessages(Get.context!, 1,  chatProvider.currentChatOrderId, false);
        _isFirst = false;
      }
      Provider.of<ProfileProvider>(Get.context!, listen: false).getUserInfo(true);
    }
  }

}




class MessageListWidget extends StatelessWidget {
  final bool fromSplash;
  final int? orderId;
  const MessageListWidget({
    super.key,
    required TextEditingController searchController, this.orderId, this.fromSplash = false,
  }) : _searchController = searchController;

  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, _) {
        return CustomScrollView(slivers: [

          /// for Search input
          SliverAppBar(
            title: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: CustomTextFieldWidget(
                radius: Dimensions.radiusSmall,
                hintText: getTranslated('search', context),
                fillColor: Theme.of(context).cardColor,
                isShowSuffixIcon: true,
                suffixIconUrl: Images.search,
                controller: _searchController,
                inputAction: TextInputAction.search,
                isIcon: true,
                onSubmit: (String text) {
                  if(text.trim().isNotEmpty || (chatProvider.conversationModel?.deliverymanConversations?.isEmpty ?? false)) {
                    chatProvider.getAllConversationList(1, search: text);
                  }
                },
                onSuffixTap: () {
                  if(_searchController.text.trim().isNotEmpty || (chatProvider.conversationModel?.deliverymanConversations?.isEmpty ?? false)) {
                    chatProvider.getAllConversationList(1, search: _searchController.text);
                  }

                },
              ),
            ),
            automaticallyImplyLeading: false,
            floating: false,
            pinned: true,
            snap: false,
            stretch: true,
            backgroundColor: Theme.of(context).primaryColor.withValues(alpha:0.05),
            elevation: 0,
            shadowColor: Colors.transparent,
            scrolledUnderElevation: 1,
            toolbarHeight: 80,
          ),

          /// for Admin Chat selection
          SliverToBoxAdapter(
            child: ChatItemWidget(isSelected: orderId == null, fromSplash: fromSplash,),
          ),

          if(chatProvider.conversationModel?.deliverymanConversations?.isNotEmpty ?? false) SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
            child: Text(getTranslated('conversation_list', context)!, style: rubikRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).hintColor,
            )),
          )),

          /// for Chat list
          SliverList.builder(
            itemCount: chatProvider.conversationModel?.deliverymanConversations?.length,
            itemBuilder: (context, index) {
              return ChatItemWidget(
                fromSplash: fromSplash,
                isSelected: chatProvider.conversationModel?.deliverymanConversations?[index].orderId == orderId,
                deliverymanConversation: chatProvider.conversationModel?.deliverymanConversations?[index],
              );
            },
          ),

        ]);
      }
    );
  }
}



