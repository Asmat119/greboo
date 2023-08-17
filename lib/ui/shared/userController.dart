import 'dart:developer';

import 'package:get/get.dart';
import 'package:grebooo/core/utils/appFunctions.dart';
import 'package:grebooo/core/utils/sharedpreference.dart';

import '../../core/service/repo/postRepo.dart';
import '../../main.dart';
import '../screens/login/model/currentUserModel.dart';

class UserController extends GetxController {
  UserModel _user = UserModel();

  UserModel get user => _user;

  set user(UserModel value) {
    _user = value;
    updateDetails();
    update();
  }

  String _userToken = "";

  String get userToken => _userToken;

  set userToken(String value) {
    _userToken = value;
    update();
  }

  bool _isGuest = false;

  bool get isGuest => _isGuest;

  set isGuest(bool value) {
    _isGuest = value;
    update();
  }

  late List<Category> _globalCategory;

  List<Category> get globalCategory => _globalCategory;

  set globalCategory(List<Category> value) {
    _globalCategory = value;
    update();
  }

  List<String> getAvailabilityDay = [];
  List<String> getCloseDay = [];

  void updateDetails() {
    getAvailabilityDay.clear();
    for (int i = 0; i < user.workingDays.length; i++) {
      var v = user.workingDays[i] - 1;
      for (int j = 0; j < 7; j++) {
        if (v == j) {
          getAvailabilityDay.add(weekDayList[v]);
        }
      }
    }
    getCloseDay = weekDayList
        .where((element) => !getAvailabilityDay.contains(element))
        .toList();
  }

  UserModel userModel = UserModel();
  Future fetchUserDetail1() async {
    log("fetchUserDetail1.....");
    // if (userController.user.id == "") {
    //   return;
    // }
    await getUserDetail();
    var response =
        await PostRepo.fetchUserDetail(businessRef: userController.user.id);
    if (response != null) {
      updateUserDetail(response);
      userModel = response;
      update();
    }
  }
}
