import 'dart:io';
import '../../../../export.dart';

forceDialog(BuildContext context) {
  return customDialog(
    barrierDismissible: false,
    context: context,
    backGroundColor: AppColors.primaryDark.withOpacity(.5),
    child: PopScope(
      canPop: false,
      child: Container(
        margin: getMargin(all: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      clipBehavior: Clip.none,
                      height: getVerticalSize(70),
                      width: getHorizontalSize(70),
                      decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle),
                      child: ClipOval(child: CustomImageView(imagePath: ImageConstants.appLogo,)),
                    ),
                  ),
                ),
              ],
            ),
            getSizeBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customText(
               text:    AppStrings.newUpdateAvailable,
                    color: AppColors.primaryLight,
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                ),
              ],
            ),
            getSizeBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customText(
                  text: AppStrings.fdDes,
                  fontSize: 11,
                  color: AppColors.appIconColor,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            getSizeBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    await redirectToAppPlayStore();
                    // Navigator.pop(context);
                  },
                  child: Container(
                    width: getHorizontalSize(150),
                    height: getVerticalSize(40),
                    decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Container(
                        margin: getMargin(all: 10),
                        child: customText(
                            text: AppStrings.updateNow,
                            color: AppColors.white,
                            fontSize: getFontSize(12),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

Future redirectToAppPlayStore() async {
  if (Platform.isAndroid) {
    var appName = Singleton.instance.latestVersion;
    var targetURL = Uri.parse("https://play.google.com/store/apps/details?id=com.wallpaperbts.btskdramashorts");
    await launchUrl(targetURL);
  } else if (Platform.isIOS) {
    // var appID = "<your_app_id>"
    // var targetURL = Uri.parse("items-apps://itunes.apple.com/app/$appID");
    // await launchUrl(_url);
  }
}
