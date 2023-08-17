import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/constants/appSetting.dart';
import 'package:grebooo/core/constants/app_assets.dart';
import 'package:grebooo/core/constants/appcolor.dart';
import 'package:grebooo/core/extension/customButtonextension.dart';
import 'package:grebooo/core/service/apiRoutes.dart';
import 'package:grebooo/core/service/repo/userRepo.dart';
import 'package:grebooo/core/utils/appFunctions.dart';
import 'package:grebooo/core/utils/config.dart';
import 'package:grebooo/core/viewmodel/controller/selectservicecontoller.dart';
import 'package:grebooo/main.dart';
import 'package:grebooo/ui/screens/editBusinessprofile/controller/editprofilecontroller.dart';
import 'package:grebooo/ui/screens/homeTab/home.dart';
import 'package:grebooo/ui/shared/alertdialogue.dart';
import 'package:grebooo/ui/shared/appbar.dart';
import 'package:grebooo/ui/shared/custombutton.dart';
import 'package:grebooo/ui/shared/customtextfield.dart';
import 'package:grebooo/ui/shared/doubleTaptoback.dart';
import 'package:grebooo/ui/shared/loader.dart';
import 'package:grebooo/ui/shared/placeScreen.dart';

import '../../global.dart';

class DetailsPage1 extends StatelessWidget {
  final bool isNext;

