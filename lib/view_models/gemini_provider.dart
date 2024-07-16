import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:my_eyes/services/app_services.dart';

class GeminiProvider with ChangeNotifier {
  String? imagePath;
  bool analyzing = false;
  String? analyzingResult;

  final String? geminiAPIKey = dotenv.env['GEMINI_API_KEY'];
  GenerativeModel? model;

  void getCapturedImage(String imagePath) {
    this.imagePath = imagePath;
    notifyListeners();
  }

  Future<void> startAnalyzing() async {
    if (imagePath == null || geminiAPIKey == null) {
      return; // No image or API key available to analyze
    }

    analyzing = true;
    notifyListeners();

    // Initialize the model if not already done
    model ??= GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: geminiAPIKey!,
    );

    try {
      final imagePart = await AppServices.addImagePart(imagePath!);
      final res = await model?.generateContent([
        Content('user', [imagePart])
      ]);
      analyzingResult = res?.text;
    } catch (e) {
      analyzingResult = 'Error analyzing image: $e';
    } finally {
      analyzing = false;
      notifyListeners();
    }
  }

  void reset() {
    analyzing = false;
    analyzingResult = null;
    imagePath = null;
    notifyListeners();
  }
}
