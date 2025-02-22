import 'package:cached_network_image/cached_network_image.dart';
import '../../../../export.dart';


class ImageView extends StatefulWidget {
  final String imgPath;

  const ImageView({super.key, required this.imgPath});

  @override
  ImageViewState createState() => ImageViewState();
}

class ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,

      ),
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Hero(
              tag: widget.imgPath,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: CachedNetworkImage(
                    imageUrl: widget.imgPath, fit: BoxFit.cover),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xff1C1B1B).withOpacity(0.8),
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white24, width: 1),
                                borderRadius: BorderRadius.circular(40),
                                gradient: const LinearGradient(
                                    colors: [
                                      Color(0x36FFFFFF),
                                      Color(0x0FFFFFFF)
                                    ],
                                    begin: FractionalOffset.topLeft,
                                    end: FractionalOffset.bottomRight)),
                            child: customText(
                            text:   "Back",
                                color: Colors.white70,
                                fontSize: 15,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                        ],
                      )),
                  getSizeBox(height: 35)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
