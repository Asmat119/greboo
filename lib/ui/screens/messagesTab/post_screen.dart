import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/constants/appSetting.dart';
import 'package:grebooo/core/constants/app_assets.dart';
import 'package:grebooo/ui/screens/homeTab/controller/homeController.dart';
import 'package:grebooo/ui/screens/homeTab/model/postModel.dart';
import 'package:grebooo/ui/shared/postview.dart';
import 'package:pagination_view/pagination_view.dart';

class PostScreen extends StatefulWidget {
  static GlobalKey<PaginationViewState> paginationPostKey =
      GlobalKey<PaginationViewState>();
  final String businessRef;
  bool isFromProfile = false;
  PostScreen({required this.businessRef, required this.isFromProfile});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            height: 50,
            width: 50,
            color: Colors.transparent,
            child: SvgPicture.asset(
              AppImages.back,
              width: 10,
              height: 10,
              fit: BoxFit.none,
            ),
          ),
        ),
        title: Text(
          "posts".tr,
          style: TextStyle(
            color: Colors.black,
            fontFamily: kAppFont,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GetBuilder(builder: (HomeController controller) {
              controller.businessRef = widget.businessRef;
              return PaginationView(
                key: PostScreen.paginationPostKey,
                pullToRefresh: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder:
                    (BuildContext context, PostData postData, int index) =>
                        PostView(
                  isFromProfile: widget.isFromProfile,
                  isProfileClickable: false,
                  postData: postData,
                  //   isFromPostList: true,
                ),
                pageFetch: controller.fetchOtherProviderPost,
                onError: (error) {
                  return Center(child: Text(error));
                },
                onEmpty: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            PostScreen.paginationPostKey.currentState!
                                .refresh();
                          },
                          icon: Icon(Icons.restart_alt)),
                      Text("no_posts_yet".tr),
                    ],
                  ),
                ),
                initialLoader: GetPlatform.isAndroid
                    ? const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Center(child: CupertinoActivityIndicator()),
              );
            }),
          )
        ],
      ),
    );
  }
}
