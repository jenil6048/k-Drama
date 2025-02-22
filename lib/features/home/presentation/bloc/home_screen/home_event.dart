
abstract class HomeEvent {}

class HomeInitEvent extends HomeEvent{}
class AddNewShortsEvent extends HomeEvent{
  int count;
  AddNewShortsEvent(this.count);
}