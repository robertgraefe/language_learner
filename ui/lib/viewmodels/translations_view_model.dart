import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/models/translation.dart';
import 'package:ui/services/translation_service.dart';

final translationServiceProvider = Provider<TranslationService>(
  (ref) => TranslationService(),
);

final translationsViewModelProvider =
    AsyncNotifierProvider<TranslationsViewModel, List<Translation>>(
      TranslationsViewModel.new,
    );

class TranslationsViewModel extends AsyncNotifier<List<Translation>> {
  List<Translation> _translations = [];

  @override
  Future<List<Translation>> build() async {
    final service = ref.read(translationServiceProvider);
    _translations = await service.getTranslations();
    return _translations;
  }

  List<Translation> get translations => _translations;

  Future<void> refresh() async {
    state = const AsyncLoading();
    final service = ref.read(translationServiceProvider);
    final newTranslations = await service.getTranslations();
    _translations = newTranslations;
    state = AsyncData(newTranslations);
  }
}
