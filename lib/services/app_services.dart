import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';

class AppServices {
  static Future<DataPart> addImagePart(String filePath) async {
    final bytes = await File(filePath).readAsBytes();
    String extension = filePath.split('.').last;
    return DataPart('image/$extension', bytes);
  }
}
