import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ocr/src/models/allergen.dart';

Future<void> setupHive() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  _registerAdapters();
}

void _registerAdapters() {
  Hive.registerAdapter(AllergenAdapter());
}

abstract class IHiveRepository<E> {
  Box<E>? _box;

  String get boxKey;

  Future<Box<E>> get box async {
    _box ??= await Hive.openBox<E>(boxKey);
    return _box!;
  }
}
