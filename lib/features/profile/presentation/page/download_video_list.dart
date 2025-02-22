import 'dart:io';
import 'package:k_drama/export.dart';

import 'package:video_thumbnail/video_thumbnail.dart';

class DownloadShortsScreen extends StatefulWidget {
  const DownloadShortsScreen({Key? key}) : super(key: key);

  @override
  DownloadShortsScreenState createState() => DownloadShortsScreenState();
}

class DownloadShortsScreenState extends State<DownloadShortsScreen> {
  late Future<List<File>> videoListFuture;
  late List<Uint8List?> thumbnails = [];
  BannerAd? _bannerAd;

  @override
  void initState() {
    if (Singleton.instance.showAdd) {
      _loadBannerAdd();
    }
    super.initState();
    videoListFuture = getVideoList();
    thumbnails = [];
    _loadThumbnails(); // Load thumbnails only once
  }

  @override
  void dispose() {
    // Dispose of the banner ad when it's no longer needed.
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(AppStrings.downloadReels),
      body: FutureBuilder<List<File>>(
        future: videoListFuture,
        builder: (BuildContext context, AsyncSnapshot<List<File>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: AppColors.primaryLight,
            ));
          } else if (snapshot.hasError) {
            return Center(
                child: customText(
                    text: "Error loading videos",
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.w600,
                    fontSize: 15));
          } else {
            List<File> videos = snapshot.data!;
            return videos.isEmpty
                ? Center(
                    child: customText(
                        text: AppStrings.noDownloadVideoFound,
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                  )
                : MasonryGridView.builder(
                    shrinkWrap: true,
                    cacheExtent: double.infinity,
                    gridDelegate:
                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: videos.length,
                    itemBuilder: (BuildContext context, int itemIndex) {
                      return _buildReelWidget(videos[itemIndex], itemIndex);
                    },
                  );
          }
        },
      ),
      bottomSheet: _bannerAd != null
          ? SizedBox(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            )
          : null,
    );
  }

  void _loadThumbnails() async {
    List<Uint8List?> updatedThumbnails = [];

    for (var video in await videoListFuture) {
      try {
        final thumbnail = await VideoThumbnail.thumbnailData(
          video: video.path,
          imageFormat: ImageFormat.JPEG,
          maxHeight: 360,
          quality: 25,
        );
        updatedThumbnails.add(thumbnail);
      } catch (e) {
        logV("Error generating thumbnail for ${video.path}: $e");
        updatedThumbnails.add(null);
      }
    }

    setState(() {
      thumbnails = updatedThumbnails;
    });
  }

  Widget _buildReelWidget(File file, int itemIndex) {
    logV("itemIndex===>$thumbnails");
    Uint8List? thumbnail;
    if (thumbnails.isNotEmpty) {
      thumbnail = thumbnails[itemIndex];
    }

    return InkWell(
      onTap: () {
        NavigatorService.push(
            context,
            VideoPlayerFromGallery(
              videoPath: file.path,
            ));
      },
      child: Container(
        width: width / 2,
        margin: getMargin(all: 5),
        height: getVerticalSize(250),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.appIconColor.withOpacity(.7),
              AppColors.primaryLight.withOpacity(.5),
              AppColors.appIconColor.withOpacity(.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          // color: AppColors.appIconColor.withOpacity(.7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: thumbnail != null
              ? Image.memory(
                  thumbnail,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                )
              : LinearProgressIndicator(
                  color: Colors.grey.shade700,
                  backgroundColor: Colors.grey.shade800),
        ),
      ),
    );
  }

  Future<List<File>> getVideoList() async {
    List<File> videoList = [];

    // Get the app's documents directory

    // Specify the path to the directory where videos are stored
    String videoDirectoryPath =
        "/data/user/0/com.wallpaperbts.btskdramashorts/app_flutter/";

    // Create the directory if it doesn't exist
    Directory videoDirectory = Directory(videoDirectoryPath);
    if (!(await videoDirectory.exists())) {
      await videoDirectory.create(recursive: true);
    }

    // List all files in the directory
    List<FileSystemEntity> files = await videoDirectory.list().toList();

    // Filter only video files (you may need to adjust the file extensions)
    videoList = files
        .where((file) => file is File && file.path.endsWith('.mp4'))
        .map((file) => File(file.path))
        .toList();

    return videoList;
  }

  _loadBannerAdd() {
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          logV('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }
}
