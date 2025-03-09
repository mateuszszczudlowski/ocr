import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ocr/src/models/allergen.dart';
import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(AllergenAdapter());
  final allergensBox = await Hive.openBox<Allergen>('allergens');

  runApp(MyApp(allergensBox: allergensBox));
}
