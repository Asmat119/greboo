import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/constants/appSetting.dart';
import 'package:grebooo/core/constants/app_assets.dart';
import 'package:grebooo/core/service/repo/userRepo.dart';
import 'package:grebooo/core/utils/config.dart';
import 'package:grebooo/ui/screens/homeTab/businessprofile.dart';
import 'package:grebooo/ui/screens/homeTab/home.dart';
import 'package:grebooo/ui/screens/profile/contactAdminScreen.dart';
import 'package:grebooo/ui/screens/profile/settingslist.dart';
import 'package:grebooo/ui/shared/appbar.dart';
import 'package:keyboard_actions/external/platform_check/platform_check.dart';
import 'package:url_launcher/url_launcher.dart';

import 'controller/aboutUsController.dart';
import 'faqs.dart';

class Settings extends StatefulWidget {
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final AboutUsController aboutUsController = Get.put(AboutUsController());

  @override
  void initState() {
    aboutUsController.aboutTheApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> list = [
      {
        'image': buildWidget(AppImages.aboutUs, 20, 20),
        'title': 'about_us'.tr,
      },
      {
        'image': buildWidget(AppImages.terms, 20, 20),
        'title': 'terms'.tr,
      },
      {
        'image': Image.asset(
          AppImages.privacyPolicy,
          height: 20,
          width: 20,
        ),
        'title': 'privacy_policy'.tr,
      },
      {
        'image': buildWidget(AppImages.contactAdmin, 20, 20),
        'title': 'contact_admin'.tr,
      },
      {
        'image': buildWidget(AppImages.faqs, 20, 20),
        'title': 'faqs'.tr,
      },
      {
        'image': buildWidget(AppImages.logOut, 20, 20),
        'title': 'logOut'.tr,
      },
    ];
    return Scaffold(
      appBar: appBar(title: 'settings'.tr),
      body: Column(
        children: List.generate(
            6,
            (index) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () async {
                          if (index == 0) {
                            Get.to(() => AboutUsAndTAndC());
                          } else if (index == 1) {
                            debugPrint(aboutUsController.tc!);
                            if (await canLaunch(
                                "http://gogrebooo.com/terms-and-conditions")) {
                              await launch(
                                  "http://gogrebooo.com/terms-and-conditions");
                            }

                            // if (aboutUsController.tc != null) {
                            //   if (await canLaunch(aboutUsController.tc!)) {
                            //     await launch(aboutUsController.tc!);
                            //   }
                            // } else {
                            //   aboutUsController
                            //       .aboutTheApp()
                            //       .then((value) async {
                            //     if (await canLaunch(aboutUsController.tc!)) {
                            //       await launch(aboutUsController.tc!);
                            //     }
                            //   });
                            // }
                          } else if (index == 2) {
                            // if (aboutUsController.tc != null) {
                            //   if (await canLaunch(
                            //       aboutUsController.privacyPolicy!)) {
                            //     await launch(aboutUsController.privacyPolicy!);
                            //   }
                            // } else {
                            //   aboutUsController
                            //       .aboutTheApp()
                            //       .then((value) async {
                            //     if (await canLaunch(
                            //         aboutUsController.privacyPolicy!)) {
                            //       await launch(
                            //           aboutUsController.privacyPolicy!);
                            //     }
                            //   });
                            // }
                            if (await canLaunch(
                                "http://gogrebooo.com/privacy-policy")) {
                              await launch("http://gogrebooo.com/privacy-policy");
                            }
                          } else if (index == 3) {
                            Get.to(() => ContactAdminScreen());
                          } else if (index == 4) {
                            Get.to(() => Faqs());
                          } else if (index == 5) {
                            logoutConfirmation(yesTap: () {
                              UserRepo.userLogout();
                            });
                          }
                        },
                        contentPadding: EdgeInsets.zero.copyWith(top: 2),
                        horizontalTitleGap: 0,
                        leading: list[index]['image'],
                        title: Text(
                          list[index]['title'],
                          style: TextStyle(
                              fontSize: getProportionateScreenWidth(17)),
                        ),
                        trailing: list[index]['title'] != 'logOut'.tr
                            ? buildWidget(AppImages.next, 17, 9)
                            : SizedBox(),
                      ),
                      Divider(
                        height: 2,
                        thickness: 1,
                      )
                    ],
                  ),
                )),
      ),
    );
  }
}

logoutConfirmation({required Function() yesTap}) {
  showDialog(
    context: Get.context as BuildContext,
    builder: (ctx) => PlatformCheck.isAndroid
        ? AlertDialog(
            title: Text("logout".tr),
            content: Text("logOutMsg".tr),
            actions: <Widget>[
              TextButton(
                onPressed: yesTap,
                child: Text("yes".tr),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text("no".tr),
              ),
            ],
          )
        : CupertinoAlertDialog(
            title: new Text("logout".tr),
            content: new Text("logOutMsg".tr),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: yesTap,
                child: Text("logoutPop".tr),
              ),
              CupertinoDialogAction(
                child: Text(
                  "cancel".tr,
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Get.back();
                },
              )
            ],
          ),
  );
}

Future lunchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
