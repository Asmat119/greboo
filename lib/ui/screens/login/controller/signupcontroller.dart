import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/service/repo/userRepo.dart';
import 'package:grebooo/core/viewmodel/controller/selectservicecontoller.dart';
import 'package:grebooo/ui/global.dart';
import 'package:grebooo/ui/shared/loader.dart';

class SignUpController extends GetxController {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  RxBool showText = true.obs;
  RxBool showText2 = true.obs;

  bool _emailVer = true;

  bool get emailVer => _emailVer;

  set emailVer(bool value) {
    _emailVer = value;
    update();
  }

  Future userSignUp() async {
    final ServiceController serviceController = Get.find<ServiceController>();

    LoadingOverlay.of().show();
    var response = await UserRepo.userSignUp(
        email: email.text.trim(),
        name: name.text.trim(),
        password: password.text.trim(),
        image: appImagePicker.imagePickerController.image as File,
        userType: getServiceTypeCode(serviceController.servicesType));
    if (response != null) emailVer = false;

    LoadingOverlay.of().hide();
  }

  @override
  void dispose() {
    appImagePicker.imagePickerController.resetImage();
    super.dispose();
  }
}
