import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/constants/appSetting.dart';
import 'package:grebooo/core/constants/appcolor.dart';
import 'package:grebooo/core/extension/customButtonextension.dart';
import 'package:grebooo/core/utils/appFunctions.dart';
import 'package:grebooo/core/utils/config.dart';
import 'package:grebooo/ui/screens/profile/contactAdminController.dart';
import 'package:grebooo/ui/shared/appbar.dart';
import 'package:grebooo/ui/shared/custombutton.dart';

class ContactAdminScreen extends StatelessWidget {
  final TextEditingController helpText = TextEditingController();
  final ContactAdminController contactAdminController =
      Get.put(ContactAdminController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'contact_admin'.tr),
      body: SingleChildScrollView(
          child: Column(
        children: [
          getHeightSizedBox(h: 10),
          Container(
            height: 187,
            margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            width: Get.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xffC4C4C4))),
            child: TextField(
              controller: helpText,
              textInputAction: TextInputAction.go,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  hintText: 'how_can_we_help'.tr,
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                      color: AppColor.kDefaultFontColor,
                      fontSize: getProportionateScreenWidth(16))),
            ),
          ),
          getHeightSizedBox(h: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: CustomButton(
                type: CustomButtonType.colourButton,
                text: 'save'.tr,
                onTap: () {
                  disposeKeyboard();
                  if (helpText.text.trim().isNotEmpty) {
                    contactAdminController.helpText = helpText.text.trim();
                    helpText.clear();
                    contactAdminController.conatctAdmin();
                  } else {
                    flutterToast("please_enter_a_word".tr);
                  }
                }),
          )
        ],
      )),
    );
  }
}
