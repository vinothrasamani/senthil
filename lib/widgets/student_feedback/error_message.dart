import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/controller/student_feedback_controller.dart';

class ErrorMessage extends ConsumerWidget {
  const ErrorMessage(
      {super.key,
      required this.msg,
      required this.info,
      required this.isSmallScreen});
  final String msg;
  final Map<String, dynamic> info;
  final bool isSmallScreen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: Colors.redAccent,
                size: isSmallScreen ? 48 : 64,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Oops!',
              style: TextStyle(
                fontSize: isSmallScreen ? 20 : 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            Text(
              msg,
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                StudentFeedbackController.startFeedback(ref, info);
              },
              icon: Icon(Icons.refresh),
              label: Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
