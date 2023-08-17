import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/constants/app_assets.dart';
import 'package:grebooo/core/constants/appcolor.dart';
import 'package:grebooo/core/extension/customButtonextension.dart';
import 'package:grebooo/core/utils/config.dart';
import 'package:grebooo/core/viewmodel/controller/selectservicecontoller.dart';
import 'package:grebooo/ui/shared/custombutton.dart';
import 'login/login.dart';

class ChooseServices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(gradient: AppColor.kGradient),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: Get.width,
                        height: getProportionateScreenHeight(245),
                        child: SvgPicture.asset(
                          AppImages.splashBackground,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                          height: getProportionateScreenHeight(133),
                          child: SvgPicture.asset(AppImages.splashLogo))
                    ],
                  ),
                  Spacer(
                    flex: 3,
                  )
                ],
              )),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25))),
                child: GetBuilder(
                  builder: (ServiceController controller) {
                    return Column(
                      children: [
                        getHeightSizedBox(h: 48),
                        Text(
                          'how_would..'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: getProportionateScreenWidth(24)),
                        ),
                        getHeightSizedBox(h: 21),
                        CustomButton(
                            type: CustomButtonType.colourButton,
                            width: getProportionateScreenWidth(316),
                            text: 'user'.tr,
                            onTap: () {
                              controller.servicesType = ServicesType.userType;

                              Get.to(() => LoginScreen());
                            }),
                        getHeightSizedBox(h: 16),
                        CustomButton(
                            type: CustomButtonType.borderButton,
                            width: getProportionateScreenWidth(316),
                            text: 'service_provider'.tr,
                            onTap: () {
                              controller.servicesType =
                                  ServicesType.providerType;

                              Get.to(() => LoginScreen());
                            }),
                        getHeightSizedBox(h: 40),
                      ],
                    );
                  },
                ),
              )),
        ],
      ),
    );
  }
}
