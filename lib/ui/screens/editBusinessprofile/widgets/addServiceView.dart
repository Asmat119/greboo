import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/constants/app_assets.dart';
import 'package:grebooo/core/utils/config.dart';
import 'package:grebooo/core/viewmodel/controller/imagepickercontoller.dart';
import 'package:grebooo/ui/screens/editBusinessprofile/controller/addservicecontroller.dart';
import 'package:grebooo/ui/screens/editBusinessprofile/model/serviceListModel.dart';
import 'package:grebooo/ui/screens/homeTab/home.dart';

class AddServiceView extends StatefulWidget {
  final TextEditingController textController = TextEditingController();

  late final AppImagePicker appImagePicker;
  final Ser? serviceModel;
  final AddServiceController addServiceController =
      Get.find<AddServiceController>();
  String tag = "";

  int index;
  AddServiceView({required this.index, this.serviceModel});

  @override
  _AddServiceViewState createState() => _AddServiceViewState();
}

class _AddServiceViewState extends State<AddServiceView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tag == "") {
      widget.tag = DateTime.now().millisecondsSinceEpoch.toString();
      widget.appImagePicker = AppImagePicker(tag: widget.tag);
      if (widget.serviceModel != null) {
        widget.textController.text = widget.serviceModel!.name;
        widget.appImagePicker.imagePickerController
            .setImage(widget.serviceModel!.image);
      }
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              GetBuilder<ImagePickerController>(
                tag: widget.tag,
                builder: (controller) {
                  File? image =
                      widget.appImagePicker.imagePickerController.image;

                  if (image != null) {
                    widget.addServiceController.addServiceModels[widget.index]
                        .image = image;
                  }
                  return GestureDetector(
                      onTap: () {
                        widget.addServiceController
                            .addServiceModels[widget.index].url = "";
                        widget.appImagePicker.openBottomSheet();
                      },
                      child: image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                height: getProportionateScreenWidth(66),
                                width: getProportionateScreenWidth(66),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    image: DecorationImage(
                                        colorFilter: ColorFilter.mode(
                                            Colors.black.withOpacity(0.55),
                                            BlendMode.dstATop),
                                        image: FileImage(
                                          image,
                                        ),
                                        fit: BoxFit.cover)),
                                child: Center(
                                  child: Text(
                                    'change'.tr,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            getProportionateScreenWidth(11)),
                                  ),
                                ),
                              ),
                            )
                          : buildWidget(AppImages.uploadImage2, 66, 66));
                },
              ),
              SizedBox(width: 10),
              Expanded(
                  child: TextField(
                minLines: 1,
                maxLines: 2,
                textInputAction: TextInputAction.done,
                style: TextStyle(
                  fontSize: 15,
                ),
                controller: widget.textController,
                cursorHeight: 15,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (val) {
                  widget.addServiceController.addServiceModels[widget.index]
                      .title = val;
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'name_of_service'.tr,
                    hintStyle: TextStyle(fontSize: 15)),
              )),
              SizedBox(width: 10),
              if (widget.index != 0)
                IconButton(
                    onPressed: () {
                      widget.addServiceController.remove(widget.index);
                    },
                    icon: SvgPicture.asset(AppImages.closeGreen))
            ],
          ),
        ),
        SizedBox(height: 15),
        Divider(
          height: 0,
        ),
        SizedBox(height: 23),
      ],
    );
  }
}
