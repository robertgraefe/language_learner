import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/models/sample.dart';
import 'package:ui/models/translation_learning.dart';
import 'package:ui/viewmodels/translations_view_model.dart';

final learningViewModelProvider = NotifierProvider<LearningViewModel, void>(
  LearningViewModel.new,
);

final currentSampleProvider = StateProvider<Sample?>((ref) => null);
final translationHistoryProvider = StateProvider<TranslationHistoryState>(
  (ref) => TranslationHistoryState(),
);

class TranslationHistoryState {
  GlobalKey? key;
  List<TranslationLearning> history = [];
}

class LearningViewModel extends Notifier<void> {
  Sample? currentSample;
  List<TranslationLearning> translationHistory = [];
  GlobalKey? historyListKey;

  @override
  void build() {
    Future.microtask(() => fetchSample());
  }

  void fetchSample() {
    final translations =
        ref.read(translationsViewModelProvider).asData?.value ?? [];

    if (translations.isEmpty) return;

    final translationsLearning =
        translations
            .map((x) => TranslationLearning(id: x.id, de: x.de, en: x.en))
            .toList();

    if (currentSample != null) {
      currentSample!.actual.isCorrect = currentSample!.isSelectedCorrectly;

      final historyState = ref.read(translationHistoryProvider.notifier).state;
      historyState.history.insert(0, currentSample!.actual);
      final animatedList = historyState.key?.currentState as AnimatedListState?;
      animatedList?.insertItem(0);
    }

    final random = Random();

    final correctGuessed =
        translationHistory.where((x) => x.isCorrect == true).toList();

    final openGuesses =
        translationsLearning
            .where((x) => !correctGuessed.any((guessed) => guessed.id == x.id))
            .toList()
          ..shuffle(random);

    final sample = openGuesses.take(4).toList();

    currentSample = Sample(
      optionOne: sample[0],
      optionTwo: sample[1],
      optionThree: sample[2],
      optionFour: sample[3],
    );

    ref.read(currentSampleProvider.notifier).state = currentSample;
  }

  void selectOption(String text, String actual) {
    final sample = currentSample;

    if (sample == null) return;

    sample.isSelectedCorrectly ??= text == actual;

    if (text == actual) {
      fetchSample();
    }
  }
}
