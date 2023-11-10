import 'package:flutter/material.dart';

class VerticalSpacing extends StatelessWidget {
  const VerticalSpacing({super.key, required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
