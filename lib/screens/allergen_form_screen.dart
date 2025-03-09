import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ocr/models/allergen_data.dart';
import 'package:ocr/screens/ocr_screen.dart';
import 'package:ocr/screens/scanner_screen.dart';
import 'package:ocr/widgets/allergen_dropdown.dart';
import '../models/allergen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AllergenFormScreen extends StatefulWidget {
  const AllergenFormScreen({super.key});

  @override
  State<AllergenFormScreen> createState() => _AllergenFormScreenState();
}

class _AllergenFormScreenState extends State<AllergenFormScreen> {
  late Box<Allergen> _allergensBox;

  @override
  void initState() {
    super.initState();
    _allergensBox = Hive.box<Allergen>('allergens');
  }

  void _removeAllergen(int index) {
    _allergensBox.deleteAt(index);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n.manageAllergens),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // In AllergenFormScreen, add this where you use AllergenDropdown:
            AllergenDropdown(
              currentLocale: Localizations.localeOf(context).languageCode,
              selectedAllergenIds: _allergensBox.values
                  .map((allergen) => allergen.name)
                  .toList(),
              onSelected: (AllergenData allergen) {
                final translations = allergen.translations;
                final name = translations[currentLocale]?.first ??
                    translations['en']?.first ??
                    allergen.id;

                // Check if allergen already exists
                final exists = _allergensBox.values.any((existing) {
                  return existing.name == name ||
                      (existing.translations?[currentLocale]?.contains(name) ??
                          false) ||
                      (existing.translations?['en']?.contains(name) ?? false);
                });

                if (!exists) {
                  final newAllergen = Allergen(
                    name: name,
                    translations: Map<String, List<String>>.from(translations),
                  );
                  _allergensBox.add(newAllergen);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          style: TextStyle(fontSize: 16),
                          AppLocalizations.of(context)!.allergenAlreadyExists),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _allergensBox.listenable(),
                builder: (context, Box<Allergen> box, _) {
                  if (box.isEmpty) {
                    return Center(
                      child: Text(
                        l10n.noAllergensYet,
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final allergen = box.getAt(index)!;
                      final displayName =
                          allergen.translations?[currentLocale]?.first ??
                              allergen.name;
                      final englishName = allergen.translations?['en']?.first;
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 4,
                          ),
                          title: Text(
                            displayName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle:
                              englishName != null && englishName != displayName
                                  ? Text(
                                      englishName,
                                      style: const TextStyle(fontSize: 16),
                                    )
                                  : null,
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, size: 28),
                            tooltip: l10n.deleteAllergen,
                            onPressed: () => _removeAllergen(index),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(
              0xFF1C1B1F), // Add this line for the dark background color
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
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
          selectedIndex: 2,
          onDestinationSelected: (index) {
            switch (index) {
              case 0:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const OCRScreen()),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScannerScreen(),
                  ),
                );
                break;
              case 2:
                // Already on allergen form screen
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
