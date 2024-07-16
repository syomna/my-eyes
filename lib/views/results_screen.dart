import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:my_eyes/view_models/gemini_provider.dart';
import 'package:my_eyes/view_models/speech_provider.dart';
import 'package:provider/provider.dart';
import 'package:siri_wave/siri_wave.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _speakResult();

    FirebaseAnalytics.instance.logEvent(
      name: 'results_screen_init',
      parameters: {
        'analysis_result': context.read<GeminiProvider>().analyzingResult!
      },
    );
  }

  void _speakResult() {
    final geminiProvider = context.read<GeminiProvider>();
    final speechProvider = context.read<SpeechProvider>();

    speechProvider.speak(geminiProvider.analyzingResult!, callbackFun: () {
      speechProvider.reset();
      geminiProvider.reset();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentWord(SpeechProvider speechProvider) {
    final currentWordIndex = speechProvider.currentWordIndex;
    const wordHeight = 30.0;
    final position = currentWordIndex * wordHeight;

    if (_scrollController.hasClients) {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final visibleAreaStart = _scrollController.offset;
      final visibleAreaEnd =
          visibleAreaStart + _scrollController.position.viewportDimension;

      if (position < visibleAreaStart || position > visibleAreaEnd) {
        _scrollController.animateTo(
          position.clamp(0.0, maxScrollExtent),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: Image(
                image: FileImage(
                  File(context.watch<GeminiProvider>().imagePath!),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Consumer<SpeechProvider>(
              builder: (context, speechProvider, child) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToCurrentWord(speechProvider);
                });
                return RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: speechProvider.words.asMap().entries.map((entry) {
                      int idx = entry.key;
                      String word = entry.value;
                      return TextSpan(
                        text: '$word ',
                        style: TextStyle(
                          color: idx == speechProvider.currentWordIndex
                              ? Colors.amber
                              : Colors.white,
                          fontSize: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.fontSize,
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            SiriWaveform.ios9(),
            SizedBox(height: MediaQuery.of(context).size.height / 4),
          ],
        ),
      ),
    );
  }
}
