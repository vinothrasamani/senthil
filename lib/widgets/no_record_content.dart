import 'package:flutter/material.dart';

class NoRecordContent extends StatelessWidget {
  const NoRecordContent({super.key, this.msg, this.title});
  final String? title;
  final String? msg;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
            border: Border.all(color: Colors.grey.withAlpha(50), width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off_rounded, size: 55),
              SizedBox(height: 12),
              Text(
                title ?? 'Nothing Here!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(msg ?? 'No results match your search.',
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
