import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:my_eyes/utils/constants.dart';

class SpeechProvider extends ChangeNotifier {
  final FlutterTts flutterTts = FlutterTts();

  String speechText = '';
  bool speechToTextAvailable = false;
  bool showCamera = false;
  List<String> words = [];
  List<Map<String, int>> wordIndices = [];
  int currentWordIndex = 0;

  SpeechProvider() {
    _initializeTts();
    // initializeSpeechToText();
  }

  Future<void> _initializeTts() async {
    try {
      await flutterTts.setPitch(2);
    } catch (e) {
      log('Error initializing TTS: $e');
    }
  }

  Future<void> speak(String text, {Function()? callbackFun}) async {
    speechText = text;
    words = text.split(' ');
    wordIndices = _calculateWordIndices(text);
    currentWordIndex = 0;

    flutterTts
        .setProgressHandler((String text, int start, int end, String word) {
      int index = _findWordIndex(start, end);
      if (index != -1) {
        currentWordIndex = index;
        notifyListeners();
      }
    });

    try {
      await flutterTts.speak(text);
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.awaitSynthCompletion(true);

      // if (listen) {
      //   log('start listen');
      //   Future.delayed(const Duration(seconds: 1), startListening);
      // }

      if (callbackFun != null) {
        callbackFun();
      }
    } catch (e) {
      log('Error during TTS: $e');
    }

    notifyListeners();
  }

  List<Map<String, int>> _calculateWordIndices(String text) {
    List<Map<String, int>> indices = [];
    int currentIndex = 0;
    for (String word in words) {
      int start = text.indexOf(word, currentIndex);
      int end = start + word.length;
      indices.add({'start': start, 'end': end});
      currentIndex = end;
    }
    return indices;
  }

  int _findWordIndex(int start, int end) {
    for (int i = 0; i < wordIndices.length; i++) {
      if (wordIndices[i]['start'] == start && wordIndices[i]['end'] == end) {
        return i;
      }
    }
    return -1;
  }

  openCamera() {
    showCamera = true;
    notifyListeners();
  }

  void reset() {
    speechText = '';
    showCamera = false;
    words = [];
    wordIndices = [];
    currentWordIndex = 0;
    Future.delayed(const Duration(milliseconds: 300), () {
      speak(Constants.captureSurroundingsQuestion);
    });
    notifyListeners();
  }
}
