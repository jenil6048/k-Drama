import 'package:k_drama/export.dart';
import 'package:k_drama/features/home/data/model/home_model_rt.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Widget builder(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(HomeInitEvent()),
      child: const HomeScreen(),
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tap = -1;
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    Singleton.instance.showAdd=false;
    if(Singleton.instance.showAdd) {
      _loadInterstitialAd();
    }
    super.initState();
  }

  void _showInterstitialAd(BuildContext context, Widget routeChild) {
    _tap += 1;
    if (_tap == 3) {
      _tap = 0;
    }
    if (_tap == 0) {
      if (_interstitialAd == null) {
        NavigatorService.push(context, routeChild);
        return;
      }

      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {},
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _loadInterstitialAd();
          NavigatorService.push(context, routeChild);
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          NavigatorService.push(context, routeChild);
        },
      );

      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      NavigatorService.push(context, routeChild);
    }
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> onRefresh() async {
      bool hasConnection = await isConnectionAvailable();
      if (!hasConnection) {
        showToast(AppStrings.interNetError);
        return;
      }
      if (context.mounted) {
        context.read<HomeBloc>().add(HomeInitEvent());
      }
    }

    return Scaffold(
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (BuildContext context, HomeState state) {
          if (state is ForceUpdateState) {
            forceDialog(context);
          }
        },
        builder: (context, state) {
          if (state is HomeSuccessState || Singleton.instance.homeResponseModel != null) {
            if(_interstitialAd==null&&Singleton.instance.showAdd){
              Singleton.instance.showAdd=false;
              // _loadInterstitialAd();
            }
            HomeResponseModelRt data;
            if (state is HomeSuccessState) {
              data = state.homeResponseModel;
            } else {
              data = Singleton.instance.homeResponseModel!;
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopImageWithDotsIndicator(data.sliderList.slider, context),
                  _buildContent(data, context),
                ],
              ),
            );
          } else if (state is HomeErrorState) {
            return RefreshIndicator(
                onRefresh: onRefresh,
                child: buildFailureWidget(state.error ?? ""));
          }
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryLight),
          );
        },
      ),
    );
  }

  Widget _buildTopImageWithDotsIndicator(
    List<SingleMovieModel> data,
    BuildContext context,
  ) {
    return SizedBox(
      height: getVerticalSize(400),
      child: Column(
        children: [
          SizedBox(
            height: 0,
            child: ListView.builder(
                cacheExtent: double.infinity,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return CustomImageView(
                    height: 1,
                    url: data[index].posterUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                }),
          ),
          Expanded(
            child: CarouselSlider.builder(

              unlimitedMode: true,
              slideBuilder: (index) {
                String posterUrl = data[index].posterUrl;
                return GestureDetector(
                  onTap: () {
                    NavigatorService.push(context,  DetailScreen.builder(
                        context, data[index]));
                  },
                  child: Stack(
                    children: [
                      CustomImageView(
                        height: double.infinity,
                        url: posterUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned.fill(
                        child: Container(
                          height: getVerticalSize(400),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                AppColors.primaryDark,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: data.length,
              initialPage: 0,
              enableAutoSlider: true,
              autoSliderTransitionTime: const Duration(seconds: 2),
              autoSliderDelay: const Duration(seconds: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
      HomeResponseModelRt data,
    BuildContext context,
  ) {
    return Padding(
      padding: getPadding(all: 15),
      child: AnimationLimiter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => SlideAnimation(
              horizontalOffset: 50.0,
              child: FadeInAnimation(
                child: widget,
              ),
            ),
            children: [
              _buildCategorySection(AppStrings.shorts, context, false),
              _buildReelList(data.sliderList.shorts, context: context),
              getSizeBox(height: 20),
              _buildCategorySection(AppStrings.moviesSeries, context, true),
              _buildMovieList(data.movieList, context),
              getSizeBox(height: 10),
              GestureDetector(
                  onTap: () {
                    NavigatorService.push(
                        context, MoviesSeriesList.builder(context));
                  },
                  child: Center(
                      child: customText(
                          text: AppStrings.viewAll,
                          fontSize: 15,
                          color: AppColors.primaryLight)))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(
      String categoryName, BuildContext context, bool isMovie) {
    return Row(
      children: [
        customText(
          text: categoryName,
          fontSize: 18,
          color: AppColors.primaryLight,
          fontWeight: FontWeight.w500,
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            if (isMovie) {
              _tap = -1;
              _showInterstitialAd(context, MoviesSeriesList.builder(context));
            } else {
              _tap = -1;
              //_onSomeUserAction();
              context.read<DashBoardBloc>().add(DashBoardIndexChangeEvent(1));
            }
          },
          child: Icon(
            Icons.arrow_right_alt,
            color: AppColors.primaryLight,
            size: getSize(30),
          ),
        ),
      ],
    );
  }

  Widget _buildReelList(List<ShortModel> list,
      {required BuildContext context}) {
    return Container(
      height: getVerticalSize(150),
      margin: getMargin(top: 10),
      child: ListView.builder(
        cacheExtent: 999999999999,
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context2, index) {
          return GestureDetector(
              onTap: () {
                _showInterstitialAd(
                    context,
                    ShortsScreen.builder(
                      context,
                      index,
                      list,
                      true,
                    ));
              },
              child: _buildReelWidget(reel: list[index]));
        },
      ),
    );
  }

  Widget _buildReelWidget({required ShortModel reel}) {
    return Container(
      width: getVerticalSize(110),
      margin: getPadding(right: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: Image.network(
                reel.videoThumb,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.primaryLight.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              bottom: 0,
              child: Container(
                alignment: Alignment.bottomCenter,
                padding: getPadding(all: 8.0),
                child: Text(
                  reel.videoName,
                  maxLines: 3,
                  textAlign: TextAlign.start,
                  style: poppinsTextStyle.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: getSize(10),
                    color: AppColors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMovieList(
      List<SingleMovieModel> movieList, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ListView.builder(
        cacheExtent: 999999999999,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: movieList.length,
        itemBuilder: (context, index) {
          return _buildSingleWidget(movieList[index], context);
        },
      ),
    );
  }

  Widget _buildSingleWidget(SingleMovieModel movie, BuildContext context) {
    return InkWell(
      onTap: () {
        _showInterstitialAd(context, DetailScreen.builder(context, movie));
      },
      child: Container(
        width: double.infinity,
        height: getVerticalSize(120),
        margin: getMargin(top: 5),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  SizedBox(
                    width: 100,
                    child: CustomImageView(
                      width: 100,
                      url: movie.posterUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.primaryLight.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: getHorizontalSize(5),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: getPadding(all: 5),
                  height: getVerticalSize(120),
                  color: AppColors.black.withOpacity(0.5),
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
                      const Spacer(),
                      Text(
                        movie.description,
                        maxLines: 2,
                        style: poppinsTextStyle.copyWith(
                          fontSize: getSize(11),
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "Type : ${movie.type.toLowerCase() == "movie" ? "Movie📽️" : "Series🎬"}",
                        style: poppinsTextStyle.copyWith(
                          fontSize: 12,
                          color: AppColors.primaryLight.withOpacity(0.9),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: movie.rating.isEmpty
                                ? 3.0
                                : (double.tryParse(movie.rating) ?? 2),
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: getSize(20),
                            unratedColor: Colors.amber.withAlpha(50),
                            direction: Axis.horizontal,
                          ),
                          SizedBox(
                            width: getHorizontalSize(5),
                          ),
                          Text(
                            "(${movie.rating.isEmpty ? 3.0 : (double.tryParse(movie.rating) ?? 2)})",
                            style: poppinsTextStyle.copyWith(
                              fontSize: 11,
                              color: AppColors.white.withOpacity(0.5),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            )
          ],
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
}
