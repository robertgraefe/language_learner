import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/viewmodels/navigation_config.dart';

class NavigationBottomBar extends StatelessWidget {
  const NavigationBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final routeProvider = GoRouter.of(context).routeInformationProvider;
    final route = routeProvider.value.uri.path;
    final navigation = navigationItems.firstWhere((x) => x.route == route);

    return BottomNavigationBar(
      items: navigationBarItems,
      currentIndex: navigationItems.indexWhere(
        (x) => x.route == navigation.route,
      ),
      onTap: (index) {
        context.go(navigationItems[index].route);
      },
    );
  }
}
