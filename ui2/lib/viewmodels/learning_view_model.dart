import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui2/models/translation.dart';
import 'package:ui2/services/translation_service.dart';

final quoteViewModelProvider =
    AsyncNotifierProvider<LearningViewModel, List<Translation>>(
      LearningViewModel.new,
    );

final _translationServiceProvider = Provider<TranslationService>(
  (ref) => TranslationService(),
);

class LearningViewModel extends AsyncNotifier<List<Translation>> {
  @override
  Future<List<Translation>> build() async {
    final service = ref.read(_translationServiceProvider);
    return await service.getTranslations();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final service = ref.read(_translationServiceProvider);
    state = await AsyncValue.guard(() => service.getTranslations());
  }
}
