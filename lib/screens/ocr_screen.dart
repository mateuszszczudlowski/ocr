import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocr/screens/settings_screen.dart';
import 'package:ocr/services/ocr_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/allergen.dart';
import '../widgets/result_dialog.dart';
import 'allergen_form_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OCRScreen extends StatefulWidget {
  const OCRScreen({super.key});

  @override
  State<OCRScreen> createState() => _OCRScreenState();
}

class _OCRScreenState extends State<OCRScreen> {
  final ImagePicker _picker = ImagePicker();
  final _ocrService = OCRService();
  File? _image;
  String _extractedText = '';
  bool _isProcessing = false;
  List<(String, String)> _matchedWords = [];
  late Box<Allergen> _allergensBox;
  double _textSize = 16.0; // Add this line for text size control

  @override
  void initState() {
    super.initState();
    _allergensBox = Hive.box<Allergen>('allergens');
  }

  void _navigateToAllergenForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AllergenFormScreen()),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      if (source == ImageSource.camera) {
        final status = await Permission.camera.request();
        if (status.isDenied) {
          if (mounted) {
            scaffoldMessenger.showSnackBar(
              SnackBar(
                  content: Text(
                      AppLocalizations.of(context)!.cameraPermissionRequired)),
            );
          }
          return;
        }
      } else {
        await Permission.photos.request();
      }

      final XFile? image = await _picker.pickImage(source: source);

      if (image != null) {
        setState(() {
          _image = File(image.path);
          _extractedText = '';
          _matchedWords = [];
          _isProcessing = true;
        });

        await _extractText();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(source == ImageSource.camera
                ? AppLocalizations.of(context)!.cameraNotAvailable
                : AppLocalizations.of(context)!
                    .errorPickingImage(e.toString())),
          ),
        );
      }
    }
  }

  Future<void> _extractText() async {
    if (_image == null) return;

    final allergens = _allergensBox.values.toList();
    final (text, matches) = await _ocrService.processImage(_image!, allergens);

    // Process matches to remove duplicates
    final uniqueMatches = <String, Set<String>>{};
    for (var match in matches) {
      uniqueMatches.putIfAbsent(match.$1, () => <String>{});
      if (match.$2.isNotEmpty) {
        uniqueMatches[match.$1]!.add(match.$2);
      }
    }

    // Convert to list of tuples with combined translations
    final processedMatches = uniqueMatches.entries.map((entry) {
      final translations = entry.value.join(', ');
      return (entry.key, translations);
    }).toList();

    setState(() {
      _extractedText = text;
      _matchedWords = processedMatches;
      _isProcessing = false;
    });

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => ResultDialog(
          matches: uniqueMatches.keys.toList(),
          text: text,
        ),
      );
    }
  }

  // Update _testOCR method similarly
  Future<void> _testOCR() async {
    setState(() {
      _isProcessing = true;
    });

    final testText = 'Example, this is a test image containing mleko, peanut.';
    final allergens = _allergensBox.values.toList();
    final (text, matches) =
        (testText, _ocrService.findAllergens(testText, allergens));

    // Process matches to remove duplicates
    final uniqueMatches = <String, Set<String>>{};
    for (var match in matches) {
      uniqueMatches.putIfAbsent(match.$1, () => <String>{});
      if (match.$2.isNotEmpty) {
        uniqueMatches[match.$1]!.add(match.$2);
      }
    }

    // Convert to list of tuples with combined translations
    final processedMatches = uniqueMatches.entries.map((entry) {
      final translations = entry.value.join(', ');
      return (entry.key, translations);
    }).toList();

    setState(() {
      _extractedText = text;
      _matchedWords = processedMatches;
      _isProcessing = false;
    });

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => ResultDialog(
          matches: uniqueMatches.keys.toList(),
          text: text,
        ),
      );
    }
  }

  @override
  void dispose() {
    _ocrService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          AppLocalizations.of(context)!.appTitle,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              size: 28,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.edit_note,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: _navigateToAllergenForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
        child: Column(
          children: [
            if (_image != null) Image.file(_image!, height: 200),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library,
                          size: 24, color: Colors.black),
                      label: Text(
                        AppLocalizations.of(context)!.gallery,
                        style: const TextStyle(fontSize: 18),
                      ),
                      style: Theme.of(context).elevatedButtonTheme.style,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt,
                          size: 24, color: Colors.black),
                      label: Text(
                        AppLocalizations.of(context)!.camera,
                        style: const TextStyle(fontSize: 18),
                      ),
                      style: Theme.of(context).elevatedButtonTheme.style,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton.icon(
                      onPressed: _testOCR,
                      icon: const Icon(Icons.bug_report,
                          size: 24, color: Colors.black),
                      label: Text(
                        AppLocalizations.of(context)!.testDemo,
                        style: const TextStyle(fontSize: 18),
                      ),
                      style: Theme.of(context).elevatedButtonTheme.style,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isProcessing)
              const CircularProgressIndicator()
            else if (_extractedText.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.extractedText,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.text_fields, size: 24),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Slider(
                            value: _textSize,
                            min: 16.0,
                            max: 26.0,
                            divisions: 8,
                            label: _textSize.round().toString(),
                            onChanged: (value) {
                              setState(() {
                                _textSize = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  _extractedText,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: _textSize,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              if (_matchedWords.isNotEmpty) ...[
                Text(
                  AppLocalizations.of(context)!.matchedWords,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _matchedWords
                      .map((match) => Chip(
                            label: Text(
                              match.$2.isEmpty ? match.$1 : '${match.$1} (${match.$2})',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ))
                      .toList(),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
