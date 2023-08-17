import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/constants/appSetting.dart';
import 'package:grebooo/core/extension/customButtonextension.dart';
import 'package:grebooo/core/utils/config.dart';
import 'package:grebooo/ui/screens/login/controller/forgotPasswordController.dart';
import 'package:grebooo/ui/shared/appbar.dart';
import 'package:grebooo/ui/shared/custombutton.dart';
import 'package:grebooo/ui/shared/customtextfield.dart';

class ForgotPassword extends StatelessWidget {
  final ForgotPasswordController forgotPasswordController =
      Get.put(ForgotPasswordController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        disposeKeyboard();
      },
      child: Scaffold(
        appBar: appBar(title: 'forgot_password'.tr),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: Get.height / 1.2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'enter_your_email..'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: getProportionateScreenWidth(20)),
                        ),
                        getHeightSizedBox(h: 39),
                        Text(
                          'e_mail'.tr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: getProportionateScreenWidth(16)),
                        ),
                        Get.height < 800
                            ? getHeightSizedBox(h: 10)
                            : SizedBox(),
                        CustomTextField(
                          controller: forgotPasswordController.email,
                          hintText: 'email_example'.tr,
                          validator: (val) => val!.trim().isEmpty
                              ? 'enter_email'.tr
                              : val.isValidEmail()
                                  ? null
                                  : 'invalid_email'.tr,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        getHeightSizedBox(h: 50),
                        CustomButton(
                            type: CustomButtonType.colourButton,
                            text: 'submit'.tr,
                            onTap: () {
                              disposeKeyboard();
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                forgotPasswordController.userForgotPassword();
                              }
                            }),
                        getHeightSizedBox(h: 70)
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
