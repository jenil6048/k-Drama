import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../../../export.dart';

class CustomInAppWebView extends StatefulWidget {
  final String title;
  final String url;

  const CustomInAppWebView({super.key, required this.title, required this.url});

  @override
  _CustomInAppWebViewState createState() => _CustomInAppWebViewState();
}

class _CustomInAppWebViewState extends State<CustomInAppWebView> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryDark,
        title: customText(
          text: widget.title,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryLight,
        ),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialSettings: InAppWebViewSettings(
              forceDark: ForceDark.OFF,
              forceDarkStrategy: ForceDarkStrategy.USER_AGENT_DARKENING_ONLY,
            ),
            initialUrlRequest: URLRequest(
              url: WebUri(widget.url),
            ),
            onLoadStart: (controller, url) {
              setState(() {
                isLoading = true;
              });
            },
            onLoadStop: (controller, url) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(color: AppColors.primaryLight),
            ),
        ],
      ),
    );
  }
}
