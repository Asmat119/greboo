import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/service/apiHandler.dart';
import 'package:grebooo/core/service/apiRoutes.dart';
import 'package:grebooo/core/utils/sharedpreference.dart';
import 'package:grebooo/core/viewmodel/controller/selectservicecontoller.dart';
import 'package:grebooo/main.dart';
import 'package:grebooo/ui/screens/baseScreen/controller/baseController.dart';
import 'package:grebooo/ui/screens/selectservice.dart';

class UserRepo {
  static Future userLogin({
    required String email,
    required String password,
    required String fcmToken,
    required int userType,
  }) async {
    var responseBody = await API.apiHandler(
      url: APIRoutes.userLogin,
      header: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {
          "email": email,
          "password": password,
          "device": Platform.isAndroid ? "android" : "ios",
          "userType": userType,
          "fcmToken": fcmToken,
        },
      ),
    );
    if (responseBody != null)
      return responseBody;
    else
      return null;
  }

  static Future userSocialLogin({
    required String name,
    required int userType,
    required String email,
    required String fcmToken,
    String? image,
    required String socialId,
    required String socialToken,
    required int socialIdentifier,
  }) async {
    var responseBody = await API.apiHandler(
        url: APIRoutes.socialLogin,
        header: {
          'Content-Type': 'application/json',
        },
        showLoader: false,
        body: jsonEncode(
          {
            "socialIdentifier": socialIdentifier,
            "email": email,
            "userType": userType,
            "name": name,
            "device": Platform.isAndroid ? "android" : "ios",
            "fcmToken": fcmToken,
            "image": image,
            "referralId": "",
            "socialId": socialId,
            "socialToken": socialToken,
          },
        ));
    if (responseBody != null)
      return responseBody;
    else
      return null;
  }

  static Future userSignUp({
    required String email,
    required String name,
    required String password,
    required File image,
    required int userType,
  }) async {
    var responseBody =
        await API.multiPartAPIHandler(url: APIRoutes.userSignUp, field: {
      "data": jsonEncode({
        "email": email,
        "password": password,
        "userType": userType,
        "name": name
      })
    }, fileImage: [
      image
    ]);
    if (responseBody != null)
      return responseBody;
    else
      return null;
  }

  static Future userForgotPassword({
    required String email,
    required int userType,
  }) async {
    var responseBody = await API.apiHandler(
      url: APIRoutes.emailVerification,
      requestType: RequestType.Post,
      header: {
        //'Content-Type': contentType(ContentType.jsonType),
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {"email": email, "requestType": 2, "userType": userType},
      ),
    );
    if (responseBody != null) return responseBody;
  }

  static Future reportUser({
    required String id,
    required int userType,
  }) async {
    var responseBody = await API.apiHandler(
      url: APIRoutes.reportAdd,
      requestType: RequestType.Post,
      header: {
        "Authorization": userController.userToken,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {"userRef": id, "userType": userType},
      ),
    );

    if (responseBody != null) return responseBody;
  }

  static Future userLogout() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.signOut();
    }
    removerUserDetail();
    Get.find<BaseController>().resetInitialTab();
    Get.offAll(() => ChooseServices());
  }
}

int getServiceTypeCode(ServicesType servicesType) {
  int code;
  switch (servicesType) {
    case ServicesType.userType:
      code = 1;
      break;
    case ServicesType.providerType:
      code = 2;
      break;
  }
  return code;
}
