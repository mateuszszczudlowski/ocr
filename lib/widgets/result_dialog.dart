import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResultDialog extends StatelessWidget {
  final List<String> matches;
  final String text;

  const ResultDialog({
    super.key,
    required this.matches,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return AlertDialog(
      icon: Icon(
        matches.isNotEmpty ? Icons.error : Icons.check_circle,
        color: matches.isNotEmpty ? Colors.red : Colors.green,
        size: 64,  // Increased from 48
      ),
      title: Text(
        matches.isNotEmpty ? l10n.allergensFound : l10n.noAllergens,
        style: TextStyle(
          color: matches.isNotEmpty ? Colors.red : Colors.green,
          fontSize: 24,  // Added font size
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (matches.isNotEmpty) ...[
            Text(
              l10n.foundAllergens(matches.join(", ")),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            l10n.scannedText,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            l10n.ok,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
