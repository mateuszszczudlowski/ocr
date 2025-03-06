import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocr/services/ocr_service.dart';
import 'package:ocr/widgets/language_selector.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/allergen.dart';
import '../theme/theme_cubit.dart';
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

    setState(() {
      _extractedText = text;
      _matchedWords = matches;
      _isProcessing = false;
    });

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => ResultDialog(
          matches: matches.map((m) => m.$1).toList(),
          text: text,
        ),
      );
    }
  }

  Future<void> _testOCR() async {
    setState(() {
      _isProcessing = true;
    });

    final testText = 'Example, this is a test image containing milk, peanut.';
    final allergens = _allergensBox.values.toList();
    final (text, matches) =
        (testText, _ocrService.findAllergens(testText, allergens));

    setState(() {
      _extractedText = text;
      _matchedWords = matches;
      _isProcessing = false;
    });

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => ResultDialog(
          matches: matches.map((m) => m.$1).toList(),
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
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: const LanguageSelector(),
          ),
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
                      label: Text(AppLocalizations.of(context)!.camera),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library),
                      label: Text(AppLocalizations.of(context)!.gallery),
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
                      label: Text(AppLocalizations.of(context)!.testDemo),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isProcessing)
              const CircularProgressIndicator()
            else if (_extractedText.isNotEmpty) ...[
              Text(
                AppLocalizations.of(context)!.extractedText,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(_extractedText),
              const SizedBox(height: 16),
              if (_matchedWords.isNotEmpty) ...[
                Text(
                  AppLocalizations.of(context)!.matchedWords,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                // In the build method, replace the Wrap widget with:
                Wrap(
                  spacing: 8,
                  children: _matchedWords
                      .map((match) => Chip(
                            label: Text('${match.$1} (${match.$2})'),
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
