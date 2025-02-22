import '../../../../export.dart';

class ShortsScreenList extends StatelessWidget {
  const ShortsScreenList({super.key});

  static Widget builder(BuildContext context) {
    return BlocProvider<ShortBloc>(
      create: (context) => ShortBloc()..add(ShortInitEvent()),
      child: const ShortsScreenList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(AppStrings.shorts),
      body: _buildTabContent(context: context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          List<ShortModel> tempList = List.from(loadedShortList);
          tempList.shuffle();
          NavigatorService.push(
              context, ShortsScreen.builder(context, 0, tempList, true));
        },
        backgroundColor: AppColors.primaryLight,
        shape: const CircleBorder(),
        child: Center(
            child: Icon(
          Icons.play_circle,
          size: getSize(30),
          color: AppColors.primaryDark,
        )),
      ),
    );
  }

  Widget _buildTabContent({required BuildContext context}) {
    Future<void> onRefresh() async {
      bool hasConnection = await isConnectionAvailable();
      if (!hasConnection) {
        showToast(AppStrings.interNetError);
        return;
      }
      if (context.mounted) {
        context.read<ShortBloc>().add(ShortInitEvent());
      }
    }

    return BlocBuilder<ShortBloc, ShortState>(
      builder: (context, state) {
        if (state is ShortSuccessState) {
          return Column(
            children: [
              Expanded(
                child: MasonryGridView.builder(
                  shrinkWrap: true,
                  cacheExtent: double.infinity,
                  gridDelegate:
                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  // padding: getPadding(all: 15),
                  itemCount: state.shortList.length,
                  itemBuilder: (BuildContext context, int itemIndex) {
                    return _buildReelWidget(state.shortList[itemIndex],
                        context: context, itemIndex: itemIndex);
                  },
                ),
              ),
            ],
          );
        } else if (state is ShortErrorState) {
          return RefreshIndicator(
              onRefresh: onRefresh,
              child: buildFailureWidget("Something went wrong"));
        }
        return Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryLight,
          ),
        );
      },
    );
  }

  Widget _buildReelWidget(ShortModel short,
      {required BuildContext context, required int itemIndex}) {
    return OpenContainerWrapper(
      childOpen:
          ShortsScreen.builder(context, itemIndex, loadedShortList, true),
      isClosed: false,
      child: Container(
        width: width / 2,
        margin: getMargin(all: 5),
        height: getVerticalSize(250),
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
      ),
    );
  }

// Widget _buildTabContent({required BuildContext context}) {
//
//   return GridView.builder(
//     cacheExtent: 99999,
//     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 15.0,
//         mainAxisSpacing: 15.0,
//         mainAxisExtent: getVerticalSize(250)),
//     padding: getPadding(all: 15),
//     itemCount: url.length,
//     itemBuilder: (BuildContext context, int itemIndex) {
//       return FutureBuilder<void>(
//         future: _generateThumbnail(url[itemIndex]),
//         builder: (context2, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             // The thumbnail has been generated successfully
//             return GestureDetector(
//               onTap: () {
//                 NavigatorService.push(context, ShortsScreen.builder(context,itemIndex));
//               },
//               child: _buildVideoTile(url[itemIndex], snapshot.data as Uint8List,
//                   randomDescriptions[itemIndex]),
//             );
//           } else {
//             // Display a placeholder or loading indicator while generating the thumbnail
//             return _buildLoadingPlaceholder();
//           }
//         },
//       );
//     },
//   );
// }
//
// Future<Uint8List> _generateThumbnail(String videoUrl) async {
//   final thumbnail = await VideoThumbnail.thumbnailData(
//     video: videoUrl,
//     imageFormat: ImageFormat.JPEG,
//     maxHeight: 720, // Set the desired height for HD quality
//     quality: 75,
//   );
//   return thumbnail!;
// }
//
// Widget _buildVideoTile(
//     String videoUrl, Uint8List thumbnail, String description,) {
//   return _buildReelWidget(thumbnail, description);
// }
//
// Widget _buildReelWidget(Uint8List image, String description) {
//   return Container(
//     height: getVerticalSize(150),
//     width: getVerticalSize(110),
//     margin: getPadding(right: 5),
//     child: ClipRRect(
//       borderRadius: BorderRadius.circular(10),
//       child: Stack(
//         children: [
//           SizedBox(
//             width: double.infinity,
//             child: Image.memory(
//               image,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Positioned.fill(
//             bottom: 0,
//             child: Container(
//               alignment: Alignment.bottomCenter,
//               padding: getPadding(all: 8.0),
//               child: Text(
//                 description,
//                 maxLines: 3,
//                 textAlign: TextAlign.start,
//                 style: poppinsTextStyle.copyWith(
//                   fontWeight: FontWeight.w500,
//                   fontSize: getSize(10),
//                   color: AppColors.white,
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     ),
//   );
// }
//
// Widget _buildLoadingPlaceholder() {
//   return ClipRRect(
//     borderRadius: BorderRadius.circular(10),
//     child: Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: Colors.grey.withOpacity(0.5),
//       ),
//       child: LinearProgressIndicator(
//           color: Colors.grey.shade700, backgroundColor: Colors.grey.shade800),
//     ),
//   );
// }
}
