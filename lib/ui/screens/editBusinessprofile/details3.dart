import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/constants/appSetting.dart';
import 'package:grebooo/core/constants/appcolor.dart';
import 'package:grebooo/core/extension/customButtonextension.dart';
import 'package:grebooo/core/utils/config.dart';
import 'package:grebooo/ui/screens/editBusinessprofile/controller/addservicecontroller.dart';
import 'package:grebooo/ui/shared/appbar.dart';
import 'package:grebooo/ui/shared/custombutton.dart';

import 'details1.dart';

class DetailsPage3 extends StatelessWidget {
  final bool isNext;
  final AddServiceController addServiceController =
      Get.put(AddServiceController());

  DetailsPage3({Key? key, this.isNext = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // addServiceController.addDefault();
    return Scaffold(
        appBar: appBar(
          title: 'add_services_offered'.tr,
          actions: [
            isNext
                ? Padding(
                    padding: const EdgeInsets.only(top: 22, right: 25),
                    child: Text(
                      '3 of 3',
                      style: TextStyle(
                          color: AppColor.kDefaultFontColor.withOpacity(0.72),
                          fontSize: 15),
                    ),
                  )
                : SizedBox()
          ],
        ),
        body: GetBuilder<AddServiceController>(
          builder: (controller) {
            return Stack(
              fit: StackFit.expand,
              children: [
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...List.generate(controller.addServiceViews.length,
                          (index) {
                        return controller.addServiceViews[index];
                      }),
                      GestureDetector(
                        onTap: () {
                          disposeKeyboard();
                          controller.add();
                        },
                        child: Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.symmetric(vertical: 5),
                          margin: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding),
                          child: header('add_more_service'.tr),
                        ),
                      ),
                      getHeightSizedBox(h: 100)
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.white,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30)
                            .copyWith(top: 10, bottom: 10),
                        child: CustomButton(
                            type: CustomButtonType.colourButton,
                            text: isNext ? 'submit'.tr : 'save'.tr,
                            onTap: () {
                              disposeKeyboard();
                              //      if (addServiceController.validateForm()) {
                              controller.submitAllFields(isNext);
                              // } else {
                              //   Get.offAll(() => BaseScreen());
                              // }
                            }),
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ));
  }
}
