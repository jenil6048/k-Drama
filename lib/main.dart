import 'dart:async';

import 'package:k_drama/export.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldKey =
    GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

 await Singleton.instance.appInIt();
  // await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme().copyWith(),
      navigatorKey: NavigatorService.navigatorKey,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splashScreen,
      // initialRoute: !Singleton.instance.isConnection
      //     ? AppRoutes.dashBord
      //     : AppRoutes.internetErrorScreen,
      // home: AppTheme(),
      routes: AppRoutes.routes,
    );
  }
}
