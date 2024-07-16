import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:my_eyes/themes/app_theme.dart';
import 'package:my_eyes/utils/constants.dart';
import 'package:my_eyes/view_models/gemini_provider.dart';
import 'package:my_eyes/view_models/speech_provider.dart';
import 'package:my_eyes/views/analyze_picture_screen.dart';
import 'package:my_eyes/views/camera_screen.dart';
import 'package:provider/provider.dart';
import 'package:siri_wave/siri_wave.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    await _initializeSpeak();
    FirebaseAnalytics.instance.logEvent(
      name: 'home_screen_init',
      parameters: null,
    );
  }

  Future<void> _initializeSpeak() async {
    context.read<SpeechProvider>().speak(Constants.captureSurroundingsQuestion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Eyes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: _displayBody(context),
          ),
        ),
      ),
    );
  }

  Widget _displayBody(BuildContext context) {
    final geminiProvider = context.watch<GeminiProvider>();
    final speechProvider = context.watch<SpeechProvider>();

    if (geminiProvider.imagePath != null) {
      return const AnalyzePictureScreen();
    }

    if (speechProvider.showCamera) {
      return const CameraScreen();
    } else {
      return _buildTextAndWaveform(speechProvider);
    }
  }

  Widget _buildTextAndWaveform(SpeechProvider speechProvider) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          MaterialButton(
            onPressed: () {
              speechProvider.openCamera();
            },
            shape: const CircleBorder(),
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.04),
            color: AppTheme.primaryColor,
            child: Icon(
              Icons.camera_alt,
              size: AppTheme.isLandscape(context) ? 25.0 : 50.0,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Text(
            speechProvider.speechText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.headlineMedium?.fontSize,
            ),
          ),
          if (speechProvider.speechText.isNotEmpty) SiriWaveform.ios9(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          )
        ],
      ),
    );
  }
}
