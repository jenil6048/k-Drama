


import '../../export.dart';

customDialog(
    {required BuildContext context,
      required Widget child,
      Color? backGroundColor,
      bool? barrierDismissible,
      double? padding,
      double? maxWidth,
      Future<bool> Function()? onWillPop}) {
  return showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.4),
      transitionBuilder: (context, a1, a2, widget) {
        return SafeArea(
          child: Transform.scale(
            scale: a1.value,
            child: Padding(
              padding:getPadding(all: 10),
              child: Dialog(
                elevation: 0,
                surfaceTintColor: AppColors.primaryLight,
                insetPadding:
                EdgeInsets.symmetric(horizontal: getHorizontalSize(padding??20),vertical: getHorizontalSize(padding??20) ),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                backgroundColor: backGroundColor ??
                    Colors.white,
                child: Container(
                  constraints: BoxConstraints( maxWidth: maxWidth??400),

                  child: child,
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: barrierDismissible ?? true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return const SizedBox();
      }
  );
}

customAlert(
    {required BuildContext context,

      Widget? title,
      Widget? content,
      Widget? cancelWidget,
      Widget? confirmWidget,
      Color? backGroundColor,
      bool? barrierDismissible,
      VoidCallback? onSubmit,
      Future<bool> Function()? onWillPop}) {
  return showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.4),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,

          child:  AlertDialog(

            actionsPadding:getPadding(bottom: 10,right: 20,left: 20),
            contentPadding: getPadding(right: 20,left: 20,top: 15),

            title: title,
            content: SizedBox(width: double.infinity,child: content),
            actions: <Widget>[
              cancelWidget??TextButton(
                child:  customText(
                 text:  'Cancel',color: AppColors.primaryDark,fontSize: 15,fontWeight: FontWeight.w600),
                onPressed: () =>
                    NavigatorService.goBack(),
              ),
              confirmWidget??   FilledButton(

                onPressed: onSubmit,
                child:
                const Text('Okay'),
              ),
            ],
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: barrierDismissible ?? true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return const SizedBox();
      }
  );
}