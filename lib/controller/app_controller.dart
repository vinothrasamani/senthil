import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:zo_animated_border/zo_animated_border.dart';

enum Purpose { success, fail, unReachable }

final Map<Purpose, Color> messagePurpose = {
  Purpose.success: const Color.fromARGB(255, 0, 131, 4),
  Purpose.fail: const Color.fromARGB(255, 163, 11, 0),
  Purpose.unReachable: const Color.fromARGB(255, 255, 0, 0)
};

class AppController {
  //--------------------- colors -----------------------
  static final lightBlue = Colors.lightBlue;
  static final headColor = const Color.fromARGB(255, 219, 0, 183);
  static final darkGreen = const Color.fromARGB(255, 4, 124, 0);
  static final lightGreen = const Color.fromARGB(255, 32, 248, 24);
  static final yellow = const Color.fromARGB(255, 243, 188, 8);
  static final red = const Color.fromARGB(255, 199, 31, 1);
  static final tableColor = headColor.withAlpha(40);

  //-------------------- For an API --------------------
  static final String baseUrl = 'https://senthil.ijessi.com';
  static final String baseApiUrl = '$baseUrl/api';
  static final String baseImageUrl = '$baseUrl/public/images';
  static final String basefileUrl = '$baseUrl/public/uploads/pdf';
  static final String baseQusUrl = '$baseUrl/public/uploads/QS';
  static final String imageUrl = '$baseUrl/public/uploads/student';
  static final String baseGifUrl = '$baseImageUrl/assets';
  static final String baseChatImgUrl = '$baseImageUrl/chat';
  static final String baseResultImageUrl = '$baseUrl/public/img';
  static final String baseStaffImageUrl = '$baseUrl/public/uploads/staff';

  static Future<dynamic> fetch(String endPoint) async {
    try {
      final url = Uri.parse('$baseApiUrl/$endPoint');
      final res = await http.get(url);
      if (res.statusCode == 200) {
        return res.body;
      }
    } catch (e) {
      if (e.toString().contains('Failed to fetch')) {
        reachError();
      }
    }
  }

  static Future<dynamic> send(String endPoint, Object object) async {
    try {
      final url = Uri.parse('$baseApiUrl/$endPoint');
      final res = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(object));
      if (res.statusCode == 200) {
        return res.body;
      }
    } catch (e) {
      if (e.toString().contains('Failed to fetch')) {
        reachError();
      }
    }
  }

  static void reachError() async {
    await Future.delayed(Duration(milliseconds: 200), () {
      Get.closeAllSnackbars();
      toastMessage(
        'Failed to fetch!',
        'Unable to reach the server, Please contact admin!',
        purpose: Purpose.unReachable,
      );
    });
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
      duration: Duration(seconds: purpose == Purpose.unReachable ? 60 : 3),
      icon: Icon(
        purpose == Purpose.unReachable
            ? Icons.error
            : purpose == Purpose.success
                ? Icons.check_circle
                : Icons.cancel_outlined,
        color: messagePurpose[purpose],
      ),
      borderColor: messagePurpose[purpose],
      borderWidth: 1.0,
      isDismissible: purpose == Purpose.unReachable,
      mainButton: purpose == Purpose.unReachable
          ? null
          : TextButton(
              onPressed: () {
                Get.closeCurrentSnackbar();
              },
              child: Icon(Icons.close),
            ),
      margin: EdgeInsets.all(10),
      leftBarIndicatorColor: messagePurpose[purpose],
    );
  }

  static void showSnackBar(BuildContext context, String msg, bool isSuccess) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(isSuccess ? Icons.check_circle_outline : Icons.error_outline,
                color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text(
              msg,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isSuccess
            ? messagePurpose[Purpose.success]
            : messagePurpose[Purpose.fail],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        duration: Duration(seconds: 5, days: !isSuccess ? 1 : 0),
        dismissDirection: DismissDirection.horizontal,
      ),
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

  static Widget heading(String text, bool isDark, IconData icon) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isDark ? Colors.blue : baseColor,
            size: text == 'Search' ? 18 : 20,
            shadows: [
              Shadow(
                offset: Offset(0, 1),
                color: isDark ? Colors.blue : baseColor,
              ),
            ],
          ),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDark ? Colors.blue : baseColor),
              overflow: TextOverflow.clip,
            ),
          ),
        ],
      );

  static Widget animatedTitle(String val, bool isDark) {
    return ZoAnimatedGradientBorder(
      gradientColor: [baseColor, headColor],
      glowOpacity: 0.05,
      borderThickness: 3,
      duration: Duration(seconds: 2),
      borderRadius: 5,
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          '<<  $val  >>',
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  static String formatToSmartDate(String utcDateString) {
    try {
      DateTime utcDate = DateTime.parse(utcDateString).toUtc();
      DateTime localDate = utcDate.toLocal();

      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      DateTime yesterday = today.subtract(Duration(days: 1));
      DateTime inputDate =
          DateTime(localDate.year, localDate.month, localDate.day);

      if (inputDate == today) {
        return DateFormat('h:mm a').format(localDate);
      } else if (inputDate == yesterday) {
        return "Yesterday";
      } else if (localDate.year == now.year) {
        return DateFormat('MMM d').format(localDate);
      } else {
        return DateFormat('MMM d, yyyy').format(localDate);
      }
    } catch (e) {
      return "";
    }
  }
}
