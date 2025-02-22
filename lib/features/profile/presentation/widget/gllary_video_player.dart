import 'dart:io';
import '../../../../export.dart';

class VideoPlayerFromGallery extends StatefulWidget {
  final String videoPath;

  const VideoPlayerFromGallery({super.key, required this.videoPath});

  @override
  VideoPlayerFromGalleryState createState() => VideoPlayerFromGalleryState();
}

class VideoPlayerFromGalleryState extends State<VideoPlayerFromGallery> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath));
    _initializeVideoPlayerFuture = _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      await _controller.initialize();
      _controller.setLooping(true); // Set to true if you want to loop the video
      _controller.play();
    } catch (e) {
      logV("Error initializing video player: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryDark,
        title: customText(
          text: AppStrings.shorts,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryLight,
        ),
      ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GestureDetector(
              onLongPress: () {
                _controller.pause();
              },
              onLongPressEnd: (l) {
                _controller.play();
              },
              onTap: () {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
              },
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(
                    _controller,
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
                child: customText(
                    text: "Error loading video: ${snapshot.error}",
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.w700));
          } else {
            return Center(
                child: CircularProgressIndicator(
              color: AppColors.primaryLight,
            ));
          }
        },
      ),
    );
  }
}
