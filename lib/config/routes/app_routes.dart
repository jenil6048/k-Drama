import 'package:k_drama/features/error/presentation/pages/error_page.dart';
import 'package:k_drama/features/splash/presentation/pages/splash_screen.dart';

import '../../export.dart';

class AppRoutes {
  static const String dashBord = '/DashBoard';
  static const String internetErrorScreen = '/InternetErrorScreen';
  static const String splashScreen = '/SplashScreen';

  /*NavigatorService.push(
  context!, EditProfileScreen.builder(context));*/
  static Map<String, WidgetBuilder> get routes => {
        dashBord: DashBoard.builder,
        internetErrorScreen: InternetErrorScreen.builder,
        splashScreen: SplashScreen.builder,
      };
}
