import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:senthil/view/stud_feedback/feedback_home_screen.dart';

class ThankYouScreen extends StatefulWidget {
  const ThankYouScreen({super.key});

  @override
  State<ThankYouScreen> createState() => _ThankYouScreenState();
}

class _ThankYouScreenState extends State<ThankYouScreen>
    with TickerProviderStateMixin {
  late AnimationController _checkController;
  late Animation<double> _fillAnimation;
  late Animation<double> _checkAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    popup();
    _checkController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _checkController,
        curve: Interval(0.0, 0.4, curve: Curves.elasticOut),
      ),
    );
    _fillAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _checkController,
        curve: Interval(0.2, 0.6, curve: Curves.easeInOut),
      ),
    );
    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _checkController,
        curve: Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );
    _checkController.forward();
    getback();
  }

  void getback() async {
    await Future.delayed(Duration(seconds: 35));
    Get.offAll(() => FeedbackHomeScreen(), transition: Transition.fadeIn);
  }

  void popup() {
    double randomInRange(double min, double max) {
      return min + Random().nextDouble() * (max - min);
    }

    int total = 60;
    int progress = 0;

    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      progress++;
      if (progress >= total) {
        timer.cancel();
        return;
      }
      int count = ((1 - progress / total) * 30).toInt();
      if (mounted) {
        Confetti.launch(
          context,
          options: ConfettiOptions(
              particleCount: count,
              startVelocity: 30,
              spread: 360,
              ticks: 60,
              x: randomInRange(0.1, 0.3),
              y: Random().nextDouble() - 0.2),
        );
        Confetti.launch(
          context,
          options: ConfettiOptions(
              particleCount: count,
              startVelocity: 30,
              spread: 360,
              ticks: 60,
              x: randomInRange(0.7, 0.9),
              y: Random().nextDouble() - 0.2),
        );
      }
    });
  }

  @override
  void dispose() {
    _checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFFF093FB),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -100,
              right: -100,
              child: FadeInDown(
                duration: Duration(milliseconds: 1000),
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withAlpha(45),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -150,
              left: -100,
              child: FadeInUp(
                duration: Duration(milliseconds: 1000),
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withAlpha(45),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _checkController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _scaleAnimation.value,
                              child: Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(70),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                      offset: Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: CustomPaint(
                                    size: Size(140, 140),
                                    painter: FilledCheckPainter(
                                      fillProgress: _fillAnimation.value,
                                      checkProgress: _checkAnimation.value,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 40),
                        FadeInUp(
                          delay: Duration(milliseconds: 300),
                          child: Text(
                            'Thank You!',
                            style: GoogleFonts.poppins(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withAlpha(100),
                                  offset: Offset(0, 4),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        FadeInUp(
                          delay: Duration(milliseconds: 500),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              'Your feedback has been submitted successfully!',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.openSans(
                                fontSize: 18,
                                color: Colors.white.withAlpha(230),
                                height: 1.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        FadeInUp(
                          delay: Duration(milliseconds: 700),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 40),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(70),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withAlpha(100),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 24,
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    'We appreciate your time and effort!',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.openSans(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilledCheckPainter extends CustomPainter {
  final double fillProgress;
  final double checkProgress;

  FilledCheckPainter({
    required this.fillProgress,
    required this.checkProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    if (fillProgress > 0) {
      final fillPaint = Paint()
        ..color = Color(0xFF4CAF50)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius * fillProgress, fillPaint);
    }
    if (fillProgress > 0) {
      final borderPaint = Paint()
        ..color = Color(0xFF4CAF50)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0;
      canvas.drawCircle(center, radius, borderPaint);
    }
    if (checkProgress > 0) {
      final checkPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      final path = Path();
      final startPoint = Offset(size.width * 0.25, size.height * 0.5);
      final midPoint = Offset(size.width * 0.43, size.height * 0.68);
      final endPoint = Offset(size.width * 0.75, size.height * 0.32);

      if (checkProgress <= 0.5) {
        final progress = checkProgress * 2;
        path.moveTo(startPoint.dx, startPoint.dy);
        path.lineTo(
          startPoint.dx + (midPoint.dx - startPoint.dx) * progress,
          startPoint.dy + (midPoint.dy - startPoint.dy) * progress,
        );
      } else {
        final progress = (checkProgress - 0.5) * 2;
        path.moveTo(startPoint.dx, startPoint.dy);
        path.lineTo(midPoint.dx, midPoint.dy);
        path.lineTo(
          midPoint.dx + (endPoint.dx - midPoint.dx) * progress,
          midPoint.dy + (endPoint.dy - midPoint.dy) * progress,
        );
      }
      canvas.drawPath(path, checkPaint);
    }
  }

  @override
  bool shouldRepaint(FilledCheckPainter oldDelegate) {
    return oldDelegate.fillProgress != fillProgress ||
        oldDelegate.checkProgress != checkProgress;
  }
}
