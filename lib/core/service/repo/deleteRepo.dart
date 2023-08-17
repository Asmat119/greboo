import 'dart:convert';
import '../../../main.dart';
import '../../models/successModel.dart';
import '../apiHandler.dart';
import '../apiRoutes.dart';

class DeleteRepo {
  static Future<DeletePost?> getDelete({required String postRef}) async {
    var responseBody = await API.apiHandler(
        url: APIRoutes.postDelete,
        showLoader: true,
        requestType: RequestType.Post,
        header: {
          "Authorization": userController.userToken,
          "Content-Type": 'application/json',
        },
        body: json.encode({"postRef": postRef}));

    if (responseBody != null) {
      print(responseBody);
      return DeletePost.fromJson(responseBody);
    }
    return null;
  }
}
