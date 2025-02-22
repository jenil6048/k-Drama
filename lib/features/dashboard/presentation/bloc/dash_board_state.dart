
abstract class DashBoardState {
  int selectedIndex;
  DashBoardState({required this.selectedIndex});
}

class DashBoardInItState extends DashBoardState {
  DashBoardInItState({required super.selectedIndex});
}

class DashBoardIndexChangeState extends DashBoardState {
  DashBoardIndexChangeState({required super.selectedIndex});
}

// class ForceUpdateState extends DashBoardState {
//   ForceUpdateState({required super.selectedIndex});
// }

