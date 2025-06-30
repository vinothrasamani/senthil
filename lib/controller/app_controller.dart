import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:zo_animated_border/zo_animated_border.dart';

enum Purpose { success, fail }

final Map<Purpose, Color> messagePurpose = {
  Purpose.success: const Color.fromARGB(255, 0, 131, 4),
  Purpose.fail: const Color.fromARGB(255, 163, 11, 0)
};

class AppController {
  //--------------------- colors -----------------------
  static final lightBlue = Colors.lightBlue;
  static final headColor = const Color.fromARGB(255, 219, 0, 183);
  static final darkGreen = const Color.fromARGB(255, 4, 124, 0);
  static final yellow = const Color.fromARGB(255, 243, 188, 8);
  static final red = const Color.fromARGB(255, 199, 31, 1);
  //-------------------- For an API --------------------
  static final String baseUrl = 'https://stest.ijessi.com';
  static final String baseApiUrl = '$baseUrl/api';
  static final String basefileUrl = '$baseUrl/public/pdf';
  static final String baseImageUrl = '$baseUrl/public/images';

  static Future<dynamic> fetch(String endPoint) async {
    final url = Uri.parse('$baseApiUrl/$endPoint');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      return res.body;
    } else {
      return null;
    }
  }

  static Future<dynamic> send(String endPoint, Object object) async {
    final url = Uri.parse('$baseApiUrl/$endPoint');
    final res = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(object));
    if (res.statusCode == 200) {
      return res.body;
    } else {
      return null;
    }
  }

  //---------------------- Additionals --------------------------
  static void toastMessage(String title, String message,
      {Purpose purpose = Purpose.success}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.white,
      colorText: Colors.black,
      borderRadius: 5,
      duration: Duration(seconds: 3),
      icon: Icon(
        purpose == Purpose.success ? Icons.check_circle : Icons.cancel_outlined,
        color: messagePurpose[purpose],
      ),
      borderColor: messagePurpose[purpose],
      borderWidth: 1.0,
      mainButton: TextButton(
          onPressed: () {
            Get.closeCurrentSnackbar();
          },
          child: Icon(Icons.close)),
      margin: EdgeInsets.all(10),
      leftBarIndicatorColor: messagePurpose[purpose],
    );
  }

  static String convertToCurrency(String amount) {
    final amt = num.parse(amount);
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      name: 'INR',
      symbol: '₹ ',
      decimalDigits: 0,
    );
    return formatter.format(amt);
  }

  static Widget heading(String text, bool isDark) => Text(
        text,
        style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isDark ? Colors.blue : baseColor),
      );

  static Widget animatedTitle(String val, bool isDark) {
    return ZoAnimatedGradientBorder(
      gradientColor: [baseColor, headColor],
      glowOpacity: 0.05,
      borderThickness: 2,
      duration: Duration(seconds: 2),
      borderRadius: 10,
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(),
        child: Text(
          val,
          style: GoogleFonts.poppins(
            fontSize: 30,
            color: isDark ? lightBlue : baseColor,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                  color: isDark ? baseColor : lightBlue,
                  blurRadius: 4,
                  offset: Offset(3, 4))
            ],
          ),
        ),
      ),
    );
  }
}
