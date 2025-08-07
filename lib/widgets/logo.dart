import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Logo extends StatelessWidget {
  final IconData? icon;
  const Logo({super.key, this.icon});

  @override
  Widget build(BuildContext context) {
    if (icon == FontAwesomeIcons.facebookF) {
      return const FaIcon(
        FontAwesomeIcons.facebookF,
        size: 30,
        color: Color.fromARGB(255, 3, 126, 227),
      );
    } else if (icon == FontAwesomeIcons.twitter) {
      return const FaIcon(
        FontAwesomeIcons.twitter,
        size: 30,
        color: Colors.lightBlue,
      );
    } else if (icon == FontAwesomeIcons.apple) {
      return const FaIcon(
        FontAwesomeIcons.apple,
        size: 30,
        color: Colors.black,
      );
    } else if (icon == FontAwesomeIcons.google) {
      // Handle gradient icon with ShaderMask
      return ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [Colors.red, Colors.yellow, Colors.green, Colors.blue],
          begin: Alignment.topCenter,
        ).createShader(bounds),
        blendMode: BlendMode.srcIn,
        child: const FaIcon(FontAwesomeIcons.google, size: 30),
      );
    } else {
      return FaIcon(icon, size: 30, color: Colors.grey);
    }
  }
}
