import 'dart:io';

import 'package:flutter/material.dart';

class ImageViewerScreen extends StatelessWidget {
  const ImageViewerScreen(
      {super.key, required this.from, required this.name, required this.url});
  final String name;
  final String url;
  final String from;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SafeArea(child: Center(child: image())),
    );
  }

  Widget image() {
    return switch (from) {
      'asset' => Image.asset(url, fit: BoxFit.contain),
      'file' => Image.file(File(url), fit: BoxFit.contain),
      _ => Image.network(url, fit: BoxFit.contain),
    };
  }
}
