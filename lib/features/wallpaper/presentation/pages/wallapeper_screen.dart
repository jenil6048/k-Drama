import 'dart:io';

import 'package:k_drama/export.dart';
import 'package:http/http.dart' as http;
import 'package:k_drama/features/wallpaper/data/model/wallpaper_list_model_rt.dart';

import 'gallery_view.dart';

class WallPaperView extends StatelessWidget {
  const WallPaperView({super.key});

  static Widget builder(BuildContext context) {
    return BlocProvider<WallpaperBloc>(
      create: (context) =>WallpaperBloc()..add(WallpaperLoadEvent()),
      child: const WallPaperView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
         AppStrings.wallpaper,
      ),
      body: BlocBuilder<WallpaperBloc, WallpaperState>(
        builder: (context2, state) {
          if (state is WallpaperLoadedState ||
              state is WallpaperLoadingState ||
              (Singleton.instance.wallpaperListRt != null &&
                  Singleton.instance.catList != null)) {
            List<String> catList;
            List<WallpaperListRt> wallpaperListRt;
            if(state is WallpaperLoadedState ||
                state is WallpaperLoadingState){
              catList=state.category!;
              wallpaperListRt=state.wallPaperList!;
            }
            else{
              catList=Singleton.instance.catList!;
              wallpaperListRt=Singleton.instance.wallpaperListRt!;
            }
            return DefaultTabController(
              length: catList.length,
              child: Column(
                children: [
                  _headerTabBar(context: context, category: catList),
                  Expanded(
                    child: state is WallpaperLoadingState
                        ? Center(
                            child: CircularProgressIndicator(
                            color: AppColors.primaryLight,
                          ))
                        : TabBarView(
                            children: List.generate(
                              catList.length,
                              (index) => _buildSubTabs(
                                  wallpaperListRt[index], index),
                            ),
                          ),
                  ),
                ],
              ),
            );
          } else if (state is WallpaperInitialState) {
            return Center(
                child: CircularProgressIndicator(
              color: AppColors.primaryLight,
            ));
          } else {
            return Center(
              child: customText(
                  text: "Something went wrong",
                  color: AppColors.primaryLight,
                  fontWeight: FontWeight.w600,
                  fontSize: 15),
            );
          }
        },
      ),
    );
  }

  Widget _headerTabBar(
      {required BuildContext context, required List<String> category}) {
    return Container(
      margin: getMargin(bottom: 10),
      child: ButtonsTabBar(

        radius: getSize(18),
        height: getVerticalSize(35),
        splashColor: Colors.transparent,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryLight,
              AppColors.purple,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        unselectedDecoration: const BoxDecoration(
          color: Colors.grey,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: getSize(15)),
        duration: 2,
        labelSpacing: 200,
        buttonMargin: EdgeInsets.symmetric(horizontal: getHorizontalSize(10)),
        labelStyle: customTextStyle(
            color: AppColors.white, fontSize: 15, fontWeight: FontWeight.w400),
        unselectedLabelStyle: customTextStyle(
            color: AppColors.white, fontSize: 15, fontWeight: FontWeight.w400),
        // isScrollable: true,
        tabs: List.generate(
          category.length,
          (index) => Tab(
            text: category[index],
          ),
        ),
      ),
    );
  }

  Widget _buildSubTabs(WallpaperListRt data, int index) {
    return DefaultTabController(
      length: data.images.length,
      child: Stack(
        children: [
          TabBarView(
            children: List.generate(
              data.images.length,
                  (index2) => _buildTabContent(data.images[index2].wallpapers),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 25,
            left: 25,
            child: Card(
              clipBehavior: Clip.antiAlias,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Container(
                height: getVerticalSize(52),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.purple,
                      AppColors.primaryLight,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: getMargin(all: 5),
                  child: TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(getSize(25.0)),
                      color: AppColors.primaryDark.withOpacity(.7),
                    ),
                    labelColor: AppColors.white,
                    labelStyle: customTextStyle(fontSize: 16),
                    unselectedLabelColor: AppColors.primaryDark,
                    dividerHeight: 0,
                    tabs: List.generate(
                      data.images.length,
                          (index2) => Tab(text:data.images[index2].membername),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildTabContent(Map<String, WallpaperData> wallpapers) {
    return MasonryGridView.builder(
      cacheExtent: 99999,

      itemCount: wallpapers.keys.length ?? 0,
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      padding: getPadding(right: 15,left: 15,top: 15,bottom: 60),
      itemBuilder: (BuildContext context, int itemIndex) {
        var wallpaperValues =
            wallpapers.values.toList(); // Convert values to a list

        if (itemIndex < wallpaperValues.length) {
          return _imageBuilder(
            wallpaperValues: wallpaperValues,
            itemIndex: itemIndex,
            context: context,
          );
        } else {
          return const Card(
            child: Text("Invalid data"),
          );
        }
      },
    );
  }

  Widget _imageBuilder({
    required List<WallpaperData> wallpaperValues,
    required int itemIndex,
    required BuildContext context,
  }) {
    return OpenContainerWrapper(
      childOpen: GalleryViewBuilder(
        wallpapers: wallpaperValues,
        initialIndex: itemIndex,
        context2: context,
        isFavorite: false,
      ),
      isClosed: false,
      child: Stack(
        children: [
          CustomImageView(
            margin: getMargin(
              all: 5,
            ),
            url: wallpaperValues[itemIndex].image,
            fit: BoxFit.cover,
            radius: BorderRadius.circular(getSize(15)),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: InkWell(
              onTap: () {
                wallpaperValues[itemIndex].isFavorite =
                    !wallpaperValues[itemIndex].isFavorite;
                if (wallpaperValues[itemIndex].isFavorite) {
                  DatabaseHelper.insertWallpaper(
                      wallpaperValues[itemIndex].image);
                } else {
                  DatabaseHelper.removeWallpaper(
                      wallpaperValues[itemIndex].image);
                }
                context.read<WallpaperBloc>().add(WallpaperSuccessEvent());
              },
              child: Container(
                alignment: Alignment.center,
                height: getVerticalSize(28),
                width: getVerticalSize(28),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white.withOpacity(.5)),
                child: Icon(
                  wallpaperValues[itemIndex].isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: AppColors.pink,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> downloadImage(String imageUrl) async {
    showToast("Downloading....");
    try {
      http.Response response = await http.get(Uri.parse(imageUrl));
      final Uint8List bytes = response.bodyBytes;

      // Get the application documents directory
      Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      String appDocumentsPath = appDocumentsDirectory.path;

      // Save the image to the documents directory
      File file = File('$appDocumentsPath/image.jpg');
      logV("file path====>${file.path}");
      await file.writeAsBytes(bytes);
      // await ImageGallerySaver.saveFile(file.path);
      showToast("Wallpaper Download successfully....");
    } catch (e) {
      logV("error while downloading image===>$e");
      showToast("Download failed..");
    }
  }

  Future<void> setWallpaper(String imageUrl) async {
    try {
      showToast("Setting wallpaper...");

      // Get the wallpaper file path
      int location = WallpaperManager.HOME_SCREEN;
      var file = await DefaultCacheManager().getSingleFile(imageUrl);

      // Set wallpaper from file or network (you can use either)
      await WallpaperManager.setWallpaperFromFile(file.path, location);
      // or
      // await FlutterWallpaperManager.setWallpaperFromUrl(imageUrl, WallpaperManagerPlatform.HOME_SCREEN);

      showToast("Wallpaper set successfully!");
    } catch (e) {
      showToast("Failed to set wallpaper: $e");
    }
  }
}
