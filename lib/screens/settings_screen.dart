import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/theme_cubit.dart';
import '../widgets/language_selector.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 2,
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              leading: const Icon(Icons.language),
              title: Text(AppLocalizations.of(context)!.language),
              trailing: const LanguageSelector(),
            ),
          ),
          const SizedBox(height: 6),
          Card(
            elevation: 2,
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              leading: BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, themeMode) {
                  return Icon(
                    themeMode == ThemeMode.light
                        ? Icons.dark_mode
                        : Icons.light_mode,
                  );
                },
              ),
              title: Text(AppLocalizations.of(context)!.theme),
              trailing: BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, themeMode) {
                  return Switch(
                    value: themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      context.read<ThemeCubit>().toggleTheme();
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
