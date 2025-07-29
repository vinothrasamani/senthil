import 'package:flutter/material.dart';

class FeebackEntryScreen extends StatefulWidget {
  const FeebackEntryScreen({super.key});

  @override
  State<FeebackEntryScreen> createState() => _FeebackEntryScreenState();
}

class _FeebackEntryScreenState extends State<FeebackEntryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback Entry'),
      ),
      body: SafeArea(
        child: ListView(),
      ),
    );
  }
}
