import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingOverlay {
  void hide() {
    Get.back();
  }

  void show() {
    Get.dialog(
      FullScreenLoader(),
      barrierDismissible: false,
    );
    // showDialog(
    //   context: _context,
    //   barrierDismissible: false,
    //   builder: (BuildContext context) => FullScreenLoader(),
    // );
  }

  Future<T> during<T>(Future<T> future) {
    show();
    return future.whenComplete(() => hide());
  }

  LoadingOverlay._create();

  factory LoadingOverlay.of() {
    return LoadingOverlay._create();
  }
}

class FullScreenLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: AppLoader(),
      ),
    );
  }
}

class AppLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: getLoader(),
            ),
          ],
        ),
      ),
    );
  }

  getLoader() {
    if (Platform.isIOS) {
      return CupertinoActivityIndicator();
    } else {
      return CircularProgressIndicator(
        strokeWidth: 2,
      );
    }
  }
}
