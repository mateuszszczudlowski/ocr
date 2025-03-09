import 'package:hive_flutter/hive_flutter.dart';
import '../models/allergen.dart';

class AllergenRepository {
  final Box<Allergen> _allergensBox;

  AllergenRepository(this._allergensBox);

  List<Allergen> getAllAllergens() {
    return _allergensBox.values.toList()..sort((a, b) => a.name.compareTo(b.name));
  }

  Future<void> addAllergen(Allergen allergen) async {
    await _allergensBox.add(allergen);
  }

  Future<void> removeAllergen(Allergen allergen) async {
    final index = _allergensBox.values.toList().indexOf(allergen);
    if (index != -1) {
      await _allergensBox.deleteAt(index);
    }
  }

  Future<void> clear() async {
    await _allergensBox.clear();
  }
}
