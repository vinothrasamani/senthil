import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:senthil/widgets/error_dialog.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, required this.details});

  final FlutterErrorDetails details;

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
              Color(0xFFF093fb),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen = constraints.maxWidth < 600;
              final padding = isSmallScreen ? 24.0 : 48.0;
              final iconSize = isSmallScreen ? 80.0 : 120.0;
              final titleSize = isSmallScreen ? 28.0 : 36.0;
              final subtitleSize = isSmallScreen ? 16.0 : 20.0;

              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: constraints.maxHeight * 0.1),
                      TweenAnimationBuilder(
                        duration: Duration(milliseconds: 800),
                        tween: Tween<double>(begin: 0, end: 1),
                        builder: (context, double value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Container(
                              padding: EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(100),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(40),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Icon(Icons.error_outline_rounded,
                                  size: iconSize, color: Colors.white),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 32),
                      Text(
                        "Oops!",
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Something went wrong",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: subtitleSize,
                          color: Colors.white.withAlpha(225),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 12),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 0 : 40),
                        child: Text(
                          "The screen has crashed. Don't worry, your data is safe. Please try again after some time.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14.0 : 16.0,
                            color: Colors.white.withAlpha(200),
                            height: 1.5,
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        children: [
                          Builder(builder: (context) {
                            bool canPop = Navigator.canPop(context);
                            return ElevatedButton.icon(
                              onPressed: () {
                                if (canPop) {
                                  Navigator.pop(context);
                                } else {
                                  SystemNavigator.pop();
                                }
                              },
                              icon: Icon(
                                  canPop ? Icons.arrow_back : Icons.close,
                                  color: canPop ? Colors.black87 : Colors.red),
                              label: Text(canPop ? "Go Back" : "Close"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Color(0xFF667eea),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 8,
                                shadowColor: Colors.black.withAlpha(100),
                              ),
                            );
                          }),
                          OutlinedButton.icon(
                            onPressed: () => openDialog(context, details),
                            icon: Icon(
                              Icons.bug_report_outlined,
                              color: const Color.fromARGB(255, 255, 113, 103),
                              shadows: [
                                Shadow(
                                  offset: Offset(0.5, 1),
                                  blurRadius: 2,
                                  color: Colors.black,
                                )
                              ],
                            ),
                            label: Text("Report"),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(color: Colors.white, width: 2),
                              padding: EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: constraints.maxHeight * 0.1),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void openDialog(BuildContext context, FlutterErrorDetails details) async {
    await showDialog(
      context: context,
      builder: (ctx) => ErrorDialog(details: details),
    );
  }
}
