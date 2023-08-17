import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:grebooo/core/constants/app_assets.dart';
import 'package:grebooo/core/constants/appcolor.dart';
import 'package:grebooo/ui/screens/baseScreen/controller/baseController.dart';
import 'package:grebooo/ui/screens/homeTab/home.dart';

class BuildBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(builder: (BaseController controller) {
      List<Widget> iconData = [
        buildWidget(
          controller.currentTab == 0 ? AppImages.homeActive : AppImages.home,
          20.59,
          20.59,
        ),
        buildWidget(
          controller.currentTab == 1 ? AppImages.chatActive : AppImages.chat,
          20.59,
          23.39,
        ),
        buildWidget(
          controller.currentTab == 2
              ? AppImages.notificationActive
              : AppImages.notification,
          20.41,
          17.01,
        ),
        buildWidget(
          controller.currentTab == 3
              ? AppImages.profileActive
              : AppImages.profile,
          20,
          17,
        ),
      ];
      return BottomAppBar(
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.bottomShitColor,
            boxShadow: [
              BoxShadow(
                color: AppColor.kDefaultFontColor.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          height: 55,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              4,
              (index) => GestureDetector(
                onTap: () {
                  // if (index == 3) {
                  //   Get.to(() => PostListScreen());
                  // }
                },
                child: Container(
                  height: double.infinity,
                  width: MediaQuery.of(context).size.width / 4,
                  color: controller.currentTab == index
                      ? Colors.white
                      : Colors.transparent,
                  child: IconButton(
                    onPressed: () {
                      controller.currentTab = index;
                    },
                    icon: iconData[index],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
