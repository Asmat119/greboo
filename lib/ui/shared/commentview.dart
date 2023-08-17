import 'package:flutter/material.dart';
import 'package:grebooo/core/constants/appSetting.dart';
import 'package:grebooo/core/constants/app_assets.dart';
import 'package:grebooo/core/constants/appcolor.dart';
import 'package:grebooo/core/extension/dateTimeFormatExtension.dart';
import 'package:grebooo/core/service/apiRoutes.dart';
import 'package:grebooo/core/utils/config.dart';
import 'package:grebooo/ui/screens/homeTab/model/commentModel.dart';

class CommentView extends StatelessWidget {
  final CommentsData commentsData;

  CommentView({Key? key, required this.commentsData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getHeightSizedBox(h: 10),
        Container(
          margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColor.kDefaultFontColor.withOpacity(0.07),
                  offset: Offset(0, 1),
                  blurRadius: 6,
                )
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getHeightSizedBox(h: 15),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: FadeInImage(
                        placeholder: AssetImage(AppImages.placeHolder),
                        image:
                            NetworkImage("${imageUrl + commentsData.picture}"),
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
                    getHeightSizedBox(w: 9),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            commentsData.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: getProportionateScreenWidth(16)),
                          ),
                          getHeightSizedBox(h: 5),
                          Text(
                            DateTimeFormatExtension
                                .displayTimeFromTimestampForPost(
                                    commentsData.createdAt.toLocal()),
                            style: TextStyle(
                                color: AppColor.kDefaultFontColor
                                    .withOpacity(0.57),
                                fontSize: getProportionateScreenWidth(13)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                getHeightSizedBox(h: 10),
                Text(
                  commentsData.text,
                  style: TextStyle(
                      color: AppColor.kDefaultFontColor.withOpacity(0.89),
                      fontSize: getProportionateScreenWidth(14)),
                ),
                getHeightSizedBox(h: 16),
              ],
            ),
          ),
        ),
        getHeightSizedBox(h: 5),
      ],
    );
  }
}
