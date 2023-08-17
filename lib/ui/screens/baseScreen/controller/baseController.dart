import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/utils/sharedpreference.dart';
import 'package:grebooo/main.dart';
import 'package:grebooo/ui/global.dart';
import 'package:grebooo/ui/screens/messagesTab/allmessages.dart';
import 'package:grebooo/ui/screens/notifications/notifications.dart';
import 'package:grebooo/ui/shared/location.dart';

import '../../homeTab/home.dart';


class BaseController extends GetxController {
  double latitude = 0;
  double longitude = 0;

  int _current = initialTab;

  int get currentTab => _current;

  set currentTab(int value) {
    _current = value;
    if (value == 1) {
      if (!userController.isGuest) {
        AllMessages.paginationKey.currentState!.refresh();
      }
    } else if (value == 2) {
      if (!userController.isGuest) {
        AllNotification.paginationKey.currentState!.refresh();
      }
    } else if (value == 3) {
      if (userController.user.id != "") {
        userController.fetchUserDetail1();
      }
    }
    update();
  }


  resetInitialTab() {
    currentTab = 0;
  }

  String _address = "";

  String get address => _address;

  set address(String value) {
    _address = value;
    update();
  }

  String _baseAddress = "";

  String get baseAddress => _baseAddress;

  set baseAddress(String value) {
    _baseAddress = value;
    update();
  }


  changeAddress(double lat, double long, String address) {
    this.latitude = lat;
    this.longitude = long;
    this.address = address;
    Home.paginationViewKey.currentState!.refresh();
  }

  getAddressFromLatLong(LatLongCoordinate locationData) async {
    if (!locationData.isNull) {
      saveUserLastLateLong(locationData.latitude!.toDouble(),
          locationData.longitude!.toDouble());
    }
    double? lat = locationData.latitude ?? readLastLateLong.call().latitude;
    double? long = locationData.longitude ?? readLastLateLong.call().longitude;

    List<Placemark> placeMarks =
        await placemarkFromCoordinates(lat.toDouble(), long.toDouble());
    Placemark place = placeMarks[0];
    changeAddress(lat, long,
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}');
  }
}
