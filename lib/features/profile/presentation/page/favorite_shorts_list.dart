
import '../../../../export.dart';

class FavoriteShorts extends StatefulWidget {
  const FavoriteShorts({super.key});

  static Widget builder(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteShortsCubit()..getFavoriteShorts(),
      child: const FavoriteShorts(),
    );
  }

  @override
  State<FavoriteShorts> createState() => _FavoriteShortsState();
}

class _FavoriteShortsState extends State<FavoriteShorts> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    if (Singleton.instance.showAdd) {
      _loadBannerAdd();
    }
    super.initState();
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
        AppStrings.favoriteShorts,
      ),
      body: BlocBuilder<FavoriteShortsCubit, FavoriteShortsState>(
        builder: (context, state) {
          if (state is FavoriteShortsSuccessState) {
            return (state.shortList?.length ?? 0) == 0
                ? Center(
                    child: customText(
                        text: AppStrings.noFavoriteShortsFound,
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                  )
                : GridView.builder(
                    cacheExtent: 99999,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 15.0,
                        mainAxisExtent: getVerticalSize(250)),
                    padding: getPadding(all: 15),
                    itemCount: state.shortList?.length,
                    itemBuilder: (BuildContext context, int itemIndex) {
                      return OpenContainerWrapper(
                        childOpen: ShortsScreen.builder(
                            context, itemIndex, state.shortList!, false),
                        isClosed: false,
                        child: _buildReelWidget(state.shortList![itemIndex],
                            context: context, itemIndex: itemIndex),
                      );
                    },
                  );
          }
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryLight,
            ),
          );
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

  Widget _buildReelWidget(ShortModel short,
      {required BuildContext context, required int itemIndex}) {
    return Container(
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
        child: Stack(
          children: [
            CustomImageView(
              height: double.infinity,
              width: double.infinity,
              // alignment: Alignment.center,
              url: short.videoThumb,
              fit: BoxFit.fitWidth,
            ),
            Positioned.fill(
              bottom: 0,
              child: Container(
                alignment: Alignment.bottomCenter,
                padding: getPadding(all: 8.0),
                child: Text(
                  short.videoName,
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
