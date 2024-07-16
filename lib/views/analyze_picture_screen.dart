import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:my_eyes/utils/widgets/loader.dart';
import 'package:my_eyes/view_models/gemini_provider.dart';
import 'package:my_eyes/view_models/speech_provider.dart';
import 'package:my_eyes/views/results_screen.dart';
import 'package:provider/provider.dart';

class AnalyzePictureScreen extends StatefulWidget {
  const AnalyzePictureScreen({super.key});

  @override
  State<AnalyzePictureScreen> createState() => _AnalyzePictureScreenState();
}

class _AnalyzePictureScreenState extends State<AnalyzePictureScreen> {
  @override
  void initState() {
    super.initState();
    _startAnalysis();
  }

  void _startAnalysis() {
    Future.delayed(const Duration(seconds: 2), () {
      final geminiProvider = context.read<GeminiProvider>();
      geminiProvider.startAnalyzing();
      context.read<SpeechProvider>().speak('Analyzing your picture');
      FirebaseAnalytics.instance.logEvent(
        name: 'analyze_picture_start',
        parameters: null,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GeminiProvider>(
      builder: (context, geminiProvider, child) {
        if (geminiProvider.analyzing) {
          return Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Image(image: FileImage(File(geminiProvider.imagePath!))),
                  const Loader(),
                ],
              ),
            ],
          );
        } else if (geminiProvider.analyzingResult != null) {
          return const ResultsScreen();
        } else {
          return const Center(child: Loader());
        }
      },
    );
  }
}
