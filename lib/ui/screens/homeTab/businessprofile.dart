import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grebooo/core/constants/appSetting.dart';
import 'package:grebooo/core/constants/app_assets.dart';
import 'package:grebooo/core/constants/appcolor.dart';
import 'package:grebooo/core/service/apiRoutes.dart';
import 'package:grebooo/core/service/googleAdd/addServices.dart';
import 'package:grebooo/core/service/repo/userRepo.dart';
import 'package:grebooo/core/utils/appFunctions.dart';
import 'package:grebooo/core/utils/config.dart';
import 'package:grebooo/core/viewmodel/controller/businesscontroller.dart';
import 'package:grebooo/core/viewmodel/controller/selectservicecontoller.dart';
import 'package:grebooo/main.dart';
import 'package:grebooo/ui/screens/editBusinessprofile/details1.dart';
import 'package:grebooo/ui/screens/editBusinessprofile/widgets/reportScreen.dart';
import 'package:grebooo/ui/screens/homeTab/controller/homeController.dart';
import 'package:grebooo/ui/screens/homeTab/home.dart';
import 'package:grebooo/ui/screens/homeTab/serviceoffered.dart';
import 'package:grebooo/ui/screens/login/model/currentUserModel.dart';
import 'package:grebooo/ui/screens/messagesTab/chatscreen.dart';
import 'package:grebooo/ui/screens/messagesTab/post_screen.dart';
import 'package:grebooo/ui/shared/alertdialogue.dart';
import 'package:grebooo/ui/shared/appbar.dart';
import 'package:grebooo/ui/shared/userController.dart';
import 'package:map_launcher/map_launcher.dart' as MapLauncher;
import 'package:url_launcher/url_launcher.dart';
import 'customerreview.dart';
import 'dart:developer';
class BusinessProfile extends StatefulWidget {
  final isShow;

  final String businessRef;
  String? userId;

  BusinessProfile({
    Key? key,
    this.isShow = false,
    required this.businessRef,
    this.userId,
  }) : super(key: key);

  @override
  _BusinessProfileState createState() => _BusinessProfileState();
}

class _BusinessProfileState extends State<BusinessProfile> {
  final BusinessController businessController = Get.put(BusinessController());
  final HomeController homeController = Get.find<HomeController>();

