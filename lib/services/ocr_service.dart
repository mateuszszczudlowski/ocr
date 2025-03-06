import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../models/allergen.dart';

class OCRService {
  final TextRecognizer _textRecognizer;

  OCRService() : _textRecognizer = TextRecognizer();

  Future<(String, List<String>)> processImage(
    File image,
    List<Allergen> allergens,
  ) async {
    final inputImage = InputImage.fromFile(image);
    final recognizedText = await _textRecognizer.processImage(inputImage);
    final scannedText = recognizedText.text;
    
    final matches = allergens
        .where((allergen) =>
            scannedText.toLowerCase().contains(allergen.name.toLowerCase()))
        .map((e) => e.name)
        .toList();

    return (scannedText, matches);
  }

  void dispose() {
    _textRecognizer.close();
  }
}