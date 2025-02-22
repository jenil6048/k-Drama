
import 'package:k_drama/export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static Widget builder(BuildContext context) {
    return const SplashScreen();
  }

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  double _progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    final Tween<double> tween = Tween(begin: 0.0, end: 1.0);
    _progressAnimation = tween.animate(_animationController);
    _animationController.forward();
    _progressAnimation.addListener(() {
      setState(() {
        _progressValue = _progressAnimation.value;
        if (_progressValue >= 1.0) {
          NavigatorService.pushNamedAndRemoveUntil(Singleton.instance.isConnection
              ? AppRoutes.dashBord
              : AppRoutes.internetErrorScreen);
        }
      });
    });

  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            CustomImageView(
              imagePath: ImageConstants.splashImage,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: getVerticalSize(50),
              right: 0,
              left: 0,
              child: Column(
                children: [
                  customText(
                    textAlign: TextAlign.center,
                    text: AppStrings.appName,
                    fontWeight: FontWeight.w500,
                    fontSize: 19,
                    color: AppColors.white,
                  ),
                  getSizeBox(height: 18),
                  SizedBox(
                    width: width / 2.1,
                    height: getVerticalSize(4),
                    child: LinearProgressIndicator(
                      borderRadius: BorderRadius.circular(getSize(16)),
                      value: _progressValue,
                      backgroundColor: AppColors.black,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