  @override
  void initState() {
    // GoogleAddService.showInterstitialAd();

    businessController.fetchUserDetail(widget.businessRef);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: appBarPro(),
      body: GetBuilder(
        builder: (BusinessController controller) {
          return controller.userModel.id == ""
              ? Center(
                  child: Platform.isIOS
                      ? CupertinoActivityIndicator()
                      : CircularProgressIndicator(strokeWidth: 2),
                )
              : GetBuilder(
                  builder: (UserController con) {
                    return SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          imageView(),
                          getHeightSizedBox(h: 15),
                          businessNameIntro(),
                          getHeightSizedBox(h: 15),
                          userController.user.id != controller.userModel.id
                              ? Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        contactButton(
                                            image: AppImages.follow,
                                            title: controller.userModel.isFollow
                                                ? "Unfollow".tr
                                                : 'follow'.tr,
                                            onTap: ()  {
                                              debugPrint("DSSDFSdfsd");

                                              print('====================');
                                              print(controller.userModel.email);
                                              print(controller.userModel.name);
                                              print(controller.userModel.id);
                                              print(userController.userModel.picture);
                                              print(userController.user.picture);


                                              // controller.userModel.isFollow ?
                                              // controller.follow(false):
                                              // controller.follow(true);



                                              if (controller.userModel.isFollow){
                                                controller.follow(false);
                                                print(controller.userModel.isFollow);
                                                handleUnFollowers(controller.userModel,userController.user);
                                              }

                                              else{

                                                controller.follow(true);
                                                print(controller.userModel.isFollow);
                                                handleFollowers(controller.userModel,userController.user);
                                              }


                                            }),
                                        contactButton(
                                            image: AppImages.call,
                                            title: 'contact'.tr,
                                            onTap: () async {
                                              if (await canLaunch(
                                                  'tel:${controller.userModel.phoneNumber}')) {
                                                await launch(
                                                    'tel:${controller.userModel.phoneNumber}');
                                              } else {
                                                throw 'Could not launch ${controller.userModel.phoneNumber}';
                                              }
                                            }),
                                        contactButton(
                                          image: AppImages.chatNew,
                                          onTap: () {
                                            if (!controller
                                                .userModel.isFollow) {
                                              flutterToast(
                                                  "You have to follow first.");
                                              return;
                                            }
                                            Get.to(
                                              () => ChatView(
                                                businessRef:
                                                    controller.userModel.id,
                                                userName: controller
                                                    .userModel.businessName,
                                              ),
                                            );
                                          },
                                          title: 'message'.tr,
                                        ),
                                        contactButton(
                                          image: AppImages.post,
                                          onTap: () {
                                            Get.to(
                                              () => PostScreen(
                                                businessRef: widget.businessRef,
                                                isFromProfile: false,
                                              ),
                                            );
                                          },
                                          title: 'posts'.tr,
                                        ),
                                      ],
                                    ),
                                    getHeightSizedBox(h: 15),
                                    const Divider(
                                      height: 0,
                                    ),
                                  ],
                                )
                              : SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                userController.user.userType ==
                                            getServiceTypeCode(
                                                ServicesType.providerType) &&
                                        userController.user.id ==
                                            controller.userModel.id
                                    ? Text(
                                        'basic_information'.tr,
                                        style: TextStyle(
                                          fontSize: getProportionateScreenWidth(
                                            15,
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                                userController.user.userType ==
                                            getServiceTypeCode(
                                                ServicesType.providerType) &&
                                        userController.user.id ==
                                            controller.userModel.id
                                    ? getHeightSizedBox(h: 10)
                                    : SizedBox(),
                                userController.user.userType ==
                                            getServiceTypeCode(
                                                ServicesType.providerType) &&
                                        userController.user.id ==
                                            controller.userModel.id
                                    ? Row(
                                        children: [
                                          buildWidget(
                                            AppImages.callProfile,
                                            41,
                                            41,
                                          ),
                                          getHeightSizedBox(w: 8),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              getHeightSizedBox(h: 3),
                                              Text(
                                                'phone'.tr,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      getProportionateScreenWidth(
                                                    16,
                                                  ),
                                                ),
                                              ),
                                              getHeightSizedBox(h: 3),
                                              Text(
                                                "+${businessController.userModel.phoneCode}${businessController.userModel.phoneNumber}",
                                                style: TextStyle(
                                                  color: Color(0xff6E6E6E)
                                                      .withOpacity(0.85),
                                                  fontSize:
                                                      getProportionateScreenWidth(
                                                    15,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : SizedBox()
                                //     : SizedBox(),
                              ],
                            ),
                          ),
                          getHeightSizedBox(h: 18),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kDefaultPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                header('description'.tr),
                                getHeightSizedBox(h: 11),
                                Text(
                                  businessController.userModel.description,
                                  style: TextStyle(
                                      height: 1.5,
                                      color: AppColor.kDefaultFontColor
                                          .withOpacity(0.89),
                                      fontSize:
                                          getProportionateScreenWidth(14)),
                                ),
                                getHeightSizedBox(h: 18),
                                header('website_links'.tr),
                                getHeightSizedBox(h: 16),
                                ...List.generate(
                                    businessController
                                        .userModel.websites.length,
                                    (index) => Column(
                                          children: [
                                            buildLink(businessController
                                                .userModel.websites[index]),
                                            getHeightSizedBox(h: 18),
                                          ],
                                        )),
                              ],
                            ),
                          ),
                          Divider(
                            height: 0,
                          ),
                          getHeightSizedBox(h: 18),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kDefaultPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                header('location'.tr),
                                getHeightSizedBox(h: 11),
                                GetBuilder(
                                    builder: (UserController controller) {
                                  return CustomGoogleMap(
                                      latitude: businessController
                                          .userModel.location.coordinates[1],
                                      longitude: businessController
                                          .userModel.location.coordinates[0]);
                                }),
                              ],
                            ),
                          ),
                          getHeightSizedBox(h: 15),
                          // userController.user.userType ==
                          //         getServiceTypeCode(ServicesType.providerType)
                          //     ?
                          // Column(
                          //   children: [
                          //     buildTile(
                          //       'customer_reviews'.tr,
                          //       () {
                          //         Get.to(() => CustomerReviewed(
                          //               businessRef:
                          //                   widget.businessRef.toString(),
                          //             ));
                          //       },
                          //       AppImages.customerReview,
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           getHeightSizedBox(w: 5),
                          //           Icon(
                          //             Icons.star,
                          //             color: Color(0xffFFAB00),
                          //           ),
                          //           getHeightSizedBox(w: 5),
                          //           Padding(
                          //             padding: const EdgeInsets.only(top: 4),
                          //             child: Text(
                          //               businessController.userModel.rating
                          //                   .toStringAsFixed(2),
                          //               style: TextStyle(
                          //                   fontSize:
                          //                       getProportionateScreenWidth(
                          //                           15)),
                          //             ),
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //     getHeightSizedBox(h: 20),
                          //   ],
                          // ),
                          //:
                          Column(
                            children: [
                              Divider(
                                height: 0,
                              ),
                              getHeightSizedBox(h: 18),
                              (userController.user.userType ==
                                          getServiceTypeCode(
                                              ServicesType.userType)) ||
                                      (userController.user.userType ==
                                              getServiceTypeCode(
                                                  ServicesType.providerType) &&
                                          userController.user.id !=
                                              controller.userModel.id)
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: kDefaultPadding),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          header('availability'.tr),
                                          getHeightSizedBox(h: 11),
                                          Text(
                                            'working_days'.tr,
                                            style: TextStyle(
                                                fontFamily: 'Opensans',
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        15)),
                                          ),
                                          getHeightSizedBox(h: 10),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              buildWidget(
                                                  AppImages.calender, 23, 26),
                                              getHeightSizedBox(w: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    RichText(
                                                        text: TextSpan(
                                                            text:
                                                                "${'open'.tr} : ",
                                                            children: [
                                                              TextSpan(
                                                                text: businessController
                                                                    .getAvailabilityDay
                                                                    .join(", "),
                                                                style:
                                                                    TextStyle(
                                                                  color: AppColor
                                                                      .kDefaultFontColor,
                                                                  fontFamily:
                                                                      'Nexa',
                                                                  fontSize:
                                                                      getProportionateScreenWidth(
                                                                          14),
                                                                ),
                                                              ),
                                                            ],
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff075935),
                                                                fontFamily:
                                                                    'Nexa',
                                                                fontSize:
                                                                    getProportionateScreenWidth(
                                                                        14)))),
                                                    getHeightSizedBox(h: 8),
                                                    RichText(
                                                        text: TextSpan(
                                                            text:
                                                                "${'closed'.tr} : ",
                                                            children: [
                                                              TextSpan(
                                                                  text: businessController
                                                                      .getCloseDay
                                                                      .join(
                                                                          ", "),
                                                                  style: TextStyle(
                                                                      color: AppColor
                                                                          .kDefaultFontColor,
                                                                      fontFamily:
                                                                          'Nexa',
                                                                      fontSize:
                                                                          getProportionateScreenWidth(
                                                                              14))),
                                                            ],
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xffDB0505),
                                                                fontFamily:
                                                                    'Nexa',
                                                                fontSize:
                                                                    getProportionateScreenWidth(
                                                                        14))))
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          getHeightSizedBox(h: 13),
                                          Text(
                                            'working_hours'.tr,
                                            style: TextStyle(
                                                fontFamily: 'Opensans',
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        15)),
                                          ),
                                          getHeightSizedBox(h: 10),
                                          Row(
                                            children: [
                                              buildWidget(
                                                  AppImages.clock, 23, 23),
                                              getHeightSizedBox(w: 10),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4),
                                                child: Text(
                                                  '${businessController.userModel.startTime == "" ? "00:00" : dateFormat.format(DateTime.parse(businessController.userModel.startTime).toLocal())}-${businessController.userModel.endTime == "" ? "00:00" : dateFormat.format(DateTime.parse(businessController.userModel.endTime).toLocal())}',
                                                  style: TextStyle(
                                                      fontSize:
                                                          getProportionateScreenWidth(
                                                              13)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(),
                              getHeightSizedBox(h: 15),
                              Divider(
                                height: 0,
                              ),
                              userController.user.id != controller.userModel.id
                                  ? buildTile('services_offered'.tr, () {
                                      debugPrint(widget.businessRef);
                                      Get.to(() => ServiceOffered(
                                            businessRef: widget.businessRef,
                                          ));
                                    }, AppImages.serviceOffer)
                                  : SizedBox(),
                              Divider(
                                height: 0,
                              ),
                              buildTile1('customer_reviews'.tr, () {
                                Get.to(() => CustomerReviewed(
                                      businessRef:
                                          widget.businessRef.toString(),
                                    ));
                              }, AppImages.customerReview),
                              getHeightSizedBox(h: 20)
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
        },
      ),
    );
  }

  businessNameIntro() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
            color: Color(0xffF4F4F4).withOpacity(0.55),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 19),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            businessController.userModel.businessName,
                            style: TextStyle(
                                fontSize: getProportionateScreenWidth(18),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        // getHeightSizedBox(w: 5),
                        GestureDetector(
                            onTap: () {
                              if (businessController.userModel.warningByAdmin !=
                                  "")
                                showCustomDialog(
                                  context: Get.context as BuildContext,
                                  color: AppColor.kDefaultColor,
                                  okText: 'ok'.tr,
                                  onTap: () {
                                    Get.back();
                                  },
                                  title: 'warning'.tr,
                                  content: businessController
                                      .userModel.warningByAdmin,
                                  height: getProportionateScreenWidth(260),
                                  contentSize: 14,
                                );
                            },
                            child: businessController.userModel.verifiedByAdmin
                                ? buildWidget(AppImages.verified, 23, 24)
                                : businessController.userModel.warningByAdmin !=
                                        ""
                                    ? buildWidget(AppImages.warning, 23, 24)
                                    : SizedBox())
                      ],
                    ),
                    getHeightSizedBox(h: 7),
                    Text(
                      businessController.userModel.categories
                          .map((e) => e.name)
                          .toString()
                          .replaceAll("(", "")
                          .replaceAll(")", ""),
                      style: TextStyle(fontSize: 15),
                    ),
                    getHeightSizedBox(h: 7),
                    Text(
                      '${"managed_by".tr} : ${businessController.userModel.name}',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              businessController.userModel.verifiedByAdmin
                  ? SizedBox()
                  : businessController.userModel.warningByAdmin == ""
                      ? GestureDetector(
                          onTap: () {
                            if (!businessController.userModel.verifiedByAdmin)
                              showCustomDialog(
                                  context: Get.context as BuildContext,
                                  color: AppColor.kDefaultColor,
                                  okText: 'ok'.tr,
                                  onTap: () {
                                    Get.back();
                                  },
                                  title: 'profileUnverified'.tr,
                                  content: "unverifiedMsg".tr,
                                  height: getProportionateScreenWidth(260),
                                  contentSize: 14);
                          },
                          child: Container(
                            height: 36,
                            width: getProportionateScreenWidth(99),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xff009345)),
                            child: Center(
                              child: Text(
                                "unverified".tr,
                                style: TextStyle(
                                  fontSize: getProportionateScreenWidth(14),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  imageView() {
    return Container(
      height: 160,
      width: Get.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView(
              onPageChanged: (val) {
                businessController.currentIndex = val;
              },
              physics: BouncingScrollPhysics(),
              children: businessController.userModel.images
                  .map(
                    (e) => FadeInImage(
                      placeholder: Image.asset(
                        AppImages.placeHolder,
                        fit: BoxFit.cover,
                      ).image,
                      image: NetworkImage("${imageUrl + e}"),
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          AppImages.placeHolder,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  )
                  .toList()),
          Positioned(bottom: 10, child: buildPagination())
        ],
      ),
    );
  }

  buildPagination() {
    return GetBuilder(
      builder: (BusinessController controller) {
        return businessController.userModel.images.length < 2
            ? SizedBox()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  businessController.userModel.images.length,
                  (index) => AnimatedContainer(
                    duration: kOnBoardingPageAnimationDuration,
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: index == businessController.currentIndex
                          ? Colors.white
                          : Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              );
      },
    );
  }

  header(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: getProportionateScreenWidth(16)),
        ),
      ],
    );
  }

  buildLink(String link) {
    return Row(
      children: [
        buildWidget(AppImages.link, 16, 16),
        getHeightSizedBox(w: 15),
        GestureDetector(
          onTap: () async {
            if (await canLaunch('https://$link')) {
              await launch(
                'https://$link',
              );
            } else {
              throw 'could not lunch';
            }
          },
          child: Text(
            link,
            style: TextStyle(
                fontSize: getProportionateScreenWidth(14),
                color: AppColor.kDefaultFontColor.withOpacity(0.89)),
          ),
        )
      ],
    );
  }

  Widget contactButton(
      {required String image, required String title, Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            buildWidget(image, 17, 18),
            getHeightSizedBox(h: 10),
            Text(
              title,
              style: TextStyle(
                  fontSize: getProportionateScreenWidth(15),
                  color: AppColor.kDefaultFontColor.withOpacity(0.75)),
            )
          ],
        ),
      ),
    );
  }

  appBarPro() {
    return userController.user.userType ==
            getServiceTypeCode(ServicesType.userType)
        ? appBar(title: 'business_profile'.tr, actions: [
            IconButton(
                onPressed: () {
                  Get.to(() => ReportScreen(
                        reportId: businessController.userModel.id,
                      ));
                },
                icon: Icon(Icons.more_vert))
          ])
        : appBar(
            title: 'about_business'.tr,
            actions: [
              widget.isShow
                  ? IconButton(
                      padding: EdgeInsets.only(right: 22),
                      onPressed: () {
                        Get.to(() => DetailsPage1(
                              isNext: false,
                            ));
                      },
                      icon: buildWidget(AppImages.editProfile, 19, 19))
                  : SizedBox()
            ],
          );
  }
  void handleUnFollowers(UserModel userModel, UserModel user) {

    final followerRef = FirebaseFirestore.instance.collection("followers");
    final followingRef = FirebaseFirestore.instance.collection("following");
    /// other followers collection


    followerRef
        .doc(userModel.id)
        .collection('userFollowers')
        .doc(user.id)
        .get().then((docs) => docs.reference.delete());

    //// yours following collection

    followingRef
        .doc(user.id)
        .collection('userFollowing')
        .doc(userModel.id)
        .get().then((docs) => docs.reference.delete());

  }


  }
  void handleFollowers(UserModel userModel, UserModel user) {
  String userImage = user.picture != ''  ? imageUrl + user.picture : "";
  String providerImage = userModel.picture != ''  ? imageUrl + userModel.picture : "";

    final followerRef = FirebaseFirestore.instance.collection("followers");
    final followingRef = FirebaseFirestore.instance.collection("following");
/// other followers collection
      followerRef
          .doc(userModel.id)
          .collection('userFollowers')
          .doc(user.id)
          .set({
        "name": user.name,
        "image": userImage
      });

      //// yours following collection

    followingRef
        .doc(user.id)
        .collection('userFollowing')
        .doc(userModel.id)
        .set({
      "name": userModel.name,
      "image": providerImage

    });


  }


