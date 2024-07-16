import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:my_eyes/themes/app_theme.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.1,
      child: LoadingIndicator(
        indicatorType: Indicator.lineSpinFadeLoader,
        colors: AppTheme.rainbowColors,
        strokeWidth: 2,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
