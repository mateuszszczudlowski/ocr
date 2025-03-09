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
import 'package:ocr/screens/scanner_screen.dart';

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
        automaticallyImplyLeading: false,
        title: Text(
          AppLocalizations.of(context)!.appTitle,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            fontFamily: 'Oswald',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              size: 28,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // if (_image != null) Image.file(_image!, height: 200),
            // const SizedBox(height: 10),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Expanded(
            //       child: Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //         child: ElevatedButton.icon(
            //           onPressed: () => _pickImage(ImageSource.gallery),
            //           icon: const Icon(Icons.photo_library,
            //               size: 24, color: Colors.black),
            //           label: Text(
            //             AppLocalizations.of(context)!.gallery,
            //             style: const TextStyle(fontSize: 18),
            //           ),
            //           style: Theme.of(context).elevatedButtonTheme.style,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 14),
            // Row(
            //   children: [
            //     Expanded(
            //       child: Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //         child: ElevatedButton.icon(
            //           onPressed: () => _pickImage(ImageSource.camera),
            //           icon: const Icon(Icons.camera_alt,
            //               size: 24, color: Colors.black),
            //           label: Text(
            //             AppLocalizations.of(context)!.camera,
            //             style: const TextStyle(fontSize: 18),
            //           ),
            //           style: Theme.of(context).elevatedButtonTheme.style,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 14),
            // Row(
            //   children: [
            //     Expanded(
            //       child: Padding(
            //         padding: const EdgeInsets.symmetric(
            //           horizontal: 8.0,
            //         ),
            //         child: ElevatedButton.icon(
            //           onPressed: _testOCR,
            //           label: Text(
            //             AppLocalizations.of(context)!.testDemo,
            //             style: const TextStyle(fontSize: 18),
            //           ),
            //           style: Theme.of(context).elevatedButtonTheme.style,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 16),
            if (_extractedText.isEmpty && !_isProcessing) ...[
              const SizedBox(height: 160),
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.list_sharp, size: 160),
                    Text(
                      'Get Started',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontFamily: 'Oswald',
                          ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '1. Add your allergens in the list',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '2. Take a photo of product ingredients',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Icon(
                      Icons.arrow_downward,
                      size: 32,
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            if (_isProcessing)
              Center(child: const CircularProgressIndicator())
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
                              match.$2.isEmpty
                                  ? match.$1
                                  : '${match.$1} (${match.$2})',
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          height: 72,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined, size: 28),
              selectedIcon: const Icon(Icons.home, size: 28),
              label: AppLocalizations.of(context)!.home,
            ),
            NavigationDestination(
              icon: const Icon(Icons.camera_alt_outlined, size: 28),
              selectedIcon: const Icon(Icons.camera_alt, size: 28),
              label: AppLocalizations.of(context)!.camera,
            ),
            NavigationDestination(
              icon: const Icon(Icons.add_box_outlined, size: 28),
              selectedIcon: const Icon(Icons.add_box, size: 28),
              label: AppLocalizations.of(context)!.add,
            ),
          ],
          selectedIndex: 0,
          onDestinationSelected: (index) {
            switch (index) {
              case 0:
                // Already on home screen
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScannerScreen(),
                  ),
                ).then((image) {
                  if (image != null) {
                    setState(() {
                      _image = File(image.path);
                      _extractedText = '';
                      _matchedWords = [];
                      _isProcessing = true;
                    });
                    _extractText();
                  }
                });
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllergenFormScreen()),
                );
                break;
            }
          },
          indicatorColor: Colors.black26,
          surfaceTintColor: Colors.transparent,
        ),
      ),
    );
  }
}
