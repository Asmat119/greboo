import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/constants/appSetting.dart';
import 'package:grebooo/core/constants/app_assets.dart';
import 'package:grebooo/core/constants/appcolor.dart';
import 'package:grebooo/core/extension/customButtonextension.dart';
import 'package:grebooo/core/utils/appFunctions.dart';
import 'package:grebooo/core/utils/config.dart';
import 'package:grebooo/core/viewmodel/controller/imagepickercontoller.dart';
import 'package:grebooo/ui/screens/login/controller/signupcontroller.dart';
import 'package:grebooo/ui/screens/login/login.dart';
import 'package:grebooo/ui/shared/appbar.dart';
import 'package:grebooo/ui/shared/custombutton.dart';
import 'package:grebooo/ui/shared/customtextfield.dart';
import 'package:grebooo/ui/shared/postview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../global.dart';

class SignUp extends StatelessWidget {
  final bool isBack;
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  final SignUpController signUpController = Get.put(SignUpController());

  SignUp({Key? key, required this.isBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        disposeKeyboard();
      },
      child: GetBuilder(
        builder: (SignUpController controller) {
          if (controller.emailVer) {
            return Scaffold(
              appBar: appBar(title: 'register'.tr),
              body: Form(
                key: globalKey,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        profileUpload(context),
                        getHeightSizedBox(h: 28),
                        header(
                          'name'.tr,
                        ),
                        nameField(),
                        getHeightSizedBox(h: 18),
                        header(
                          'email'.tr,
                        ),
                        emailField(),
                        getHeightSizedBox(h: 18),
                        header(
                          'password'.tr,
                        ),
                        passwordField(),
                        getHeightSizedBox(h: 18),
                        header(
                          'confirm_password'.tr,
                        ),
                        confirmPasswordField(),
                        getHeightSizedBox(h: 150),
                        CustomButton(
                            type: CustomButtonType.colourButton,
                            text: 'Signup'.tr,
                            onTap: () {
                              if (globalKey.currentState!.validate()) {
                                if (!appImagePicker
                                    .imagePickerController.image.isNull) {
                                  globalKey.currentState!.save();
                                  signUpController.userSignUp();
                                } else {
                                  flutterToast("select_image".tr);
                                }
                              }
                            }),
                        getHeightSizedBox(h: 20),
                        toLoginText(),
                        getHeightSizedBox(h: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding),
                          child: RichText(
                            text: TextSpan(children: [
                              tcText1('by_sign_up_in'.tr),
                              tcText2('terms_of_service'.tr, onTap: () async {
                                if (!await launch(
                                    "http://gogrebooo.com/terms-and-conditions"))
                                  throw 'Could not launch ';
                              }),
                              tcText1('and'.tr),
                              tcText2('privacy_policy'.tr, onTap: () async {
                                if (!await launch(
                                    "http://gogrebooo.com/privacy-policy"))
                                  throw 'Could not launch ';
                              }),
                            ]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        getHeightSizedBox(h: 40)
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: getProportionateScreenWidth(171),
                      width: getProportionateScreenWidth(171),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        AppImages.emailVer,
                        fit: BoxFit.fill,
                      ),
                    ),
                    getHeightSizedBox(h: 28),
                    Text(
                      'email_verify..'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                          fontSize: getProportionateScreenWidth(20)),
                    ),
                    getHeightSizedBox(h: 30),
                    CustomButton(
                        type: CustomButtonType.colourButton,
                        text: 'ok'.tr,
                        onTap: () {
                          isBack ? Get.back() : Get.off(() => LoginScreen());

                          controller.emailVer = true;
                        }),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Center toLoginText() {
    return Center(
      child: Wrap(
        children: [
          Text('already_have'.tr,
              style: TextStyle(
                  color: AppColor.kDefaultFontColor.withOpacity(0.4),
                  fontWeight: FontWeight.bold,
                  fontSize: getProportionateScreenWidth(15))),
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Text('login'.tr,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: getProportionateScreenWidth(15))),
          )
        ],
      ),
    );
  }

  Obx confirmPasswordField() {
    return Obx(
      () => CustomTextField(
        controller: signUpController.confirmPassword,
        validator: (val) => val!.trim().isEmpty
            ? "please_enter_password".tr
            : signUpController.password.text.trim() == val
                ? null
                : 'password_not_matched'.tr,
        textInputAction: TextInputAction.done,
        hintText: 'XXXXXXXX',
        suffixWidth: 40,
        //keyboardType: TextInputType.visiblePassword,
        obSecureText: signUpController.showText2.value,
        suffix: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            signUpController.showText2.toggle();
          },
          icon: Text(
            signUpController.showText2.value ? 'show'.tr : 'hide'.tr,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Obx passwordField() {
    return Obx(() => CustomTextField(
          controller: signUpController.password,
          suffixWidth: 40,
          textInputAction: TextInputAction.next,
          hintText: 'XXXXXXXX',
          validator: (val) =>
              val!.trim().isEmpty ? "please_enter_password".tr : null,
          //  keyboardType: TextInputType.visiblePassword,
          obSecureText: signUpController.showText.value,
          suffix: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              signUpController.showText.toggle();
            },
            icon: Text(
              signUpController.showText.value ? 'show'.tr : 'hide'.tr,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }

  emailField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (val) => val!.trim().isEmpty
          ? "please_enter_email".tr
          : val.isValidEmail()
              ? null
              : 'please_enter_valid_email'.tr,
      textCapitalization: TextCapitalization.none,
      controller: signUpController.email,
      hintText: 'johnsmith@gmail.com',
    );
  }

  nameField() {
    return CustomTextField(
      controller: signUpController.name,
      validator: (val) => val!.trim().isEmpty ? "please_enter_name".tr : null,
      textInputAction: TextInputAction.next,
      hintText: 'John smith',
      textCapitalization: TextCapitalization.sentences,
    );
  }



  profileUpload(BuildContext context) {
    return
      GetBuilder(
      builder: (ImagePickerController controller) {
        return Center(
          child: Container(
            child: GestureDetector(
              onTap: () {
                disposeKeyboard();
                appImagePicker.openBottomSheet();
              },
              child: appImagePicker.imagePickerController.image == null
                  ? Container(
                      height: 94,
                      width: 94,
                      child: SvgPicture.asset(
                        AppImages.upload,
                        fit: BoxFit.fill,
                      ),
                    )
                  : uploadProfile(
                      image: appImagePicker.imagePickerController.image!.path, height: 94, width: 94),
            ),
          ),
        );
      },
    );
  }
}
