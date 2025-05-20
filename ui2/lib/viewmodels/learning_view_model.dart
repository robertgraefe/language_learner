import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui2/models/sample.dart';
import 'package:ui2/models/translation.dart';
import 'package:ui2/services/translation_service.dart';

final learningViewModelProvider =
    AsyncNotifierProvider<LearningViewModel, List<Translation>>(
      LearningViewModel.new,
    );
final translationServiceProvider = Provider<TranslationService>(
  (ref) => TranslationService(),
);
final currentSampleProvider = StateProvider<Sample?>((ref) => null);
final translationHistoryProvider = StateProvider<TranslationHistoryState>(
  (ref) => TranslationHistoryState(),
);

class TranslationHistoryState {
  GlobalKey? key;
  List<Translation> history = [];
}

class LearningViewModel extends AsyncNotifier<List<Translation>> {
  Sample? currentSample;
  List<Translation> translations = [];
  List<Translation> translationHistory = [];
  bool? isCorrect;
  GlobalKey? historyListKey;

  @override
  Future<List<Translation>> build() async {
    final translationService = ref.read(translationServiceProvider);
    translations = await translationService.getTranslations();
    fetchSample();
    return translations;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final translationService = ref.read(translationServiceProvider);
    state = await AsyncValue.guard(() => translationService.getTranslations());
  }

  void fetchSample() {
    if (translations.isEmpty) return;

    if (currentSample != null) {
      currentSample!.actual.isCorrect = isCorrect;
      isCorrect = null; // Reset isCorrect for the new sample
      translationHistory.insert(0, currentSample!.actual);
      var animatedList = historyListKey?.currentState as AnimatedListState?;
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

    final historyState = ref.read(translationHistoryProvider.notifier).state;
    historyState.history.insert(0, currentSample!.actual);

    // Make sure you call insertItem on the key stored in the provider
    final animatedList = historyState.key?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);
  }
}
