import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/constants/appSetting.dart';
import 'package:grebooo/core/constants/app_assets.dart';
import 'package:grebooo/core/constants/appcolor.dart';
import 'package:grebooo/core/service/googleAdd/addServices.dart';
import 'package:grebooo/core/utils/config.dart';
import 'package:grebooo/ui/screens/homeTab/controller/homeController.dart';
import 'package:grebooo/ui/screens/homeTab/controller/postDetailController.dart';
import 'package:grebooo/ui/screens/homeTab/home.dart';
import 'package:grebooo/ui/screens/homeTab/viewcomments.dart';
import 'package:grebooo/ui/shared/appbar.dart';
import 'package:grebooo/ui/shared/commentview.dart';
import 'package:grebooo/ui/shared/postdetailbottom.dart';
import 'package:grebooo/ui/shared/postview.dart';

import '../../../main.dart';
import 'widget/guestLoginScreen.dart';

class PostDetails extends StatefulWidget {
  final String? postRef;

  PostDetails({
    Key? key,
    this.postRef,
  }) : super(key: key);

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  final PostDetailController postDetailController =
      Get.find<PostDetailController>();

  final TextEditingController comment = TextEditingController();
  @override
  void initState() {
    // GoogleAddService.showInterstitialAd();
    postDetailController.selectedPostRef =
        Get.find<HomeController>().currentPostRef;

    postDetailController.getPostDetails(widget.postRef!);
    postDetailController.fetchCommentsLast2();

    super.initState();
  }

  @override
  void deactivate() {
    if (postDetailController.postDataModel.userRef != "") {
      HomeController controller = Get.find<HomeController>();
      int index = controller.getPosts
          .indexWhere((element) => element.id == widget.postRef);
      if (index != -1) {
        controller.getPosts[index].like =
            postDetailController.postDataModel.like;
        controller.getPosts[index].isLike =
            postDetailController.postDataModel.isLike;
      }
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(title: 'post_details'.tr),
        body: GetBuilder(
            builder: (PostDetailController postDetailController) =>
                postDetailController.postDataModel.userRef == ""
                    ? Center(
                        child: Platform.isIOS
                            ? CupertinoActivityIndicator()
                            : CircularProgressIndicator(
                                strokeWidth: 2,
                              ))
                    : Stack(
                        fit: StackFit.expand,
                        children: [
                          SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                GetBuilder(
                                  builder: (PostDetailController controller) =>
                                      PostView(
                                    postData:
                                        postDetailController.postDataModel,
                                    isPostDetail: true,
                                  ),
                                ),
                                getHeightSizedBox(h: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: kDefaultPadding),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'comments'.tr,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        16)),
                                          ),
                                          Spacer(),
                                          GetBuilder(
                                            builder:
                                                (HomeController controller) =>
                                                    postDetailController
                                                                .postDataModel
                                                                .comment ==
                                                            0
                                                        ? SizedBox()
                                                        : GestureDetector(
                                                            onTap: () {
                                                              disposeKeyboard();
                                                              if (userController
                                                                  .isGuest) {
                                                                Get.to(() =>
                                                                    GuestLoginScreen());
                                                                return;
                                                              }
                                                              Get.to(() =>
                                                                  ViewComments(
                                                                    postData:
                                                                        postDetailController
                                                                            .postDataModel,
                                                                  ));
                                                            },
                                                            child: Text(
                                                              'view_all_comments'
                                                                  .tr,
                                                              style: TextStyle(
                                                                  color: AppColor
                                                                      .kDefaultFontColor
                                                                      .withOpacity(
                                                                          0.6),
                                                                  fontSize:
                                                                      getProportionateScreenWidth(
                                                                          14)),
                                                            ),
                                                          ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                getHeightSizedBox(h: 5),
                                GetBuilder(
                                  builder: (HomeController controller) =>
                                      postDetailController
                                                  .postDataModel.comment ==
                                              0
                                          ? Container(
                                              height: 200,
                                              width: 200,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  buildWidget(
                                                      AppImages.noComment,
                                                      20,
                                                      21.34),
                                                  Text(
                                                    'no_comments'.tr,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff969696),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            getProportionateScreenWidth(
                                                                20)),
                                                  )
                                                ],
                                              ),
                                            )
                                          : GetBuilder(
                                              builder: (PostDetailController
                                                      controller) =>
                                                  controller.last2Comments
                                                              .length ==
                                                          0
                                                      ? SizedBox(
                                                          height: 100,
                                                          child: Center(
                                                            child: GetPlatform
                                                                    .isAndroid
                                                                ? CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2,
                                                                  )
                                                                : CupertinoActivityIndicator(),
                                                          ))
                                                      : Column(
                                                          children:
                                                              List.generate(
                                                            controller
                                                                .last2Comments
                                                                .length,
                                                            (index) =>
                                                                CommentView(
                                                              commentsData:
                                                                  controller
                                                                          .last2Comments[
                                                                      index],
                                                            ),
                                                          ),
                                                        ),
                                            ),
                                ),
                                SizedBox(
                                  height: 130,
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: PostDetailsBottomView(
                              comment: comment,
                              hintText: 'textfieldmsg1'.tr,
                              send: () {
                                if (userController.isGuest) {
                                  Get.to(() => GuestLoginScreen());
                                  return;
                                }
                                if (comment.text.isNotEmpty) {
                                  disposeKeyboard();
                                  postDetailController.commentText =
                                      comment.text.trim();
                                  comment.clear();

                                  postDetailController.addComments(
                                      postDetailController.postDataModel);
                                }
                              },
                              isAddRequired: true,
                            ),
                          )
                        ],
                      )));
  }
}
