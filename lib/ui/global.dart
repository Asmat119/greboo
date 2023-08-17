import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/service/googleAdd/addServices.dart';
import 'package:grebooo/core/viewmodel/controller/imagepickercontoller.dart';
import 'package:grebooo/main.dart';
import 'package:grebooo/ui/screens/homeTab/home.dart';
import 'package:grebooo/ui/screens/messagesTab/allmessages.dart';
import 'package:grebooo/ui/screens/notifications/notifications.dart';
import 'package:grebooo/ui/screens/profile/profile.dart';
import 'package:grebooo/ui/shared/userController.dart';

import 'screens/homeTab/widget/guestLoginView.dart';

List<Widget> tabNavigation = [
  Home(),
  AllMessages(),
  AllNotification(),
  ProfileScreen(),
];
List<Widget> tabNavigationForGuest = [
  Home(),
  GuestLoginView(),
  GuestLoginView(),
  GuestLoginView(),
];
late AppImagePicker appImagePicker;

globalVerbsInit() async {
  userController = Get.put(UserController());
  appImagePicker = AppImagePicker();
  // GoogleAddService.createInterstitialAd();
}

int initialTab = 0;
bool navigationScreen = false;

networkImageShow(String url) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(11),
    child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            )),
        errorWidget: (context, url, error) => Container()),
  );
}

networkImageShow1(String url) {
  return CachedNetworkImage(
    imageUrl: url,
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
          colorFilter: const ColorFilter.mode(
            Colors.red,
            BlendMode.colorBurn,
          ),
        ),
      ),
    ),
    // placeholder: (context, url) =>
    // const CircularProgressIndicator(),
    //errorWidget: (context, url, error) => const Icon(Icons.error),
  );
}

networkImageShow2(String url) {
  return CachedNetworkImageProvider(url);
}
