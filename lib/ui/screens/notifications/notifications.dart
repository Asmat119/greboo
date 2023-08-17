import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/constants/appSetting.dart';
import 'package:grebooo/core/constants/app_assets.dart';
import 'package:grebooo/core/constants/appcolor.dart';
import 'package:grebooo/core/extension/dateTimeFormatExtension.dart';
import 'package:grebooo/core/service/apiRoutes.dart';
import 'package:grebooo/core/service/repo/userRepo.dart';
import 'package:grebooo/core/utils/config.dart';
import 'package:grebooo/core/viewmodel/controller/selectservicecontoller.dart';
import 'package:grebooo/ui/screens/homeTab/controller/homeController.dart';
import 'package:grebooo/ui/screens/homeTab/post_list_screen.dart';
import 'package:grebooo/ui/screens/homeTab/postdetails.dart';
import 'package:grebooo/ui/screens/messagesTab/chatscreen.dart';
import 'package:grebooo/ui/screens/notifications/controller/allNotificationController.dart';
import 'package:grebooo/ui/screens/notifications/model/notificationModel.dart';
import 'package:pagination_view/pagination_view.dart';

import '../../../main.dart';

class AllNotification extends StatelessWidget {
  final NotificationController notificationController =
      Get.find<NotificationController>();
  static GlobalKey<PaginationViewState> paginationKey =
      GlobalKey<PaginationViewState>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (NotificationController controller) => PaginationView(
        itemBuilder:
            (BuildContext context, NotificationData notifyData, int index) {
          return notifyListTile(notifyData: notifyData);
        },
        physics: AlwaysScrollableScrollPhysics(),
        pullToRefresh: true,
        key: paginationKey,
        pageFetch: notificationController.fetchNotification,
        onEmpty: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  paginationKey.currentState!.refresh();
                },
                icon: Icon(Icons.restart_alt),
              ),
              Text('no_notification_yet'.tr),
            ],
          ),
        ),
        onError: (error) {
          return Center(child: Text(error));
        },
        initialLoader: GetPlatform.isAndroid
            ? Center(
                child: CircularProgressIndicator(
                strokeWidth: 2,
              ))
            : Center(
                child: CupertinoActivityIndicator(),
              ),
      ),
    );
  }

  notifyListTile({required NotificationData notifyData}) {
    return Column(
      children: [
        ListTile(
          horizontalTitleGap: 12,
          minVerticalPadding: 17,
          onTap: () async {
            if (notifyData.seen == false) {
              notificationController.readNotification(
                  notifyData.id, notifyData);
            }
            if (notifyData.type == 2) {
              Get.to(() => ChatView(
                  businessRef: notifyData.userRef,
                  channelRef: notifyData.channelRef,
                  userName: userController.user.userType ==
                          getServiceTypeCode(ServicesType.userType)
                      ? notifyData.user.businessName
                      : notifyData.user.name));
            } else if (notifyData.type == 4) {
              Get.find<HomeController>().currentPostRef = notifyData.sourceRef;

              /// if (userController.user.userType ==
              ///     getServiceTypeCode(ServicesType.userType)) {
              Get.to(() => PostDetails(
                    postRef: notifyData.sourceRef,
                  ));

              /// }
            } else if (notifyData.type == 5) {
              await userController.fetchUserDetail1();
              if (userController.user.firstAfterVerification) {
                Get.to(
                  () => PostListScreen(),
                );
              } else {
                print("==================**********//////////////////////");
              }
            }
          },
          contentPadding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          leading: Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: FadeInImage(
                  placeholder: AssetImage(AppImages.placeHolder),
                  image: notifyData.type == 5
                      ? AssetImage("assets/splash/icon.png")
                      : NetworkImage(imageUrl + notifyData.image)
                          as ImageProvider,
                  fit: BoxFit.cover,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      AppImages.placeHolder,
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    );
                  },
                  height: 40,
                  width: 40,
                ),
              ),
              Positioned(
                bottom: 0,
                right: -3,
                child: notifyData.seen
                    ? SizedBox()
                    : CircleAvatar(
                        radius: getProportionateScreenWidth(8),
                        backgroundColor: Colors.white,
                        child: Center(
                          child: CircleAvatar(
                            radius: getProportionateScreenWidth(6.5),
                            backgroundColor: Color(0xff8BC53F),
                          ),
                        ),
                      ),
              )
            ],
          ),
          title: Text(
            notifyData.text,
            maxLines: 2,
            style: TextStyle(fontSize: getProportionateScreenWidth(15)),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                DateTimeFormatExtension.displayChatTimeFromTimestamp(
                    notifyData.createdAt.toLocal()),
                style: TextStyle(
                  color: AppColor.kDefaultFontColor.withOpacity(0.65),
                  fontSize: getProportionateScreenWidth(12),
                ),
              ),
            ),
          ),
        ),
        Divider(
          height: 0,
        ),
      ],
    );
  }
}
