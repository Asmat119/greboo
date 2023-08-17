import 'package:get/get.dart';
import 'package:grebooo/core/service/repo/editProfileRepo.dart';
import 'package:grebooo/ui/screens/login/model/currentUserModel.dart';


class ServiceOfferedController extends GetxController {
  late bool isNextPost;
  ServiceOfferedController() {
    isNextPost = true;
  }
  String? userRef;
  Future<List<ServiceList>> getServices(int offset) async {
    if (offset == 0) isNextPost = true;
    if (isNextPost == false) return [];
    List<ServiceList> allServices = [];
    var request = await EditProfileRepo.getServices(userRef: userRef);
    allServices =
        List.from(request["data"].map((x) => ServiceList.fromJson(x)));
    isNextPost = request["hasMore"];
    return allServices;
  }
}
