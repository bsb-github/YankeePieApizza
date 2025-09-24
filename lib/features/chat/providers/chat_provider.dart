import 'dart:async';
import 'package:flutter_restaurant/common/models/api_response_model.dart';
import 'package:flutter_restaurant/features/chat/domain/models/conversation_model.dart';
import 'package:flutter_restaurant/features/order/domain/models/order_model.dart';
import 'package:flutter_restaurant/features/notification/domain/reposotories/notification_repo.dart';
import 'package:flutter_restaurant/helper/api_checker_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/chat/domain/models/chat_model.dart';
import 'package:flutter_restaurant/features/chat/domain/reposotories/chat_repo.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ChatProvider extends ChangeNotifier {
  final ChatRepo? chatRepo;
  final NotificationRepo? notificationRepo;
  ChatProvider({required this.chatRepo, required this.notificationRepo});

  List<bool>? _showDate;
  List<XFile>? _imageFiles;
  // XFile _imageFile;
  bool _isSendButtonActive = false;
  final bool _isSeen = false;
  final bool _isSend = true;
  bool _isMe = false;
  bool _isLoading= false;
  bool get isLoading => _isLoading;
  int? _currentChatOrderId;
  DeliveryMan? _currentDeliveryMan;

  List<bool>? get showDate => _showDate;
  List<XFile>? get imageFiles => _imageFiles;
  bool get isSendButtonActive => _isSendButtonActive;
  bool get isSeen => _isSeen;
  bool get isSend => _isSend;
  bool get isMe => _isMe;
  final List<Messages>  _deliveryManMessage = [];
  List<Messages>?  _messageList = [];
  List<Messages>? get messageList => _messageList;
  List<Messages> get deliveryManMessage => _deliveryManMessage;
  final List<Messages>  _adminManMessage = [];
  List<Messages> get adminManMessages => _adminManMessage;
  List <XFile>?_chatImage = [];
  List<XFile>? get chatImage => _chatImage;
  int? get currentChatOrderId => _currentChatOrderId;
  DeliveryMan? get currentDeliveryMan => _currentDeliveryMan;

  Future<void> getMessages(BuildContext? context, int offset, int? orderId, bool isFirst, {isUpdate = false}) async {
    ApiResponseModel apiResponse;

    if(isFirst) {
      _messageList = null;

      if(isUpdate) {
        notifyListeners();
      }
    }
    //
    if(orderId == null || orderId == -1) {
      apiResponse = await chatRepo!.getAdminMessage(1);
    }else {
      apiResponse = await chatRepo!.getDeliveryManMessage(orderId, 1);
    }
    if (apiResponse.response != null&& apiResponse.response!.data['messages'] != {} && apiResponse.response!.statusCode == 200) {
      _messageList = [];
      _messageList?.addAll(ChatModel.fromJson(apiResponse.response!.data).messages!);
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
    notifyListeners();
  }


  void pickImage(bool isRemove) async {
    if(isRemove) {
      _imageFiles = [];
      _chatImage = [];
    }else {
      _imageFiles = await ImagePicker().pickMultiImage(imageQuality: 30);
      if (_imageFiles != null) {
        _chatImage = imageFiles;
        _isSendButtonActive = true;
      }
    }
    notifyListeners();
  }
  void removeImage(int index){
    chatImage!.removeAt(index);
    notifyListeners();
  }


  Future<http.StreamedResponse> sendMessage(String message, BuildContext context, String token, int? orderId) async {
    http.StreamedResponse response;
    _isLoading = true;
    if(orderId == null || orderId == -1) {
      response = await chatRepo!.sendMessageToAdmin(message, _chatImage!, token);
    }else {
      response = await chatRepo!.sendMessageToDeliveryMan(message, _chatImage!, orderId, token);
    }
    if (response.statusCode == 200) {
      getMessages(Get.context!, 1, orderId, false);
      _isLoading = false;
    }
    _imageFiles = [];
    _chatImage = [];
    _isSendButtonActive = false;
    notifyListeners();
    _isLoading = false;
    return response;
  }

  void toggleSendButtonActivity() {
    _isSendButtonActive = !_isSendButtonActive;
    notifyListeners();
  }

  void setImageList(List<XFile> images) {
    _imageFiles = [];
    _imageFiles = images;
    _isSendButtonActive = true;
    notifyListeners();
  }

  void setIsMe(bool value) {
    _isMe = value;
  }

  ConversationModel? _conversationModel;
  ConversationModel? get conversationModel => _conversationModel;


  Future<void> getAllConversationList(int offset, {bool isUpdate = true, String? search}) async {

    if(offset == 1) {
      _conversationModel = null;

      if(isUpdate) {
        notifyListeners();
      }
    }

    ApiResponseModel? response = await chatRepo?.getAllConversationList(offset, search: search);

    if (response?.response?.data != null && response?.response?.statusCode == 200) {
      if(offset == 1){
        _conversationModel = ConversationModel.fromMap(response?.response?.data);
      } else {
        _conversationModel?.totalSize = ConversationModel.fromMap(response?.response?.data).totalSize;
        _conversationModel?.offset = ConversationModel.fromMap(response?.response?.data).offset;
        _conversationModel?.deliverymanConversations?.addAll(ConversationModel.fromMap(response?.response?.data).deliverymanConversations ?? []);
      }

      notifyListeners();


    } else {
      ApiCheckerHelper.checkApi(response!);

    }

  }

  void onChangeChatOrderId(int? id, {bool isUpdate = true}) {
    _currentChatOrderId = id;

    if(isUpdate) {
      notifyListeners();
    }
  }


  void onChangeCurrentDeliveryMan(DeliveryMan? deliveryMan, {isUpdate = false}){
    _currentDeliveryMan = deliveryMan;

    if(isUpdate) {
      notifyListeners();
    }
  }



}