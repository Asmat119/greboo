import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/models/countrymodel.dart';
import '../../../../core/service/repo/editProfileRepo.dart';
import '../../../../core/service/repo/imageRepo.dart';
import '../../../../core/utils/appFunctions.dart';
import '../../../../core/utils/sharedpreference.dart';
import '../../../../core/viewmodel/controller/businesscontroller.dart';
import '../../../../main.dart';
import '../../../../ui/screens/login/model/currentUserModel.dart';

import '../../../../core/models/countrymodel.dart';
import '../../../global.dart';
import '../details 2.dart';

class EditBProfileController extends GetxController {
  final TextEditingController businessName = TextEditingController();
  final TextEditingController businessCategory = TextEditingController();
  final TextEditingController mobileNumber = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController location = TextEditingController();
  final TextEditingController weblinks = TextEditingController();

  late CountryModel _selectedCountry;
  CountryModel get selectedCountry => _selectedCountry;
  set selectedCountry(CountryModel value) {
    _selectedCountry = value;
    update();
  }

  late bool isNext;

  List<CountryModel>? _countries;
  List<CountryModel>? get countries => _countries;
  set countries(List<CountryModel>? value) {
    _countries = value;
    update();
  }

  //add websites
  List<String> websites = <String>[];
  void addWebsite(String str) {
    websites.add(str);
    update();
  }

  void removeWebsite(val) {
    websites.remove(val);
    update();
  }

  List<File> multiFile = <File>[];
  List<String> uploadMultiFile = <String>[];

  //country update
  late String _kDefaultCountry = '1';
  late String _lastSelectedCountry = '1';

  String get kDefaultCountry => _kDefaultCountry;
  String get lastSelectedCountry => _lastSelectedCountry;

  set kDefaultCountry(String value) {
    _kDefaultCountry = value.substring(1);
    update();
  }

  set lastSelectedCountry(String value) {
    _lastSelectedCountry = value;
  }

  void removeImage(int index) {
    if (multiFile.length > index) {
      multiFile.removeAt(index);
    }
    uploadMultiFile.removeAt(index);

    userController.user.images = uploadMultiFile;
    updateUserDetail(userController.user);

    update();
  }

  void multiAddImages(File file, String imageID) {
    multiFile.add(file);
    uploadMultiFile.add(imageID);
    update();
  }

  ///-------------------------------------------------

  String? _selectValue;

  String? get selectValue => _selectValue;

  set selectValue(String? value) {
    _selectValue = value;
    update();
  }

  double lat = 0;
  double long = 0;

  int _categorySelect = 1;
  int _lastCategorySelect = 1;

  int get categorySelect => _categorySelect;
  int get lastCategorySelect => _lastCategorySelect;

  set lastCategorySelect(int value) {
    _lastCategorySelect = value;
  }

  set categorySelect(int value) {
    _categorySelect = value;
    update();
  }

  Color _defaultColor = Color(0xff8F92A3);

  Color get defaultColor => _defaultColor;

  set defaultColor(Color value) {
    _defaultColor = value;
    update();
  }

  void loadCountryJsonFile() async {
    var jsonText = await rootBundle.loadString(AppJson.country);
    countries = countryModelFromJson(jsonText);
  }

  uploadImage() {
    appImagePicker.imagePickerController.resetImage();
    appImagePicker.openBottomSheet().then((value) {
      if (appImagePicker.imagePickerController.image != null) {
        ImageRepo.uploadImage(
                fileImage: [appImagePicker.imagePickerController.image as File])
            .then((value) {
          if (value != null) {
            flutterToast(value["message"]);
            multiAddImages(appImagePicker.imagePickerController.image as File,
                value["data"]);
          }
        });
      }
    });
  }

  deleteImage(int index) {
    if (uploadMultiFile.length > 1) {
      ImageRepo.deleteImage(imageId: uploadMultiFile[index]).then((value) {
        if (value != null) {
          flutterToast(value["message"]);
          removeImage(index);
        }
      });
    } else {
      flutterToast("at_least_one_image".tr);
    }
  }

  Future submitAllFields(bool isNext) async {
    appImagePicker.imagePickerController.resetImage();

    var v = await EditProfileRepo.updateUser(
      map: {
        "businessName": businessName.text.trim(),
        "images": uploadMultiFile,
        "latitude": lat,
        "longitude": long,
        "address": location.text.trim(),
        "categories": [userController.globalCategory[categorySelect].id],
        "websites": websites,
        "phoneCode": kDefaultCountry,
        "phoneNumber": mobileNumber.text.trim(),
        "description": description.text.trim(),
        // "profileCompleted": true,
      },
    );
    if (v != null) {
      updateUserDetail(UserModel.fromJson(v['data']));

      if (isNext)
        Get.to(() => DetailsPage2());
      else {
        Get.find<BusinessController>().updateUserModelList();
        Get.back();
      }
    }
  }

  @override
  void onInit() {
    loadCountryJsonFile();

    if (userController.user.profileCompleted) {
      businessName.text = userController.user.businessName;
      mobileNumber.text = userController.user.phoneNumber;
      location.text = userController.user.location.address;
      lat = userController.user.location.coordinates[0];
      long = userController.user.location.coordinates[1];
      description.text = userController.user.description;
      uploadMultiFile = userController.user.images;
      multiFile.addAll(userController.user.images.map((e) => File("")));
      websites = userController.user.websites;
      _kDefaultCountry = userController.user.phoneCode;

      for (int i = 0; i < userController.user.categories.length; i++) {
        for (int j = 0; j < userController.globalCategory.length; j++) {
          if (userController.user.categories[i].id ==
              userController.globalCategory[j].id) {
            businessCategory.text = userController.globalCategory[j].name;
          }
        }
      }
    }
    super.onInit();
  }
}