  final EditBProfileController editProfileController =
      Get.put(EditBProfileController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  DetailsPage1({Key? key, this.isNext = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    editProfileController.isNext = isNext;
    if (userController.userModel.location.coordinates.length == 2) {
      editProfileController.lat =
          userController.userModel.location.coordinates[1];
      editProfileController.long =
          userController.userModel.location.coordinates[0];
    }

    return isNext
        ? DoubleBackToCloseApp(child: scaffoldWidget())
        : scaffoldWidget();
  }

  GestureDetector scaffoldWidget() {
    return GestureDetector(
      onTap: () {
        disposeKeyboard();
      },
      child: Scaffold(
          appBar: customAppBar(),
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding - 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    imageSelectGrid(),
                    getHeightSizedBox(h: 18),
                    header('business_name'.tr),
                    Get.height < 800 ? getHeightSizedBox(h: 10) : SizedBox(),
                    nameField(),
                    getHeightSizedBox(h: 18),
                    header('business_category'.tr),
                    categorySelect(),
                    getHeightSizedBox(h: 18),
                    header('phone_number'.tr),
                    countryField(),
                    getHeightSizedBox(h: 18),
                    header('description'.tr),
                    descField(),
                    getHeightSizedBox(h: 18),
                    header('location'.tr),
                    locationFiled(),
                    getHeightSizedBox(h: 18),
                    websiteHeader(),
                    getHeightSizedBox(h: 16),
                    websites(),
                    getHeightSizedBox(h: 10),
                    Divider(
                      height: 0,
                      thickness: 1,
                      color: Color(0xffA4A4A4),
                    ),
                    getHeightSizedBox(h: 30),
                    CustomButton(
                        type: CustomButtonType.colourButton,
                        text: isNext ? 'next'.tr : 'save'.tr,
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();

                            editProfileController.submitAllFields(isNext);
                            // if (editProfileController
                            //     .uploadMultiFile.isNotEmpty) {
                            //   editProfileController.submitAllFields(isNext);
                            //   // if (editProfileController.websites.isNotEmpty) {
                            //   //   appImagePicker.imagePickerController
                            //   //       .resetImage();
                            //   //
                            //   //   editProfileController.submitAllFields(isNext);
                            //   // } else {
                            //   //   flutterToast('enter_websites'.tr);
                            //   // }
                            // } else {
                            //   if (editProfileController.websites.isNotEmpty) {
                            //     flutterToast('at_least_one_image'.tr);
                            //   } else {
                            //     flutterToast("${'select_image'.tr}");
                            //   }
                            // }
                          }
                        }),
                    getHeightSizedBox(h: 40),
                  ],
                )),
          )),
    );
  }

  websites() {
    return GetBuilder(
      builder: (EditBProfileController controller) {
        return controller.websites.length == 0
            ? SizedBox()
            : Column(
                children: controller.websites
                    .map((e) => FittedBox(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 7),
                            height: getProportionateScreenWidth(26),
                            width: getProportionateScreenWidth(165),
                            decoration: BoxDecoration(
                                color: Color(0xff009345),
                                borderRadius: BorderRadius.circular(13)),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  getHeightSizedBox(w: 10),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Text(
                                        e,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                getProportionateScreenWidth(
                                                    12)),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      disposeKeyboard();
                                      controller.removeWebsite(e);
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              );
      },
    );
  }

  websiteHeader() {
    return GetBuilder(
      builder: (EditBProfileController controller) => Row(
        children: [
          header('website_links'.tr),
          Spacer(),
          GestureDetector(
            onTap: () {
              if (controller.websites.length < 3)
                dialogueOpen(
                    controller: controller.weblinks,
                    context: Get.context as BuildContext,
                    onCancel: () {
                      Get.back();
                    },
                    onOk: () {
                      if (controller.weblinks.text.trim().isNotEmpty) {
                        controller.addWebsite(controller.weblinks.text);
                        controller.weblinks.clear();

                        Get.back();
                      } else {
                        flutterToast("kindly_add_a_link".tr);
                      }
                      controller.weblinks.clear();
                    });
              else
                flutterToast('weblink_toast'.tr);
            },
            child: Wrap(
              //  crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  '+',
                  style: TextStyle(
                      fontSize: getProportionateScreenWidth(20),
                      color: AppColor.kDefaultFontColor.withOpacity(0.74)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    'add'.tr,
                    style: TextStyle(
                        fontSize: getProportionateScreenWidth(15),
                        color: AppColor.kDefaultFontColor.withOpacity(0.74)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  locationFiled() {
    return GestureDetector(
      onTap: () {
        GoogleSearchPlace.buildGooglePlaceSearch().then((value) async {
          LoadingOverlay.of().show();
          editProfileController.lat = value.late;
          editProfileController.long = value.long;
          editProfileController.location.text = value.address;
          LoadingOverlay.of().hide();
        });
      },
      child: TextFormField(
        style: TextStyle(
          fontSize: getProportionateScreenWidth(14),
        ),
        controller: editProfileController.location,

        // validator: (val) => val!.trim().isEmpty ? "enter_location".tr : null,
        enabled: false,
        textInputAction: TextInputAction.next,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
            errorStyle: TextStyle(
              color: Theme.of(Get.context as BuildContext)
                  .errorColor, // or any other color
            ),
            errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              width: 1,
              color: Theme.of(Get.context as BuildContext).errorColor,
            )),
            disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              width: 0.5,
            )),
            hintStyle: TextStyle(
                fontSize: getProportionateScreenWidth(14),
                color: Color(0xff8F92A3)),
            hintText: 'Villaz Johns Street 11, California..',
            suffixIcon: Padding(
              padding: const EdgeInsets.fromLTRB(10, 12, 0, 12),
              child: SvgPicture.asset(
                AppImages.gps,
              ),
            )),
      ),
    );
  }

  descField() {
    return TextFormField(
      controller: editProfileController.description,
      textInputAction: TextInputAction.done,
      //  validator: (val) => val!.trim().isEmpty ? "enter_description".tr : null,
      style: TextStyle(
        fontSize: getProportionateScreenWidth(14),
      ),
      textCapitalization: TextCapitalization.sentences,
      maxLines: 2,
      minLines: 1,
      maxLength: 300,
      decoration: InputDecoration(
          hintStyle: TextStyle(
              fontSize: getProportionateScreenWidth(14),
              color: Color(0xff8F92A3)),
          hintText:
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry.'),
    );
  }

  categorySelect() {
    return GetBuilder(
      builder: (EditBProfileController controller) => GestureDetector(
        onTap: () {
          disposeKeyboard();

          showCupertinoModalPopup(
            context: Get.context as BuildContext,
            builder: (_) => SizedBox(
              height: getProportionateScreenWidth(250),
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: Colors.grey),
                            )),
                        Spacer(),
                        TextButton(
                            onPressed: () {
                              Get.back();
                              controller.categorySelect =
                                  controller.lastCategorySelect;
                              controller.businessCategory.text = userController
                                  .globalCategory[controller.categorySelect]
                                  .name;
                            },
                            child: Text("Done"))
                      ],
                    ),
                    Expanded(
                      child: CupertinoPicker(
                          itemExtent: 30,
                          // looping: true,
                          scrollController: FixedExtentScrollController(
                              initialItem: controller.categorySelect),
                          children: List.generate(
                              userController.globalCategory.length,
                              (index) => Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Text(userController
                                        .globalCategory[index].name),
                                  )),
                          onSelectedItemChanged: (val) {
                            controller.lastCategorySelect = val;
                          }),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        child: TextFormField(
          enabled: false,
          // validator: (val) => val!.isEmpty ? "enter_category".tr : null,
          controller: controller.businessCategory,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(fontSize: getProportionateScreenWidth(14)),
          decoration: InputDecoration(
            errorStyle: TextStyle(
              color: Theme.of(Get.context as BuildContext)
                  .errorColor, // or any other color
            ),
            errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              width: 1,
              color: Theme.of(Get.context as BuildContext).errorColor,
            )),
            disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              width: 0.5,
            )),
            hintText: 'Heal care',
            hintStyle: TextStyle(
                fontSize: getProportionateScreenWidth(14),
                color: Color(0xff8F92A3)),
            suffixIcon: RotatedBox(
                quarterTurns: 1, child: Icon(Icons.arrow_forward_ios_sharp)),
          ),
        ),
      ),
    );
  }

  nameField() {
    return CustomTextField(
      controller: editProfileController.businessName,
      textInputAction: TextInputAction.next,
      validator: (val) => val!.trim().isEmpty ? "enter_business_name".tr : null,
      textCapitalization: TextCapitalization.sentences,
      hintText: 'Smith Hospitality',
      textSize: 14,
    );
  }

  imageSelectGrid() {
    return AspectRatio(
      aspectRatio: 1.8,
      child: GetBuilder(
        builder: (EditBProfileController controller) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 100 / 80),
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(
              top: 10,
            ),
            clipBehavior: Clip.none,
            itemCount: 6,
            itemBuilder: isNext
                ? (context, index) {
                    return controller.multiFile.length > (index)
                        ? Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: AspectRatio(
                                  aspectRatio: 100 / 80,
                                  child: Image.file(
                                    controller.multiFile[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                  right: -4,
                                  top: -4,
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.deleteImage(index);
                                    },
                                    child: buildWidget(
                                        AppImages.closeGreen, 20, 20),
                                  ))
                            ],
                          )
                        : GestureDetector(
                            onTap: () {
                              controller.uploadImage();
                            },
                            child: buildWidget(AppImages.uploadImage, 80, 100),
                          );
                  }
                : (context, index) {
                    return controller.uploadMultiFile.length > index
                        ? Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: FadeInImage(
                                  image: NetworkImage(
                                      "${imageUrl + controller.uploadMultiFile[index]}"),
                                  height: 80,
                                  width: 100,
                                  fit: BoxFit.cover,
                                  placeholder:
                                      AssetImage(AppImages.placeHolder),
                                ),
                              ),
                              Positioned(
                                  right: -4,
                                  top: -4,
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.deleteImage(index);
                                    },
                                    child: buildWidget(
                                        AppImages.closeGreen, 20, 20),
                                  ))
                            ],
                          )
                        : controller.multiFile.length > (index)
                            ? Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(7),
                                    child: AspectRatio(
                                      aspectRatio: 100 / 80,
                                      child: Image.file(
                                        controller.multiFile[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      right: -4,
                                      top: -4,
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.deleteImage(index);
                                        },
                                        child: buildWidget(
                                            AppImages.closeGreen, 20, 20),
                                      ))
                                ],
                              )
                            : GestureDetector(
                                onTap: () {
                                  controller.uploadImage();
                                },
                                child:
                                    buildWidget(AppImages.uploadImage, 80, 100),
                              );
                  },
          );
        },
      ),
    );
  }

  countryField() {
    return GetBuilder(
      builder: (EditBProfileController controller) => TextFormField(
        controller: controller.mobileNumber,
        textInputAction: TextInputAction.next,
        validator: (val) =>
            val!.trim().isEmpty ? "enter_mobile_number".tr : null,
        style: TextStyle(
          fontSize: getProportionateScreenWidth(14),
        ),
        keyboardType: TextInputType.phone,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintStyle: TextStyle(
              fontSize: getProportionateScreenWidth(14),
              color: AppColor.kDefaultFontColor.withOpacity(0.5)),
          hintText: '987654321',
          prefixIcon: GestureDetector(
            onTap: () {
              disposeKeyboard();

              showCupertinoModalPopup(
                context: Get.context as BuildContext,
                builder: (_) => SizedBox(
                  height: getProportionateScreenWidth(250),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.grey),
                                )),
                            Spacer(),
                            TextButton(
                                onPressed: () {
                                  Get.back();
                                  controller.kDefaultCountry =
                                      controller.lastSelectedCountry;
                                },
                                child: Text("Done"))
                          ],
                        ),
                        Expanded(
                          child: CupertinoPicker(
                            itemExtent: 40,
                            useMagnifier: false,
                            children: List.generate(
                                controller.countries!.length,
                                (index) => Padding(
                                      padding: const EdgeInsets.only(top: 7),
                                      child: Text(controller
                                          .countries![index].name
                                          .toString()),
                                    )),
                            looping: false,
                            onSelectedItemChanged: (value) {
                              controller.lastSelectedCountry = controller
                                  .countries![value].dialCode
                                  .toString();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: Container(
              color: Colors.transparent,
              width: getProportionateScreenWidth(65),
              child: Row(
                children: [
                  Text(
                    "+${controller.kDefaultCountry}",
                    softWrap: false,
                    maxLines: 1,
                    style: TextStyle(fontSize: getProportionateScreenWidth(14)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: SvgPicture.asset(AppImages.dropdownCloseBlack),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  customAppBar() {
    return appBar(
      title: 'business_details'.tr,
      isBackButtonShow: isNext ? false : true,
      actions: [
        isNext
            ? Padding(
                padding: const EdgeInsets.only(top: 22, right: 25),
                child: Text(
                  '1 of 3',
                  style: TextStyle(
                    color: AppColor.kDefaultFontColor.withOpacity(0.72),
                    fontSize: 15,
                  ),
                ),
              )
            : SizedBox()
      ],
    );
  }
}

Widget header(String title) {
  return Text(
    title,
    style: TextStyle(
        fontSize: getProportionateScreenWidth(16), fontWeight: FontWeight.bold),
  );
}