Widget buildTile(String title, Function()? onTap, String image,
    [Widget? widget]) {
  return Column(
    children: [
      getHeightSizedBox(h: 15),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: MaterialButton(
          padding: EdgeInsets.zero,
          onPressed: onTap,
          child: Row(
            children: [
              buildWidget(image, 41, 41),
              getHeightSizedBox(w: 10),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: getProportionateScreenWidth(16)),
                    ),
                  ),
                  widget == null ? SizedBox() : widget
                ],
              ),
              Spacer(),
              buildWidget(AppImages.next, 20, 10),
            ],
          ),
        ),
      ),
      getHeightSizedBox(h: 15),
    ],
  );
}

Widget buildTile1(String title, Function()? onTap, String image,
    [Widget? widget]) {
  BusinessController businessController = Get.put(BusinessController());
  return Column(
    children: [
      getHeightSizedBox(h: 15),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: MaterialButton(
          padding: EdgeInsets.zero,
          onPressed: onTap,
          child: Row(
            children: [
              buildWidget(image, 41, 41),
              getHeightSizedBox(w: 10),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: getProportionateScreenWidth(16)),
                    ),
                  ),
                  widget == null ? SizedBox() : widget
                ],
              ),
              userController.user.id == businessController.userModel.id
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getHeightSizedBox(w: 5),
                        Icon(
                          Icons.star,
                          color: Color(0xffFFAB00),
                        ),
                        getHeightSizedBox(w: 5),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            businessController.userModel.rating
                                .toStringAsFixed(2),
                            style: TextStyle(
                                fontSize: getProportionateScreenWidth(15)),
                          ),
                        )
                      ],
                    )
                  : SizedBox(),
              Spacer(),
              buildWidget(AppImages.next, 20, 10),
            ],
          ),
        ),
      ),
      getHeightSizedBox(h: 15),
    ],
  );
}

