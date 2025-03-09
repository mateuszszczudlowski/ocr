import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocr/src/blocs/allergen/allergen_bloc.dart';
import 'package:ocr/src/models/allergen.dart';
import 'package:ocr/src/models/allergen_data.dart';
import 'package:ocr/src/widgets/allergen_dropdown.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@RoutePage()
class AllergenFormView extends StatefulWidget {
  const AllergenFormView({super.key});

  @override
  State<AllergenFormView> createState() => _AllergenFormViewState();
}

class _AllergenFormViewState extends State<AllergenFormView> {
  @override
  void initState() {
    super.initState();
    context.read<AllergenBloc>().add(LoadAllergens());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          l10n.manageAllergens,
          style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
        ),
      ),
      body: BlocBuilder<AllergenBloc, AllergenState>(builder: (context, state) {
        if (state is AllergenLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AllergenError) {
          return Center(child: Text(state.message));
        }

        final allergens =
            state is AllergenLoaded ? state.allergens : <Allergen>[];

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              AllergenDropdown(
                currentLocale: currentLocale,
                selectedAllergenIds: allergens.map((a) => a.name).toList(),
                onSelected: (AllergenData allergen) {
                  final translations = allergen.translations;
                  final name = translations[currentLocale]?.first ??
                      translations['en']?.first ??
                      allergen.id;

                  final exists = allergens.any((existing) {
                    return existing.name == name ||
                        (existing.translations?[currentLocale]
                                ?.contains(name) ??
                            false) ||
                        (existing.translations?['en']?.contains(name) ?? false);
                  });

                  if (!exists) {
                    context.read<AllergenBloc>().add(
                          AddAllergen(
                            name: name,
                            translations:
                                Map<String, List<String>>.from(translations),
                          ),
                        );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          l10n.allergenAlreadyExists,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: allergens.isEmpty
                    ? Center(
                        child: Text(
                          l10n.noAllergensYet,
                          style: const TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: allergens.length,
                        itemBuilder: (context, index) {
                          final allergen = allergens[index];
                          final displayName =
                              allergen.translations?[currentLocale]?.first ??
                                  allergen.name;
                          final englishName =
                              allergen.translations?['en']?.first;
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
                              subtitle: englishName != null &&
                                      englishName != displayName
                                  ? Text(
                                      englishName,
                                      style: const TextStyle(fontSize: 16),
                                    )
                                  : null,
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, size: 28),
                                tooltip: l10n.deleteAllergen,
                                onPressed: () {
                                  context
                                      .read<AllergenBloc>()
                                      .add(DeleteAllergen(allergen));
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
