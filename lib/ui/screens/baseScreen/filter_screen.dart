import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/constants/appcolor.dart';
import 'package:grebooo/core/utils/sharedpreference.dart';

import '../../../core/constants/appSetting.dart';
import '../../../core/constants/app_assets.dart';
import '../../../main.dart';
import '../homeTab/controller/homeController.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  int SelectIndex = 1;
  double _currentSliderValue = getFilterData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'filter'.tr,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: kAppFont,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: IconButton(
            enableFeedback: false,
            icon: SvgPicture.asset(
              AppImages.back,
            ),
            onPressed: () {
              print(
                  "]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]${userController.user.following}");

              Get.back();
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "distance".tr,
                    style: TextStyle(
                      fontFamily: kAppFont,
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    (" ${_currentSliderValue.round().toString()} miles"),
                    style: TextStyle(
                      fontFamily: kAppFont,
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Slider(
                min: 25,
                max: 2000,
                activeColor: AppColor.categoriesColor,
                inactiveColor: Colors.grey.withOpacity(0.2),
                value: _currentSliderValue,
                divisions: 2000,
                label: (" ${_currentSliderValue.round().toString()} miles"),
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue = value;
                    print("********* ${_currentSliderValue}***********");
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "25 miles".tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: kAppFont,
                      color: Colors.black.withOpacity(0.70),
                    ),
                  ),
                  Text(
                    "2000 miles".tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: kAppFont,
                      color: Colors.black.withOpacity(0.70),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  containerBtn(
                    index: 1,
                    onTap: () {
                      //  print(_currentSliderValue.round().toString());
                      print(getFilterData());
                      Get.back();
                      addFilterData(_currentSliderValue);

                      print(
                          "*********////////// ${getFilterData()}////////////***********");

                      Get.find<HomeController>().distance = _currentSliderValue;
                      setState(() {
                        SelectIndex = 1;
                      });
                    },
                    txt: "apply".tr,
                  ),
                  SizedBox(width: 20),
                  containerBtn(
                    index: 2,
                    onTap: () {
                      _currentSliderValue = 25;
                      addFilterData(_currentSliderValue);
                      Get.find<HomeController>().distance = _currentSliderValue;
                      setState(() {
                        SelectIndex = 2;
                      });
                    },
                    txt: "clear".tr,
                  ),
                ],
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  containerBtn({
    void Function()? onTap,
    required String txt,
    required int index,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: SelectIndex == index
                    ? AppColor.kDefaultColor
                    : Colors.black54),
            borderRadius: BorderRadius.circular(50),
            color: SelectIndex == index ? AppColor.kDefaultColor : Colors.white,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 14, bottom: 10, left: 12, right: 12),
              child: Text(
                txt,
                style: TextStyle(
                  color: SelectIndex == index ? Colors.white : Colors.black,
                  fontFamily: kAppFont,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
