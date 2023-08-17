import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/constants/appSetting.dart';
import 'package:grebooo/core/constants/app_assets.dart';
import 'package:grebooo/core/extension/customButtonextension.dart';
import 'package:grebooo/core/service/repo/userRepo.dart';
import 'package:grebooo/core/utils/config.dart';
import 'package:grebooo/core/viewmodel/controller/selectservicecontoller.dart';
import 'package:grebooo/ui/screens/homeTab/controller/homeController.dart';
import 'package:grebooo/ui/screens/homeTab/controller/postDetailController.dart';
import 'package:grebooo/ui/shared/appbar.dart';
import 'package:grebooo/ui/shared/commentview.dart';
import 'package:grebooo/ui/shared/custombutton.dart';
import 'package:grebooo/ui/shared/postdetailbottom.dart';

import '../../../main.dart';
import 'home.dart';
import 'model/postModel.dart';

class ViewComments extends StatefulWidget {
  final PostData postData;

  ViewComments({Key? key, required this.postData}) : super(key: key);

  @override
  _ViewCommentsState createState() => _ViewCommentsState();
}

class _ViewCommentsState extends State<ViewComments> {
  final TextEditingController comment = TextEditingController();

  final PostDetailController postDetailController =
      Get.find<PostDetailController>();
  final scrollController = ScrollController();

  @override
  void initState() {
    postDetailController.selectedPostRef =
        Get.find<HomeController>().currentPostRef;

    super.initState();
    scrollController.addListener(scrollListener);
    postDetailController.fetchComments();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent / 2 &&
        !scrollController.position.outOfRange) {
      if (postDetailController.hasNext) {
        postDetailController.fetchNextComments();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'comments'.tr),
      body: Stack(
        fit: StackFit.expand,
        children: [
          GetBuilder(
            builder: (HomeController controller) {
              return widget.postData.comment == 0
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 200,
                          width: 200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildWidget(AppImages.noComment, 20, 21.34),
                              Text(
                                'no_comments'.tr,
                                style: TextStyle(
                                    color: Color(0xff969696),
                                    fontWeight: FontWeight.bold,
                                    fontSize: getProportionateScreenWidth(20)),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  : GetBuilder(
                      builder: (PostDetailController controller) {
                        return RefreshIndicator(
                          onRefresh: () async {
                            await controller.fetchComments();
                          },
                          child: controller.getComments.isEmpty
                              ? Center(
                                  child: GetPlatform.isIOS
                                      ? CupertinoActivityIndicator()
                                      : CircularProgressIndicator(
                                          strokeWidth: 2),
                                )
                              : ListView.builder(
                                  controller: scrollController,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  itemCount: controller.getComments.length,
                                  padding: EdgeInsets.only(bottom: 90),
                                  itemBuilder: (context, index) {
                                    return CommentView(
                                      commentsData:
                                          controller.getComments[index],
                                    );
                                  },
                                ),
                        );
                      },
                    );
            },
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: userController.user.userType ==
                      getServiceTypeCode(ServicesType.userType)
                  ? PostDetailsBottomView(
                      comment: comment,
                      hintText: 'textfieldmsg1'.tr,
                      send: () {
                        if (comment.text.isNotEmpty) {
                          disposeKeyboard();
                          postDetailController.commentText =
                              comment.text.trim();
                          comment.clear();
                          postDetailController.addComments(widget.postData);
                          scrollController.jumpTo(0);
                        }
                      },
                    )
                  : userController.user.verifiedByAdmin
                      ? PostDetailsBottomView(
                          comment: comment,
                          hintText: 'textfieldmsg1'.tr,
                          send: () {
                            if (comment.text.isNotEmpty) {
                              disposeKeyboard();
                              postDetailController.commentText =
                                  comment.text.trim();
                              comment.clear();
                              postDetailController.addComments(widget.postData);
                              scrollController.jumpTo(0);
                            }
                          },
                        )
                      : Container(
                          color: Color(0xffF9F9F9),
                          child: Column(
                            children: [
                              getHeightSizedBox(h: 26),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 60),
                                child: Text(
                                  'like_error'.tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize:
                                          getProportionateScreenWidth(16)),
                                ),
                              ),
                              getHeightSizedBox(h: 17),
                              SafeArea(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  child: CustomButton(
                                      type: CustomButtonType.colourButton,
                                      text: 'view_profile'.tr,
                                      onTap: () {}),
                                ),
                              ),
                              getHeightSizedBox(h: 17),
                            ],
                          ),
                        ))
        ],
      ),
    );
  }
}
