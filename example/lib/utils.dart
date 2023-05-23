import 'package:flutter/material.dart';

/// Utils
class Utils {
  // spacers
  static const spacerSmall = SizedBox(height: 5);
  static const spacerLarge = SizedBox(height: 23);

  // styles
  static const headingStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  // Dialog
  static void showTextDialog(BuildContext context, String title, String content) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('OK'))
            ],
          );
        });
  }
}
