import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/constants/appSetting.dart';
import 'package:grebooo/core/constants/app_assets.dart';
import 'package:grebooo/core/constants/appcolor.dart';
import 'package:grebooo/core/extension/customButtonextension.dart';
import 'package:grebooo/core/utils/config.dart';
import 'package:grebooo/core/utils/sharedpreference.dart';
import 'package:grebooo/core/viewmodel/controller/onboadingController.dart';
import 'package:grebooo/ui/screens/selectservice.dart';
import 'package:grebooo/ui/shared/custombutton.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  OnBoardingController onBoardingController = Get.put(OnBoardingController());
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: Get.width,
              height: getProportionateScreenHeight(361),
              child: SvgPicture.asset(
                AppImages.onBoardingBackground,
                fit: BoxFit.fill,
              ),
            ),
          ),
          SafeArea(child: GetBuilder(
            builder: (OnBoardingController controller) {
              return Column(
                children: [
                  Expanded(
                    child: PageView(
                      physics: BouncingScrollPhysics(),
                      children: [
                        buildColumn(AppImages.onBoardingBackground1,
                            'onBoarding_title1'.tr),
                        buildColumn(AppImages.onBoardingBackground2,
                            'onBoarding_title2'.tr),
                        buildColumn(AppImages.onBoardingBackground3,
                            'onBoarding_title3'.tr),
                      ],
                      controller: pageController,
                      onPageChanged: (val) {
                        controller.index = val;
                      },
                    ),
                  ),
                  getHeightSizedBox(h: 10),
                  buildPagination(),
                  getHeightSizedBox(h: 35),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: Row(
                      children: [
                        InkWell(
                            onTap: () {
                              onBoardingHide();
                              Get.offAll(() => ChooseServices());
                            },
                            child: Container(
                              height: 40,
                              width: 50,
                              //  color: Colors.red,
                              child: Center(
                                child: Text(
                                  'skip'.tr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          getProportionateScreenWidth(15)),
                                ),
                              ),
                            )),
                        Spacer(),
                        CustomButton(
                          width: getProportionateScreenWidth(155),
                          text: 'next'.tr,
                          type: CustomButtonType.colourButton,
                          onTap: () {
                            if (onBoardingController.index == 3 - 1) {
                              onBoardingHide();
                              Get.offAll(() => ChooseServices());
                            } else {
                              pageController.nextPage(
                                duration: kOnBoardingPageAnimationDuration,
                                curve: Curves.ease,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  getHeightSizedBox(h: 16),
                ],
              );
            },
          ))
        ],
      ),
    );
  }

  Widget buildColumn(String image, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Column(
        children: [
          Spacer(),
          SvgPicture.asset(image),
          Spacer(),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(20),
            ),
          ),
          SizedBox(
            height: getProportionateScreenHeight(15),
          )
        ],
      ),
    );
  }

  buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
          3,
          (index) => AnimatedContainer(
                duration: kOnBoardingPageAnimationDuration,
                margin: EdgeInsets.only(right: index == 3 - 1 ? 0 : 10),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: index == onBoardingController.index
                      ? AppColor.kDefaultColor
                      : AppColor.kDefaultColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
              )),
    );
  }
}
