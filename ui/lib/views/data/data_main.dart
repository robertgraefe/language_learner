import 'package:flutter/material.dart';
import 'package:ui/utils/ScreenSize.dart';
import 'package:ui/views/data/data_page/data_page.dart';
import 'package:ui/views/navigation/navigation_bottombar.dart';
import 'package:ui/views/navigation/navigation_sidebar.dart';

class DataMainPage extends StatelessWidget {
  const DataMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (ScreenSize.isPhone(context)) {
      return Scaffold(
        body: Column(children: [Expanded(child: DataPage())]),
        bottomNavigationBar: NavigationBottomBar(),
      );
    }

    return Scaffold(
      body: Row(children: [NavigationSidebar(), Expanded(child: DataPage())]),
    );
  }
}
