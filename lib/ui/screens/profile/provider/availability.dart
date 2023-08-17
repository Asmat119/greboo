import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/constants/appSetting.dart';
import 'package:grebooo/core/constants/app_assets.dart';
import 'package:grebooo/core/constants/appcolor.dart';
import 'package:grebooo/core/utils/config.dart';
import 'package:grebooo/ui/screens/editBusinessprofile/details%202.dart';
import 'package:grebooo/ui/screens/editBusinessprofile/details1.dart';
import 'package:grebooo/ui/screens/homeTab/home.dart';
import 'package:grebooo/ui/shared/appbar.dart';
import 'package:grebooo/ui/shared/userController.dart';

class Availability extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'availability'.tr, actions: [
        IconButton(onPressed: () {}, icon: SizedBox()),
        IconButton(
            padding: EdgeInsets.only(right: 22),
            onPressed: () {
              Get.to(() => DetailsPage2(isNext: false));
            },
            icon: buildWidget(AppImages.editProfile, 19, 19))
      ]),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getHeightSizedBox(h: 5),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: header('working_days'.tr),
          ),
          getHeightSizedBox(h: 16),
          GetBuilder(
            builder: (UserController controller) => buildContainer(
              Column(
                children: [
                  getHeightSizedBox(h: 20),
                  buildWidget(AppImages.workingDays, 91, 100),
                  getHeightSizedBox(h: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 70),
                    child: Text(
                      "${controller.getAvailabilityDay.join(", ")}",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: getProportionateScreenWidth(18)),
                    ),
                  ),
                  getHeightSizedBox(h: 23),
                ],
              ),
            ),
          ),
          getHeightSizedBox(h: 28),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: header('working_hours'.tr),
          ),
          getHeightSizedBox(h: 16),
          GetBuilder(
            builder: (UserController controller) {
              return buildContainer(Column(
                children: [
                  getHeightSizedBox(h: 20),
                  buildWidget(AppImages.workingHours, 91, 100),
                  getHeightSizedBox(h: 15),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Spacer(),
                        Column(
                          children: [
                            Text(
                              'starts'.tr,
                              style: TextStyle(
                                  fontSize: getProportionateScreenWidth(15),
                                  color: AppColor.kDefaultFontColor
                                      .withOpacity(0.78)),
                            ),
                            Text(
                              dateFormat.format(
                                  DateTime.parse(controller.user.startTime)
                                      .toLocal()),
                              style: TextStyle(
                                  fontSize: getProportionateScreenWidth(16),
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Spacer(),
                        VerticalDivider(
                          width: 0,
                        ),
                        Spacer(),
                        Column(
                          children: [
                            Text(
                              'end'.tr,
                              style: TextStyle(
                                  fontSize: getProportionateScreenWidth(15),
                                  color: AppColor.kDefaultFontColor
                                      .withOpacity(0.78)),
                            ),
                            Text(
                              dateFormat.format(
                                  DateTime.parse(controller.user.endTime)
                                      .toLocal()),
                              style: TextStyle(
                                  fontSize: getProportionateScreenWidth(16),
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  getHeightSizedBox(h: 23),
                ],
              ));
            },
          )
        ],
      ),
    );
  }

  Container buildContainer(Widget child) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
        width: Get.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Color(0xffEDEDED), offset: Offset(0, 1), blurRadius: 6)
            ]),
        child: child);
  }
}
