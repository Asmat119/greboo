import 'package:geocoding/geocoding.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/service/repo/postRepo.dart';
import '../../main.dart';
import '../../ui/global.dart';
import '../../ui/screens/login/model/currentUserModel.dart';




final sharedPreference = GetStorage();

saveUserDetails(Datum data) {
  userController.user = data.user;
  userController.userToken = data.accessToken;
  sharedPreference.write("greboooUser", data.user.toJson());
  sharedPreference.write("UserToken", data.accessToken);
  sharedPreference.write("isUserLogin", true);
}

String getUserToken() {
  return sharedPreference.read("UserToken") ?? "";
}

isUserLogin() {
  if (sharedPreference.read("isUserLogin") == null) {
    return false;
  }
  bool value = sharedPreference.read("isUserLogin");
  return value;
}

saveUserLastLateLong(double late, double long) {
  sharedPreference.write("userLate", late);
  sharedPreference.write("userLong", long);
}

Location readLastLateLong() {
  return Location(
      latitude: sharedPreference.read("userLate"),
      longitude: sharedPreference.read("userLong"),
      timestamp: DateTime.now());
}

onBoardingHide() {
  sharedPreference.write("HideOnBoarding", true);
}

bool onBoardingHideRead() {
  if (sharedPreference.read("HideOnBoarding") == null) {
    return false;
  } else
    return true;
}

//    FILTER SLADER
addFilterData(double radius) {
  sharedPreference.write("FilterData", radius);
}

double getFilterData() {
  if (sharedPreference.read("FilterData") == null) {
    return 25;
  } else
    return sharedPreference.read("FilterData");
}

updateUserDetail(UserModel user) async {
  userController.user = user;
  sharedPreference.write("greboooUser", user.toJson());
}

removerUserDetail() async {
  sharedPreference.remove("greboooUser");
  sharedPreference.remove("UserToken");
  sharedPreference.remove("userLate");
  sharedPreference.remove("userLong");
  sharedPreference.remove("isUserLogin");
}

Future<UserModel> getUserDetail() async {
  var userData = sharedPreference.read("greboooUser");
  var userToken = sharedPreference.read("UserToken");

  if (userData == null) {
    navigationScreen = false;
  } else {
    navigationScreen = true;
    userController.user = UserModel.fromJson(userData);
    userController.userToken = userToken;
    if (!userController.user.verifiedByAdmin) {
      final p =
          await PostRepo.fetchUserDetail(businessRef: userController.user.id);
      if (p != null) {
        if (p.verifiedByAdmin) {
          updateUserDetail(p);
        }
        return p;
      }
    }
  }
  return UserModel();
}
