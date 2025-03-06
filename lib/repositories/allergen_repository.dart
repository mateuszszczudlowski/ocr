import 'package:hive_flutter/hive_flutter.dart';
import '../models/allergen.dart';

class AllergenRepository {
  static const String _boxName = 'allergens';
  final Box<Allergen> _box;

  AllergenRepository(this._box);

  static Future<AllergenRepository> initialize() async {
    final box = await Hive.openBox<Allergen>(_boxName);
    return AllergenRepository(box);
  }

  List<Allergen> getAllAllergens() {
    return _box.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  Future<void> addAllergen(Allergen allergen) async {
    await _box.add(allergen);
  }

  Future<void> removeAllergen(Allergen allergen) async {
    await allergen.delete();
  }

  Future<void> clear() async {
    await _box.clear();
  }
}