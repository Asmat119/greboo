import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grebooo/core/constants/appSetting.dart';
import 'package:grebooo/core/constants/app_assets.dart';
import 'package:grebooo/core/constants/appcolor.dart';
import 'package:grebooo/core/service/repo/userRepo.dart';
import 'package:grebooo/core/utils/config.dart';
import 'package:grebooo/ui/screens/baseScreen/controller/baseController.dart';
import 'package:grebooo/ui/screens/homeTab/controller/homeController.dart';
import 'package:grebooo/ui/screens/homeTab/model/postModel.dart';
import 'package:grebooo/ui/screens/homeTab/viewAllCategories.dart';
import 'package:grebooo/ui/shared/custombutton.dart';
import 'package:grebooo/ui/shared/placeScreen.dart';
import 'package:grebooo/ui/shared/postview.dart';
import 'package:pagination_view/pagination_view.dart';
import '../../../core/viewmodel/controller/selectservicecontoller.dart';
import '../../../main.dart';
import 'controller/postDetailController.dart';


class Home extends StatefulWidget {
  static GlobalKey<PaginationViewState> paginationViewKey =
      GlobalKey<PaginationViewState>();

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _displayAll = false;
  final PageController _pageController = PageController();

  HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final curvedValue = Curves.easeInOutSine.transform(1) - 1.0;
    homeController.fetchOtherProviderPost;
    print("HOME POSTS");
    print(homeController.getPosts.length);


    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){
      //     _pageController.nextPage(duration: Duration(milliseconds: 1000), curve: Curves.easeIn);
      //   },
      //   child: Icon(Icons.add),
      // ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            userController.user.userType ==
                    getServiceTypeCode(ServicesType.userType)
                ?
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            spreadRadius: 1,
                            blurRadius: 2),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      child: Row(
                        children: [
                          buildWidget(AppImages.location, 18, 13),
                          SizedBox(
                            width: getProportionateScreenWidth(9),
                          ),
                          GetBuilder(
                            builder: (BaseController controller) {
                              if(controller.address.isEmpty){
                                print("else");


                              }
                             return SizedBox(
                                width: getProportionateScreenWidth(250),
                                height: 18,
                                child: Text(
                                  controller.address,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: getProportionateScreenWidth(14),
                                      color: AppColor.kDefaultFontColor
                                          .withOpacity(0.75)),
                                ));},
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () async {
                      await GoogleSearchPlace.buildGooglePlaceSearch()
                          .then((value) async {
                        if (!(value.long == 0 &&
                            value.late == 0 &&
                            value.address == "")) {
                          Get.find<BaseController>().changeAddress(
                              value.late, value.long, value.address);
                        }
                      });
                    },
                    child: Text(
                      'change'.tr,
                      style: TextStyle(
                          fontSize: getProportionateScreenWidth(14),
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ) : SizedBox(),
            Divider(),
            getHeightSizedBox(h: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Row(
                children: [
                  Text(
                    'business_categories'.tr,
                    style: TextStyle(fontSize: getProportionateScreenWidth(16)),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => ViewAll());
                    },
                    child: Text(
                      'view_all'.tr,
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(14),
                      ),
                    ),
                  )
                ],
              ),
            ),
            getHeightSizedBox(h: 62),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: GetBuilder(builder: (HomeController controller) {
                return SizedBox(
                  height: 80,
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,

                    children: List.generate(
                        userController.globalCategory.length,
                            (index) => BusinessCategories(
                          text: userController.globalCategory[index].name,
                          textStyle: TextStyle(
                            fontSize: getProportionateScreenWidth(11),
                            color: controller.selectedCategory.contains(
                                userController
                                    .globalCategory[index].id)
                                ? AppColor.kDefaultFontColor
                                : AppColor.kDefaultFontColor,

                          ),
                          onTap: () {
                            controller.updateCategory(
                                userController.globalCategory[index].id);
                          },
                          //height: 150,
                          backgroundColor: controller.selectedCategory
                              .contains(userController
                              .globalCategory[index].id)
                              ? Colors.green[100]
                              : Colors.white,
                          border: Border.all(
                            color: AppColor.categoriesColor,
                            width: 1,
                          ),
                        ))
                      ..add(InkWell(
                        onTap: () => setState(() => _displayAll = !_displayAll),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 3,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),

                          ),
                        ),
                      )),
                  ),
                );
              }),
            ),
            getHeightSizedBox(h: 10),
            Divider(
              height: 0,
            ),
            //   : SizedBox(),

          //  upperWidgets() ,
            GetBuilder(
              builder: (HomeController controller) => FutureBuilder<List<PostData>>(
                  future: controller.fetchUserPost(0),
                  builder: (context,AsyncSnapshot<List<PostData>> snapshot) {
                    print("LENGTH");
                    print(controller.getPosts.length);
                    if(!snapshot.hasData){
                      return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Home.paginationViewKey.currentState!.refresh();
                                  },
                                  icon: Icon(Icons.restart_alt),
                                ),
                                Text("no_posts_yet".tr),
                              ],
                            ),
                          );
                    }else{
                      return
                        ListView.builder(
                      //  controller: _pageController,
                        itemCount: controller.getPosts!.length,
                        scrollDirection: Axis.vertical,
                        //
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder:
                            (BuildContext context, int index) =>
                            PostView(
                              postData: controller.getPosts![index], index: index,
                            ),
                        );
                        //  pageFetch: controller.fetchUserPost,
                        // userController.user.userType ==
                        //         getServiceTypeCode(ServicesType.userType)
                        //     ? controller.fetchUserPost
                        //     : controller.fetchProviderPost,
                        // onError: (error) {
                        //   return Center(child: Text(error));
                        // },
                        // onEmpty: Center(
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       IconButton(
                        //         onPressed: () {
                        //           Home.paginationViewKey.currentState!.refresh();
                        //         },
                        //         icon: Icon(Icons.restart_alt),
                        //       ),
                        //       Text("no_posts_yet".tr),
                        //     ],
                        //   ),
                        // ),
                        // initialLoader: GetPlatform.isAndroid
                        //     ? Center(
                        //         child: CircularProgressIndicator(
                        //           strokeWidth: 2,
                        //         ),
                        //       )
                        //     : Center(
                        //         child: CupertinoActivityIndicator(),
                        //       ),


                    }
                  }
              ),
            )

          ],
        ),
      ),
    );
  }


  Widget upperWidgets() {
    return Column(
      children: [
        // userController.user.userType ==
        //         getServiceTypeCode(ServicesType.userType)
        //     ?
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade300,
                        spreadRadius: 1,
                        blurRadius: 2),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  child: Row(
                    children: [
                      buildWidget(AppImages.location, 18, 13),
                      SizedBox(
                        width: getProportionateScreenWidth(9),
                      ),
                      GetBuilder(
                        builder: (BaseController controller) =>
                            SizedBox(
                                width: getProportionateScreenWidth(250),
                                height: 18,
                                child: Text(
                                  controller.address,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: getProportionateScreenWidth(14),
                                      color: AppColor.kDefaultFontColor
                                          .withOpacity(0.75)),
                                )),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () async {
                  await GoogleSearchPlace.buildGooglePlaceSearch()
                      .then((value) async {
                    if (!(value.long == 0 &&
                        value.late == 0 &&
                        value.address == "")) {
                      Get.find<BaseController>().changeAddress(
                          value.late, value.long, value.address);
                    }
                  });
                },
                child: Text(
                  'change'.tr,
                  style: TextStyle(
                      fontSize: getProportionateScreenWidth(14),
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
        Divider(),
        getHeightSizedBox(h: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Row(
            children: [
              Text(
                'business_categories'.tr,
                style: TextStyle(fontSize: getProportionateScreenWidth(16)),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Get.to(() => ViewAll());
                },
                child: Text(
                  'view_all'.tr,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(14),
                  ),
                ),
              )
            ],
          ),
        ),
        getHeightSizedBox(h: 62),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: GetBuilder(builder: (HomeController controller) {
            return SizedBox(
              height: 80,
              child: ListView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,

                children: List.generate(
                    userController.globalCategory.length,
                        (index) =>
                        BusinessCategories(
                          text: userController.globalCategory[index].name,
                          textStyle: TextStyle(
                            fontSize: getProportionateScreenWidth(11),
                            color: controller.selectedCategory.contains(
                                userController
                                    .globalCategory[index].id)
                                ? AppColor.kDefaultFontColor
                                : AppColor.kDefaultFontColor,

                          ),
                          onTap: () {
                            controller.updateCategory(
                                userController.globalCategory[index].id);
                          },
                          //height: 150,
                          backgroundColor: controller.selectedCategory
                              .contains(userController
                              .globalCategory[index].id)
                              ? Colors.green[100]
                              : Colors.white,
                          border: Border.all(
                            color: AppColor.categoriesColor,
                            width: 1,
                          ),
                        ))
                  ..add(InkWell(
                    onTap: () => setState(() => _displayAll = !_displayAll),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),

                      ),
                    ),
                  )),
              ),
            );
          }),
        ),
        getHeightSizedBox(h: 10),
        Divider(
          height: 0,
        ),
        //   : SizedBox(),
      ],
    );
  }
}

