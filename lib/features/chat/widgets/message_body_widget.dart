import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/chat/providers/chat_provider.dart';
import 'package:flutter_restaurant/features/chat/widgets/message_bubble_shimmer_widget.dart';
import 'package:flutter_restaurant/features/chat/widgets/message_bubble_widget.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class MessageBodyWidget extends StatelessWidget {
  const MessageBodyWidget({
    super.key,
    required this.isAdmin,
    required this.authProvider,
    required TextEditingController inputMessageController,
    required this.orderId,
  }) : _inputMessageController = inputMessageController;

  final bool isAdmin;
  final AuthProvider authProvider;
  final TextEditingController _inputMessageController;
  final int? orderId;

  @override
  Widget build(BuildContext context) {

    return Consumer<ChatProvider>(builder: (context, chatProvider,child) {
        return Column(children: [

          chatProvider.messageList == null ? Expanded(child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: 24,
            itemBuilder: (context, index)=> MessageBubbleShimmerWidget(isMe: index.isOdd),
          )) : chatProvider.messageList!.isEmpty ? Expanded(child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [

            CustomAssetImageWidget(
              Images.noMessageSvg,
              width: ResponsiveHelper.isDesktop(context) ? 185 : 125,
              height: ResponsiveHelper.isDesktop(context) ? 150 : 100,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Text(getTranslated('no_message_found', context)!, style: rubikSemiBold),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Text(isAdmin ? "${getTranslated('start_typing_to_chat_with_restaurant', context)!} ${getTranslated('admin', context)!}"
                :  "${getTranslated('start_typing_to_chat_with_restaurant', context)!} ${getTranslated('deliveryman', context)!}",
                style: rubikRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).hintColor.withValues(alpha:0.7),
            )),

          ])) : Expanded(child: ListView.builder(
            reverse: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: chatProvider.messageList?.length,
            itemBuilder: (context, index) {
              return MessageBubbleWidget(messages: chatProvider.messageList?[index], isAdmin: isAdmin);
            },
          )),

          /// for Message input section
          Container(
            color: Theme.of(context).cardColor,
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeLarge),
            child: Column(children: [

              Consumer<ChatProvider>(builder: (context, chatProvider, _) {

                return chatProvider.chatImage!.isNotEmpty ? SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: chatProvider.chatImage!.length,
                    itemBuilder: (BuildContext context, index){

                      return  chatProvider.chatImage!.isNotEmpty?
                      Padding(padding: const EdgeInsets.all(8.0), child: Stack(children: [

                        Container(width: 100, height: 100,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault)),
                            child: ResponsiveHelper.isWeb()? Image.network(
                              chatProvider.chatImage![index].path,
                              width: 100, height: 100,
                              fit: BoxFit.cover,
                            ) : Image.file(
                              File(chatProvider.chatImage![index].path),
                              width: 100, height: 100,
                              fit: BoxFit.cover,
                            ),
                          ) ,
                        ),

                        Positioned(
                          top:0, right:0,
                          child: InkWell(
                            onTap: () => chatProvider.removeImage(index),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault))
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(Icons.clear,color: Colors.red,size: 15,),
                              ),
                            ),
                          ),
                        ),

                      ])) : const SizedBox();

                    },
                  ),
                ) : const SizedBox();

              }),

              Row(children: [

                InkWell(
                  onTap: () async {
                    chatProvider.pickImage(false);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).hintColor.withValues(alpha:0.5)),
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    width: 40, height: 40,
                    child: CustomAssetImageWidget(Images.image, color: Theme.of(context).hintColor, fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Expanded(
                  child: TextField(
                    inputFormatters: [LengthLimitingTextInputFormatter(Dimensions.messageInputLength)],
                    controller: _inputMessageController,
                    textCapitalization: TextCapitalization.sentences,
                    style: rubikRegular,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        borderSide: BorderSide(color: Theme.of(context).hintColor.withValues(alpha:0.5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        borderSide: BorderSide(color: Theme.of(context).hintColor.withValues(alpha:0.5)),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        borderSide: BorderSide(color: Theme.of(context).hintColor.withValues(alpha:0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        borderSide: BorderSide(color: Theme.of(context).hintColor.withValues(alpha:0.5)),
                      ),
                      hintText: getTranslated('start_a_new_message', context),
                      hintStyle: rubikRegular.copyWith(color: Theme.of(context).hintColor.withValues(alpha:0.8), fontSize: Dimensions.fontSizeSmall),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
                    ),
                    onSubmitted: (String newText) {
                      if(newText.trim().isNotEmpty && !chatProvider.isSendButtonActive) {
                        chatProvider.toggleSendButtonActivity();
                      }else if(newText.isEmpty && chatProvider.isSendButtonActive) {
                        chatProvider.toggleSendButtonActivity();
                      }
                    },
                    onChanged: (String newText) {
                      if(newText.trim().isNotEmpty && !chatProvider.isSendButtonActive) {
                        chatProvider.toggleSendButtonActivity();
                      }else if(newText.isEmpty && chatProvider.isSendButtonActive) {
                        chatProvider.toggleSendButtonActivity();
                      }
                    },

                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                InkWell(
                  onTap: () async {
                    if(chatProvider.isSendButtonActive){
                      chatProvider.sendMessage(_inputMessageController.text, context, authProvider.getUserToken(), orderId);
                      _inputMessageController.clear();
                      chatProvider.toggleSendButtonActivity();

                    }else{
                      showCustomSnackBarHelper(getTranslated('write_somethings', context));
                    }
                  },
                  child: Container(
                    width: 40, height: 40,
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: chatProvider.isLoading ? SizedBox(
                      width: 25, height: 25,
                      child: CircularProgressIndicator(color: Theme.of(context).cardColor,),
                    ) : const Icon(Icons.send_rounded, color: Colors.white, size: Dimensions.fontSizeLarge),
                  ),
                ),

              ]),

            ]),
          ),

        ]);
      }
    );
  }
}