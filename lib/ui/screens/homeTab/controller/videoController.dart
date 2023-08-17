import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoScreenController extends GetxController {
  Duration _currentDuration = Duration();

  Duration get currentDuration => _currentDuration;

  set currentDuration(Duration value) {
    _currentDuration = value;
    update(["seekUpdate"]);
  }

  Duration startTime = Duration();
  Duration endTime = Duration();
  String videoPath = "";
  bool _overlayShow = false;

  bool get overlayShow => _overlayShow;

  set overlayShow(bool value) {
    _overlayShow = value;
    update(["overlayUpdate", "init"]);
  }

  late VideoPlayerController controller;
  @override
  void onInit() {
    super.onInit();
  }

  seekUpdate() {
    currentDuration = controller.value.position;
  }
}
