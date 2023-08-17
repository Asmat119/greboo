import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/constants/appSetting.dart';
import 'package:grebooo/core/constants/appcolor.dart';
import 'package:grebooo/core/utils/config.dart';
import 'customtextfield.dart';

Future<void> showCustomDialog({
  required BuildContext context,
  double? height,
  String? title,
  required String content,
  required double contentSize,
  required Function()? onTap,
  required Color color,
  required String okText,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)), //this right here
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: FittedBox(
            child: Container(
              width: Get.width,
              child: Column(
                children: [
                  getHeightSizedBox(h: 20),
                  title == null
                      ? SizedBox()
                      : Text(
                          title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: getProportionateScreenWidth(17)),
                        ),
                  getHeightSizedBox(h: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      content,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 1.4,
                        fontSize: getProportionateScreenWidth(contentSize),
                      ),
                    ),
                  ),
                  getHeightSizedBox(h: 39),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: MaterialButton(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      onPressed: onTap,
                      child: Text(
                        okText,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: getProportionateScreenWidth(15)),
                      ),
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}





Future<void> showCustomDialog1({
  required BuildContext context,
  double? height,
  String? title,
  required String content,
  required double contentSize,
  required Function()? noonTap,
  required Function()? yesonTap,
  required Color color,
  required String okText,
  required String noText,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)), //this right here
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: FittedBox(
            child: Container(
              width: Get.width,
              child: Column(
                children: [
                  getHeightSizedBox(h: 20),
                  title == null
                      ? SizedBox()
                      : Text(
                          title,
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontFamily: kAppFont,
                            fontWeight: FontWeight.w700,
                            fontSize: getProportionateScreenWidth(17),
                          ),
                        ),
                  getHeightSizedBox(h: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      content,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 1.4,
                        fontFamily: kAppFont,
                        fontSize: getProportionateScreenWidth(contentSize),
                      ),
                    ),
                  ),
                  getHeightSizedBox(h: 39),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: Row(
                      children: [
                        MaterialButton(
                          minWidth: MediaQuery.of(context).size.width / 2,
                          height: 100,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          onPressed: noonTap,
                          child: Text(
                            okText,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: kAppFont,
                                fontSize: getProportionateScreenWidth(16)),
                          ),
                          color: Colors.white,
                        ),
                        MaterialButton(
                          minWidth: MediaQuery.of(context).size.width / 2,
                          height: 100,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          onPressed: yesonTap,
                          child: Text(
                            noText,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: kAppFont,
                              fontWeight: FontWeight.bold,
                              fontSize: getProportionateScreenWidth(16),
                            ),
                          ),
                          color: color,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

/// ---------------------------------------------------- ///


Future<void> dialogueOpen(
    {context,
    Function()? onOk,
    Function()? onCancel,
    required TextEditingController controller}) async {
    return showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: FittedBox(
        child: Container(
          width: Get.width,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 23),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getHeightSizedBox(h: 5),
                    Text(
                      'enter_website_url'.tr,
                      style:
                          TextStyle(fontSize: getProportionateScreenWidth(18)),
                    ),
                    getHeightSizedBox(h: 20),
                    CustomTextField(
                      controller: controller,
                      hintText: 'www.businessurl.com',
                      inputBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColor.kDefaultFontColor)),
                      textSize: 16,
                    ),
                  ],
                ),
                getHeightSizedBox(h: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    getButtons(
                        text: 'cancel'.tr,
                        onTap: onCancel,
                        color: AppColor.kDefaultFontColor.withOpacity(0.66)),
                    getButtons(text: 'add'.tr, onTap: onOk),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget getButtons({Function()? onTap, required String text, Color? color}) {
  return TextButton(
    onPressed: onTap,
    child: Text(
      text,
      style: TextStyle(
          fontSize: getProportionateScreenWidth(15),
          color: color == null ? AppColor.kDefaultFontColor : color),
    ),
  );
}
