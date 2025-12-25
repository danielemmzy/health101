// widgets/custom_back_button.dart
import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final double size;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.color,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Navigator.of(context).pop(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.06,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/back.png"),
            colorFilter: color != null
                ? ColorFilter.mode(color!, BlendMode.srcATop)
                : null,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}