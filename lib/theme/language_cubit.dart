import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LanguageCubit extends Cubit<Locale> {
  final Box settingsBox;
  static const String languageKey = 'app_language';

  LanguageCubit(this.settingsBox) : super(Locale(settingsBox.get(languageKey, defaultValue: 'en')));

  void changeLanguage(String languageCode) {
    settingsBox.put(languageKey, languageCode);
    emit(Locale(languageCode));
  }
}