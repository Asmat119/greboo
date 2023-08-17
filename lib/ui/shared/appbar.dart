import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/constants/app_assets.dart';

AppBar appBar(
    {required String title,
    bool isBackButtonShow = true,
    List<Widget>? actions}) {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    leadingWidth: 50,
    automaticallyImplyLeading: false,
    leading: isBackButtonShow
        ? IconButton(
            splashRadius: 10,
            focusNode: FocusNode(canRequestFocus: false),
            enableFeedback: false,
            icon: SvgPicture.asset(
              AppImages.back,
            ),
            onPressed: () {
              Get.back();
            },
          )
        : SizedBox(),
    //titleSpacing: 200,
    actions: actions == null ? [] : actions,
    title: Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Text(
        title,
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    ),
    backgroundColor: Colors.white,
  );
}
