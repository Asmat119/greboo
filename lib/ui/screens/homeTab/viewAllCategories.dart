import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/constants/app_assets.dart';
import 'package:grebooo/core/extension/customButtonextension.dart';
import 'package:grebooo/core/utils/config.dart';
import 'package:grebooo/main.dart';
import 'package:grebooo/ui/screens/homeTab/controller/homeController.dart';
import 'package:grebooo/ui/shared/appbar.dart';
import 'package:grebooo/ui/shared/custombutton.dart';

class ViewAll extends StatelessWidget {
  final HomeController homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'business_categories'.tr),
      body: Column(
        children: [
          Expanded(
            child: GetBuilder(
              builder: (HomeController controller) {
                return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: userController.globalCategory.length,
                    itemBuilder: (context, index) {
                      var catRef = userController.globalCategory[index].id;
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              userController.globalCategory[index].name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: getProportionateScreenWidth(15),
                              ),
                            ),
                            onTap: () {
                              controller.updateCategory(catRef);
                            },
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 25),
                            trailing:
                                controller.selectedCategory.contains(catRef)
                                    ? SvgPicture.asset(AppImages.checked)
                                    : SvgPicture.asset(AppImages.unchecked),
                          ),
                          Divider(
                            height: 0,
                          )
                        ],
                      );
                    });
              },
            ),
          ),
          SafeArea(
            child: CustomButton(
              type: CustomButtonType.colourButton,
              text: 'apply'.tr,
              onTap: () {
                Get.back();
              },
              padding: 30,
            ),
          ),
          getHeightSizedBox(h: 20)
        ],
      ),
    );
  }
}
