

import '../../export.dart';
import 'open_container.dart';

class OpenContainerWrapper extends StatelessWidget {
   const OpenContainerWrapper({
    Key? key,
    required this.child,
    required this.childOpen,
    required this.isClosed,

  }) : super(key: key);

  final Widget child;
  final Widget childOpen;

  final bool isClosed;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedShape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(getVerticalSize(10.0))),
      ),
      //closedColor: const Color(0xFFE5E6E8)

      transitionType: ContainerTransitionType.fade,
      openElevation: 0.0,
      closedColor: Colors.transparent,
      openColor: Colors.transparent,
      closedElevation: 0.0,
      transitionDuration: const Duration(milliseconds: 900),
      closedBuilder: (_, VoidCallback openContainer) {
        return InkWell(onTap: openContainer, child: child);
      },
      openBuilder: (_, __) {
        return gotoOther();
      },
    );
  }

   Widget gotoOther() {
     return isClosed ? Container() : childOpen;
   }

}
