import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/models/FollowersModel.dart';
import 'package:grebooo/core/service/repo/editProfileRepo.dart';
import 'package:grebooo/core/service/repo/userRepo.dart';
import 'package:grebooo/core/utils/appFunctions.dart';
import 'package:grebooo/core/utils/sharedpreference.dart';
import 'package:grebooo/core/viewmodel/controller/selectservicecontoller.dart';
import 'package:grebooo/ui/global.dart';
import 'package:grebooo/ui/screens/baseScreen/controller/baseController.dart';
import 'package:grebooo/ui/screens/login/model/currentUserModel.dart';
import 'package:grebooo/ui/screens/profile/profile.dart';

import '../../../../main.dart';

class ProfileChangeController extends GetxController {
  final TextEditingController name = TextEditingController();

  final TextEditingController email = TextEditingController();

  final TextEditingController location = TextEditingController();
  var followingList = <MyFollowers>[].obs;
  double lat = -1;
  double long = -1;

  Future updateUser() async {
    EditProfileRepo.updateUser(
            map: userController.user.userType ==
                    getServiceTypeCode(ServicesType.userType)
                ? {
                    "name": name.text.trim(),
                    "latitude": lat,
                    "longitude": long,
                    "address": location.text.trim(),
                    "email": email.text.trim()
                  }
                : {"name": name.text.trim(), "email": email.text.trim()},
            image: appImagePicker.imagePickerController.image)
        .then((v) {
      if (v != null) {
        Get.find<BaseController>().baseAddress = location.text.trim();

        appImagePicker.imagePickerController.resetImage();
        updateUserDetail(UserModel.fromJson(v['data']));
        print("***********************************");
        print(userController.user.toJson());
        flutterToast(v["message"]);
        Get.back();
      }
    });
  }

  @override
  void onInit() {
    name.text = userController.user.name;
    email.text = userController.user.email;
    lat = userController.user.location.coordinates[0];
    long = userController.user.location.coordinates[1];
    location.text = userController.user.location.address;

    super.onInit();
  }

  Future<void> getFollowers(FOLLOWER_TYPE follower_type)  async{
    followingList.value.clear();

    String collectionRef = follower_type == FOLLOWER_TYPE.following ? "following" : "follower";
    String userCollecRef = follower_type == FOLLOWER_TYPE.following ? "userFollowing" : "userFollowers";

    print("caled firebase get function");
    final followerRef = FirebaseFirestore.instance.collection(collectionRef);
    final QuerySnapshot snapshot = await followerRef
        .doc(userController.userModel.id)
        .collection(userCollecRef)
        .get();
    // await followerRef.get();
  
    snapshot.docs.map((e) {
      final data = e.data() as Map<String, dynamic>;
      print("Snapshot: "+ jsonEncode(data));

      followingList.value.add(new MyFollowers(name: data['name'], image: data['image']));
      // followingList.value =  [MyFollowers(
      //   name: data['name'],
      //   image: data['image'],
      // )
      // ];
    }).toList();
    print('--------------foloowinf-------------------');

    // return followingList;
  }
}
