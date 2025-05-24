import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/views/data/data_main.dart';
import 'package:ui/views/learning/learning_main.dart';

class NavigationItem {
  final IconData icon;
  final String label;
  final String route;
  final Widget widget;

  const NavigationItem({
    required this.route,
    required this.icon,
    required this.label,
    required this.widget,
  });
}

const List<NavigationItem> navigationItems = [
  NavigationItem(
    route: "/data",
    icon: Icons.home,
    label: 'Data',
    widget: DataMainPage(),
  ),
  NavigationItem(
    route: "/learning",
    icon: Icons.favorite,
    label: 'Learning',
    widget: LearningMainPage(),
  ),
];

final List<NavigationRailDestination> navigationRailDestinations =
    navigationItems
        .map(
          (item) => NavigationRailDestination(
            icon: Icon(item.icon),
            label: Text(item.label),
          ),
        )
        .toList();

final List<BottomNavigationBarItem> navigationBarItems =
    navigationItems
        .map(
          (item) =>
              BottomNavigationBarItem(icon: Icon(item.icon), label: item.label),
        )
        .toList();

final List<GoRoute> routes =
    navigationItems
        .map(
          (item) => GoRoute(
            path: item.route,
            builder: (context, state) => item.widget,
          ),
        )
        .toList();
