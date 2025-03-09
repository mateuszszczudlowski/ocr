import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light) {
    _loadTheme();
  }

  static const _themeBox = 'theme_box';
  static const _themeKey = 'theme_key';

  void toggleTheme() {
    final newTheme = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    Hive.box(_themeBox).put(_themeKey, newTheme.index);
    emit(newTheme);
  }

  Future<void> _loadTheme() async {
    await Hive.openBox(_themeBox);
    final themeIndex = Hive.box(_themeBox).get(_themeKey, defaultValue: 1);
    emit(ThemeMode.values[themeIndex]);
  }
}