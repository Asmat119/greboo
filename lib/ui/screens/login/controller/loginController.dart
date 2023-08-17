import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:grebooo/core/service/auth/googleAuth.dart';
import 'package:grebooo/core/service/repo/userRepo.dart';
import 'package:grebooo/core/utils/keychain.dart';
import 'package:grebooo/core/utils/sharedpreference.dart';
import 'package:grebooo/core/viewmodel/controller/selectservicecontoller.dart';
import 'package:grebooo/main.dart';
import 'package:grebooo/ui/screens/baseScreen/baseScreen.dart';
import 'package:grebooo/ui/screens/editBusinessprofile/details1.dart';
import 'package:grebooo/ui/screens/homeTab/post_list_screen.dart';
import 'package:grebooo/ui/screens/login/model/currentUserModel.dart';
import 'package:grebooo/ui/screens/profile/profile.dart';
import 'package:grebooo/ui/shared/loader.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginController extends GetxController {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  RxBool showText = true.obs;
  CurrentUserModel? currentUserModel;

  Future userLogin() async {
    final ServiceController serviceController = Get.find<ServiceController>();
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    var response = await UserRepo.userLogin(
        email: email.text.trim(),
        password: password.text.trim(),
        userType:
            serviceController.servicesType == ServicesType.providerType ? 2 : 1,
        fcmToken: fcmToken.toString());
    if (response != null) {
      userController.isGuest = false;

      currentUserModel = CurrentUserModel.fromJson(response);
      saveUserDetails(currentUserModel!.data);
      print("***************edfasfasef********");
      print(currentUserModel!.data.user.toJson());
      if (currentUserModel!.data.user.userType ==
          getServiceTypeCode(ServicesType.providerType)) {
        if (currentUserModel!.data.user.firstAfterVerification) {
          Get.offAll(() => PostListScreen());
        } else if (currentUserModel!.data.user.profileCompleted) {
          Get.offAll(() => BaseScreen());
        } else {
          Get.offAll(() => DetailsPage1());
        }
      } else {
        Get.offAll(() => BaseScreen());
      }
    }
  }

  Future googleLogin() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.signOut();
    }
    LoadingOverlay.of().show();

    final ServiceController serviceController = Get.find<ServiceController>();
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    var response;
    if (fcmToken != null) {
      await GoogleAuth.signInWithGoogle().then((data) async {
        if (data != null) {
          User userFireBase = data["user"];
          response = await UserRepo.userSocialLogin(
              name: userFireBase.displayName.toString(),
              userType: getServiceTypeCode(serviceController.servicesType),
              email: userFireBase.email.toString(),
              fcmToken: fcmToken.toString(),
              image: userFireBase.photoURL.toString(),
              socialId: data["socialId"],
              socialToken: data["token"],
              socialIdentifier: getSocialIdentifier(SocialIdentifier.Google));
        }
        if (response != null) {
          userController.isGuest = false;
          currentUserModel = CurrentUserModel.fromJson(response);
          saveUserDetails(currentUserModel!.data);
          if (currentUserModel!.data.user.userType ==
              getServiceTypeCode(ServicesType.providerType)) {
            if (currentUserModel!.data.user.profileCompleted) {
              Get.offAll(() => BaseScreen());
            } else {
              Get.offAll(() => DetailsPage1());
            }
          } else {
            Get.offAll(() => BaseScreen());
          }
        }
        LoadingOverlay.of().hide();
      }).catchError((e) {
        LoadingOverlay.of().hide();
      });
    } else
      LoadingOverlay.of().hide();
  }

  Future appleLogin() async {
    LoadingOverlay.of().show();
    final ServiceController serviceController = Get.find<ServiceController>();
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    var response;
    if (fcmToken != null) {
      await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      ).catchError((e) async {
        LoadingOverlay.of().hide();
      }).then((credential) async {
        final cred = await getKeyChain();

        if (cred == null) {
          putKeyChain(name: credential.givenName, email: credential.email);
        }
        response = await UserRepo.userSocialLogin(
          name: credential.givenName ?? cred!["name"],
          userType: getServiceTypeCode(serviceController.servicesType),
          email: credential.email ?? cred!["email"],
          fcmToken: fcmToken.toString(),
          socialId: credential.userIdentifier.toString(),
          socialToken: credential.identityToken.toString(),
          socialIdentifier: getSocialIdentifier(SocialIdentifier.Apple),
        );
      });
    }

    if (response != null) {
      userController.isGuest = false;
      currentUserModel = CurrentUserModel.fromJson(response);
      saveUserDetails(currentUserModel!.data);
      if (currentUserModel!.data.user.userType ==
          getServiceTypeCode(ServicesType.providerType)) {
        if (currentUserModel!.data.user.profileCompleted) {
          Get.offAll(() => BaseScreen());
        } else {
          Get.offAll(() => DetailsPage1());
        }
      } else {
        Get.offAll(() => BaseScreen());
      }
    }
    LoadingOverlay.of().hide();
  }
}

enum SocialIdentifier { FaceBook, Google, Apple }

int getSocialIdentifier(SocialIdentifier socialIdentifier) {
  int code;
  switch (socialIdentifier) {
    case SocialIdentifier.FaceBook:
      code = 1;
      break;
    case SocialIdentifier.Google:
      code = 2;
      break;
    case SocialIdentifier.Apple:
      code = 3;
      break;
  }
  return code;
}
