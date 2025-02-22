import '../../export.dart';

Widget buildFailureWidget(String message) {
  return Center(
    child: CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: customText(
                  text:message,
                  color: AppColors.primaryLight,
                  fontWeight: FontWeight.w600,
                  fontSize: 15),
            ))
      ],
    ),
  );
}
