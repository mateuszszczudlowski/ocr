import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../config/theme/language_cubit.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, Locale>(
      builder: (context, currentLocale) {
        return DropdownButton<String>(
          value: currentLocale.languageCode,
          items: const [
            DropdownMenuItem(
              value: 'en',
              child: Text('English'),
            ),
            DropdownMenuItem(
              value: 'pl',
              child: Text('Polski'),
            ),
          ],
          onChanged: (String? languageCode) {
            if (languageCode != null) {
              context.read<LanguageCubit>().changeLanguage(languageCode);
            }
          },
        );
      },
    );
  }
}
