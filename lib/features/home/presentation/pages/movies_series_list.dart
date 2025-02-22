
import '../../../../export.dart';

class MoviesSeriesList extends StatefulWidget {
  const MoviesSeriesList({super.key});

  static Widget builder(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryCubit()..getAllMovieAndSeries(),
      child: const MoviesSeriesList(),
    );
  }

  @override
  State<MoviesSeriesList> createState() => _MoviesSeriesListState();
}

class _MoviesSeriesListState extends State<MoviesSeriesList> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryDark,
        title: customText(
          text: AppStrings.allMoviesSeries,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryLight,
        ),
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is CategorySuccessState ||
              Singleton.instance.moviesAndSeriesList != null) {
            List<AllMoviesList> movieList;
            if (state is CategorySuccessState) {
              movieList = state.movieList;
            } else {
              movieList = Singleton.instance.moviesAndSeriesList!;
            }

            return Padding(
              padding: getPadding(right: 20, left: 20, bottom: 20),
              child: DefaultTabController(
                length: movieList.length,
                child: Column(
                  children: [
                    Container(
                        height: getVerticalSize(52),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryLight.withOpacity(.5),
                              AppColors.primaryLight,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Padding(
                          padding: getMargin(all: 5),
                          child: TabBar(
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(getSize(25.0)),
                              color: AppColors.primaryDark,
                            ),
                            labelColor: AppColors.white,
                            labelStyle: customTextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                            unselectedLabelColor: AppColors.primaryDark,
                            unselectedLabelStyle: customTextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                            dividerHeight: 0,
                            tabs: List.generate(
                              movieList.length,
                              (index) => Tab(
                                  text: movieList[index]
                                      .type
                                      ?.capitalizeFirstLetter()),
                            ),
                          ),
                        )),
                    Expanded(
                      child: TabBarView(
                        children: List.generate(
                            movieList.length,
                            (index) => _bodyBuilder(movieList[index].data ?? [],
                                context: context)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is CategoryErrorState) {
            return Center(
              child: customText(
                  text: state.error ?? "",
                  color: AppColors.primaryLight,
                  fontWeight: FontWeight.w600,
                  fontSize: 15),
            );
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

  Widget _bodyBuilder(List<SingleMovieModel> movieList,
      {required BuildContext context}) {
    return GridView.builder(
      cacheExtent: double.infinity,
      padding: getPadding(top: 10),
      itemCount: movieList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: getVerticalSize(250),
        crossAxisCount: 2,
        crossAxisSpacing: getHorizontalSize(8),
        mainAxisSpacing: getVerticalSize(8),
      ),
      itemBuilder: (BuildContext context2, int index) {
        return _buildSingleWidget(movieList[index], context);
      },
    );
  }

  Widget _buildSingleWidget(SingleMovieModel movie, BuildContext context) {
    return OpenContainerWrapper(
      childOpen: DetailScreen.builder(context, movie),
      isClosed: false,
      child: ClipRRect(
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
                        fontSize: getSize(12),
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
                          itemSize: getSize(14),
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
