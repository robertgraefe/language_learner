import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/viewmodels/navigation_config.dart';

class NavigationSidebar extends StatelessWidget {
  const NavigationSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final routeProvider = GoRouter.of(context).routeInformationProvider;
    final route = routeProvider.value.uri.path;
    final navigation = navigationItems.firstWhere((x) => x.route == route);

    return SafeArea(
      child: NavigationRail(
        extended: false,
        destinations: navigationRailDestinations,
        selectedIndex: navigationItems.indexWhere(
          (x) => x.route == navigation.route,
        ),
        onDestinationSelected:
            (index) => context.go(navigationItems[index].route),
        labelType: NavigationRailLabelType.all,
      ),
    );
  }
}
