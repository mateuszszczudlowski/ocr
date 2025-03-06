import 'package:flutter/material.dart';

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
    return AlertDialog(
      icon: Icon(
        matches.isNotEmpty ? Icons.error : Icons.check_circle,
        color: matches.isNotEmpty ? Colors.red : Colors.green,
        size: 48,
      ),
      title: Text(
        matches.isNotEmpty ? 'Allergens Found!' : 'No Allergens',
        style: TextStyle(
          color: matches.isNotEmpty ? Colors.red : Colors.green,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (matches.isNotEmpty) ...[
            Text('Found these allergens: ${matches.join(", ")}'),
            const SizedBox(height: 16),
          ],
          const Text('Scanned Text:'),
          const SizedBox(height: 8),
          Text(text),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}