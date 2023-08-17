import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/constants/app_assets.dart';
import 'controller/controller.dart';

class ImagePicker1 extends StatefulWidget {
  const ImagePicker1({Key? key}) : super(key: key);

  @override
  _ImagePicker1State createState() => _ImagePicker1State();
}

class _ImagePicker1State extends State<ImagePicker1> {
  ImageController imageController1 = Get.put(ImageController());
  final picker = ImagePicker();
  File? image;

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = File(pickedFile!.path);
      if (image != null) {
        imageController1.imagePath = image!.path;
      }
    });
  }

  Future getCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      image = File(pickedFile!.path);
      if (image != null) {
        imageController1.imagePath = image!.path;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (ImageController controller) {
        return imageController1.imagePath != ""
            ? GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext bc) {
                        return SafeArea(
                          child: SizedBox(
                            child: Wrap(
                              children: [
                                ListTile(
                                  leading: Icon(Icons.photo_library),
                                  title: Text('Photo Library'),
                                  tileColor: Colors.white,
                                  onTap: () {
                                    Get.back();
                                    getImage();

                                    // Get.back();
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.photo_camera),
                                  title: Text('Camera'),
                                  tileColor: Colors.white,
                                  onTap: () {
                                    getCamera();
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
                child: Container(
                  height: 130,
                  width: 130,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: FileImage(
                          File(imageController1.imagePath),
                        )),
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
              )
            : GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext bc) {
                        return SafeArea(
                          child: SizedBox(
                            child: Wrap(
                              children: [
                                ListTile(
                                  leading: Icon(Icons.photo_library),
                                  title: Text('Photo Library'),
                                  tileColor: Colors.white,
                                  onTap: () {
                                    getImage();
                                    Get.back();
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.photo_camera),
                                  title: Text('Camera'),
                                  tileColor: Colors.white,
                                  onTap: () {
                                    getCamera();
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Container(
                    height: 130,
                    width: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: SvgPicture.asset(
                      AppImages.uploadImg,
                    ),
                  ),
                ),
              );
      },
    );
  }
}
