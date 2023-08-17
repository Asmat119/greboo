import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

double getProportionateScreenHeight(double inputHeight) {
  // 812 is the layout height that designer use
  return (inputHeight / 812.0) * Get.height;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * Get.width;
}

SizedBox getHeightSizedBox({double? h, double? w}) {
  return SizedBox(
    height: h == null ? null : getProportionateScreenHeight(h),
    width: w == null ? null : getProportionateScreenWidth(w),
  );
}
