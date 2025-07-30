import 'package:flutter/material.dart';

class MyChip extends StatelessWidget {
  const MyChip(this.value, this.color, {super.key});
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        value,
        style:
            TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
