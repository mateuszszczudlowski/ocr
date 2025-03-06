import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/allergen.dart';
import '../theme/theme_cubit.dart';
import '../widgets/result_dialog.dart';
import 'allergen_form_screen.dart';

class OCRScreen extends StatefulWidget {
  const OCRScreen({super.key});

  @override
  State<OCRScreen> createState() => _OCRScreenState();
}

class _OCRScreenState extends State<OCRScreen> {
  final ImagePicker _picker = ImagePicker();
  final textRecognizer = TextRecognizer();
  File? _image;
  String _extractedText = '';
  bool _isProcessing = false;
  List<String> _matchedWords = [];
  late Box<Allergen> _allergensBox;

  @override
  void initState() {
    super.initState();
    _allergensBox = Hive.box<Allergen>('allergens');
  }

  List<String> get wordList {
    return _allergensBox.values
        .map((allergen) => allergen.name.toLowerCase())
        .toList();
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
              const SnackBar(content: Text('Camera permission is required')),
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
            content: Text(
              source == ImageSource.camera
                  ? 'Camera is not available. Please use a physical device.'
                  : 'Error picking image: $e',
            ),
          ),
        );
      }
    }
  }

  Future<void> _extractText() async {
    if (_image == null) return;

    final inputImage = InputImage.fromFile(_image!);
    final recognizedText = await textRecognizer.processImage(inputImage);
    final scannedText = recognizedText.text.toLowerCase();

    final matches =
        wordList
            .where((word) => scannedText.contains(word.toLowerCase()))
            .toList();

    setState(() {
      _extractedText = recognizedText.text;
      _matchedWords = matches;
      _isProcessing = false;
    });

    if (mounted) {
      showDialog(
        context: context,
        builder:
            (context) =>
                ResultDialog(matches: matches, text: recognizedText.text),
      );
    }
  }

  Future<void> _testOCR() async {
    setState(() {
      _extractedText = '';
      _matchedWords = [];
      _isProcessing = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    final testText = 'Example, this is a test image containing milk.';
    final matches =
        wordList
            .where(
              (word) => testText.toLowerCase().contains(word.toLowerCase()),
            )
            .toList();

    setState(() {
      _extractedText = testText;
      _matchedWords = matches;
      _isProcessing = false;
    });

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => ResultDialog(matches: matches, text: testText),
      );
    }
  }

  @override
  void dispose() {
    textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OCR App'),
        actions: [
          IconButton(
            icon: BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, themeMode) {
                return Icon(
                  size: 32,
                  themeMode == ThemeMode.light
                      ? Icons.dark_mode
                      : Icons.light_mode,
                );
              },
            ),
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(size: 42, Icons.edit_note),
            onPressed: _navigateToAllergenForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_image != null) Image.file(_image!, height: 200),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Camera'),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Gallery'),
                    ),
                  ),
                ),
              ],
            ),
            // Replace the test button's onPressed
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton.icon(
                      onPressed: _testOCR,
                      icon: const Icon(Icons.bug_report),
                      label: const Text('Test Demo'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isProcessing)
              const CircularProgressIndicator()
            else if (_extractedText.isNotEmpty) ...[
              const Text(
                'Extracted Text:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(_extractedText),
              const SizedBox(height: 16),
              if (_matchedWords.isNotEmpty) ...[
                const Text(
                  'Matched Words:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children:
                      _matchedWords
                          .map((word) => Chip(label: Text(word)))
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
