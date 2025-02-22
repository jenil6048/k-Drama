import 'package:k_drama/features/home/presentation/pages/youtube_palyer_screen.dart';

import '../../../../core/widgets/expandable_text.dart';
import '../../../../export.dart';

class DetailScreen extends StatefulWidget {
  final SingleMovieModel movie;
  final bool fromWatchList;
  final BuildContext context2;

  const DetailScreen(
      {super.key,
      required this.movie,
      required this.fromWatchList,
      required this.context2});

  static Widget builder(BuildContext context, SingleMovieModel movie,
      {bool fromWatchList = false}) {
    return DetailScreen(
      movie: movie,
      fromWatchList: fromWatchList,
      context2: context,
    );
  }

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    if(Singleton.instance.showAdd) {
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

  void _showInterstitialAd(void Function() onTap) {
    if (_interstitialAd == null) {
      onTap();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {},
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _imageBuilder(),
                _genreBuilder(),
                Padding(
                  padding: getPadding(left: 10, right: 10, top: 20, bottom: 20),
                  child: myButton(
                    onTap: () async {
                      _showInterstitialAd(
                            () async {
                          NavigatorService.push(context, YoutubeAppDemo( url:widget.movie.trailerUrl, title:widget.movie.movieName,));
                        },
                      );
                    },
                    title: "Watch",
                    icon: Icons.play_circle_outline,
                  ),
                ),
                // _rowBuilder(),
                _infoBuilder(),
              ],
            ),
          ),
          Positioned(
            top: getVerticalSize(45),
            left: 0,
            right: 0,
            child: Padding(
              padding: getPadding(right: 16.0, left: 16),
              // Adjust horizontal spacing
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buttonBuilder(Icons.arrow_back_rounded, () {
                    NavigatorService.goBack();
                  }),
                  const Spacer(),
                  StatefulBuilder(builder: (context, setState) {
                    return _buttonBuilder(
                        widget.movie.inWatchList || widget.fromWatchList
                            ? Icons.playlist_add_check
                            : Icons.playlist_add, () async {
                      if (widget.fromWatchList) {
                        widget.context2
                            .read<WatchListCubit>()
                            .removeFromWatchList(widget.movie);
                        NavigatorService.goBack();
                      } else {
                        widget.movie.inWatchList = !widget.movie.inWatchList;
                        if (widget.movie.inWatchList) {
                          showToast("Successfully added to watchlist");
                          DatabaseHelper.insertSingleMovie(widget.movie);
                        } else {
                          showToast("Successfully removed from watchlist");
                          DatabaseHelper.removeMovieByName(
                              widget.movie.movieName);
                        }
                        await HapticFeedback.vibrate();
                        setState(() {});
                      }
                    });
                  }),
                  getSizeBox(width: 10),
                  _buttonBuilder(Icons.share_outlined, () async {
                    await Share.share(
                        "${widget.movie.trailerUrl} \nHey,\nCheck out this awesome ${widget.movie.type.toLowerCase()}!",
                        subject:
                            "Hey,\nCheck out this awesome ${widget.movie.type.toLowerCase()}!");
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowBuilder() {
    return Padding(
      padding: getPadding(left: 10, right: 10, top: 20, bottom: 20),
      child:Singleton.instance.inReview?myButton(
        onTap: () async {
          _showInterstitialAd(
                () async {
                  NavigatorService.push(context, YoutubeAppDemo( url:widget.movie.trailerUrl, title:widget.movie.movieName,));
            },
          );
        },
        title: "Watch",
        icon: Icons.play_circle_outline,
      ): Column(
        children: [
          myButton(
            onTap: () async {
              _showInterstitialAd(
                () async {
                  if (Singleton.instance.inReview) {
                    NavigatorService.push(context, YoutubeAppDemo( url:widget.movie.trailerUrl, title:widget.movie.movieName,));
                  } else {
                    if (widget.movie.trailerUrl.isNotEmpty) {
                      await launchUrl(Uri.parse(widget.movie.trailerUrl));
                    } else {
                      await launchUrl(Uri.parse(
                          "https://www.youtube.com/results?search_query=${widget.movie.movieName}_trailer"));
                    }
                  }
                },
              );
            },
            title: "Trailer",
            icon: Icons.play_circle_outline,
          ),
          getSizeBox(height: 20),
          Row(
            children: [
              Expanded(
                  child: myButton(
                onTap: () async {
                  _showInterstitialAd(() async {
                    if (Singleton.instance.inReview) {
                      NavigatorService.push(context, YoutubeAppDemo( url:widget.movie.trailerUrl, title:widget.movie.movieName,));
                    } else {
                      if (widget.movie.steamUrl.isNotEmpty) {
                        await launchUrl(Uri.parse(widget.movie.steamUrl));
                      } else {
                        await launchUrl(Uri.parse(
                            "https://www.youtube.com/results?search_query=${widget.movie.movieName}"));
                      }
                    }
                  });
                },
                title: "Watch online",
                icon: Icons.play_circle_outline,
              )),
              getSizeBox(
                width: 15,
              ),
              Expanded(
                  child: myButton(
                onTap: () async {
                  _showInterstitialAd(() async {
                    if (Singleton.instance.inReview) {
                      NavigatorService.push(context, YoutubeAppDemo( url:widget.movie.trailerUrl, title:widget.movie.movieName,));
                    } else {
                      if (widget.movie.downloadUrl.isNotEmpty) {
                        await launchUrl(Uri.parse(widget.movie.downloadUrl));
                      } else {
                        await launchUrl(Uri.parse(
                            "https://www.youtube.com/results?search_query=${widget.movie.movieName}"));
                      }
                    }
                  });
                },
                title: "Download",
                icon: Icons.download_outlined,
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _genreBuilder() {
    return widget.movie.genres.isNotEmpty
        ? Column(
            children: [
              getSizeBox(height: 20),
              SizedBox(
                height: getVerticalSize(18),
                child: ListView.separated(
                    padding: getPadding(right: 20, left: 20),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return customText(
                          text: widget.movie.genres[index],
                          color: AppColors.white.withOpacity(.8),
                          fontSize: 15);
                    },
                    separatorBuilder: (context, index) {
                      return VerticalDivider(
                        color: AppColors.white,
                      );
                    },
                    itemCount: widget.movie.genres.length),
              ),
            ],
          )
        : const SizedBox();
  }

  Widget _infoBuilder() {
    return Padding(
      padding: getPadding(right: 20, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(text: "Description", color: AppColors.white, fontSize: 15),
          getSizeBox(height: 15),
          ExpandableText(
            widget.movie.description,
            maxLines: 10,
            linkColor: AppColors.purple,
            collapseText: "Show less",
            expandText: 'Show more',
            style: customTextStyle(
                color: AppColors.white.withOpacity(.5),
                fontWeight: FontWeight.w400,
                fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _imageBuilder() {
    return Stack(
      children: [
        CustomImageView(
          height: getVerticalSize(height / 2),
          width: double.infinity,
          url: widget.movie.poster2.isEmpty
              ? widget.movie.posterUrl
              : widget.movie.poster2,
          fit: BoxFit.cover,
        ),
        Container(
          height: getVerticalSize(height / 2),
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            AppColors.primaryDark,
            Colors.transparent,
            Colors.transparent,
          ], begin: Alignment.centerLeft, end: Alignment.centerRight)),
        ),
        Container(
          height: getVerticalSize(height / 2) + 1,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            AppColors.primaryDark,
            // Colors.transparent,
            Colors.transparent,
          ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
        ),
        Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Column(
              children: [
                customText(
                    text: widget.movie.movieName,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
                customText(
                    text: widget.movie.type.toLowerCase().replaceFirst(
                        widget.movie.type[0],
                        widget.movie.type[0].toUpperCase()),
                    fontSize: 15,
                    color: Colors.white),
              ],
            )),
      ],
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

}

Widget _buttonBuilder(IconData icon, GestureTapCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: getVerticalSize(40),
      width: getHorizontalSize(40),

      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(.3),
      ),
      // alignment: Alignment.center,
      child: Center(
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    ),
  );
}

Widget myButton({
  double? width,
  required String title,
  required IconData icon,
  required GestureTapCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: getVerticalSize(45),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.pink.withOpacity(.5),
            AppColors.purple.withOpacity(.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(getSize(20)),
      ),

      // alignment: Alignment.center,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            getSizeBox(width: 10),
            customText(
              text: title,
              fontSize: 15,
              color: Colors.white,
            ),
          ],
        ),
      ),
    ),
  );
}
