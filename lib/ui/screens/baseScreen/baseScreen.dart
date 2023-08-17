import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';


import 'package:grebooo/core/constants/app_assets.dart';
import 'package:grebooo/core/service/googleAdd/addServices.dart';
import 'package:grebooo/core/service/repo/userRepo.dart';
import 'package:grebooo/core/viewmodel/controller/selectservicecontoller.dart';
import 'package:grebooo/main.dart';
import 'package:grebooo/ui/screens/baseScreen/controller/baseController.dart';
import 'package:grebooo/ui/screens/baseScreen/filter_screen.dart';
import 'package:grebooo/ui/screens/homeTab/controller/homeController.dart';
import 'package:grebooo/ui/screens/homeTab/controller/postDetailController.dart';
import 'package:grebooo/ui/screens/homeTab/provider/likeerror.dart';
import 'package:grebooo/ui/screens/messagesTab/controller/allChatController.dart';
import 'package:grebooo/ui/screens/notifications/controller/allNotificationController.dart';
import 'package:grebooo/ui/shared/bottomabar.dart';
import 'package:grebooo/ui/shared/doubleTaptoback.dart';
import 'package:grebooo/ui/shared/location.dart';
import 'package:grebooo/ui/shared/utils_notification.dart';
import '../../../core/constants/appcolor.dart';
import '../../global.dart';
import '../homeTab/home.dart';
import '../homeTab/provider/createpost.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final BaseController baseController = Get.find<BaseController>();
  final HomeController homeController = Get.put(HomeController());
  final AllChatController allChatController = Get.put(AllChatController());
  final NotificationController notificationController = Get.put(NotificationController());
  final GetCurrentLocation locationController = Get.put(GetCurrentLocation());

  @override
  void initState() {
    Get.lazyPut(() => PostDetailController(), fenix: true);
    NotificationUtils().handleAppLunchLocalNotification();

    if (userController.user.userType ==
        getServiceTypeCode(ServicesType.userType)) {
      locationController.determinePosition().then((value) {
        print("ADDRESS"+baseController.address);
        baseController.getAddressFromLatLong(
          LatLongCoordinate(latitude: value.latitude, longitude: value.longitude),
        );

      }).catchError((e) {

        if (userController.user.location.coordinates[0] != 0.0 &&
            userController.user.location.coordinates[1] != 0.0) {

          baseController.getAddressFromLatLong(
            LatLongCoordinate(
              latitude: userController.user.location.coordinates[1],
              longitude: userController.user.location.coordinates[0],
            ),
          );

        }
      });
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      await NotificationUtils().handleNotificationData(message.data);
    });
    // listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // received the message while the app was foreground
      // here the notification is not shown automatically.
      await NotificationUtils().handleNewNotification(message, false);
    });
    FirebaseMessaging.instance.getInitialMessage().then((value) async {
      if (value != null) {
        await NotificationUtils().handleNotificationData(value.data);
      }
    });



    // GoogleAddService.showInterstitialAd();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DoubleBackToCloseApp(
      child: Scaffold(
        appBar: buildAppBar(),
        body: GetBuilder(
          builder: (BaseController controller) {
            return IndexedStack(
              index: controller.currentTab,
              children: userController.isGuest
                  ? tabNavigationForGuest
                  : tabNavigation,
            );
          },
        ),
        bottomNavigationBar: BuildBottomBar(),
        floatingActionButton: userController.user.userType ==
                getServiceTypeCode(ServicesType.providerType)
            ? floatingAction()
            : SizedBox(),
      ),
    );
  }

  floatingAction() {
    return GetBuilder(
      builder: (BaseController controller) => controller.currentTab == 0
          ? GestureDetector(
              onTap: () {
                if (userController.user.verifiedByAdmin) {
                  Get.to(() => CreatePost());
                } else {
                  Get.to(() => LikeError());
                }
              },
              child: buildWidget(AppImages.create, 50, 50),
            )
          : SizedBox(),
    );
  }

  AppBar buildAppBar() {
    List<String> appTitle = [
      'grebo'.tr,
      'messages'.tr,
      'notifications'.tr,
      'profile'.tr
    ];

    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      title: GetBuilder(
        builder: (BaseController controller) => Align(
          alignment: Alignment.centerLeft,
          child: Text(
            appTitle[controller.currentTab],
            style: TextStyle(color:AppColor.categoriesColor, fontWeight: FontWeight.bold,fontSize: 22),
          ),
        ),
      ),
      actions: [
        GetBuilder(
          builder: (BaseController controller) => controller.currentTab == 0
              ? GestureDetector(
                  onTap: () {
                    Get.to(() => FilterScreen());
                  },
                  child: SvgPicture.asset(AppImages.filter),
                )
              : SizedBox(),
        ),
        SizedBox(width: 21),
      ],
    );
  }
}


