class AllergenData {
  final String id;
  final Map<String, List<String>> translations;

  AllergenData({
    required this.id,
    required this.translations,
  });

  factory AllergenData.fromJson(Map<String, dynamic> json) {
    return AllergenData(
      id: json['id'],
      translations: Map<String, List<String>>.from(
        json['translations'].map((key, value) => 
          MapEntry(key, List<String>.from(value))
        ),
      ),
    );
  }
}