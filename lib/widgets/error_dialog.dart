import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/theme_controller.dart';

class ErrorDialog extends ConsumerStatefulWidget {
  const ErrorDialog({super.key, required this.details});
  final FlutterErrorDetails details;

  @override
  ConsumerState<ErrorDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends ConsumerState<ErrorDialog> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;
    return AlertDialog(
      title: AppController.heading('Report', isDark, Icons.report),
      content: Container(
        constraints: BoxConstraints(maxWidth: 280),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                'Something went wrong! Would you like to submit a crash report to help us fix the issue?'),
            SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: isDark ? Colors.white12 : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey.withAlpha(100))),
              child: Text(
                widget.details.toString(),
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontFamily: "monospace",
                  fontSize: 6,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: isLoading ? null : () => submitReport(context),
                child: Text(
                  isLoading ? "Submitting.." : "Submit Report",
                  overflow: TextOverflow.fade,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void submitReport(BuildContext context) async {
    try {
      setState(() => isLoading = true);
      final res = await AppController.send(
          'err-report', {'err': widget.details.toString()});
      final result = jsonDecode(res);
      if (result['success']) {
        if (context.mounted) Navigator.pop(context);
        AppController.toastMessage(
            'Thank You!', 'Your report has been submitted successfully.');
        return;
      }
      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
      AppController.toastMessage(
        'Failed!',
        'Something went wrong while submitting report.',
        purpose: Purpose.fail,
      );
    }
  }
}
