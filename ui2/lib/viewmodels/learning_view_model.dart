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

class LearningViewModel extends AsyncNotifier<List<Translation>> {
  Sample? currentSample;

  @override
  Future<List<Translation>> build() async {
    final service = ref.read(translationServiceProvider);
    final translations = await service.getTranslations();
    currentSample = translations.isNotEmpty ? translations[0] : null;
    return translations;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final service = ref.read(translationServiceProvider);
    state = await AsyncValue.guard(() => service.getTranslations());
  }
}
