import 'package:in_app_review/in_app_review.dart';
import '../../../../export.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static Widget builder(BuildContext context) {
    return const ProfileScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
      AppStrings.profile,

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: getPadding(all: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(text: AppStrings.whatYouSee,color: AppColors.primaryLight,fontSize: 15),
              getSizeBox(height: 5),
              Divider(color: AppColors.grey,height: 1,thickness: .5),
              buildProfileItem(AppStrings.favoriteWallpapers, Icons.favorite_border,
                  onTap: () async {
                NavigatorService.push(
                    context, FavoriteWallpaper.builder(context));
              }),
              getSizeBox(height: 5),
              buildProfileItem(AppStrings.watchList, Icons.playlist_add_check,
                  onTap: () async {
                    NavigatorService.push(
                        context, WatchListMovie.builder(context));
                  }),
              getSizeBox(height: 5),
              buildProfileItem(AppStrings.download, Icons.download_outlined,
                  onTap: () async {
                    NavigatorService.push(
                        context, const DownloadShortsScreen());
                  }),
              getSizeBox(height: 5),
              buildProfileItem(AppStrings.favoriteShorts, Icons.movie_creation_outlined,
                  onTap: () async {
                    NavigatorService.push(
                        context, FavoriteShorts.builder(context));
                  }),
              getSizeBox(height: 16),
              customText(text: AppStrings.contact,color: AppColors.primaryLight,fontSize: 15),
              getSizeBox(height: 5),
              Divider(color: AppColors.grey,height: 1,thickness: .5),
              getSizeBox(height: 5),
              buildProfileItem(AppStrings.feedback,arrowShow: false, Icons.feedback_outlined,
                  onTap: () async {
                final Uri params = Uri(
                  scheme: 'mailto',
                  path: AppStrings.feedbackEmail,
                  query: 'Hello',
                );
                final url = params.toString();
                await launchUrl(Uri.parse(url));
              }),
              getSizeBox(height: 5),
              buildProfileItem(AppStrings.inviteFriends,arrowShow: false, Icons.person_add_alt,
                  onTap: () async {
                await share();
              }),
              getSizeBox(height: 5),
              buildProfileItem(AppStrings.rateUs, Icons.star_border,arrowShow: false, onTap: () async {
                // Handle rate app action
                final InAppReview inAppReview = InAppReview.instance;
                bool data = await inAppReview.isAvailable();
                if (data) {
                  inAppReview.requestReview();
                  inAppReview.openStoreListing();
                }
              }),
              getSizeBox(height: 16),
              customText(text: AppStrings.otherInformation,color: AppColors.primaryLight,fontSize: 15),
              getSizeBox(height: 5),
              Divider(color: AppColors.grey,height: 1,thickness: .5),
              getSizeBox(height: 5),
              buildProfileItem(AppStrings.privacyPolicy, Icons.privacy_tip_outlined,
                  onTap: () {
                NavigatorService.push(
                    context,
                     CustomInAppWebView(
                      title: AppStrings.privacyPolicy,
                      url: AppStrings.privacyPolicyUrl,
                    ));
              }),
              getSizeBox(height: 16),
              buildProfileItem(AppStrings.exitApp, Icons.exit_to_app,arrowShow: false, onTap: () {
                customAlert(
                  context: context,
                  title: customText(text: AppStrings.exitApp, color: AppColors.black),
                  content: customText(
                      text: AppStrings.exitDes,
                      color: AppColors.primaryDark,
                      fontSize: 15),
                  confirmWidget: InkWell(
                    onTap: () {
                      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                    },
                    child: Container(
                      // alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(getSize(16)),
                      ),
                      padding: getPadding(top: 8, right: 20, left: 20, bottom: 8),
                      child: customText(
                        color: AppColors.white,
                        fontSize: 15,
                        text: AppStrings.exit,
                      ),
                    ),
                  ),
                );
              }),
              // const Spacer(),
              getSizeBox(height: 16),
              Center(
                child: customText(
                    text: "${AppStrings.version} : ${Singleton.instance.currentAppVersion}",
                    color: AppColors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
              getSizeBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileItem(String title, IconData icon,
      {GestureTapCallback? onTap,bool arrowShow=true}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: getPadding(top: 15, bottom: 0),
        child: Row(

          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.white,
                  size: getSize(24),
                ),
                getSizeBox(width: 16),
                customText(text: title, color: AppColors.white, fontSize: 16,fontWeight: FontWeight.w300),
              ],
            ),
           const Spacer(),
           if(arrowShow) Icon(
              Icons.arrow_forward_ios,
              color: AppColors.white,
              size: getSize(18),
            ),
          ],
        ),
      ),
    );
  }

  ///shear link
  Future<void> share() async {
    await Share.share(AppStrings.appShareLink,
        subject: AppStrings.appShareSub);
  }
}
