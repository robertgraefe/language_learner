import 'package:flutter/material.dart';
import 'package:ui2/viewmodels/navigation_config.dart';

class NavigationBottomBar extends StatelessWidget {
  const NavigationBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(items: navigationBarItems);
  }
}
