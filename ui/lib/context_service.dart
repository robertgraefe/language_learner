import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:language_learner/models.dart';

class ContextService extends ChangeNotifier {
  List<Language> languages = [];
  bool isLoading = true;
  Sample? currentSample; // Store the current sample
  bool? isCorrect;

  List<Language> languageHistory = [];
  GlobalKey? historyListKey;

  Future<void> loadLanguages() async {
    isLoading = true;
    notifyListeners();

    String jsonString = await rootBundle.loadString(
      'lib/assets/indonesia.json',
    );
    final List<dynamic> jsonData = json.decode(jsonString);
    languages = jsonData.map((item) => Language.fromJson(item)).toList();

    fetchSample();
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadLanguagesApi() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('http://165.232.124.109:3000/api/words'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        languages = jsonData.map((item) => Language.fromJson(item)).toList();
        fetchSample(); // Fetch the initial sample
      } else {
        throw Exception('Failed to load languages');
      }
    } catch (e) {
      print('Error fetching languages: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  void fetchSample() {
    if (languages.isEmpty) return;

    final random = Random();

    final correctGuessed =
        languageHistory
            .where((language) => language.isCorrect == true)
            .toList();

    final openLanguages =
        languages
            .where(
              (lang) => !correctGuessed.any((guessed) => guessed.id == lang.id),
            )
            .toList();

    final selectedLanguages = openLanguages..shuffle(random);

    if (currentSample != null) {
      currentSample!.actual.isCorrect = isCorrect;
      languageHistory.insert(0, currentSample!.actual);
      var animatedList = historyListKey?.currentState as AnimatedListState?;
      animatedList?.insertItem(0);
    }

    final s = selectedLanguages.take(4).toList();

    currentSample = Sample(
      optionOne: s[0],
      optionTwo: s[1],
      optionThree: s[2],
      optionFour: s[3],
    );

    isCorrect = null; // Reset isCorrect for the new sample

    notifyListeners(); // Notify listeners about the new sample
  }
}
