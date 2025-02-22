import 'package:k_drama/export.dart';

class InternetErrorScreen extends StatefulWidget {
  const InternetErrorScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return const InternetErrorScreen();
  }

  @override
  State<InternetErrorScreen> createState() => _InternetErrorScreenState();
}

class _InternetErrorScreenState extends State<InternetErrorScreen> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: getPadding(all: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.signal_wifi_off,
                    size: getSize(100),
                    color: AppColors.appIconColor,
                  ),
                  getSizeBox(height: 20),
                  customText(
                      textAlign: TextAlign.center,
                      text: AppStrings.interNetError,
                      color: AppColors.primaryLight,
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                  getSizeBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (await isConnectionAvailable()) {
                        loading = true;
                        setState(() {});
                        await Singleton.instance.appInIt();
                        await NavigatorService.pushNamedAndRemoveUntil(
                            AppRoutes.dashBord);
                      } else {
                        showToast(AppStrings.interNetError);
                      }
                    },
                    child: customText(
                        textAlign: TextAlign.center,
                        text: AppStrings.retry,
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
              visible: loading,
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primaryLight),
              ))
        ],
      ),
    );
  }
}
