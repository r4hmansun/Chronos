import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String title;
  final String content;

  const DetailPage(
    this.title,
    this.content, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(title)),
      body: Padding(
        padding:
            const EdgeInsets.all(
                16),
        child: Text(
          content,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}