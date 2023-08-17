import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/service/repo/editProfileRepo.dart';
import 'package:grebooo/core/service/repo/postRepo.dart';
import 'package:grebooo/core/utils/sharedpreference.dart';
import 'package:grebooo/main.dart';
import 'package:grebooo/ui/screens/baseScreen/controller/baseController.dart';
import 'package:grebooo/ui/screens/homeTab/model/postModel.dart';

import '../../login/model/currentUserModel.dart';
import '../../profile/profile.dart';
import '../home.dart';

class HomeController extends GetxController {
  String businessRef = "";
  int page = 1;
  double _distance = 0;

  set distance(double value) {
    _distance = value;
    update();
    Home.paginationViewKey.currentState?.refresh();
  }

  double get distance => _distance;

  HomeController() {
    page = 1;
  }
  RxBool descTextShowFlag = false.obs;

  List<String> selectedCategory = [];

  updateCategory(String id) {
    if (selectedCategory.contains(id)) {
      selectedCategory.remove(id);
    } else {
      selectedCategory.add(id);
    }
    update();
    Home.paginationViewKey.currentState?.refresh();
  }

  List<PostData> getPosts = [];

//for providers post
  Future<List<PostData>> fetchProviderPost(int offset) async {
    if (offset == 0) {
      page = 1;
      getPosts.clear();
    }
    if (page == -1) return [];

    var request = await PostRepo.fetchProviderPost(page);
    getPosts = request!.postData;
    page = request.hasMore ? page + 1 : -1;

    return getPosts;
  }

  Future<List<PostData>> fetchOtherProviderPost(int offset) async {
    if (offset == 0) {
      page = 1;
      getPosts.clear();
    }
    if (page == -1) return [];

    var request = await PostRepo.fetchOtherProviderPost(businessRef, page);
    if (request != null) {
      getPosts = request.postData;
      //print(request.postData);
      page = request.hasMore ? page + 1 : -1;
    }

    return getPosts;
  }

  //for user posts

  Future<List<PostData>> fetchUserPost(int offset) async {
    if (userController.globalCategory.length == 0) {
      userController.globalCategory = await EditProfileRepo.getCategories();
    }
    double lat = Get.find<BaseController>().latitude;
    double lang = Get.find<BaseController>().longitude;
    if (lat == 0 && lang == 0) return [];
    if (offset == 0) page = 1;
    if (page == -1) return [];

    var request = await PostRepo.fetchUserPost(
        page: page,
        distance: getFilterData(), //distance,
        latitude: lat,
        longitude: lang,
        categoryRefs: selectedCategory);
    getPosts = request!.postData;
    page = request.hasMore ? page + 1 : -1;
    print("RRRRRRRRR ${request}");
    return getPosts;
  }

  Future likeUpdate(PostData postData) async {
    int? index = getPosts.indexWhere((element) => element.id == postData.id);

    if (index != -1) {
      getPosts[index].isLike = !getPosts[index].isLike;
      if (getPosts[index].isLike) {
        getPosts[index].like += 1;
      } else {
        getPosts[index].like -= 1;
      }
    }

    update();
  }
@override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchProviderPost;
  }
  late String currentPostRef;

  addComment(PostData postData, String commentText) async {
    PostRepo.addComments(postRef: currentPostRef, commentsText: commentText);
    try {
      getPosts[getPosts.indexWhere((element) => element.id == currentPostRef)]
          .comment += 1;
    } on Exception catch (e) {
      debugPrint("prince $e");
    }
    update();
  }
}
