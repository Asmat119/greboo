import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ScrollableVideoPlayer extends StatefulWidget {
  final String videoUrl;

  ScrollableVideoPlayer({required this.videoUrl});

  @override
  _ScrollableVideoPlayerState createState() => _ScrollableVideoPlayerState();
}

class _ScrollableVideoPlayerState extends State<ScrollableVideoPlayer> {
  late VideoPlayerController _controller;
  late ScrollController _scrollController;
  late GlobalKey _videoKey;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _scrollController = ScrollController();
    _videoKey = GlobalKey();
    _controller.addListener(_updateVideoPosition);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _updateVideoPosition() {
    final position = _controller.value.position;
    final screenWidth = MediaQuery.of(context).size.width;
    RenderBox? renderBox = _videoKey.currentContext!.findRenderObject() as RenderBox;
    final videoTop = renderBox.localToGlobal(Offset.zero).dy;
    final videoBottom = videoTop + _videoKey.currentContext!.size!.height;

    if (position.inMilliseconds > 0 && _visible && (videoTop < 0 || videoBottom > screenWidth)) {
      _controller.pause();
      setState(() => _visible = false);
    } else if (position.inMilliseconds == 0 && !_visible && videoTop > 0 && videoBottom < screenWidth) {
      _controller.play();
      setState(() => _visible = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        controller: _scrollController,
        itemCount: 30,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.width * 9 / 16,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: VideoPlayer(_controller),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Visibility(
                    visible: !_visible,
                    child: IconButton(
                      icon: Icon(Icons.play_circle_fill),
                      color: Colors.white,
                      iconSize: 50,
                      onPressed: () {
                        _controller.play();
                        setState(() => _visible = true);
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
