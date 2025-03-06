import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../models/allergen_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AllergenDropdown extends StatefulWidget {
  final Function(AllergenData) onSelected;
  final String currentLocale;
  final List<String> selectedAllergenIds;

  const AllergenDropdown({
    super.key,
    required this.onSelected,
    required this.currentLocale,
    required this.selectedAllergenIds,
  });

  @override
  State<AllergenDropdown> createState() => _AllergenDropdownState();
}

class _AllergenDropdownState extends State<AllergenDropdown> {
  List<AllergenData> _allergens = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAllergens();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAllergens() async {
    final String data =
        await rootBundle.loadString('assets/data/allergens.json');
    final json = jsonDecode(data);
    setState(() {
      _allergens = (json['allergens'] as List)
          .map((item) => AllergenData.fromJson(item))
          .toList()
          .where(
              (allergen) => !widget.selectedAllergenIds.contains(allergen.id))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<AllergenData>(
          isExpanded: true,
          hint: Text(
            AppLocalizations.of(context)!.selectAllergens,
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).hintColor,
            ),
          ),
          items: _allergens
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: StatefulBuilder(
                      builder: (context, menuSetState) {
                        final translations = item.translations[widget.currentLocale] ?? [];
                        final englishTranslations = item.translations['en'] ?? [];
                        final displayName = translations.isNotEmpty ? translations.first : item.id;
                        final englishName = englishTranslations.isNotEmpty ? englishTranslations.first : item.id;

                        return Container(
                          height: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      displayName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if (widget.currentLocale != 'en' && englishName != displayName)
                                      Text(
                                        englishName,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ))
              .toList(),
          value: null,
          onChanged: (value) {
            if (value != null) {
              widget.onSelected(value);
            }
          },
          buttonStyleData: ButtonStyleData(
            height: 75, // Increased by 1.5x
            padding:
                const EdgeInsets.symmetric(horizontal: 21), // Increased by 1.5x
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6), // Increased by 1.5x
              border: Border.all(color: Colors.black26),
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 450, // Increased by 1.5x
            width: MediaQuery.of(context).size.width -
                32, // Full width minus padding
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6), // Increased by 1.5x
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 60, // Increased by 1.5x
          ),
          dropdownSearchData: DropdownSearchData(
            searchController: _searchController,
            searchInnerWidgetHeight: 75, // Increased by 1.5x
            searchInnerWidget: Container(
              height: 75, // Increased by 1.5x
              padding: const EdgeInsets.only(
                top: 12, // Increased by 1.5x
                bottom: 6, // Increased by 1.5x
                right: 12, // Increased by 1.5x
                left: 12, // Increased by 1.5x
              ),
              child: TextFormField(
                expands: true,
                maxLines: null,
                controller: _searchController,
                style: const TextStyle(fontSize: 18), // Increased by 1.5x
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15, // Increased by 1.5x
                    vertical: 12, // Increased by 1.5x
                  ),
                  hintText: AppLocalizations.of(context)!.findAllergens,
                  hintStyle: const TextStyle(fontSize: 18), // Increased by 1.5x
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12), // Increased by 1.5x
                  ),
                ),
              ),
            ),
            searchMatchFn: (item, searchValue) {
              final allergen = item.value as AllergenData;
              final translations =
                  allergen.translations[widget.currentLocale] ?? [];
              return translations.any((term) =>
                  term.toLowerCase().contains(searchValue.toLowerCase()));
            },
          ),
        ),
      ),
    );
  }
}
