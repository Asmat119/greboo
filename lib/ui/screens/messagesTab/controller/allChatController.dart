import 'package:get/get.dart';
import 'package:grebooo/core/service/repo/chatRepo.dart';
import 'package:grebooo/ui/screens/messagesTab/model/chatListModel.dart';

class AllChatController extends GetxController {
  int page = 1;

  AllChatController() {
    page = 1;
  }
  List<AllChatData> getChatList = [];
  Future<List<AllChatData>> fetchAllChatList(int offset) async {
    if (offset == 0) {
      page = 1;
      getChatList.clear();
    }
    if (page == -1) return [];
    var request = await ChatRepo.getAllChatLIst(page);
    var temp = request!.data;
    getChatList.addAll(temp);
    page = request.hasMore ? page + 1 : -1;
    return temp;
  }

  realAllMessagesLocally(AllChatData allChatData) {
    // String lastMsg=allChatD.lastMessage.message;
    allChatData.unreadCount = 0;
    // allChatData.lastMessage.message=allChatD.lastMessage.message;
    update();
  }
}
