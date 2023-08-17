import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/constants/appSetting.dart';
import 'package:grebooo/core/constants/app_assets.dart';
import 'package:grebooo/core/constants/appcolor.dart';
import 'package:grebooo/core/extension/customButtonextension.dart';
import 'package:grebooo/core/service/apiRoutes.dart';
import 'package:grebooo/core/service/repo/userRepo.dart';
import 'package:grebooo/core/utils/config.dart';
import 'package:grebooo/core/viewmodel/controller/selectservicecontoller.dart';
import 'package:grebooo/main.dart';
import 'package:grebooo/ui/screens/homeTab/controller/reviewController.dart';
import 'package:grebooo/ui/screens/homeTab/model/reviewModel.dart';
import 'package:grebooo/ui/shared/appbar.dart';
import 'package:grebooo/ui/shared/custombutton.dart';
import 'package:pagination_view/pagination_view.dart';

import 'givefeedback.dart';

class CustomerReviewed extends StatefulWidget {
  final String businessRef;

  CustomerReviewed({Key? key, required this.businessRef}) : super(key: key);

  @override
  _CustomerReviewedState createState() => _CustomerReviewedState();
}

class _CustomerReviewedState extends State<CustomerReviewed> {
  final ReviewController reviewController = Get.put(ReviewController());
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    reviewController.selectedBusinessRef = widget.businessRef;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(title: 'customer_reviews'.tr),
        body: GetBuilder(
          builder: (ReviewController controller) => controller.isFetching
              ? Center(
                  child: Platform.isIOS
                      ? CupertinoActivityIndicator()
                      : CircularProgressIndicator(
                          strokeWidth: 2,
                        ))
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: PaginationView(
                            pullToRefresh: true,
                            key: Key(DateTime.now().toString()),
                            physics: AlwaysScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context,
                                    ReviewData reviewData, int index) =>
                                reviewBox(reviewData),
                            pageFetch: reviewController.fetchReviews,
                            onError: (error) {
                              debugPrint("Error $error");
                              return Center(child: Text(error));
                            },
                            onEmpty: Center(
                              child: Text("no_reviews_yet".tr),
                            ),
                            initialLoader: GetPlatform.isAndroid
                                ? Center(
                                    child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ))
                                : Center(child: CupertinoActivityIndicator()),
                          ),
                        ),
                        getHeightSizedBox(h: 90),
                      ],
                    ),
                    userController.user.userType ==
                            getServiceTypeCode(ServicesType.providerType)
                        ? SizedBox()
                        : Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 6,
                                        offset: Offset(0, -2),
                                        color: AppColor.kDefaultFontColor
                                            .withOpacity(0.05))
                                  ]),
                              child: Column(
                                children: [
                                  getHeightSizedBox(h: 12),
                                  SafeArea(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30),
                                      child: CustomButton(
                                          type: CustomButtonType.colourButton,
                                          text: 'give_feedback'.tr,
                                          onTap: () {
                                            Get.to(() => GiveFeedback(
                                                businessRef: widget.businessRef
                                                    .toString()));
                                          }),
                                    ),
                                  ),
                                  getHeightSizedBox(h: 12),
                                ],
                              ),
                            ))
                  ],
                ),
        ));
  }

  Widget reviewBox(ReviewData reviewData) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: AppColor.kDefaultFontColor.withOpacity(0.07),
                blurRadius: 6,
                offset: Offset(0, 1))
          ]),
      margin: EdgeInsets.symmetric(horizontal: kDefaultPadding)
          .copyWith(bottom: 10, top: 5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: FadeInImage(
                    placeholder: AssetImage(AppImages.placeHolder),
                    image:
                        NetworkImage("${imageUrl + reviewData.user.picture}"),
                    height: 40,
                    width: 40,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        AppImages.placeHolder,
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      );
                    },
                    fit: BoxFit.cover,
                  ),
                ),
                getHeightSizedBox(w: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reviewData.user.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: getProportionateScreenWidth(14)),
                    ),
                    getHeightSizedBox(h: 4),
                    RatingBar.builder(
                      initialRating: reviewData.rating.toDouble(),
                      minRating: 1,
                      direction: Axis.horizontal,
                      ignoreGestures: true,
                      itemCount: 5,
                      unratedColor: Color(0xffE8E8E8),
                      itemSize: 16,
                      itemPadding: EdgeInsets.only(right: 2.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Color(0xffFAAA01),
                      ),
                      onRatingUpdate: (double value) {},
                    )
                  ],
                )
              ],
            ),
            getHeightSizedBox(h: 10),
            Text(
              reviewData.text,
              style: TextStyle(
                fontSize: getProportionateScreenWidth(13),
              ),
            ),
            getHeightSizedBox(h: 10),
            if (reviewData.image != "")
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: FadeInImage(
                  placeholder: AssetImage(AppImages.placeHolder),
                  image: NetworkImage("${imageUrl + reviewData.image}"),
                  height: 120,
                  width: Get.width - 30,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      AppImages.placeHolder,
                      height: 120,
                      width: Get.width - 30,
                      fit: BoxFit.cover,
                    );
                  },
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
