import 'package:flutter/material.dart';
import 'package:ui/utils/ScreenSize.dart';
import 'package:ui/views/learning/learning_page/learning_page.dart';
import 'package:ui/views/navigation/navigation_bottombar.dart';
import 'package:ui/views/navigation/navigation_sidebar.dart';

class LearningMainPage extends StatelessWidget {
  const LearningMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (ScreenSize.isPhone(context)) {
      return Scaffold(
        body: Column(children: [Expanded(child: LearningPage())]),
        bottomNavigationBar: NavigationBottomBar(),
      );
    }

    return Scaffold(
      body: Row(
        children: [NavigationSidebar(), Expanded(child: LearningPage())],
      ),
    );
  }
}
