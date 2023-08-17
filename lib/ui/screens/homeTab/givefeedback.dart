import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/constants/appSetting.dart';
import 'package:grebooo/core/constants/app_assets.dart';
import 'package:grebooo/core/constants/appcolor.dart';
import 'package:grebooo/core/extension/customButtonextension.dart';
import 'package:grebooo/core/service/apiRoutes.dart';
import 'package:grebooo/core/utils/appFunctions.dart';
import 'package:grebooo/core/utils/config.dart';
import 'package:grebooo/core/viewmodel/controller/businesscontroller.dart';
import 'package:grebooo/core/viewmodel/controller/imagepickercontoller.dart';
import 'package:grebooo/ui/screens/homeTab/controller/feedbackController.dart';
import 'package:grebooo/ui/screens/homeTab/home.dart';
import 'package:grebooo/ui/shared/appbar.dart';
import 'package:grebooo/ui/shared/custombutton.dart';

class GiveFeedback extends StatefulWidget {
  final String businessRef;

  GiveFeedback({Key? key, required this.businessRef}) : super(key: key);

  @override
  _GiveFeedbackState createState() => _GiveFeedbackState();
}

class _GiveFeedbackState extends State<GiveFeedback> {
  final AppImagePicker appImagePicker = AppImagePicker();

  final FeedbackController feedbackController = Get.put(FeedbackController());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    appImagePicker.imagePickerController.resetImage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    feedbackController.businessRef = widget.businessRef;
    return Scaffold(
      appBar: appBar(title: 'give_feedback'.tr),
      body: Form(
        key: formKey,
        child: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: FadeInImage(
                    placeholder: AssetImage(AppImages.placeHolder),
                    image: NetworkImage(
                        "${imageUrl + Get.find<BusinessController>().userModel.picture}"),
                    height: 95,
                    width: 95,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        AppImages.placeHolder,
                        height: 95,
                        width: 95,
                        fit: BoxFit.cover,
                      );
                    },
                    fit: BoxFit.cover,
                  ),
                ),
                getHeightSizedBox(h: 21),
                Text(
                  "${'how_was..'.tr}\n${Get.find<BusinessController>().userModel.businessName}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: getProportionateScreenWidth(16)),
                ),
                getHeightSizedBox(h: 13),
                Text(
                  'your_feedback..'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: getProportionateScreenWidth(14),
                      color: AppColor.kDefaultFontColor.withOpacity(0.77)),
                ),
                getHeightSizedBox(h: 17),
                GetBuilder(
                  builder: (FeedbackController controller) {
                    return RatingBar.builder(
                      initialRating: controller.rating,
                      minRating: 1,
                      glow: false,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 33,
                      unratedColor: Color(0xffE8E8E8),
                      itemPadding: EdgeInsets.only(right: 5.0),
                      itemBuilder: (context, _) {
                        return Icon(
                          Icons.star,
                          color: Color(0xffFAAA01),
                        );
                      },
                      onRatingUpdate: (rating) {
                        feedbackController.rating = rating;
                      },
                    );
                  },
                ),
                getHeightSizedBox(h: 20),
                Divider(
                  thickness: 1,
                  height: 0,
                  //color: AppColor.kDefaultFontColor.withOpacity(0.09),
                ),
                getHeightSizedBox(h: 28),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'write_your..'.tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getProportionateScreenWidth(16)),
                      ),
                      getHeightSizedBox(h: 16),
                      TextFormField(
                        controller: feedbackController.description,
                        textInputAction: TextInputAction.done,
                        validator: (val) => val!.trim().isEmpty
                            ? "please_enter_review".tr
                            : null,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 2,
                        minLines: 1,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: AppColor.kDefaultFontColor.withOpacity(0.9),
                          )),
                          // hintStyle: TextStyle(
                          //     fontSize: getProportionateScreenWidth(14),
                          //     color: Color(0xff8F92A3)),
                          // hintText:
                          //     'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                        ),
                      ),
                      getHeightSizedBox(h: 16),
                      Text(
                        'upload_photo'.tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getProportionateScreenWidth(16)),
                      ),
                      getHeightSizedBox(h: 16),
                    ],
                  ),
                ),
                GetBuilder(
                  builder: (ImagePickerController controller) => MaterialButton(
                    onPressed: () {
                      appImagePicker.openBottomSheet();
                    },
                    padding: EdgeInsets.zero,
                    child: Container(
                      height: 130,
                      width: Get.width,
                      margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                      decoration: BoxDecoration(
                        //color: Colors.black,
                        border: controller.image != null
                            ? null
                            : Border.all(
                                color: Color(0xff747474).withOpacity(0.26),
                                width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: controller.image == null
                          ? Column(
                              children: [
                                Spacer(),
                                buildWidget(AppImages.uploadReview, 30, 32),
                                getHeightSizedBox(h: 13),
                                Text(
                                  'click_here'.tr,
                                  style: TextStyle(
                                      fontSize:
                                          getProportionateScreenWidth(14)),
                                ),
                                Spacer(),
                              ],
                            )
                          : Stack(
                              clipBehavior: Clip.none,
                              fit: StackFit.expand,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(controller.image!.path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                    right: -7,
                                    top: -7,
                                    child: GestureDetector(
                                        onTap: () {
                                          appImagePicker.imagePickerController
                                              .resetImage();
                                        },
                                        child: buildWidget(
                                            AppImages.close, 29, 29))),
                              ],
                            ),
                    ),
                  ),
                ),
                getHeightSizedBox(h: 87),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: CustomButton(
                      type: CustomButtonType.colourButton,
                      text: 'submit'.tr,
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          if (feedbackController.rating != 0.0) {
                            feedbackController.submitAllFields();
                          } else {
                            flutterToast("please_provide_rating".tr);
                          }
                        }
                      }),
                ),
                getHeightSizedBox(h: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
