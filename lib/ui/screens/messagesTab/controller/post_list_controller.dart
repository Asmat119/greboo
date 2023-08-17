import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/service/repo/postRepo.dart';
import 'package:grebooo/ui/screens/homeTab/model/postModel.dart';

class PostListController extends GetxController {
  int page = 1;

  PostListController() {
    page = 1;
  }

  RxBool descTextShowFlag = false.obs;

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
