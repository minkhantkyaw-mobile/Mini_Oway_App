import 'package:flutter/material.dart';
import 'package:project_one/screens/user_screen/user_signUp_screen.dart';

class WelcomeButton extends StatelessWidget {
  const WelcomeButton({
    super.key,
    this.buttonText,
    this.onTap,
    this.color,
    this.textColor,
    this.borderRadius,
  });

  final String? buttonText;
  final VoidCallback? onTap;
  final Color? color;
  final Color? textColor;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: color!,
          // borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
          borderRadius: borderRadius,
        ),
        child: Text(
          buttonText!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor!,
          ),
        ),
      ),
    );
  }
}
