import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/constants/appcolor.dart';
import 'package:grebooo/core/service/repo/userRepo.dart';
import 'package:grebooo/core/utils/config.dart';
import 'package:grebooo/core/viewmodel/controller/selectservicecontoller.dart';
import 'package:grebooo/ui/shared/alertdialogue.dart';

class ForgotPasswordController extends GetxController {
  final TextEditingController email = TextEditingController();

  Future userForgotPassword() async {
    final ServiceController serviceController = Get.find<ServiceController>();

    var response = await UserRepo.userForgotPassword(
        email: email.text.trim(),
        userType: getServiceTypeCode(serviceController.servicesType));
    if (response != null) {
      showCustomDialog(
          context: Get.context as BuildContext,
          color: AppColor.kDefaultColor,
          content: 'a_link_to..'.tr,
          contentSize: 16,
          okText: 'ok'.tr,
          onTap: () {
            Get.back();
            Get.back();
          },
          height: getProportionateScreenWidth(180));
    }
  }
}
