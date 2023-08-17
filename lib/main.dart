import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grebooo/core/constants/app_theme.dart';
import 'package:grebooo/core/service/googleAdd/addHandler.dart';
import 'package:grebooo/core/viewmodel/controller/selectservicecontoller.dart';
import 'package:grebooo/ui/global.dart';
import 'package:grebooo/ui/screens/baseScreen/controller/baseController.dart';
import 'package:grebooo/ui/screens/baseScreen/controller/createPostController.dart';
import 'package:grebooo/ui/screens/homeTab/controller/postDetailController.dart';
import 'package:grebooo/ui/screens/homeTab/post_list_screen.dart';
import 'package:grebooo/ui/screens/onbording.dart';
import 'package:grebooo/ui/screens/profile/controller/ProfileChangeController.dart';
import 'package:grebooo/ui/screens/selectservice.dart';
import 'package:grebooo/ui/shared/userController.dart';
import 'package:grebooo/ui/shared/utils_notification.dart';
import 'package:keyboard_actions/external/platform_check/platform_io.dart';

import 'package:permission_handler/permission_handler.dart';
import 'core/service/repo/editProfileRepo.dart';
import 'core/service/repo/userRepo.dart';
import 'core/utils/lang.dart';
import 'core/utils/sharedpreference.dart';
import 'core/viewmodel/controller/imagepickercontoller.dart';
import 'ui/screens/baseScreen/baseScreen.dart';
import 'ui/screens/editBusinessprofile/details1.dart';
import 'ui/shared/controller/delete_controller.dart';

late UserController userController;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}
const bool isProduction = bool.fromEnvironment('dart.vm.product');
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (isProduction) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }
  // WidgetsFlutterBinding.ensureInitialized();
  //--Firebase initialize
  await  Firebase.initializeApp();

  //--Google Add initialize
  // GoogleAddHandler.initialize();
  globalVerbsInit();

  await GetStorage.init();
  if (isUserLogin()) {
    await userController.fetchUserDetail1();
  }
  print("=============== Get User Detail ===============");
  // listen for background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // firebase messaging
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  // request for notification permission
  // only applicable for iOS, Mac, Web. For the Android the result is always authorized.
  // ignore: unused_local_variable
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  // initialize the notifications
  // if (!kIsWeb) {
    // ic_notification is a drawable source added in the Android
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
     DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);
    final FlutterLocalNotificationsPlugin plugin =
    FlutterLocalNotificationsPlugin();

    // initialise the plugin

    await plugin.initialize(initializationSettings,
     onDidReceiveNotificationResponse: onDidReceiveNotificationResponse
    );

    // await plugin.initialize(initializationSettings,
    //     onDidReceiveNotificationResponse: (String? payload) async {
    //       // notification tapped
    //       if (payload != null) {
    //         Map<String, dynamic> data = jsonDecode(payload);
    //         await NotificationUtils().handleNotificationData(data);
    //       }
    //     });
  //
  //   // create the channel
    await plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
        NotificationUtils().androidNotificationChannel);
  // }
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  userController.globalCategory = await EditProfileRepo.getCategories();

  final ImagePickerController imagePickerController = Get.put(ImagePickerController());



  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final BaseController baseController = Get.put(BaseController());
  final AddPostController postController = Get.put(AddPostController());
  @override
  void initState() {
    accessLocation();
    super.initState();
  }
  Future accessLocation()async{
    if(Platform.isIOS){
      print("IOS platform");
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.locationAlways
        //add more permission to request here.
      ].request();
      return statuses;
    }else{
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.locationAlways
        //add more permission to request here.
      ].request();
      return statuses;
    }

  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return GetMaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: child as Widget,
      ),
      initialBinding: BaseBinding(),
      debugShowCheckedModeBanner: false,
      title: 'grebo',
      // home: navigationRoute(),
      // home: OnBoarding(),
      home: navigationScreen
          ? userController.user.userType ==
          getServiceTypeCode(ServicesType.userType) //user
          ? BaseScreen()
          : userController.user.firstAfterVerification
          ? PostListScreen()
          : userController.user.profileCompleted //provider
          ? BaseScreen()
          : DetailsPage1()
          : onBoardingHideRead()
          ? ChooseServices()
          : OnBoarding(),
      translations: Lang(),
      theme: AppTheme.defTheme,
      locale: Locale('en', 'US'), //Localizations.localeOf(context),
      fallbackLocale: Locale('en', 'US'),
    );
  }

  navigationRoute() {
    if (navigationScreen) {
      if (userController.user.profileCompleted ||
          userController.user.userType ==
              getServiceTypeCode(ServicesType.userType)) {
        BaseScreen();
      } else {
        if (userController.user.userType ==
          getServiceTypeCode(ServicesType.providerType)) {
        if (userController.user.firstAfterVerification) {
          const PostListScreen();
        } else if (!userController.user.profileCompleted) {
          DetailsPage1();
        } else {
          BaseScreen();
        }
      }
      }
    } else {
      if (onBoardingHideRead()) {
        ChooseServices();
      } else {
        OnBoarding();
      }
    }
  }
}

class BaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ServiceController(), fenix: true);
    Get.lazyPut(() => DeleteController(), fenix: true);
    Get.lazyPut(() => PostDetailController(), fenix: true);
    Get.lazyPut(() => ProfileChangeController(), fenix: true);
  }
}

void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
  final String payload = notificationResponse.payload!;
  if (notificationResponse.payload != null) {
    debugPrint('notification payload: $payload');

    Map<String, dynamic> data = jsonDecode(payload);
            await NotificationUtils().handleNotificationData(data);
  }
  // await Navigator.push(
  //   context,
  //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
  // );
}
