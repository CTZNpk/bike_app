import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  const MyElevatedButton({
    super.key,
    required this.label,
    required this.labelIcon,
    required this.imageUrl,
    required this.onPressed,
    required this.backgroundColor,
  });

  final String label;
  final IconData? labelIcon;
  final String? imageUrl;
  final Color backgroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            foregroundColor: const MaterialStatePropertyAll(Colors.white),
            backgroundColor: MaterialStatePropertyAll(backgroundColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imageUrl != null
                  ? Image.network(
                      imageUrl!,
                      width: 25,
                    )
                  : labelIcon != null
                      ? Icon(labelIcon!)
                      : const SizedBox.shrink(),
              const SizedBox(width: 3),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
