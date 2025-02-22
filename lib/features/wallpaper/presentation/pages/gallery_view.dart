import 'dart:io';
import '../../../../export.dart';
import 'package:http/http.dart' as http;

GlobalKey<SpeedDialFabWidgetState> _speedDialKey =
    GlobalKey<SpeedDialFabWidgetState>();

class GalleryViewBuilder extends StatefulWidget {
  final List<WallpaperData>? wallpapers;
  final List<String>? fWallpapersList;
  final bool isFavorite;
  final int initialIndex;
  final BuildContext context2;

  const GalleryViewBuilder(
      {super.key,
      this.wallpapers,
      this.isFavorite = false,
      this.fWallpapersList,
      required this.initialIndex,
      required this.context2});

  @override
  State<GalleryViewBuilder> createState() => _GalleryViewBuilderState();
}

class _GalleryViewBuilderState extends State<GalleryViewBuilder> {
  late int index; // Declare index as late
  InterstitialAd? _interstitialAd;
  int _tap = 0;

  @override
  void initState() {
    if (Singleton.instance.showAdd) {
      _loadInterstitialAd();
    }
    super.initState();
    index = widget.initialIndex;
  }

  @override
  void dispose() {
    // TODO: Dispose an InterstitialAd object
    _interstitialAd?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PageController pageController =
        PageController(initialPage: widget.initialIndex);
    return Scaffold(
      appBar: _appBarBuilder(index),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: AppColors.white,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: List.generate(
                    6,
                    (index) => index % 2 == 0
                        ? AppColors.primaryLight.withOpacity(.5)
                        : AppColors.purple.withOpacity(.5)),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: PageView.builder(
              onPageChanged: (int page) {
                logV("page===>$page");
                _showInterstitialAd(() {});
                index = page;
                _speedDialKey.currentState?.forceCollapseSecondaryFab();
                setState(() {});
              },
              controller: pageController,
              itemCount: widget.isFavorite
                  ? widget.fWallpapersList!.length
                  : widget.wallpapers!.length,
              itemBuilder: (context, index) {
                logV("page builder====>$index");
                return CustomImageView(
                  // margin: getMargin(right: 10, left: 10),
                  url: widget.isFavorite
                      ? widget.fWallpapersList![index]
                      : widget.wallpapers![index].image,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton:
          _floatingActionBar(pageController: pageController, context: context),
    );
  }

  PreferredSizeWidget _appBarBuilder(int index) {

    return CustomAppBar(
      AppStrings.wallpaperTitle,
      fontSize: 15,
      actions: [
        GestureDetector(
          onTap: () async {
            await HapticFeedback.vibrate();
            if (context.mounted) {
              if (widget.isFavorite) {
                if (index >= widget.fWallpapersList!.length) {
                  index = widget.fWallpapersList!.length - 1;
                }
                DatabaseHelper.removeWallpaper(widget.fWallpapersList![index]);
                if (Singleton.instance.wallpaperListRt != null) {
                  for (WallpaperListRt data
                  in Singleton.instance.wallpaperListRt!) {
                    for (Wallpapers data2 in data.images) {
                      for (WallpaperData data3 in data2.wallpapers.values) {
                        data3.isFavorite = false;
                      }
                    }
                  }
                }
                widget.fWallpapersList?.removeAt(index);
                if (widget.fWallpapersList!.isEmpty) {
                  NavigatorService.goBack();
                }
                widget.context2
                    .read<FavoriteWallpaperCubit>()
                    .removeFromFavorite(widget.fWallpapersList ?? []);
                setState(() {});
              } else {
                setState(() {
                  widget.wallpapers![index].isFavorite =
                      !widget.wallpapers![index].isFavorite;
                });
                widget.context2
                    .read<WallpaperBloc>()
                    .add(WallpaperSuccessEvent());
                if (widget.wallpapers![index].isFavorite) {
                  DatabaseHelper.insertWallpaper(
                      widget.wallpapers![index].image);
                } else {
                  DatabaseHelper.removeWallpaper(
                      widget.wallpapers![index].image);
                }
              }
            }
          },
          child: Icon(
            widget.isFavorite || widget.wallpapers![index].isFavorite
                ? Icons.favorite
                : Icons.favorite_border,
            color: AppColors.primaryLight,
          ),
        ),
        getSizeBox(width: 20),
      ],
    );
  }

  Widget _floatingActionBar(
      {required PageController pageController, required BuildContext context}) {
    return SpeedDialFabWidget(
      key: _speedDialKey,
      primaryIconCollapse: Icons.close,
      primaryIconExpand: Icons.more_vert,
      secondaryElevation: 0,
      primaryElevation: 0,
      secondaryIconsList: const [
        Icons.download,
        Icons.wallpaper,
        Icons.share,
      ],
      secondaryIconsOnPress: [
        () async => {
              await downloadImage(widget.isFavorite
                  ? widget.fWallpapersList![index]
                  : widget.wallpapers![pageController.page?.round() ?? 0].image)
            },
        () => {
              _wallPaperDialog(
                  imageUrl: widget.isFavorite
                      ? widget.fWallpapersList![index]
                      : widget
                          .wallpapers![pageController.page?.round() ?? 0].image,
                  context: widget.context2)
            },
        () async => {
              await shareWallpaper(
                  widget.isFavorite
                      ? widget.fWallpapersList![index]
                      : widget
                          .wallpapers![pageController.page?.round() ?? 0].image,
                  context)
            },
      ],
      secondaryBackgroundColor: AppColors.primaryLight,
      secondaryForegroundColor: AppColors.white,
      primaryBackgroundColor: AppColors.primaryDark,
      primaryForegroundColor: AppColors.primaryLight,
    );
  }

  _wallPaperDialog({
    required String imageUrl,
    required BuildContext context,
  }) {
    return customDialog(
        context: context,
        child: Container(
          margin: getMargin(right: 15, left: 15, top: 10, bottom: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    customText(
                        text: AppStrings.preview, color: AppColors.red, fontSize: 20),
                    const Spacer(),
                    GestureDetector(
                      child: Icon(Icons.highlight_remove,
                          size: getSize(20), color: AppColors.red),
                      onTap: () {
                        NavigatorService.goBack();
                      },
                    ),
                  ],
                ),
                getSizeBox(height: 10),
                customText(
                    text: AppStrings.setWallpaperConfirmation,
                    color: AppColors.black,
                    fontSize: 15),
                getSizeBox(height: 20),
                Row(
                  children: [
                    _customButton(
                        customColor: true,
                        onTap: () {
                          NavigatorService.goBack();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ImageView(imgPath: imageUrl),
                            ),
                          );
                        },
                        title:  AppStrings.preview),
                    getSizeBox(width: 10),
                    _customButton(
                      onTap: () async {
                        await setWallpaper(imageUrl);
                      },
                      title: AppStrings.setWallpaper,
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  ///customSubmit button
  Widget _customButton(
      {required GestureTapCallback onTap,
      required String title,
      bool? customColor}) {
    return Expanded(
      child: InkWell(
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  if (customColor ?? false) AppColors.purple,
                  AppColors.pink,
                  if (!(customColor ?? false)) AppColors.purple,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(getSize(16)),
            ),
            padding: getPadding(all: 10),
            child: customText(
              color: AppColors.white,
              fontSize: 15,
              text: title,
            ),
          )),
    );
  }

  ///share video
  bool _isDownloading = false;

  Future<void> shareWallpaper(String url, BuildContext context) async {
    _isDownloading = true;
    _tap = -1;
    _showInterstitialAd(() async {
      showLoading(context);
      logV("url====>$url");
      final DefaultCacheManager cacheManager = DefaultCacheManager();
      final FileInfo? fileInfo = await cacheManager.getFileFromCache(url);

      try {
        if (fileInfo == null) {
          // Video is not in the cache, download and store it
          await cacheManager.downloadFile(url);
        }

        final cachedVideoPath = fileInfo?.file.path;
        logV("cachedVideoPath===>$cachedVideoPath");

        if (cachedVideoPath != null && File(cachedVideoPath).existsSync()) {
          // Video is now in the cache, share it
          await Share.shareXFiles([XFile(cachedVideoPath)],
              text: AppStrings.shareDes,
              subject: 'Hey, Check out this awesome wallpaper!');
        } else {
          // Handle the case where the video couldn't be downloaded or fileInfo is null
          showToast("Please try again.");
          logV('Error downloading the video or fileInfo is null.');
        }
      } finally {
        _isDownloading = false;
        if (context.mounted) {
          Navigator.pop(context);
        }
      }
    });
  }

  void showLoading(BuildContext context) {
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

  ///download image
  Future<void> downloadImage(String imageUrl) async {
    _isDownloading = true;
    _tap = -1;
    _showInterstitialAd(() async {
      try {
        showLoading(context);
        showToast("Downloading....");
        http.Response response = await http.get(Uri.parse(imageUrl));
        final Uint8List bytes = response.bodyBytes;

        // Get the application documents directory
        Directory appDocumentsDirectory =
            await getApplicationDocumentsDirectory();
        String appDocumentsPath = appDocumentsDirectory.path;

        // Save the image to the documents directory
        File file = File('$appDocumentsPath/image.jpg');
        logV("file path====>${file.path}");
        await file.writeAsBytes(bytes);
        await ImageGallerySaver.saveFile(file.path);
        showToast("Wallpaper Download successfully....");
      } finally {
        _isDownloading = false;
        if (context.mounted) {
          Navigator.pop(context);
        }
        showToast("Download failed..");
      }
      // } catch (e) {
      //   logV("error while downloading image===>$e");
      //   showToast("Download failed..");
      // }
    });
  }

  ///set home wallpaper
  Future<void> setWallpaper(String imageUrl) async {
    _tap = -1;

    _showInterstitialAd(
      () async {
        try {
          showToast("Setting wallpaper...");
          NavigatorService.goBack();

          // Get the wallpaper file path
          int location = WallpaperManager.HOME_SCREEN;
          var file = await DefaultCacheManager().getSingleFile(imageUrl);

          // Set wallpaper from file or network (you can use either)
          await WallpaperManager.setWallpaperFromFile(file.path, location);
          // or

          // await FlutterWallpaperManager.setWallpaperFromUrl(imageUrl, WallpaperManagerPlatform.HOME_SCREEN);

          showToast("Wallpaper set successfully!");
        } catch (e) {
          showToast("Failed to set wallpaper");
        }
      },
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

  void _showInterstitialAd(void Function() onTap) {
    _tap += 1;
    if (_tap == 5) {
      _tap = 0;
    }
    if (_tap == 0) {
      if (_interstitialAd == null) {
        // NavigatorService.push(context, routeChild);
        onTap();
        return;
      }

      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {},
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _loadInterstitialAd();
          onTap();
          // NavigatorService.push(context, routeChild);
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          onTap();
          // NavigatorService.push(context, routeChild);
        },
      );

      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      onTap();
      // NavigatorService.push(context, routeChild);
    }
  }
}
