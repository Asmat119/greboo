import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/constants/appSetting.dart';
import 'package:grebooo/core/constants/appcolor.dart';
import 'package:grebooo/core/extension/customButtonextension.dart';
import 'package:grebooo/core/utils/appFunctions.dart';
import 'package:grebooo/core/utils/config.dart';
import 'package:grebooo/ui/screens/editBusinessprofile/controller/reportController.dart';
import 'package:grebooo/ui/screens/profile/contactAdminController.dart';
import 'package:grebooo/ui/shared/appbar.dart';
import 'package:grebooo/ui/shared/custombutton.dart';

class ReportScreen extends StatelessWidget {
  final String reportId;
  final TextEditingController reportText = TextEditingController();
  final ReportController reportController = Get.put(ReportController());

  ReportScreen({Key? key, required this.reportId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'report'.tr),
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
              controller: reportText,
              textInputAction: TextInputAction.go,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  hintText: 'report_a_user'.tr,
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
                text: 'submit'.tr,
                onTap: () {
                  disposeKeyboard();
                  if (reportText.text.trim().isNotEmpty) {
                    reportController.reportUser(reportId);
                  } else {
                    flutterToast("please_enter_word".tr);
                  }
                }),
          )
        ],
      )),
    );
  }
}
