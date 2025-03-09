import 'package:hive/hive.dart';

part 'allergen.g.dart';

@HiveType(typeId: 0)
class Allergen extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  Map<String, List<String>>? translations;

  @HiveField(2)
  DateTime createdAt;

  Allergen({
    required this.name,
    this.translations,
  }) : createdAt = DateTime.now();
}