import 'package:get/get.dart';

class ImageController extends GetxController {
  String _imagePath = "";

  String get imagePath => _imagePath;

  set imagePath(String value) {
    _imagePath = value;
    update();
  }
}
