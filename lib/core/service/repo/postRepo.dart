import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grebooo/core/service/apiHandler.dart';
import 'package:grebooo/core/service/apiRoutes.dart';
import 'package:grebooo/main.dart';
import 'package:grebooo/ui/screens/homeTab/model/commentModel.dart';
import 'package:grebooo/ui/screens/homeTab/model/postDetialModel.dart';
import 'package:grebooo/ui/screens/homeTab/model/postModel.dart';
import 'package:grebooo/ui/screens/homeTab/model/reviewModel.dart';
import 'package:grebooo/ui/screens/login/model/currentUserModel.dart';

import '../../utils/sharedpreference.dart';

class PostRepo {
  static Future<PostData?> getPostDetails(String postRef) async {
    var response = await API.apiHandler(
        url: userController.isGuest
            ? APIRoutes.guestPostDetail
            : APIRoutes.postDetails,
        showLoader: false,
        header: {
          "Authorization": userController.userToken,
          "Content-Type": 'application/json',
        },
        body: jsonEncode({"postRef": postRef}));
    if (response != null) {
      debugPrint("getPostDetails $response");
      return PostDetailModel.fromJson(response).postData;
    } else
      return null;
  }

  static Future<PostModel?> fetchOtherProviderPost(
      String userRef, int page) async {
    var response = await API.apiHandler(
        url: APIRoutes.providerPostList,
        showLoader: false,
        header: {
          "Authorization": userController.userToken,
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {
          "page": "$page",
          "userRef": userRef
        });
    if (response != null) {
      return PostModel.fromJson(response);
    } else
      return null;
  }

  static Future<PostModel?> fetchProviderPost(int page) async {
    var response = await API.apiHandler(
        url: APIRoutes.providerPostList,
        showLoader: false,
        header: {
          "Authorization": userController.userToken,
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {
          "page": "$page"
        });
    if (response != null) {
      return PostModel.fromJson(response);
    } else
      return null;
  }

  static Future<PostModel?> fetchUserPost(
      {required int page,

      ///
      required double distance,
      required double longitude,
      required double latitude,
      List<String>? categoryRefs}) async {
    var response = await API.apiHandler(
      url: userController.isGuest
          ? APIRoutes.guestPostList
          : APIRoutes.userPostList,
      showLoader: false,
      header: {
        "Authorization": userController.userToken,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {
          "page": page,
          "locationRange": distance,
          "longitude": longitude,
          "latitude": latitude,
          "categoryRefs": categoryRefs
        },
      ),
    );
    print("This is Post data ${response.toString()}");
    if (response != null) {
      {
        debugPrint("fetchUserPost $response");
        return PostModel.fromJson(response);
      }
    } else
      return null;
  }

  static Future postUpload({
    File? image,
    required Map<String, dynamic> caption,
    required int isImage,
    File? thumbnail,
  }) async {
    String map = jsonEncode(caption);
    var response;
    if (isImage == 1 || isImage == 2) {
      response = await API.multiPartAPIHandler(
          url: APIRoutes.addPost,
          thumbnail: thumbnail,
          multiPartImageKeyName: isImage == 2 ? "image" : "video",
          fileImage: [image as File],
          field: {"data": map},
          header: {"Authorization": userController.userToken});
    } else
      response = await API.multiPartAPIHandler(
          url: APIRoutes.addPost,
          field: {"data": map},
          header: {"Authorization": userController.userToken});

    if (response != null) {
      return response;
    } else
      return null;
  }

  static Future postUpdate({
    File? image,
    required Map<String, dynamic> caption,
    required int isImage,
    File? thumbnail,
  }) async {
    String map = jsonEncode(caption);
    var response;
    if (isImage == 1 || isImage == 2) {
      response = await API.multiPartAPIHandler(
          url: APIRoutes.postEdit,
          thumbnail: thumbnail,
          multiPartImageKeyName: isImage == 2 ? "image" : "video",
          fileImage: [image as File],
          field: {"data": map},
          header: {"Authorization": userController.userToken});
    } else
      response = await API.multiPartAPIHandler(
          url: APIRoutes.postEdit,
          field: {"data": map},
          header: {"Authorization": userController.userToken});

    if (response != null) {
      return response;
    } else
      return null;
  }

  static Future likeUpdate(String id, bool isLike) async {
    var response = await API.apiHandler(
        url: APIRoutes.updateLike,
        showLoader: false,
        body: jsonEncode({"postRef": id, "isLike": isLike}),
        header: {
          "Authorization": userController.userToken,
          "Content-Type": 'application/json',
        });
    if (response != null) {
      return response;
    } else
      return null;
  }

  static Future<CommentModel?> fetchComments(
      {required String postRef, required int page}) async {
    var response = await API.apiHandler(
      url: userController.isGuest
          ? APIRoutes.guestCommentList
          : APIRoutes.getComments,
      showLoader: false,
      header: {
        "Authorization": userController.userToken,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {"postRef": postRef, "page": page},
      ),
    );
    if (response != null) {
      return CommentModel.fromJson(response);
    } else
      return null;
  }

  static Future addComments(
      {required String postRef, required String commentsText}) async {
    var response = await API.apiHandler(
      url: APIRoutes.addComments,
      showLoader: false,
      header: {
        "Authorization": userController.userToken,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {"postRef": postRef, "text": commentsText},
      ),
    );
    if (response != null) {
      return response;
    } else
      return null;
  }

  static Future<ReviewModel?> fetchReview(int page, String businessRef) async {
    var response = await API.apiHandler(
        url: APIRoutes.review,
        showLoader: false,
        header: {
          "Authorization": userController.userToken,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"businessRef": businessRef}));
    if (response != null) {
      return ReviewModel.fromJson(response);
    } else
      return null;
  }

  static Future updateReview(Map<String, dynamic> review, File? image) async {
    String map = jsonEncode(review);
    var response = await API.multiPartAPIHandler(
        url: APIRoutes.reviewUpdate,
        header: {"Authorization": userController.userToken},
        multiPartImageKeyName: "image",
        field: {"data": map},
        fileImage: image != null ? [image] : null);
    if (response != null) {
      return response;
    } else
      return null;
  }

  static Future<UserModel?> fetchUserDetail(
      {required String businessRef}) async {
    var response = await API.apiHandler(
        url: APIRoutes.userDetail,
        showLoader: false,
        header: {"Authorization": getUserToken()},
        body: {"userRef": businessRef});
    if (response != null) {
      print("*******************************");
      print(response["data"]);
      return UserModel.fromJson(response["data"]);
    } else
      return null;
  }

  static Future followProvider(String businessRef, bool follow) async {
    var response = await API.apiHandler(
        url: APIRoutes.follow,
        showLoader: false,
        header: {
          "Authorization": userController.userToken,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"businessRef": businessRef,"isFollow": follow}));
    if (response != null) {
      return response;
    } else
      return null;
  }

  // static Future getfollowers(String businessRef, bool follow) async {
  //   var response = await API.apiHandler(
  //       url: APIRoutes.followers,
  //       requestType: RequestType.Get,
  //       showLoader: false,
  //       header: {
  //         "Authorization": userController.userToken,
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode({"businessRef": businessRef, "isFollow": follow}));
  //   if (response != null) {
  //     print("FOLLERRS========="+response);
  //     return response;
  //   } else
  //     return null;
  // }
}
