import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../../export.dart';
import '../widget/like_widget.dart';

class ShortsScreen extends StatefulWidget {
  final bool fromShortPage;
  final BuildContext context2;
  final List<ShortModel> shortList;

  const ShortsScreen(
      {super.key,
      required this.fromShortPage,
      required this.context2,
      required this.shortList});

  static Widget builder(BuildContext context, int index,
      List<ShortModel> shortList, bool fromShortPage) {
    return ChangeNotifierProvider(
      create: (_) => PreloadProvider(shortList)..initialize(index),
      child: ShortsScreen(
        fromShortPage: fromShortPage,
        context2: context,
        shortList: shortList,
      ),
    );
  }

  @override
  State<ShortsScreen> createState() => _ShortsScreenState();
}

class _ShortsScreenState extends State<ShortsScreen> {
  InterstitialAd? _interstitialAd;
  int _tap = 0;
  @override
  void initState() {
    if (Singleton.instance.showAdd) {
      _loadInterstitialAd();
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: Dispose an InterstitialAd object
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Consumer<PreloadProvider>(
        builder: (context, provider, _) {
          return PageView.builder(
            itemCount: provider.shortList.length,
            scrollDirection: Axis.vertical,
            controller: provider.pageController,
            onPageChanged: (index) {
              logV("onPageChanged====>$index");
              _showInterstitialAd(() {
                provider.controllers[index]?.play();
              }, provider.controllers[index]);
              provider.onVideoIndexChanged(index);
            },
            itemBuilder: (context, index) {
              final VideoPlayerController? controller =
                  provider.controllers[index];

              controller?.addListener(() {
                if (!controller.value.isPlaying &&
                    controller.value.isInitialized &&
                    (controller.value.duration == controller.value.position)) {
                  if (index != provider.shortList.length - 1) {
                    provider.nextVideo(index + 1);
                    provider.pageController.animateToPage(
                      index + 1,
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.easeInOut,
                    );
                  }
                }
              });

              ShortModel data = provider.shortList[provider.focusedIndex];

              return provider.focusedIndex == index
                  ? controller != null
                      ? GestureDetector(
                          onLongPress: () {
                            controller.pause();
                          },
                          onLongPressEnd: (l) {
                            controller.play();
                          },
                          onDoubleTap: () {
                            if (!data.isLiked) {
                              data.totalLike += 1;
                            }
                            data.isLiked = true;
                            if (widget.fromShortPage) {
                              DatabaseHelper.insertFavoriteShort(data);
                              DatabaseHelper.updateShortIsLiked(
                                  data.videoUrl, data.isLiked);
                            }
                            showDialog(
                              context: context,
                              barrierColor: Colors.transparent,
                              barrierDismissible: false,
                              // Dialog cannot be dismissed by tapping outside
                              builder: (BuildContext context) {
                                return const LikeWidget();
                              },
                            );
                            provider.setFocusedIndex(provider.focusedIndex);
                          },
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(
                                color: AppColors.transparent,
                                width: double.infinity,
                                height: double.infinity,
                                child: Center(
                                  child: AspectRatio(
                                    aspectRatio: controller.value.aspectRatio,
                                    // aspectRatio: 9 / 16,
                                    child: SizedBox(
                                      width: controller.value.size.width,
                                      height: controller.value.size.height,
                                      child: VideoPlayer(
                                        controller,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: getPadding(left: 8, right: 8, top: 8),
                                child: Column(
                                  children: [
                                    const Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                      width:
                                                          getVerticalSize(30),
                                                      height:
                                                          getVerticalSize(30),
                                                      child: Lottie.asset(
                                                          'assets/lottie/wave.json')),
                                                  SizedBox(
                                                      width: getHorizontalSize(
                                                          10)),
                                                  Expanded(
                                                    child: Text(
                                                      data.videoName,
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: poppinsTextStyle
                                                          .copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: getSize(14),
                                                        color: AppColors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                data.isLiked = !data.isLiked;
                                                if (data.isLiked) {
                                                  data.totalLike += 1;
                                                  DatabaseHelper
                                                      .insertFavoriteShort(
                                                          data);
                                                  showDialog(
                                                    context: context,
                                                    barrierColor:
                                                        Colors.transparent,
                                                    barrierDismissible: false,
                                                    builder:
                                                        (BuildContext context) {
                                                      return const LikeWidget();
                                                    },
                                                  );
                                                } else {
                                                  data.totalLike -= 1;
                                                  DatabaseHelper
                                                      .removeFavoriteShort(
                                                          data.id);
                                                  if (!widget.fromShortPage) {
                                                    widget.context2
                                                        .read<
                                                            FavoriteShortsCubit>()
                                                        .removeFromFavorite(
                                                            data.id);
                                                    NavigatorService.goBack();
                                                  }
                                                }
                                                DatabaseHelper
                                                    .updateShortIsLiked(
                                                        data.videoUrl,
                                                        data.isLiked);
                                                provider.setFocusedIndex(
                                                    provider.focusedIndex);
                                              },
                                              child: Icon(
                                                  data.isLiked
                                                      ? Icons.favorite
                                                      : Icons.favorite_outline,
                                                  color: data.isLiked
                                                      ? Colors.red
                                                      : Colors.white,
                                                  size: getSize(30)),
                                            ),
                                            Text(
                                              '${data.totalLike}',
                                              textAlign: TextAlign.start,
                                              style: poppinsTextStyle.copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: getSize(12),
                                                color: AppColors.white,
                                              ),
                                            ),
                                            getSizeBox(height: 20),
                                            GestureDetector(
                                              onTap: () async {
                                                _isDownloading = true;
                                                _tap = -1;
                                                if (Singleton
                                                    .instance.showAdd) {
                                                  _showInterstitialAd(() async {
                                                    await downloadVideo(
                                                        data.videoUrl,
                                                        context,
                                                        controller);
                                                  }, controller);
                                                } else {
                                                  await downloadVideo(
                                                      data.videoUrl,
                                                      context,
                                                      controller);
                                                }
                                              },
                                              child: Icon(Icons.download,
                                                  color: Colors.white,
                                                  size: getSize(30)),
                                            ),
                                            // Text("${temList[index]}",
                                            //   textAlign: TextAlign.start,
                                            //   style: poppinsTextStyle.copyWith(
                                            //     fontWeight: FontWeight.w500,
                                            //     fontSize: getSize(12),
                                            //     color: AppColors.white,
                                            //   ),
                                            // ),
                                            const SizedBox(height: 20),
                                            GestureDetector(
                                              onTap: () async {
                                                _isDownloading = true;
                                                _tap = -1;
                                                if (Singleton
                                                    .instance.showAdd) {
                                                  _showInterstitialAd(() async {
                                                    await shareVideo(
                                                        data.videoUrl,
                                                        context, controller);
                                                  }, controller);
                                                }else {
                                                  await shareVideo(
                                                      data.videoUrl,
                                                      context, controller);
                                                }
                                              },
                                              child: Icon(Icons.share,
                                                  color: Colors.white,
                                                  size: getSize(30)),
                                            ),
                                            getSizeBox(height: 80),
                                          ],
                                        ),
                                        getSizeBox(width: 5),
                                      ],
                                    ),
                                    SizedBox(
                                      height: getSize(10),
                                    ),
                                    _getLoading(
                                        !controller.value.isInitialized ||
                                            controller.value.isBuffering, () {
                                      provider.nextVideo(0);
                                    })
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: Lottie.asset("assets/lottie/loading.json",
                              height: getVerticalSize(180),
                              width: getHorizontalSize(200)))
                  : const SizedBox();
            },
          );
        },
      ),
    );
  }

  ///share video
  bool _isDownloading = false;

  Future<void> shareVideo(String videoUrl, BuildContext context,
      final VideoPlayerController? controller) async {


    showLoading(context, controller);
    controller?.pause();
    logV("url====>$videoUrl");
    final DefaultCacheManager cacheManager = DefaultCacheManager();
    final FileInfo? fileInfo = await cacheManager.getFileFromCache(videoUrl);

    try {
      if (fileInfo == null) {
        // Video is not in the cache, download and store it
        await cacheManager.downloadFile(videoUrl);
      }

      final cachedVideoPath = fileInfo?.file.path;
      logV("cachedVideoPath===>$cachedVideoPath");

      if (cachedVideoPath != null && File(cachedVideoPath).existsSync()) {
        // Video is now in the cache, share it
        await Share.shareXFiles([XFile(cachedVideoPath)],
            text:
            AppStrings.shareDes,
            subject: 'Hey, Check out this awesome short!');
      } else {
        // Handle the case where the video couldn't be downloaded or fileInfo is null
        showToast("Please try again.");
        logV('Error downloading the video or fileInfo is null.');
      }
    } finally {
      // Ensure that _isDownloading is set to false, even if an error occurred
      _isDownloading = false;
      if (context.mounted) {
        Navigator.pop(context);
      }
      controller?.play();
    }
  }

  void showLoading(
      BuildContext context, final VideoPlayerController? controller) {
    controller?.pause();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: !_isDownloading,
          child: Container(
            color: AppColors.transparent,
            padding: getPadding(all: 10),
            child: Center(
                child:
                    CircularProgressIndicator(color: AppColors.primaryLight)),
          ),
        );
      },
    );
  }

  ///download video
  Future<void> downloadVideo(String videoUrl, BuildContext context,
      final VideoPlayerController? controller) async {
    showLoading(context, controller);
    showToast("Downloading....");
    try {
      http.Response response = await http.get(Uri.parse(videoUrl));
      final Uint8List bytes = response.bodyBytes;

      // Get the application documents directory
      Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      String appDocumentsPath = appDocumentsDirectory.path;

      // Save the image to the documents directory
      File file = File('$appDocumentsPath/video.mp4');
      logV("file path====>${file.path}");
      await file.writeAsBytes(bytes);
      await ImageGallerySaver.saveFile(file.path);
      showToast("Video Download successfully....");
    } catch (e) {
      logV("error while downloading image===>$e");
      showToast("Download failed..");
    } finally {
      // Ensure that _isDownloading is set to false, even if an error occurred
      _isDownloading = false;
      if (context.mounted) {
        Navigator.pop(context);
      }
      controller?.play();
    }
  }

  _getLoading(bool isLoading, VoidCallback callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
      // Add Your Code here.
    });

    return Visibility(
      visible: isLoading,
      child: Padding(
        padding: getPadding(top: 5),
        child: LinearProgressIndicator(
          color: AppColors.primaryLight,
        ),
      ),
    );
  }

  Future<void> _loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (err) {
          _interstitialAd = null;
          logV('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  void _showInterstitialAd(
      void Function() onTap, final VideoPlayerController? controller) {
    _tap += 1;
    if (_tap == 5) {
      _tap = 0;
    }
    if (_tap == 0) {
      if (_interstitialAd == null) {
        onTap();
        controller?.play();
        return;
      }

      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {
          controller?.pause();
        },
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();

          _loadInterstitialAd();
          onTap();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          onTap();
        },
      );

      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      onTap();
      controller?.play();
    }
  }
}
