import 'package:hive/hive.dart';

part 'allergen.g.dart';

@HiveType(typeId: 0)
class Allergen extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String? description;

  @HiveField(2)
  DateTime createdAt;

  Allergen({
    required this.name,
    this.description,
  }) : createdAt = DateTime.now();

  @override
  String toString() => name;
}