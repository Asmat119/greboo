import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:grebooo/core/utils/config.dart';
import 'package:grebooo/ui/screens/homeTab/controller/videoController.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  final String path;

  const VideoScreen({Key? key, required this.path}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final VideoScreenController videoScreenController =
      Get.put(VideoScreenController());

  @override
  void initState() {
    videoScreenController.controller =
        VideoPlayerController.network(widget.path)
          ..initialize().then((_) {
            videoScreenController.endTime =
                videoScreenController.controller.value.duration;
            videoScreenController.controller.setLooping(true);
            videoScreenController.controller.play();
            videoScreenController.controller.addListener(() {
              videoScreenController.seekUpdate();
            });
            setState(() {});
          });
    super.initState();
  }

  @override
  void dispose() {
    videoScreenController.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        body: Stack(
          children: [
            GetBuilder(
              id: "init",
              builder: (VideoScreenController videoScreenController) =>
                  videoScreenController.controller.value.isInitialized
                      ? Align(
                          alignment: Alignment.center,
                          child: AspectRatio(
                            aspectRatio: videoScreenController
                                .controller.value.aspectRatio,
                            child: Stack(
                              fit: StackFit.expand,
                              alignment: Alignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    videoScreenController.overlayShow = true;
                                    videoScreenController.controller.pause();
                                  },
                                  child: VideoPlayer(
                                      videoScreenController.controller),
                                ),
                                videoScreenController.overlayShow
                                    ? GetBuilder(
                                        id: "overlayUpdate",
                                        builder: (VideoScreenController
                                                controller) =>
                                            Container(
                                          color: Colors.black12,
                                          child: Center(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.black26,
                                                  shape: BoxShape.circle),
                                              child: IconButton(
                                                onPressed: () {
                                                  controller.controller.play();
                                                  controller.overlayShow =
                                                      false;
                                                },
                                                icon: controller.controller
                                                        .value.isPlaying
                                                    ? Icon(
                                                        Icons.pause,
                                                        color: Colors.white,
                                                        size:
                                                            getProportionateScreenWidth(
                                                                25),
                                                      )
                                                    : Icon(
                                                        Icons.play_arrow,
                                                        color: Colors.white,
                                                        size:
                                                            getProportionateScreenWidth(
                                                                25),
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox()
                              ],
                            ),
                          ),
                        )
                      : GetPlatform.isAndroid
                          ? Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Center(child: CupertinoActivityIndicator()),
            ),
            GetBuilder(
              id: "init",
              builder: (VideoScreenController controller) => Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _buildProgressBar(),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildProgressBar() {
    return GetBuilder(
      id: "seekUpdate",
      builder: (VideoScreenController controller) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ProgressBar(
            progress: controller.currentDuration,
            total: controller.endTime,
            timeLabelPadding: 7,
            timeLabelTextStyle:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            progressBarColor: Colors.red,
            baseBarColor: Colors.white.withOpacity(0.24),
            bufferedBarColor: Colors.white.withOpacity(0.24),
            thumbColor: Colors.white,
            barHeight: 5.0,
            thumbRadius: 5.0,
            onSeek: (duration) {
              controller.controller.seekTo(duration);
            },
          ),
          SafeArea(
              top: false,
              child: SizedBox(
                height: 10,
              )),
        ],
      ),
    );
  }
}
