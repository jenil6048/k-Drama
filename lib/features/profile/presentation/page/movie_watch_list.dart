
import '../../../../export.dart';

class WatchListMovie extends StatefulWidget {
  const WatchListMovie({super.key});

  static Widget builder(BuildContext context) {
    return BlocProvider(
      create: (context) => WatchListCubit()..getWatchListMovies(),
      child: const WatchListMovie(),
    );
  }

  @override
  State<WatchListMovie> createState() => _WatchListMovieState();
}

class _WatchListMovieState extends State<WatchListMovie> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    if (Singleton
        .instance.showAdd) {
      _loadBannerAdd();
    }
    super.initState();
    // TODO: Load a banner ad
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
      appBar: CustomAppBar(
        AppStrings.watchlist
      ),
      body: BlocBuilder<WatchListCubit, WatchListState>(
        builder: (context, state) {
          if (state is WatchListSuccessState) {
            if (state.watchListMovie.isEmpty) {
              return Center(
                child: customText(
                    text: AppStrings.noWatchlistFound,
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              );
            }
            return _bodyBuilder(state.watchListMovie,
                context: context, state: state);
          } else {
            return Center(
                child: CircularProgressIndicator(
              color: AppColors.primaryLight,
            ));
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

  Widget _bodyBuilder(List<SingleMovieModel> movieList,
      {required BuildContext context, required WatchListSuccessState state}) {
    return GridView.builder(
      padding: getPadding(top: 10, right: 20, left: 20),
      itemCount: movieList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: getVerticalSize(250),
        crossAxisCount: 2,
        crossAxisSpacing: getHorizontalSize(8),
        mainAxisSpacing: getVerticalSize(8),
      ),
      itemBuilder: (BuildContext context2, int index) {
        return _buildSingleWidget(movieList[index], context, state);
      },
    );
  }

  Widget _buildSingleWidget(SingleMovieModel movie, BuildContext context,
      WatchListSuccessState state) {
    return OpenContainerWrapper(
      childOpen: DetailScreen.builder(context, movie, fromWatchList: true),
      isClosed: false,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Stack(
                      children: [
                        CustomImageView(
                          width: double.infinity,
                          url: movie.posterUrl,
                          fit: BoxFit.cover,
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  AppColors.primaryDark.withOpacity(0.6),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: getPadding(all: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.movieName,
                          // maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: poppinsTextStyle.copyWith(
                            fontSize: getSize(14),
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        getSizeBox(height: 5),
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: (movie.rating).isEmpty
                                  ? 3.0
                                  : (double.tryParse(movie.rating) ?? 2),
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 14,
                              unratedColor: Colors.amber.withAlpha(50),
                              direction: Axis.horizontal,
                            ),
                            SizedBox(
                              width: getHorizontalSize(5),
                            ),
                            Text(
                              "(${(movie.rating).isEmpty ? 3.0 : (double.tryParse(movie.rating) ?? 2)})",
                              style: poppinsTextStyle.copyWith(
                                fontSize: 12,
                                color: AppColors.white.withOpacity(0.5),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: 5,
            top: 5,
            child: InkWell(
              onTap: () async {
                await HapticFeedback.vibrate();
                if (context.mounted) {
                  context.read<WatchListCubit>().removeFromWatchList(movie);
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: getVerticalSize(28),
                width: getVerticalSize(28),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white.withOpacity(.5)),
                child: Icon(
                  Icons.delete,
                  color: AppColors.red,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _loadBannerAdd() {
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
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
