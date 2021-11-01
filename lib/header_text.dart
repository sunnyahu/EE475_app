import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  final String text;
  static const double fontsize = 28.0;

  HeaderText(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: fontsize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
