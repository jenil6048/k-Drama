import '../../../../export.dart';

class CustomAppBar extends AppBar {
  final String titleText;
  final double? fontSize;
  final List<Widget>? actions;

  CustomAppBar(this.titleText, {super.key,this.actions,this.fontSize}) :super(
      forceMaterialTransparency: true,
      iconTheme:IconThemeData(color: AppColors.primaryLight),
      centerTitle: true,
      title: customText(
        text: titleText,
        fontSize:fontSize ,
        fontWeight: FontWeight.w500,
        color: AppColors.primaryLight,
      ),
      actions: actions,
      elevation: 0,
      backgroundColor: AppColors.primaryDark,
  );
}