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
import 'package:grebooo/main.dart';
import 'package:grebooo/ui/screens/messagesTab/chatscreen.dart';
import 'package:grebooo/ui/screens/messagesTab/controller/allChatController.dart';
import 'package:grebooo/ui/screens/messagesTab/model/chatListModel.dart';
import 'package:pagination_view/pagination_view.dart';

class AllMessages extends StatefulWidget {
  static GlobalKey<PaginationViewState> paginationKey =
      GlobalKey<PaginationViewState>();
  @override
  State<AllMessages> createState() => _AllMessagesState();
}

class _AllMessagesState extends State<AllMessages> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(builder: (AllChatController controller) {
      return PaginationView(
        pullToRefresh: true,
        key: AllMessages.paginationKey,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder:
            (BuildContext context, AllChatData allChatData, int index) =>
                chatListTile(allChatData),
        pageFetch: controller.fetchAllChatList,
        onError: (error) {
          return Center(child: Text(error));
        },
        onEmpty: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    AllMessages.paginationKey.currentState!.refresh();
                  },
                  icon: Icon(Icons.restart_alt)),
              Text("no_messages_yet".tr),
            ],
          ),
        ),
        initialLoader: GetPlatform.isAndroid
            ? Center(
                child: CircularProgressIndicator(
                strokeWidth: 2,
              ))
            : Center(child: CupertinoActivityIndicator()),
      );
    });
  }

  chatListTile(AllChatData allChatData) {
    return GetBuilder(
      builder: (AllChatController controller) => Column(
        children: [
          ListTile(
            horizontalTitleGap: 12,
            contentPadding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            leading: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: FadeInImage(
                    placeholder: AssetImage(AppImages.placeHolder),
                    image: NetworkImage(
                        "${imageUrl + allChatData.chatUserDetail.picture}"),
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
                  child: allChatData.unreadCount == 0
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
            subtitle: Text(
              allChatData.lastMessage.message,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: getProportionateScreenWidth(13),
                  fontWeight: FontWeight.w400,
                  color: AppColor.kDefaultFontColor),
            ),
            title: Text(
              userController.user.userType ==
                      getServiceTypeCode(ServicesType.userType)
                  ? allChatData.chatUserDetail.businessName
                  : allChatData.chatUserDetail.name,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: getProportionateScreenWidth(15)),
            ),
            onTap: () {
              Get.to(() => ChatView(
                  channelRef: allChatData.channelRef,
                  businessRef: allChatData.chatUserDetail.id,
                  userName: userController.user.userType ==
                      getServiceTypeCode(ServicesType.userType)
                      ? allChatData.chatUserDetail.businessName
                      : allChatData.chatUserDetail.name,));
              controller.realAllMessagesLocally(allChatData);
            },
            trailing: Padding(
              padding: EdgeInsets.only(bottom: 11),
              child: Text(
                DateTimeFormatExtension.displayMSGTimeFromTimestamp(
                    allChatData.lastMessage.createdAt.toLocal()),
                style: TextStyle(
                    fontSize: getProportionateScreenWidth(13),
                    color: AppColor.kDefaultFontColor.withOpacity(0.50)),
              ),
            ),
          ),
          Divider(
            height: 0,
            thickness: 1,
            color: AppColor.kDefaultFontColor.withOpacity(0.08),
          ),
        ],
      ),
    );
  }
}
