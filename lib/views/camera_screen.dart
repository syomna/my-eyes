import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:my_eyes/utils/constants.dart';
import 'package:my_eyes/utils/widgets/loader.dart';
import 'package:my_eyes/view_models/gemini_provider.dart';
import 'package:my_eyes/view_models/speech_provider.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    Future.delayed(const Duration(milliseconds: 300), () {
      context
          .read<SpeechProvider>()
          .speak(Constants.captureSurroundingsInstructions);
    });
    FirebaseAnalytics.instance.logEvent(
      name: 'camera_screen_init',
      parameters: null,
    );
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        log('No cameras available');
        return;
      }
      final camera = cameras.first;
      _controller = CameraController(
        camera,
        ResolutionPreset.high,
      );
      _initializeControllerFuture = _controller.initialize();
      setState(() {});
    } catch (e) {
      log('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GestureDetector(
              onTap: _onTap,
              child: CameraPreview(_controller),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: Loader());
          }
        },
      ),
    );
  }

  Future<void> _onTap() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();

      if (!mounted) return;

      context.read<GeminiProvider>().getCapturedImage(image.path);
    } catch (e) {
      log('Error taking picture: $e');
    }
  }
}
