import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/constants/appcolor.dart';
import 'package:grebooo/core/service/repo/editProfileRepo.dart';
import 'package:grebooo/core/utils/sharedpreference.dart';
import 'package:grebooo/ui/screens/baseScreen/baseScreen.dart';
import 'package:grebooo/ui/screens/editBusinessprofile/model/addSeviceModel.dart';
import 'package:grebooo/ui/screens/editBusinessprofile/widgets/addServiceView.dart';
import 'package:grebooo/ui/screens/login/model/currentUserModel.dart';
import 'package:grebooo/ui/shared/alertdialogue.dart';

import '../../../../core/service/repo/imageRepo.dart';
import '../../homeTab/serviceoffered.dart';
import '../model/serviceListModel.dart';


class AddServiceController extends GetxController {
  List<AddServiceView> addServiceViews = [];

  List<AddServicesModel> addServiceModels = [];

  addDefault() {
    if (addServiceModels.length == 0) {
      addServiceViews = [AddServiceView(index: 0)];
      addServiceModels = <AddServicesModel>[AddServicesModel()];
    }
  }

  bool validateForm() {
    for (int i = 0; i < addServiceModels.length; i++) {
      var element = addServiceModels[i];
      if (element.image == null ||
          element.title == null ||
          element.title!.trim().isEmpty) {
        //  flutterToast("kindly_add_name_and_image".tr);
        return false;
      }
    }
    return true;
  }

  add() {
    bool flag = validateForm();
    if (flag) {
      addServiceViews.add(AddServiceView(index: addServiceViews.length));
      addServiceModels.add(AddServicesModel());
    }
    update();
  }

  remove(int index) {
    addServiceModels.removeAt(index);
    addServiceViews.removeAt(index);
    addServiceViews.asMap().forEach((int index, AddServiceView view) {
      view.index = index;
    });

    update();
  }

  Future<dynamic> submitAllFields(bool isNext) async {
    if (validateForm()) {
      List<Map<String, dynamic>> uploadData = [];
      for (int i = 0; i < addServiceModels.length; i++) {
        if (addServiceModels[i].url != "") {
          uploadData.add({
            "image": addServiceViews[i].serviceModel!.image,
            "name": addServiceModels[i].title
          });
        } else {
          var v = await ImageRepo.uploadImage(
              fileImage: [addServiceModels[i].image as File]);
          if (v != null) {
            uploadData
                .add({"image": v["data"], "name": addServiceModels[i].title});
          }
        }
      }

      var p = await EditProfileRepo.updateUser(
        map: {
          "services": uploadData,
          "profile": true,
        },
      );
      if (p != null) {
        updateUserDetail(UserModel.fromJson(p["data"]));

        if (isNext) {
          showCustomDialog(
              context: Get.context as BuildContext,
              content: 'dialogue_msg'.tr,
              contentSize: 15,
              onTap: () {
                Get.offAll(() => BaseScreen());
              },
              color: AppColor.kDefaultColor,
              okText: 'ok'.tr);
        } else {
          Get.back();
          ServiceOffered.paginationKey.currentState!.refresh();
        }
      }
    } else {
      Get.offAll(() => BaseScreen());
    }
  }

  Future getAllServices() async {
    await EditProfileRepo.getServices().then((value) {
      if (value != null) {
        List<Ser> services = ServiceListModel.fromJson(value).data;
        if (services.isNotEmpty) {
          addServiceViews.clear();
          addServiceModels.clear();
          services.forEach((element) {
            Future.delayed(Duration(milliseconds: 20), addData(element));
          });
        } else {
          addDefault();
        }
        update();
      }
    });
  }

  addData(Ser element) {
    addServiceViews.add(
        AddServiceView(index: addServiceViews.length, serviceModel: element));
    addServiceModels
        .add(AddServicesModel(title: element.name, url: element.image));
  }

  @override
  void onInit() {
    getAllServices();
    super.onInit();
  }
}
