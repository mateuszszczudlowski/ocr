import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../models/allergen.dart';

class OCRService {
  final TextRecognizer _textRecognizer;

  OCRService() : _textRecognizer = TextRecognizer();

  Future<(String, List<(String allergenName, String matchedTerm)>)>
      processImage(
    File image,
    List<Allergen> allergens,
  ) async {
    final inputImage = InputImage.fromFile(image);
    final recognizedText = await _textRecognizer.processImage(inputImage);
    final scannedText = recognizedText.text.toLowerCase();

    return (recognizedText.text, findAllergens(scannedText, allergens));
  }

  List<(String allergenName, String matchedTerm)> findAllergens(
    String text,
    List<Allergen> allergens,
  ) {
    final scannedText = text.toLowerCase();
    final matches = <(String, String)>[];

    for (var allergen in allergens) {
      // Check all possible translations for each allergen
      if (allergen.translations != null) {
        allergen.translations!.forEach((language, terms) {
          for (var term in terms) {
            if (scannedText.contains(term.toLowerCase())) {
              // When found, add both the primary allergen name and the matched term
              matches.add((allergen.name, term));
            }
          }
        });
      }

      // Also check the main name
      if (scannedText.contains(allergen.name.toLowerCase())) {
        matches.add((allergen.name, allergen.name));
      }
    }

    return matches;
  }

  void dispose() {
    _textRecognizer.close();
  }
}
