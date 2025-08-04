import 'package:flutter/material.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/theme_controller.dart';

class MessageBox extends StatelessWidget {
  const MessageBox({super.key, required this.isYou, required this.isDark});
  final bool isYou;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Color color = isYou
        ? isDark
            ? AppController.lightBlue
            : baseColor
        : Colors.grey;

    return Row(
      mainAxisAlignment:
          isYou ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: color.withAlpha(50),
            border: Border.all(
              color: color.withAlpha(60),
            ),
          ),
          constraints: BoxConstraints(
            maxWidth: size.width > 450 ? 450 : size.width * 0.7,
          ),
          child: Column(
            children: [
              Text(
                  'I\'m eagar to design new things the where could i find them...'),
              SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'now ${isYou ? '👍' : '✊'}',
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
