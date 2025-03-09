import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';
import 'package:ocr/src/blocs/allergen/allergen_bloc.dart';
import 'package:ocr/src/config/routes.dart';
import 'package:ocr/src/config/theme/app_theme.dart';
import 'package:ocr/src/config/theme/language_cubit.dart';
import 'package:ocr/src/config/theme/theme_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocr/src/models/allergen.dart';
import 'package:ocr/src/repositories/allergen_repository.dart';

class MyApp extends StatelessWidget {
  final Box<Allergen> allergensBox;
  MyApp({super.key, required this.allergensBox});

  final _router = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AllergenRepository(allergensBox),
        ),
        // Add AllergenBloc provider
        BlocProvider(
          create: (context) => AllergenBloc(
            context.read<AllergenRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => LanguageCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<LanguageCubit, Locale>(
            builder: (context, locale) {
              return MaterialApp.router(
                routerConfig: _router.config(),
                title: 'Allergen Scanner',
                locale: locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                debugShowCheckedModeBanner: false,
              );
            },
          );
        },
      ),
    );
  }
}
