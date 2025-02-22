import 'package:k_drama/export.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  static Widget builder(BuildContext context) {
    return BlocProvider(
        create: (context) => DashBoardBloc(), child: const DashBoard());
  }

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  AppOpenAd? _appOpenAd;

  @override
  void initState() {
    _initAppOpenAd();
    super.initState();
  }

  @override
  void dispose() {
    _appOpenAd?.dispose();
    super.dispose();
  }

  Future<void> _initAppOpenAd() async {
    print("_initAppOpenAd===>");
    if (_appOpenAd != null) {
      print("App Open Ad already loaded");
      return; // Prevent loading a duplicate ad
    }

    await AppOpenAd.load(
      adUnitId: AdHelper.appOpenAd,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _appOpenAd?.show();
        },
        onAdFailedToLoad: (err) {
          _appOpenAd = null;
          logV('Failed to load an interstitial ad: ${err.message}');
        },
      ),
      orientation: AppOpenAd.orientationPortrait,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<WidgetBuilder> widget = [
      HomeScreen.builder,
      ShortsScreenList.builder,
      WallPaperView.builder,
      ProfileScreen.builder,
    ];
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light
          .copyWith(systemNavigationBarColor: AppColors.primaryDark),
      child: BlocBuilder<DashBoardBloc, DashBoardState>(
        builder: (context, state) {
          return PopScope(
            canPop: state.selectedIndex == 0,
            onPopInvoked: (val) {
              if (!val) {
                context.read<DashBoardBloc>().add(DashBoardIndexChangeEvent(0));
              }
            },
            child: Scaffold(
              extendBody: false,
              backgroundColor: AppColors.primaryDark,
              body: widget[state.selectedIndex](context),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: state.selectedIndex,
                selectedItemColor: AppColors.primaryLight,
                elevation: 0,
                unselectedItemColor: Colors.white54,
                backgroundColor: AppColors.primaryDark,
                onTap: (index) {
                  context
                      .read<DashBoardBloc>()
                      .add(DashBoardIndexChangeEvent(index));
                },
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.home_outlined),
                    activeIcon: const Icon(Icons.home),
                    label: AppStrings.home,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.movie_outlined),
                    activeIcon: const Icon(Icons.movie),
                    label: AppStrings.shorts,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.wallpaper_outlined),
                    activeIcon: const Icon(Icons.wallpaper),
                    label: AppStrings.wallpaper,
                  ),
                  BottomNavigationBarItem(
                    activeIcon: const Icon(Icons.person_2),
                    icon: const Icon(Icons.person_2_outlined),
                    label: AppStrings.profile,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
