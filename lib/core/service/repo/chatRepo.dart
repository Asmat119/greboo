import 'dart:convert';

import 'package:grebooo/main.dart';
import 'package:grebooo/ui/screens/messagesTab/model/chatListModel.dart';
import 'package:grebooo/ui/screens/messagesTab/model/messageModel.dart';

import '../apiHandler.dart';
import '../apiRoutes.dart';

class ChatRepo {
  static Future getChannel(String businessRef) async {
    var responseBody = await API.apiHandler(
        url: APIRoutes.getChannel,
        showLoader: false,
        header: {
          'Content-Type': 'application/json',
          "Authorization": userController.userToken
        },
        body: jsonEncode({"userId": businessRef}));
    if (responseBody != null)
      return responseBody;
    else
      return null;
  }

  static Future<MessageModel?> getAllMessages(
      {required String channelRef, required int page}) async {
    var responseBody = await API.apiHandler(
        url: APIRoutes.getMessages,
        showLoader: false,
        header: {
          'Content-Type': 'application/json',
          "Authorization": userController.userToken
        },
        body: jsonEncode({"channelRef": channelRef, "page": page}));
    if (responseBody != null)
      return MessageModel.fromJson(responseBody);
    else
      return null;
  }

  static Future<ChatListModel?> getAllChatLIst(int page) async {
    var responseBody = await API.apiHandler(
        url: APIRoutes.messageList,
        showLoader: false,
        header: {"Authorization": userController.userToken},
        body: jsonEncode({"page": page}));
    if (responseBody != null)
      return ChatListModel.fromJson(responseBody);
    else
      return null;
  }
}
