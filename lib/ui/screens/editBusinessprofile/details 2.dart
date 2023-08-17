import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:grebooo/core/constants/appSetting.dart';
import 'package:grebooo/core/constants/app_assets.dart';
import 'package:grebooo/core/constants/appcolor.dart';
import 'package:grebooo/core/extension/customButtonextension.dart';
import 'package:grebooo/core/extension/dateTimeFormatExtension.dart';
import 'package:grebooo/core/utils/appFunctions.dart';
import 'package:grebooo/core/utils/config.dart';
import 'package:grebooo/ui/screens/editBusinessprofile/controller/availabilitycontroller.dart';
import 'package:grebooo/ui/screens/homeTab/home.dart';
import 'package:grebooo/ui/shared/appbar.dart';
import 'package:grebooo/ui/shared/custombutton.dart';
import 'package:keyboard_actions/external/platform_check/platform_check.dart';

import 'details1.dart';

class DetailsPage2 extends StatelessWidget {
  final bool isNext;
  final AvailabilityController availabilityController =
      Get.put(AvailabilityController());

  DetailsPage2({Key? key, this.isNext = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (AvailabilityController controller) {
        return Scaffold(
          appBar: appBar(
            title: isNext ? 'set_availability'.tr : "edit_availability".tr,
            actions: [
              isNext
                  ? Padding(
                      padding: const EdgeInsets.only(top: 22, right: 25),
                      child: Text(
                        '2 of 3',
                        style: TextStyle(
                            color: AppColor.kDefaultFontColor.withOpacity(0.72),
                            fontSize: 15),
                      ),
                    )
                  : SizedBox()
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getHeightSizedBox(h: 10),
                header('select_working_days'.tr),
                getHeightSizedBox(h: 16),
                Container(
                  height: 70,
                  child: GridView.builder(
                      itemCount: weekDayList.length,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 4,
                          mainAxisSpacing: 16),
                      itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              if (controller.daysCount.contains(index + 1)) {
                                controller.removeDays(index + 1);
                              } else {
                                controller.addDays(index + 1);
                              }
                            },
                            child: Container(
                              color: Colors.transparent,
                              margin: EdgeInsets.only(right: 5),
                              child: Row(
                                children: [
                                  GetBuilder(
                                    builder: (AvailabilityController con) =>
                                        Container(
                                      width: 20,
                                      height: 20,
                                      decoration:
                                          con.daysCount.contains(index + 1)
                                              ? BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xff2C9344))
                                              : BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Color(0xff2C9344),
                                                      width: 1)),
                                      child: Center(
                                        child: Icon(
                                          Icons.check,
                                          size: 15.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  getHeightSizedBox(w: 5),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      weekDayList[index],
                                      style: TextStyle(
                                          fontSize:
                                              getProportionateScreenWidth(15),
                                          color: AppColor.kDefaultFontColor
                                              .withOpacity(0.80)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                ),
                getHeightSizedBox(h: 20),
                header('select_working_hours'.tr),
                getHeightSizedBox(h: 20),
                Row(
                  children: [
                    timeBox(
                      text: 'opening_hour'.tr,
                      context: context,
                      onTap: () {
                        if (PlatformCheck.isIOS) {
                          // DatePicker.showTime12hPicker(
                          //   context,
                          //   showTitleActions: true,
                          //   onChanged: (date) {},
                          //   onConfirm: (date) {
                          //     controller.defaultTime = dateFormat.format(date);
                          //     controller.startTime =
                          //         appTimeFunDB(TimeOfDay.fromDateTime(date));
                          //   },
                          // );
                        } else {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (context, widget) {
                              return MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(alwaysUse24HourFormat: false),
                                child: widget as Widget,
                              );
                            },
                          )..then((value) {
                              final localizations =
                                  MaterialLocalizations.of(context);
                              final formattedTimeOfDay =
                                  localizations.formatTimeOfDay(value!);
                              controller.defaultTime = formattedTimeOfDay;
                              controller.startTime = appTimeFunDB(value);
                            });
                        }
                      },
                      timeText: controller.defaultTime,
                    ),
                    getHeightSizedBox(w: 45),
                    timeBox(
                      text: 'closing_hour'.tr,
                      context: context,
                      onTap: () {
                        if (PlatformCheck.isIOS) {
                          // DatePicker.showTime12hPicker(
                          //   context,
                          //   showTitleActions: true,
                          //   onChanged: (date) {},
                          //   onConfirm: (date) {
                          //     controller.defaultTimeEnd =
                          //         dateFormat.format(date);
                          //
                          //     controller.endTime =
                          //         appTimeFunDB(TimeOfDay.fromDateTime(date));
                          //   },
                          // );
                        } else {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (context, widget) {
                              return MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(alwaysUse24HourFormat: false),
                                child: widget as Widget,
                              );
                            },
                          )..then((value) {
                              final localizations =
                                  MaterialLocalizations.of(context);
                              final formattedTimeOfDay =
                                  localizations.formatTimeOfDay(value!);
                              controller.defaultTimeEnd = formattedTimeOfDay;
                              controller.endTime = appTimeFunDB(value);
                            });
                        }
                      },
                      timeText: controller.defaultTimeEnd,
                    )
                  ],
                ),
                Spacer(),
                SafeArea(
                    child: CustomButton(
                  text: isNext ? 'next'.tr : 'save'.tr,
                  onTap: () {
                    // ("START ${DateTime.parse(controller.startTime)}");
                    // debugPrint("END ${DateTime.parse(controller.endTime)}");
                    // print(
                    //     "COMPARE ${DateTime.parse(controller.startTime).compareTo(DateTime.parse(controller.endTime))}");
                    // if (DateTime.parse(controller.startTime)
                    //         .compareTo(DateTime.parse(controller.endTime)) <
                    //     0) {
                    //   debugPrint("Start time must be before end time");
                    //   return;
                    // }
                    controller.submitAllFields(isNext);
                    //
                    // if (controller.defaultTime != "00:00 AM" &&
                    //     controller.defaultTimeEnd != "00:00 PM") {
                    //   if (controller.daysCount.isNotEmpty) {
                    //     controller.submitAllFields(isNext);
                    //   } else {
                    //     flutterToast('please_select_working_days');
                    //   }
                    // } else {
                    //   flutterToast('please_select_working_hours');
                    // }
                  },
                  type: CustomButtonType.colourButton,
                )),
                getHeightSizedBox(h: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget timeBox(
    {required String text,
    required Function()? onTap,
    required BuildContext context,
    required String timeText}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        text,
        style: TextStyle(
            color: AppColor.kDefaultFontColor.withOpacity(0.85),
            fontSize: getProportionateScreenWidth(14)),
      ),
      GestureDetector(
          onTap: onTap,
          child: SizedBox(
            width: 110,
            height: 40,
            child: DropdownButtonFormField(
              items: [],
              hint: Text(
                timeText,
                style: TextStyle(
                    fontSize: getProportionateScreenWidth(15),
                    color: AppColor.kDefaultFontColor),
              ),
              icon: buildWidget(AppImages.dropdownCloseBlack, 7, 15),
              onChanged: (dynamic value) => value,
            ),
          )),
    ],
  );
}
