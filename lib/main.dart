import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ocr/blocs/allergen/allergen_bloc.dart';
import 'package:ocr/repositories/allergen_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/allergen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme/theme_cubit.dart';
import 'screens/ocr_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(AllergenAdapter());

  // Initialize repositories
  final allergenRepository = await AllergenRepository.initialize();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => ThemeCubit()),
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
        return MaterialApp(
          title: 'Allergen Scanner',
          themeMode: themeMode,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
          ),
          home: const OCRScreen(),
        );
      },
    );
  }
}
