import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ocr/blocs/allergen/allergen_bloc.dart';
import 'package:ocr/repositories/allergen_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ocr/theme/app_theme.dart';
import 'package:ocr/theme/language_cubit.dart';
import 'models/allergen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme/theme_cubit.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(AllergenAdapter());

  // Open settings box
  final settingsBox = await Hive.openBox('settings');
  final allergenRepository = await AllergenRepository.initialize();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => ThemeCubit()),
      BlocProvider(create: (_) => LanguageCubit(settingsBox)),
      BlocProvider(
          create: (_) =>
              AllergenBloc(allergenRepository)..add(LoadAllergens())),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return BlocBuilder<LanguageCubit, Locale>(
          builder: (context, locale) {
            return MaterialApp(
              title: 'Allergen Scanner',
              locale: locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              // In MaterialApp widget, update home:
              home: const LoginScreen(),
              builder: (context, child) {
                return Builder(
                  builder: (context) {
                    return child!;
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
