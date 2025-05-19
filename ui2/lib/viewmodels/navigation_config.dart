import 'package:flutter/material.dart';

class NavigationItem {
  final IconData icon;
  final String label;

  const NavigationItem({required this.icon, required this.label});
}

const List<NavigationItem> navigationItems = [
  NavigationItem(icon: Icons.home, label: 'Home'),
  NavigationItem(icon: Icons.favorite, label: 'Favorites'),
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