/* PaginationView(
                key: Home.paginationViewKey,
                pullToRefresh: true,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder:
                    (BuildContext context, PostData postData, int index) =>

                        PostView(
                  postData: postData,
                ),
                pageFetch: controller.fetchUserPost,
                // userController.user.userType ==
                //         getServiceTypeCode(ServicesType.userType)
                //     ? controller.fetchUserPost
                //     : controller.fetchProviderPost,
                onError: (error) {
                  return Center(child: Text(error));
                },
                onEmpty: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Home.paginationViewKey.currentState!.refresh();
                        },
                        icon: Icon(Icons.restart_alt),
                      ),
                      Text("no_posts_yet".tr),
                    ],
                  ),
                ),
                initialLoader: GetPlatform.isAndroid
                    ? Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Center(
                        child: CupertinoActivityIndicator(),
                      ),
              ),*/

Widget buildWidget(String image, double height, double width) {
  return Container(
    height: getProportionateScreenWidth(height),
    width: getProportionateScreenWidth(width),
    child: SvgPicture.asset(
      image,
      fit: BoxFit.fill,
    ),
  );
}

// GetBuilder(
//   builder: (HomeController controller) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       physics: BouncingScrollPhysics(),
//       child: Padding(
//         padding: EdgeInsets.only(left: kDefaultPadding),
//         child: GetBuilder(
//           builder: (UserController c) => Row(
//             children: List.generate(
//                 userController.globalCategory.length, (index) {
//               var catRef = userController.globalCategory[index];
//
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: BusinessCategories(
//                   text: catRef.name,
//                   textStyle: TextStyle(
//                     fontSize: getProportionateScreenWidth(13),
//                     color: controller.selectedCategory
//                         .contains(catRef.id)
//                         ? Colors.white
//                         : AppColor.kDefaultFontColor,
//                   ),
//                   onTap: () {
//                     controller.updateCategory(catRef.id);
//                   },
//                   height: 60,
//                   backgroundColor:
//                   controller.selectedCategory.contains(catRef.id)
//                       ? AppColor.kDefaultColor
//                       : Colors.white,
//                   border: Border.all(
//                     color: AppColor.categoriesColor,
//                     width: 1,
//                   ),
//                 ),
//               );
//             }),
//           ),
//         ),
//       ),
//     );
//   },
// ),
// GetBuilder(
//   builder: (HomeController controller) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       physics: BouncingScrollPhysics(),
//       child: Padding(
//         padding: EdgeInsets.only(left: kDefaultPadding),
//         child: GetBuilder(
//           builder: (UserController c) => Row(
//             children: List.generate(
//                 userController.globalCategory.length, (index) {
//               var catRef = userController.globalCategory[index];
//
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: BusinessCategories(
//                   text: catRef.name,
//                   textStyle: TextStyle(
//                     fontSize: getProportionateScreenWidth(13),
//                     color: controller.selectedCategory
//                         .contains(catRef.id)
//                         ? Colors.white
//                         : AppColor.kDefaultFontColor,
//                   ),
//                   onTap: () {
//                     controller.updateCategory(catRef.id);
//                   },
//                   height: 60,
//                   backgroundColor:
//                   controller.selectedCategory.contains(catRef.id)
//                       ? AppColor.kDefaultColor
//                       : Colors.white,
//                   border: Border.all(
//                     color: AppColor.categoriesColor,
//                     width: 1,
//                   ),
//                 ),
//               );
//             }),
//           ),
//         ),
//       ),
//     );
//   },
// ),
