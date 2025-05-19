import 'package:flutter/material.dart';
import 'package:ui2/viewmodels/navigation_config.dart';

class NavigationSidebar extends StatelessWidget {
  const NavigationSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NavigationRail(
        extended: false,
        destinations: navigationRailDestinations,
        selectedIndex: 0,
      ),
    );
  }
}
