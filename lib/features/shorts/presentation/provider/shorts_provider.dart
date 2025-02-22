import 'dart:developer';
import '../../../../export.dart';


class PreloadProvider extends ChangeNotifier {
  // List<ShortModel> get shortList => loadedShortList;
  final List<ShortModel> shortList;
  final Map<int, VideoPlayerController> _controllers = {};
  PreloadProvider(this.shortList);
  Map<int, VideoPlayerController> get controllers => _controllers;

  int _focusedIndex = 0;

  int get focusedIndex => _focusedIndex;
  final PageController _pageController = PageController(initialPage: 0);

  PageController get pageController => _pageController;
  void setFocusedIndex(int index) {
    _focusedIndex = index;
    notifyListeners();
  }
  Future _initializeControllerAtIndex(int index) async {
    if (shortList.length > index && index >= 0) {
      /// Create new controller
      final VideoPlayerController controller =
          VideoPlayerController.contentUri(Uri.parse(shortList[index].videoUrl));

      /// Add to [controllers] list
      _controllers[index] = controller;

      /// Initialize
      await controller.initialize();

      log('🚀🚀🚀 INITIALIZED $index');
    }
  }

  void _playControllerAtIndex(int index) async {
    if (shortList.length > index && index >= 0) {
      logV("index2===>$index");

      /// Get controller at [index]
      final VideoPlayerController controller = _controllers[index]!;

      /// Play controller
      controller.play();
      notifyListeners();
      log('🚀🚀🚀 PLAYING $index');
    }
  }

  void nextVideo(int index) async {
    logV("index0==>");
    if (shortList.length - 1 != index && index >= 0) {
      logV("index1==>");

      notifyListeners();
    }
  }

  void _stopControllerAtIndex(int index) async {
    if (shortList.length > index && index >= 0) {
      /// Get controller at [index]
      final VideoPlayerController controller = _controllers[index]!;

      /// Pause
      controller.pause();

      /// Reset postiton to beginning
      controller.seekTo(const Duration());

      log('🚀🚀🚀 STOPPED $index');
    }
  }

  void _disposeControllerAtIndex(int index) async {
    if (shortList.length > index && index >= 0&& _controllers[index] !=null) {
      /// Get controller at [index]
      final VideoPlayerController controller = _controllers[index]!;

      /// Dispose controller
      controller.dispose();

      _controllers.remove(controller);

      log('🚀🚀🚀 DISPOSED $index');
    }
  }

  void _playNext(int index) async {
    /// Stop [index - 1] controller
    _stopControllerAtIndex(index - 1);

    /// Dispose [index - 2] controller
    _disposeControllerAtIndex(index - 2);

    /// Play current video (already initialized)
    _playControllerAtIndex(index);

    /// Initialize [index + 1] controller
    _initializeControllerAtIndex(index + 1);
  }

  void _playPrevious(int index) async {
    /// Stop [index + 1] controller
    _stopControllerAtIndex(index + 1);

    /// Dispose [index + 2] controller
    _disposeControllerAtIndex(index + 2);

    /// Play current video (already initialized)
    _playControllerAtIndex(index);

    /// Initialize [index - 1] controller
    _initializeControllerAtIndex(index - 1);
  }

  void initialize(int index) async {
    /// Initialize 1st video
  await  _initializeControllerAtIndex(index);
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 1),
      curve: Curves.easeInOut,
    );
    /// Play 1st video
    _playControllerAtIndex(index);
    if(index != 0){
      _initializeControllerAtIndex(index-1);
    }

    /// Initialize 2nd vide
      _initializeControllerAtIndex(index+1);
  }

  void onVideoIndexChanged(int index) async {
    bool isConnection = await isConnectionAvailable();
    if (!isConnection) {
      showToast("Please check internet connection!!!");
    }
    if (!isConnection) return;
    if (index > _focusedIndex) {
      _playNext(index);
    } else {
      _playPrevious(index);
    }
    _focusedIndex = index;
    notifyListeners();
  }

  @override
  void dispose() {
    _focusedIndex = 0;
    // TODO: implement dispose
    // Dispose all video controllers
    for (var controller in _controllers.values) {
      controller.dispose();
    }

    // Clear the controllers map
    _controllers.clear();
    super.dispose();
  }
}
