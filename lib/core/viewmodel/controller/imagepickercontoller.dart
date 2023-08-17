import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grebooo/core/service/apiRoutes.dart';
import 'package:grebooo/core/utils/appFunctions.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerController extends GetxController {
  setImage(String url) async {
    if (url != "") {
      _image = await urlToFile(imageUrl + url);
      debugPrint("ImagePickerController SET IMAGE $tag");
      update();
    }
  }

  String? tag;
  File? _image;
  File? get image => _image;
  set image(File? value) {
    _image = value;
    update();
  }

  void resetImage() {
    image = null;
  }

  ImagePickerController({this.tag});
}

class AppImagePicker {
  ImagePicker imagePicker = ImagePicker();
  String? tag;
  late ImagePickerController _imagePickerController;
  ImagePickerController get imagePickerController =>
      Get.find<ImagePickerController>(tag: tag);

  AppImagePicker({String? tag}) {
    this.tag = tag;
    _imagePickerController = Get.put(ImagePickerController(tag: tag), tag: tag);
  }

  update() {
    _imagePickerController.update();
  }
  Future<void> browseImage(ImageSource imageSource) async {


    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: imageSource);

    if (pickedImage != null) {
      final croppedImage = await ImageCropper().cropImage(
        sourcePath: pickedImage.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxWidth: 800,
        maxHeight: 800,
        compressFormat: ImageCompressFormat.jpg,
                uiSettings: [
                AndroidUiSettings(
                toolbarTitle: 'Image crop',
                toolbarColor: Colors.white,
                ),
                IOSUiSettings(
                title: 'Cropper',
            ),
                ]
      );

      if (croppedImage != null) {

          imagePickerController.image = File(croppedImage.path);

      }
    }
  }
  // Future browseImage(ImageSource imageSource) async {
  //   try {
  //     var pickedFile =
  //         await imagePicker.pickImage(source: imageSource, imageQuality: 50);
  //
  //     File? file = (await ImageCropper().cropImage(
  //       sourcePath: pickedFile!.path,
  //       compressQuality: 100,
  //       maxWidth: 1080,
  //       maxHeight: 1080,
  //       compressFormat: ImageCompressFormat.jpg,
  //         uiSettings: [
  //         AndroidUiSettings(
  //         toolbarTitle: 'Image crop',
  //         toolbarColor: Colors.white,
  //         ),
  //         IOSUiSettings(
  //         title: 'Cropper',
  //     ),
  //         ]
  //     )) as File?;
  //
  //     imagePickerController.image = file;
  //     print("MY IMAGE  NAME "+imagePickerController.image.toString());
  //   } on Exception catch (e) {
  //     return Future.error(e);
  //   }
  // }
  // Future<void> browseImage(ImageSource imageSource) async {
  //   final imagePicker = ImagePicker();
  //   final pickedImage = await imagePicker.pickImage(source: imageSource);
  //
  //   if (pickedImage != null) {
  //
  //       _imagePickerController._image = File(pickedImage.path);
  //
  //       print("MY IMAGE"+_imagePickerController._image.toString());
  //
  //   }
  // }
  Future<void> openBottomSheet() async {
    if (Platform.isIOS) {
      await showCupertinoModalPopup<void>(
        context: Get.context as BuildContext,
        builder: (BuildContext context) => CupertinoActionSheet(
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
                child: const Text(
                  'Camera',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () async {

                  final cameraPermissionStatus = await Permission.camera.status;
                  if (cameraPermissionStatus.isDenied) {
                    Permission.camera.request().then((value) async {
                      if (value.isPermanentlyDenied) {
                        await openAppSettings();
                      } else if (value.isDenied) {
                        Permission.camera.request();
                      } else if (value.isGranted) {
                        await browseImage(ImageSource.camera);
                      }
                    });
                  } else if (cameraPermissionStatus.isRestricted) {
                    await openAppSettings();
                  } else if (cameraPermissionStatus.isGranted) {
                    await browseImage(ImageSource.camera);
                  }
                  // await browseImage(ImageSource.camera).catchError((e) async {
                  //   await openAppSettings();
                  // });

                  Get.back();
                }),
            CupertinoActionSheetAction(
              child: const Text(
                'Gallery',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {

                final photoPermissionStatus = await Permission.storage.status;
                if (photoPermissionStatus.isDenied) {
                  Permission.photos.request().then((value) async {
                    if (value.isPermanentlyDenied) {
                      await openAppSettings();
                    } else if (value.isDenied) {
                      Permission.photos.request();
                    } else if (value.isGranted) {
                      await browseImage(ImageSource.gallery);
                    }
                  });
                } else if (photoPermissionStatus.isRestricted) {
                  await openAppSettings();
                } else if (photoPermissionStatus.isGranted) {
                  await browseImage(ImageSource.gallery);
                }
                // await browseImage(ImageSource.gallery);

                Get.back();
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ),
      );
    } else {
      await Get.bottomSheet(
        Container(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                tileColor: Colors.white,
                onTap: () async {
                  await browseImage(ImageSource.gallery);
                  Get.back();
                },
              ),
              const Divider(
                height: 0.5,
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: const Text('Camera'),
                tileColor: Colors.white,
                onTap: () async {
                  final cameraPermissionStatus = await Permission.camera.status;
                  if (cameraPermissionStatus.isDenied) {
                    Permission.camera.request().then((value) async {
                      if (value.isPermanentlyDenied) {
                        await openAppSettings();
                      } else if (value.isDenied) {
                        Permission.camera.request();
                      } else if (value.isGranted) {
                        await browseImage(ImageSource.camera);
                      }
                    });
                  } else if (cameraPermissionStatus.isRestricted) {
                    await openAppSettings();
                  } else if (cameraPermissionStatus.isGranted) {
                    await browseImage(ImageSource.camera);
                  }

                  Get.back();
                },
              ),
            ],
          ),
        ),
        barrierColor: Colors.black.withOpacity(0.3),
      );
    }
  }
}
