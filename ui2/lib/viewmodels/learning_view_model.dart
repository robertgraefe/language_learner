import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui2/models/sample.dart';
import 'package:ui2/models/translation.dart';
import 'package:ui2/viewmodels/translations_view_model.dart';

final learningViewModelProvider = NotifierProvider<LearningViewModel, void>(
  LearningViewModel.new,
);

final currentSampleProvider = StateProvider<Sample?>((ref) => null);
final translationHistoryProvider = StateProvider<TranslationHistoryState>(
  (ref) => TranslationHistoryState(),
);

class TranslationHistoryState {
  GlobalKey? key;
  List<Translation> history = [];
}

class LearningViewModel extends Notifier<void> {
  Sample? currentSample;
  List<Translation> translationHistory = [];
  GlobalKey? historyListKey;

  @override
  void build() {
    Future.microtask(() => fetchSample());
  }

  void fetchSample() {
    final translations =
        ref.read(translationsViewModelProvider).asData?.value ?? [];

    if (translations.isEmpty) return;

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
        translations
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
    if (currentSample == null) {
      return;
    }

    currentSample!.isSelectedCorrectly = text == actual;

    if (currentSample!.isSelectedCorrectly!) {
      fetchSample();
    }
  }
}
