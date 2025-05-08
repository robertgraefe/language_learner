import 'package:flutter/material.dart';

import 'package:language_learner/context_service.dart';

import 'package:language_learner/learning_page/learning_page.dart';
import 'package:language_learner/navigation.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  MyJsonWidgetState createState() => MyJsonWidgetState();
}

class MyJsonWidgetState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final provider = ContextService();
        provider.loadLanguagesApi();
        return provider;
      },
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Row(children: [NavigationPage(), LearningPage()]));
  }
}
