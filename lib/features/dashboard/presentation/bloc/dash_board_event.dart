
abstract class DashBoardEvent {}

class DashBoardIndexChangeEvent extends DashBoardEvent{
  int index;
  DashBoardIndexChangeEvent(this.index);
}
class DashBoardInItEvent extends DashBoardEvent{}

// class AddNewShortsEvent extends DashBoardEvent{
//   int count;
//   AddNewShortsEvent(this.count);
// }