class CustomGoogleMap extends StatefulWidget {
  final double latitude;
  final double longitude;

  CustomGoogleMap({required this.latitude, required this.longitude});

  @override
  CustomGoogleMapState createState() => CustomGoogleMapState();
}

class CustomGoogleMapState extends State<CustomGoogleMap> {
  GoogleMapController? _controller;

  @override
  Widget build(BuildContext context) {
    animateCamera(LatLng(widget.latitude, widget.longitude));

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 143,
        width: Get.width,
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(10)),
        child: GoogleMap(
          myLocationEnabled: false,
          mapType: MapType.normal,
          myLocationButtonEnabled: false,
          mapToolbarEnabled: false,
          zoomControlsEnabled: false,
          zoomGesturesEnabled: false,
          initialCameraPosition: CameraPosition(
              target: LatLng(widget.latitude, widget.longitude), zoom: 13.0),
          onTap: (pos) async {
            if (Platform.isAndroid) {
              MapLauncher.MapLauncher.isMapAvailable(MapLauncher.MapType.google)
                  .then((value) async {
                if (value != null) {
                  await MapLauncher.MapLauncher.showMarker(
                    mapType: MapLauncher.MapType.google,
                    coords:
                        MapLauncher.Coords(widget.latitude, widget.longitude),
                    title: '',
                  );
                } else {
                  _launchMapsUrl(widget.latitude, widget.longitude);
                }
              });
            } else {
              final availableMaps = await MapLauncher.MapLauncher.installedMaps;
              MapLauncher.MapLauncher.isMapAvailable(MapLauncher.MapType.google)
                  .then((value) async {
                if (value != null) {
                  await MapLauncher.MapLauncher.showMarker(
                    mapType: MapLauncher.MapType.google,
                    coords:
                        MapLauncher.Coords(widget.latitude, widget.longitude),
                    title: '',
                  );
                } else {
                  await availableMaps.first.showMarker(
                    coords:
                        MapLauncher.Coords(widget.latitude, widget.longitude),
                    title: "",
                  );
                }
              }).catchError((e) {
                _launchMapsUrl(widget.latitude, widget.longitude);
              });
            }
          },
          markers: Set<Marker>.of({
            Marker(
              // icon: mapPin,
              markerId: MarkerId("center"),
              draggable: false,
              position: LatLng(widget.latitude, widget.longitude),
            )
          }),
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
            animateCamera(LatLng(widget.latitude, widget.longitude));
          },
        ),
      ),
    );
  }

  animateCamera(LatLng latLng) {
    if (_controller == null) return;
    _controller!.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
        target: latLng, zoom: 13.0,
        // bearing: 45.0, tilt: 45.0
      )),
    );
  }
}

void _launchMapsUrl(double lat, double lon) async {
  final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
