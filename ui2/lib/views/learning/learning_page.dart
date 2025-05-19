import 'package:flutter/material.dart';
import 'package:ui2/utils/ScreenSize.dart';

class LearningPage extends StatelessWidget {
  const LearningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Text(ScreenSize.isPhone(context).toString()));
  }
}
