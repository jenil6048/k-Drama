import '../../../../export.dart';

class LikeWidget extends StatefulWidget {
  const LikeWidget({super.key});

  @override
  State<LikeWidget> createState() => _LikeWidgetState();
}

class _LikeWidgetState extends State<LikeWidget> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent, // Transparent background
      elevation: 0, // No shadow
      child: Container(
        height: getHorizontalSize(250),
        width: getHorizontalSize(250),
        color: Colors.transparent, // Adjust as needed
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Your content, for example a Lottie animation
              Lottie.asset('assets/lottie/heart.json', fit: BoxFit.fitWidth),
            ],
          ),
        ),
      ),
    );
  }
}

// To show the dialog:
