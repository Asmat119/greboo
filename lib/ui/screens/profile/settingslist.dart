import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/constants/appSetting.dart';
import 'package:grebooo/core/constants/appcolor.dart';
import 'package:grebooo/core/utils/config.dart';
import 'package:grebooo/ui/screens/profile/controller/aboutUsController.dart';
import 'package:grebooo/ui/shared/appbar.dart';

class AboutUsAndTAndC extends StatefulWidget {
  const AboutUsAndTAndC({
    Key? key,
  }) : super(key: key);

  @override
  _AboutUsAndTAndCState createState() => _AboutUsAndTAndCState();
}

class _AboutUsAndTAndCState extends State<AboutUsAndTAndC> {
  bool response = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'about_us'.tr),
      body: GetBuilder(
        builder: (AboutUsController controller) =>
            controller.aboutUs == null && controller.tc == null
                ? Center(
                    child: GetPlatform.isIOS
                        ? CupertinoActivityIndicator()
                        : CircularProgressIndicator(
                            strokeWidth: 2,
                          ))
                : ListView(
                    physics: BouncingScrollPhysics(),
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding)
                            .copyWith(top: 5),
                    children: [
                      Text(
                        controller.aboutUs.toString(),
                        style: TextStyle(
                            height: 1.3,
                            color: AppColor.kDefaultFontColor.withOpacity(0.81),
                            fontSize: getProportionateScreenWidth(15)),
                      ),
                    ],
                  ),
      ),
    );
  }
}
