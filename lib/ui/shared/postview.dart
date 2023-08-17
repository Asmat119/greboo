import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/constants/appSetting.dart';
import 'package:grebooo/core/constants/app_assets.dart';
import 'package:grebooo/core/constants/appcolor.dart';
import 'package:grebooo/core/extension/dateTimeFormatExtension.dart';
import 'package:grebooo/core/service/apiRoutes.dart';
import 'package:grebooo/core/service/repo/postRepo.dart';
import 'package:grebooo/core/service/repo/userRepo.dart';
import 'package:grebooo/core/utils/config.dart';
import 'package:grebooo/core/viewmodel/controller/selectservicecontoller.dart';
import 'package:grebooo/main.dart';
import 'package:grebooo/ui/global.dart';
import 'package:grebooo/ui/screens/homeTab/businessprofile.dart';
import 'package:grebooo/ui/screens/homeTab/controller/homeController.dart';
import 'package:grebooo/ui/screens/homeTab/controller/postDetailController.dart';
import 'package:grebooo/ui/screens/homeTab/home.dart';
import 'package:grebooo/ui/screens/homeTab/model/postModel.dart';
import 'package:grebooo/ui/screens/homeTab/postdetails.dart';
import 'package:grebooo/ui/screens/homeTab/provider/editPost.dart';
import 'package:grebooo/ui/screens/homeTab/videoScreen.dart';
import 'package:grebooo/ui/screens/homeTab/viewcomments.dart';
import 'package:grebooo/ui/screens/homeTab/widget/guestLoginScreen.dart';
import 'package:grebooo/ui/shared/alertdialogue.dart';
import 'package:grebooo/ui/shared/controller/delete_controller.dart';
import 'package:grebooo/ui/shared/userController.dart';
import 'package:readmore/readmore.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../screens/messagesTab/post_screen.dart';

class PostView extends StatefulWidget {
  final PostData postData;
  final bool isPostDetail;
  final bool isProfileClickable;
  bool isFromProfile = false;
  final int index;
  bool? isMiddleIndex = false;

  PostView({
    Key? key,
    required this.postData,
    this.isPostDetail = false,
    this.isProfileClickable = true,
    this.isFromProfile = false,
    this.index = 0,
    this.isMiddleIndex,
  }) : super(key: key);

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  final HomeController homeScreenController = Get.find<HomeController>();

  final DeleteController deleteController = Get.find<DeleteController>();

  final PostDetailController postDetailController =
      Get.find<PostDetailController>();

  bool option = true;
  final ServiceController serviceController = Get.find<ServiceController>();

  List<VideoPlayerController> videoControllers = [];

  @override
  void initState() {
    super.initState();
    initializeVideoControllers();
  }

  @override
  void dispose() {
    disposeVideoControllers();
    super.dispose();
  }

  void initializeVideoControllers() {
    if (widget.postData.image == "") {
      print("VIDEO COUNT" + widget.index.toString());
      print("VIDEO URL$videoUrl${widget.postData.video}");
      widget.postData.isVideo = true;
      final controller =
          VideoPlayerController.network(videoUrl + widget.postData.video);
      videoControllers.add(controller);
      controller.initialize().then((_) {
        setState(() {}); // Refresh the UI when each video is initialized
      });
    }
  }

  void disposeVideoControllers() {
    for (var controller in videoControllers) {
      controller.dispose();
    }
    videoControllers.clear();
  }

