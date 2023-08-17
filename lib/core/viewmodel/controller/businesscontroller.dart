import 'package:get/get.dart';
import 'package:grebooo/core/service/repo/postRepo.dart';

import 'package:grebooo/core/utils/appFunctions.dart';
import 'package:grebooo/main.dart';
import 'package:grebooo/ui/screens/login/model/currentUserModel.dart';


class BusinessController extends GetxController {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int value) {
    _currentIndex = value;
    update();
  }


  List<String> getAvailabilityDay = [];
  List<String> getCloseDay = [];

  String businessRefID = "";
  UserModel userModel = UserModel();
  updateUserModelList() {
    userModel = userController.user;
    update();
  }

  Future fetchUserDetail(String businessRef) async {
    businessRefID = businessRef;
    var response = await PostRepo.fetchUserDetail(businessRef: businessRef);
    if (response != null) {
      userModel = response;
      getAvailabilityDay.clear();
      for (int i = 0; i < userModel.workingDays.length; i++) {
        var v = userModel.workingDays[i] - 1;
        for (int j = 0; j < 7; j++) {
          if (v == j) {
            getAvailabilityDay.add(weekDayList[v]);
          }
        }
      }
      getCloseDay = weekDayList
          .where((element) => !getAvailabilityDay.contains(element))
          .toList();
      update();
    }
  }

  Future fetchUserDetail1(String businessRef) async {
    var response =
        await PostRepo.fetchUserDetail(businessRef: userController.user.id);
    if (response != null) {
      userModel = response;
    }
  }

  Future follow(bool isFollow) async {
    userModel.isFollow = isFollow;
    update();

    var response = await PostRepo.followProvider(businessRefID, isFollow);
    if (response != null) {
      flutterToast(userModel.isFollow ? 'followed'.tr : 'unfollowed'.tr);
    }
  }

}
