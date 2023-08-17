import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/constants/appSetting.dart';
import 'package:grebooo/core/constants/app_assets.dart';
import 'package:grebooo/core/service/apiRoutes.dart';
import 'package:grebooo/core/utils/config.dart';
import 'package:grebooo/core/viewmodel/controller/serviceOfferedController.dart';
import 'package:grebooo/ui/screens/editBusinessprofile/details3.dart';
import 'package:grebooo/ui/screens/login/model/currentUserModel.dart';
import 'package:grebooo/ui/shared/appbar.dart';
import 'package:pagination_view/pagination_view.dart';

import 'home.dart';

class ServiceOffered extends StatelessWidget {
  final bool isEdit;
  final String? businessRef;
  final ServiceOfferedController serviceOfferedController =
      Get.put(ServiceOfferedController());

  static GlobalKey<PaginationViewState> paginationKey =
      GlobalKey<PaginationViewState>();
  ServiceOffered({Key? key, this.isEdit = false, this.businessRef})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    serviceOfferedController.userRef = businessRef;
    return Scaffold(
      appBar: appBar(title: 'services_offered'.tr, actions: [
        isEdit
            ? IconButton(
                padding: EdgeInsets.only(right: 22),
                onPressed: () {
                  Get.to(() => DetailsPage3(
                        isNext: false,
                      ));
                },
                icon: buildWidget(AppImages.editProfile, 19, 19))
            : SizedBox()
      ]),
      body: PaginationView(
        key: paginationKey,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder:
            (BuildContext context, ServiceList serviceList, int index) {
          return buildListTile(
              text: serviceList.name, image: serviceList.image);
        },
        pullToRefresh: true,
        pageFetch: serviceOfferedController.getServices,
        onEmpty: Center(
          child: Text('no_post_found'.tr),
        ),
        onError: (error) {
          return Center(child: Text(error));
        },
      ),
    );
  }

  Widget buildListTile({required String text, required String image}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: FadeInImage(
                  placeholder: AssetImage(AppImages.placeHolder),
                  image: NetworkImage("${imageUrl + image}"),
                  height: 60,
                  width: 60,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      AppImages.placeHolder,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    );
                  },
                  fit: BoxFit.cover,
                ),
              ),
              getHeightSizedBox(w: 10),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: getProportionateScreenWidth(14)),
                ),
              )
            ],
          ),
        ),
        getHeightSizedBox(h: 15),
        Divider(
          height: 0,
        ),
        getHeightSizedBox(h: 15),
      ],
    );
  }
}
