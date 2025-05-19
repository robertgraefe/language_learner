import 'package:flutter/material.dart';

class ScreenSize {
  static bool isPhone(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

static bool isTabelet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 1024;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;
}
