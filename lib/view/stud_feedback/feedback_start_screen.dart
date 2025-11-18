import 'dart:math';

import 'package:flutter/material.dart';
import 'package:senthil/controller/app_controller.dart';

class FeedbackStartScreen extends StatefulWidget {
  const FeedbackStartScreen({super.key, required this.info});
  final Map<String, dynamic> info;

  @override
  State<FeedbackStartScreen> createState() => _FeedbackStartScreenState();
}

class _FeedbackStartScreenState extends State<FeedbackStartScreen> {
  String url = '${AppController.baseGifUrl}/back1.gif';

  @override
  void initState() {
    super.initState();
    final item = Random().nextInt(4);
    url = '${AppController.baseGifUrl}/back${item + 1}.gif';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.black,
            width: double.infinity,
            height: double.infinity,
            child: Image.network(
              url,
              gaplessPlayback: true,
              fit: BoxFit.cover,
              alignment: Alignment.centerLeft,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/back.png', fit: BoxFit.cover);
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: widget.info.entries
                        .map((item) => item.value == null
                            ? SizedBox.shrink()
                            : myChip(item.value))
                        .toList(),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black45,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.feedback_outlined,
                              size: 80,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Welcome to Feedback',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withAlpha(120),
                                    offset: Offset(2, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Share your thoughts and opinions of subjects',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white.withAlpha(230),
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withAlpha(120),
                                    offset: Offset(1, 1),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 48),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 48,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 8,
                              ),
                              child: const Text(
                                'Get Started',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget myChip(String val) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.black45,
        border: Border.all(color: Colors.black87),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        val,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