  @override
  Widget build(BuildContext context) {
    final videoIndex = videoControllers.indexWhere((controller) =>
        controller.dataSource == videoUrl + widget.postData.video);
    return Column(
      children: [
        getHeightSizedBox(h: 8),
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (widget.isPostDetail == false) {
                        homeScreenController.currentPostRef =
                            widget.postData.id;
                        Get.to(
                          () => PostDetails(postRef: widget.postData.id),
                        );
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getHeightSizedBox(h: 5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              profileImageView(),
                              getHeightSizedBox(w: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: getProportionateScreenWidth(275),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            if (widget.isProfileClickable ==
                                                false) {
                                              return;
                                            }
                                            if (userController.isGuest) {
                                              Get.to(() => GuestLoginScreen());
                                              return;
                                            }

                                            debugPrint(widget.postData.userRef);
                                            Get.to(() => BusinessProfile(
                                                  businessRef:
                                                      widget.postData.userRef,
                                                ));
                                          },
                                          child: Text(
                                            widget.postData.postUserDetail
                                                .businessName,
                                            style: TextStyle(
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                16,
                                              ),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        getHeightSizedBox(w: 5),
                                        buildWidget(
                                          widget.postData.postUserDetail
                                                  .verifiedByAdmin
                                              ? AppImages.verified
                                              : AppImages.warning,
                                          20,
                                          20,
                                        ),
                                        Spacer(),
                                        (userController.user.userType ==
                                                    getServiceTypeCode(
                                                        ServicesType
                                                            .providerType)) &&
                                                widget.isFromProfile
                                            ? GestureDetector(
                                                onTap: () {
                                                  bottomShit(
                                                      context: context,
                                                      EditOnTap: () {
                                                        Get.back();
                                                        Get.to(() => EditPost(
                                                            postData: widget
                                                                .postData));
                                                        PostScreen
                                                            .paginationPostKey
                                                            .currentState!
                                                            .refresh();
                                                      },
                                                      yesOnTap: () {
                                                        deleteController
                                                            .getDelete(
                                                          postRef: widget
                                                              .postData.id,
                                                        );
                                                        Get.back();

                                                        PostScreen
                                                            .paginationPostKey
                                                            .currentState!
                                                            .refresh();
                                                      });
                                                },
                                                child: Container(
                                                  color: Colors.transparent,
                                                  child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 10,
                                                        vertical: 10,
                                                      ),
                                                      child: SvgPicture.asset(
                                                          AppImages.optionIc)),
                                                ),
                                              )
                                            : SizedBox(),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    DateTimeFormatExtension
                                        .displayTimeFromTimestampForPost(
                                      widget.postData.createdAt.toLocal(),
                                    ),
                                    style: TextStyle(
                                      fontSize: getProportionateScreenWidth(14),
                                      color: AppColor.kDefaultFontColor
                                          .withOpacity(0.57),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        widget.postData.video == "" &&
                                widget.postData.image == ""
                            ? SizedBox()
                            : GestureDetector(
                                onTap: () {
                                  if (widget.isPostDetail) {
                                    if (widget.postData.image == "") {
                                      debugPrint("ok");
                                      Get.to(
                                        () => VideoScreen(
                                            path:
                                                "${videoUrl + widget.postData.video}"),
                                      );
                                    }
                                  } else {
                                    homeScreenController.currentPostRef =
                                        widget.postData.id;
                                    Get.to(
                                      () => PostDetails(
                                        postRef: widget.postData.id,
                                      ),
                                    );
                                  }
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    widget.postData.image == ""
                                        ? VisibilityDetector(
                                            key: Key(widget.index.toString()),
                                            onVisibilityChanged:
                                                (visibilityInfo) {
                                              var visiblePercentage =
                                                  visibilityInfo
                                                          .visibleFraction *
                                                      80;
                                              if (visiblePercentage >= 50) {
                                                setState(() {
                                                  videoControllers[videoIndex]
                                                      .play();
                                                });
                                              } else {
                                                setState(() {
                                                  videoControllers[videoIndex]
                                                      .pause();
                                                });
                                              }
                                            },
                                            // child: AspectRatio(
                                            //   aspectRatio: videoControllers[videoIndex].value.aspectRatio, // Adjust the aspect ratio as per your video dimensions
                                            //   child: VideoPlayer(
                                            //       videoControllers[videoIndex]),
                                            // ),
                                            child:VideoWidget(
                                                videoPlayerController: videoControllers[videoIndex],
                                                play: true,
                                                url: videoUrl+widget.postData.video,
                                              )
                                          )
                                        // VideoPlayerItem(videoUrl: videoUrl+widget.postData.video,)
                                        : Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: ClipRRect(
                                              child: FadeInImage(
                                                placeholder: AssetImage(
                                                    AppImages.placeHolder),
                                                image: widget.postData.image ==
                                                        ""
                                                    ? NetworkImage(
                                                        "${imageUrl + widget.postData.thumbnail}")
                                                    : NetworkImage(
                                                        "${imageUrl + widget.postData.image}"),
                                                height: Get.width - 94,
                                                width: Get.width,
                                                imageErrorBuilder: (context,
                                                    error, stackTrace) {
                                                  return Image.asset(
                                                    AppImages.placeHolder,
                                                    height: Get.width - 94,
                                                    width: Get.width,
                                                    fit: BoxFit.cover,
                                                  );
                                                },
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                    // postData.image == ""
                                    //     ? SvgPicture.asset(AppImages.videoPlay)
                                    //     : SizedBox()
                                  ],
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              widget.postData.text == ""
                                  ? getHeightSizedBox(h: 5)
                                  : getHeightSizedBox(h: 10),
                              widget.postData.text == ""
                                  ? SizedBox()
                                  : ReadMoreText(
                                      widget.postData.text,
                                      trimLines: 3,
                                      style: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(14),
                                        fontFamily: 'Nexa',
                                        color: AppColor.kDefaultFontColor
                                            .withOpacity(0.89),
                                      ),
                                      lessStyle: TextStyle(
                                        color: AppColor.kDefaultFontColor,
                                        fontSize:
                                            getProportionateScreenWidth(14),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: 'see_all'.tr,
                                      trimExpandedText: 'see_less'.tr,
                                      moreStyle: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(14),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        Divider(),
                        getHeightSizedBox(h: 3),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  disposeKeyboard();
                                  if (userController.isGuest) {
                                    Get.to(() => GuestLoginScreen());
                                    return;
                                  }

                                  if (widget.isPostDetail) {
                                    final postDetailController =
                                        Get.find<PostDetailController>();

                                    postDetailController.postDataModel.isLike =
                                        !postDetailController
                                            .postDataModel.isLike;

                                    if (postDetailController
                                        .postDataModel.isLike) {
                                      postDetailController.postDataModel.like +=
                                          1;
                                    } else {
                                      postDetailController.postDataModel.like -=
                                          1;
                                    }
                                    homeScreenController
                                        .likeUpdate(widget.postData);

                                    postDetailController.update();

                                    PostRepo.likeUpdate(
                                        postDetailController.postDataModel.id,
                                        postDetailController
                                            .postDataModel.isLike);
                                  } else {
                                    homeScreenController
                                        .likeUpdate(widget.postData);
                                    PostRepo.likeUpdate(widget.postData.id,
                                        widget.postData.isLike);
                                  }
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  padding: EdgeInsets.all(3),
                                  child: Row(
                                    children: [
                                      buildWidget(
                                        widget.postData.isLike
                                            ? AppImages.like
                                            : AppImages.unlike,
                                        15,
                                        17,
                                      ),
                                      getHeightSizedBox(w: 5),
                                      Text(
                                        widget.postData.like.toString(),
                                        style: TextStyle(
                                          fontSize: getProportionateScreenWidth(
                                            12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              getHeightSizedBox(w: 20),
                              GestureDetector(
                                onTap: () {
                                  disposeKeyboard();
                                  if (userController.isGuest) {
                                    Get.to(() => GuestLoginScreen());
                                    return;
                                  }
                                  homeScreenController.currentPostRef =
                                      widget.postData.id;
                                  Get.to(() => ViewComments(
                                        postData: widget.postData,
                                      ));
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  padding: EdgeInsets.all(3),
                                  child: Row(
                                    children: [
                                      buildWidget(AppImages.comment, 15, 16),
                                      getHeightSizedBox(w: 5),
                                      Text(
                                        widget.postData.comment.toString(),
                                        style: TextStyle(
                                            fontSize:
                                                getProportionateScreenWidth(
                                                    12)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        getHeightSizedBox(h: 7),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Divider(),
      ],
    );
  }

  GestureDetector profileImageView() {
    return GestureDetector(
      onTap: () {
        if (widget.isProfileClickable == false) {
          return;
        }
        if (userController.isGuest) {
          Get.to(
            () => GuestLoginScreen(),
          );
          return;
        }

        Get.to(
          () => BusinessProfile(
            businessRef: widget.postData.userRef,
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(150),
        child: FadeInImage(
          placeholder: AssetImage(AppImages.placeHolder),
          // image: userController.user.userType ==
          //         getServiceTypeCode(ServicesType.providerType)
          //     ? NetworkImage("${imageUrl + userController.user.picture}")
          //image: NetworkImage("${imageUrl + postData.postUserDetail.picture}"),
          image: networkImageShow2(
              imageUrl + widget.postData.postUserDetail.picture),
          height: 44,
          width: 44,
          imageErrorBuilder: (context, error, stackTrace) {
            return Image.asset(
              AppImages.placeHolder,
              height: 44,
              width: 44,
              fit: BoxFit.cover,
            );
          },
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

Widget buildCircleProfile(
    {required String image, required double height, required double width}) {
  return Container(
    height: getProportionateScreenWidth(height),
    width: getProportionateScreenWidth(width),
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(image: NetworkImage(image), fit: BoxFit.cover)),
  );
}

Widget uploadProfile(
    {required String image, required double height, required double width}) {
  return Container(
    height: getProportionateScreenWidth(height),
    width: getProportionateScreenWidth(width),
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        image:
            DecorationImage(image: FileImage(File(image)), fit: BoxFit.cover)),
  );
}

bottomShit({
  required BuildContext context,
  required dynamic Function()? yesOnTap,
  required void Function() EditOnTap,
}) {
  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 220,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                bottomShitContainer(
                  onTap: EditOnTap,
                  Color: AppColor.showModelBottomShitColor,
                  txt: "Edit Post",
                  fontSize: 16,
                ),
                bottomShitContainer(
                  onTap: () {
                    Get.back();
                    showCustomBox(context: context, yesonTap: yesOnTap);
                  },
                  Color: AppColor.showModelBottomShitColor,
                  txt: "Delete Post",
                  fontSize: 16,
                ),
                bottomShitContainer(
                  onTap: () {
                    Get.back();
                  },
                  Color: Colors.white,
                  txt: "Cancel",
                  fontSize: 20,
                ),
              ],
            ),
          ),
        );
      });
}

bottomShitContainer({
  required Color Color,
  required String txt,
  required void Function() onTap,
  required double fontSize,
}) {
  return Column(
    children: [
      GestureDetector(
        onTap: onTap,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Color,
          ),
          child: Center(
            child: Text(
              txt,
              style: TextStyle(
                fontSize: fontSize,
                fontFamily: kAppFont,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
      SizedBox(height: 10),
    ],
  );
}

showCustomBox(
    {required BuildContext context, required dynamic Function()? yesonTap}) {
  return showCustomDialog1(
    context: context,
    content: "Are you sure you want to delete this post?",
    title: "Delete Post",
    contentSize: 16,
    color: AppColor.bottomShitColor,
    okText: "No",
    noText: "Yes",
    noonTap: () {
      Get.back();
    },
    yesonTap: yesonTap,
  );
}

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  bool? isMiddleIndex = false;
  VideoPlayerItem({
    Key? key,
    required this.videoUrl,
    this.isMiddleIndex,
  }) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.play();
      });
  }

  @override
  void dispose() {
    super.dispose();
    // videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      decoration: const BoxDecoration(
        color: Colors.pink,
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: VideoPlayer(videoPlayerController),
      ),
    );
  }
}

/* */

//VideoPlayerItem(videoUrl: videoUrl+postData.video) ,

// flutter clean
// rm ios/podfile
// rm ios/podfile.lock
// flutter pub get
// cd ios
// pod install --repo-update

// flutter clean
// flutter pub get
// cd ios
// pod install --repo-update

// cd studioprojects
// cd grebooo-main

class VideoWidget extends StatefulWidget {
  final bool play;
  final String url;
  final VideoPlayerController? videoPlayerController;

  const VideoWidget(
      {Key? key,
      required this.url,
      required this.play,
      this.videoPlayerController})
      : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  // VideoPlayerController? videoPlayerController;

  Future<void>? _initializeVideoPlayerFuture;

  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();

    // widget!.videoPlayerController = new VideoPlayerController.network(widget.url);

    _initializeVideoPlayerFuture = widget.videoPlayerController!.initialize().then((_) {
      //Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      widget.videoPlayerController?.play();
      setState(() {

      });
    });
  } // This closing tag was missing

  @override
  void dispose() {
    widget.videoPlayerController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
              itemCount: 1,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Card(
                  key: PageStorageKey(widget.url[index]),
                  child: Column(
                    children: <Widget>[
                      Chewie(
                        key: PageStorageKey(widget.url[index]),
                        controller: ChewieController(
                          videoPlayerController: widget.videoPlayerController!,
                          aspectRatio:
                              widget.videoPlayerController!.value.aspectRatio,
                          // Prepare the video to be played and display the first frame
                          autoInitialize: true,
                          looping: false,
                          // Errors can occur for example when trying to play a video
                          // from a non-existent URL
                          errorBuilder: (context, errorMessage) {
                            return Center(
                              child: Text(
                                errorMessage,
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              });
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
