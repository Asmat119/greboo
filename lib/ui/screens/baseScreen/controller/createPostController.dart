import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grebooo/core/viewmodel/controller/imagepickercontoller.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_compress/video_compress.dart';

import '../../../../core/service/repo/postRepo.dart';
import '../../../shared/loader.dart';


class AddPostController extends GetxController {
  final TextEditingController postCaption = TextEditingController();
  bool imageDelete = false;
  bool videoDelete = false;

  File? _uploadFile;
  String _networkImage = "";

  String get networkImage => _networkImage;

  set networkImage(String value) {
    _networkImage = value;
    Future.delayed(Duration.zero, () {
      update();
    });
  }

  File? get uploadFile => _uploadFile;

  bool _isImageSelected = false;

  bool get isImageSelected => _isImageSelected;

  set isImageSelected(bool value) {
    _isImageSelected = value;
    Future.delayed(Duration.zero, () {
      update();
    });
  }

  set uploadFile(File? value) {
    _uploadFile = value;
    isImageSelected = true;
    Future.delayed(Duration.zero, () {
      update();
    });
  }

  File? _thumbnail;

  File? get thumbnail => _thumbnail;

  set thumbnail(File? value) {
    _thumbnail = value;
    Future.delayed(Duration.zero, () {
      update();
    });
  }

  reset() {
    postCaption.clear();
    uploadFile = thumbnail = null;
  }

  Future addPost() async {
    var response = await PostRepo.postUpload(
      caption: {"text": postCaption.text.trim()},
      isImage: isImage,
      image: uploadFile,
      thumbnail: thumbnail,
    );

    if (response != null) {
      return response;
    }
  }

  Future updatePost(String postRef, bool deleteVideo, bool deleteImage) async {
    var response = await PostRepo.postUpdate(
      caption: {
        "text": postCaption.text.trim(),
        "postRef": postRef,
        "deleteVideo": deleteVideo,
        "deleteImage": deleteImage,
      },
      isImage: isImage,
      image: uploadFile,
      thumbnail: thumbnail,
    );

    if (response != null) {
      return response;
    }
  }

  int _isImage = 0;

  int get isImage => _isImage;

  set isImage(int value) {
    _isImage = value;
    Future.delayed(Duration.zero, () {
      update();
    });
  }



  Future browseImage(ImageSource imageSource, bool isVideo) async {
    try {
      ImagePicker imagePicker = ImagePicker();
      if (isVideo) {
        isImage = 1;
        var pickedVideo = await imagePicker.pickVideo(
          source: imageSource,
        );
        if (pickedVideo != null) {
          LoadingOverlay.of().show();
          MediaInfo? mediaInfo = await VideoCompress.compressVideo(
            pickedVideo.path,
            quality: VideoQuality.MediumQuality,
            deleteOrigin: true, // It's false by default
          );
          LoadingOverlay.of().hide();

          final uint8list = await VideoCompress.getFileThumbnail(
            mediaInfo!.path.toString(),
          );
          thumbnail = uint8list;

          uploadFile = File(mediaInfo.path.toString());
        }

        Future.delayed(Duration.zero, () {
          update();
        });
      } else {
        isImage = 2;

        var pickedFile =
            await imagePicker.pickImage(source: imageSource, imageQuality: 50);

        if (pickedFile != null) {
          final croppedImage = await ImageCropper().cropImage(
              sourcePath: pickedFile.path,
              aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
              compressQuality: 100,
              maxWidth: 700,
              maxHeight: 700,
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

            uploadFile = File(croppedImage.path);
            print("Image file from ggallery :$uploadFile");

          }
        }
       // final file = (await ImageCropper().cropImage(
       //    sourcePath: pickedFile!.path,
       //    aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
       //    compressQuality: 100,
       //    maxHeight: 700,
       //    maxWidth: 700,
       //    compressFormat: ImageCompressFormat.jpg,
       //    uiSettings:[
       //      AndroidUiSettings(
       //        toolbarColor: Colors.white,
       //        toolbarTitle: "Image Cropper",
       //      ),
       //      IOSUiSettings(
       //        title: 'Image cropper'
       //      )
       //    ] ,
       //  )) as File?;
       //  uploadFile = file;
        Future.delayed(Duration.zero, () {
          update();
        });
      }
    } on Exception catch (e) {
      return Future.error(e);
    }
  }

  void openBottomSheet({required BuildContext context, required bool isVideo}) {
    if (Platform.isIOS) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              child: const Text(
                'Camera',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                browseImage(ImageSource.camera, isVideo).catchError((e) async {
                  await openAppSettings();
                });

                Get.back();
                uploadFile = null;
              },
            ),
            CupertinoActionSheetAction(
              child: const Text(
                'Gallery',
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
                      browseImage(ImageSource.camera, isVideo);
                    }
                  });
                } else if (cameraPermissionStatus.isRestricted) {
                  await openAppSettings();
                } else if (cameraPermissionStatus.isGranted) {
                  browseImage(ImageSource.camera, isVideo)
                      .catchError((e) async {
                    await openAppSettings();
                  });
                  ;
                }

                Get.back();
              },
              // onPressed: () {
              //   browseImage(ImageSource.gallery, isVideo).catchError((e) async {
              //     await openAppSettings();
              //   });
              //
              //   Get.back();
              //   uploadFile = null;
              // },
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
      Get.bottomSheet(
        Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Photo Library'),
              tileColor: Colors.white,
              onTap: () async {
                browseImage(ImageSource.gallery, isVideo)
                    .catchError((e) async {
                  await openAppSettings();
                });

                Get.back();
              },
            ),
            const Divider(
              height: 0.5,
            ),
            ListTile(
              leading: Icon(Icons.photo_camera),
              title: Text('Camera'),
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
                      browseImage(ImageSource.camera, isVideo);
                    }
                  });
                } else if (cameraPermissionStatus.isRestricted) {
                  await openAppSettings();
                } else if (cameraPermissionStatus.isGranted) {
                  browseImage(ImageSource.camera, isVideo)
                      .catchError((e) async {
                    await openAppSettings();
                  });
                  ;
                }

                Get.back();
              },
            ),
          ],
        ),
        barrierColor: Colors.black.withOpacity(0.3),
      );
    }
  }
}
