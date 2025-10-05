import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xff58cc02);
  static const Color background = Color(0xff1c1e26);
  static const Color white = Color(0xffffffff);
  static const Color blue = Color(0xFF1CB0F6);
  static const Color orange = Color(0xFFFF9600);

  static get surface => null;
}

class AppStrings {
  static const String appName = "Learnify";
  static const String welcome =
      "La forma divertida, efectiva y\n gratis de aprender idiomas!";
}

class AppImages {
  static Image logo = Image.asset('images/logo.png', height: 150);
  static Image celebracion = Image.asset('images/celebracion.png', height: 150);
}
