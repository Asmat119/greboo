import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grebooo/core/constants/appSetting.dart';
import 'package:grebooo/core/constants/app_assets.dart';
import 'package:grebooo/core/extension/customButtonextension.dart';
import 'package:grebooo/core/utils/config.dart';
import 'package:get/get.dart';
import 'package:grebooo/ui/screens/login/login.dart';
import 'package:grebooo/ui/screens/login/signup.dart';
import 'package:grebooo/ui/shared/custombutton.dart';

class GuestLoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Column(
        children: [
          Spacer(),
          SvgPicture.asset(
            AppImages.guestLogin,
            height: getProportionateScreenWidth(220),
          ),
          Spacer(),
          Text(
            'sign_in_sign_up'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: getProportionateScreenWidth(24),
                fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'please_signup'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: getProportionateScreenWidth(14),
                color: Colors.black.withOpacity(0.70),
              ),
            ),
          ),
          Spacer(),
          CustomButton(
              type: CustomButtonType.colourButton,
              text: 'signup'.tr,
              onTap: () {
                Get.to(() => SignUp(isBack: false));
              }),
          SizedBox(height: 15),
          CustomButton(
              type: CustomButtonType.borderButton,
              text: 'login'.tr,
              onTap: () {
                Get.to(() => LoginScreen());
              }),
          Spacer(),
        ],
      ),
    );
  }
}
