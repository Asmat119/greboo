import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grebooo/core/constants/appSetting.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/constants/app_assets.dart';
import 'package:grebooo/core/constants/appcolor.dart';
import 'package:grebooo/core/utils/appFunctions.dart';
import 'package:grebooo/ui/screens/baseScreen/controller/baseController.dart';
import '../baseScreen/baseScreen.dart';
import '../baseScreen/controller/createPostController.dart';
import 'home.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({Key? key}) : super(key: key);

  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final AddPostController postController = Get.find<AddPostController>();
  final BaseController baseController = Get.find<BaseController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (AddPostController controller) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                Spacer(),
                postController.uploadFile == null
                    ? GestureDetector(
                        onTap: () {
                          postController.openBottomSheet(
                            context: context,
                            isVideo: false,
                          );
                        },
                        child: Container(
                          height: 130,
                          width: 130,
                          child: SvgPicture.asset(AppImages.uploadImg),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          postController.openBottomSheet(
                            context: context,
                            isVideo: false,
                          );
                        },
                        child: Container(
                          height: 130,
                          width: 130,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: FileImage(controller.uploadFile!),
                            ),
                            borderRadius: BorderRadius.circular(80),
                          ),
                        ),
                      ),
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "upload_your_profile_picture_before_your_first_post".tr,
                    style: TextStyle(
                      fontFamily: kAppFont,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 90),
                MaterialButton(
                  minWidth: double.infinity,
                  height: 50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  onPressed: () {
                    //  Get.to(() => BaseScreen());
                    //call API profile picture update

                    /// controller.postCaption.text = "Updated profile picture";
                    if (controller.uploadFile != null) {
                      controller.addPost().then((value) {
                        if (value != null) {
                          Home.paginationViewKey.currentState?.refresh();
                          Get.find<BaseController>().currentTab = 3;
                          Get.find<BaseController>().update();
                          Get.to(BaseScreen());
                        }
                      });
                    } else {
                      flutterToast("Please upload profile image");
                    }
                  },
                  color: AppColor.kDefaultColor,
                  child: Text(
                    "next".tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
