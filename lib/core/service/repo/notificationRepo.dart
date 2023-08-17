import 'package:grebooo/ui/screens/notifications/model/notificationModel.dart';

import '../../../main.dart';
import '../apiHandler.dart';
import '../apiRoutes.dart';

class NotificationRepo {
  static Future<NotificationModel?> fetchNotification(int page) async {
    var response = await API.apiHandler(
        url: APIRoutes.notificationList,
        showLoader: false,
        header: {
          "Authorization": userController.userToken,
        },
        body: {
          "page": "${page.toString()}"
        });
    if (response != null) {
      return NotificationModel.fromJson(response);
    } else
      return null;
  }

  static Future readNotification(String id) async {
    var response = await API.apiHandler(
        url: APIRoutes.notificationSeen,
        showToast: false,
        showLoader: false,
        header: {
          "Authorization": userController.userToken,
        },
        body: {
          "notificationId": id
        });
    if (response != null) {
      return response;
    } else
      return null;
  }
}
