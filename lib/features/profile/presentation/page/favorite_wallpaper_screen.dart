import '../../../../export.dart';
import '../../../wallpaper/data/model/wallpaper_list_model_rt.dart';

class FavoriteWallpaper extends StatefulWidget {
  const FavoriteWallpaper({super.key});

  static Widget builder(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteWallpaperCubit()..getFavoriteWallPaper(),
      child: const FavoriteWallpaper(),
    );
  }

  @override
  State<FavoriteWallpaper> createState() => _FavoriteWallpaperState();
}

class _FavoriteWallpaperState extends State<FavoriteWallpaper> {
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
        AppStrings.favorite,
      ),
      body: BlocBuilder<FavoriteWallpaperCubit, FavoriteWallpaperState>(
        builder: (context, state) {
          if (state is FavoriteWallpaperSuccessState) {
            if ((state.wallPaperList?.length ?? 0) == 0) {
              return Center(
                child: customText(
                    text: AppStrings.noFavoriteWallpaperFound,
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              );
            }
            return MasonryGridView.builder(
              cacheExtent: 99999,
              itemCount: state.wallPaperList?.length ?? 0,
              gridDelegate:
                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              padding: getPadding(all: 15),
              itemBuilder: (BuildContext context, int itemIndex) {
                return _imageBuilder(
                    wallpaperValues: state.wallPaperList!,
                    itemIndex: itemIndex,
                    context: context);
              },
            );
          } else {
            return const SizedBox();
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

  Widget _imageBuilder({
    required List<String> wallpaperValues,
    required int itemIndex,
    required BuildContext context,
  }) {
    return OpenContainerWrapper(
      childOpen: GalleryViewBuilder(
        initialIndex: itemIndex,
        context2: context,
        fWallpapersList: wallpaperValues,
        isFavorite: true,
      ),
      isClosed: false,
      child: Stack(
        children: [
          CustomImageView(
            margin: getMargin(
              all: 5,
            ),
            url: wallpaperValues[itemIndex],
            fit: BoxFit.cover,
            radius: BorderRadius.circular(getSize(15)),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: InkWell(
              onTap: () async {
                DatabaseHelper.removeWallpaper(wallpaperValues[itemIndex]);
                wallpaperValues.removeAt(itemIndex);
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
                await HapticFeedback.vibrate();
                if (context.mounted) {
                  context
                      .read<FavoriteWallpaperCubit>()
                      .removeFromFavorite(wallpaperValues);
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
                  Icons.favorite,
                  color: AppColors.pink,
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
