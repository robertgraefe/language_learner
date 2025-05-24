import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/models/translation.dart';
import 'package:ui/viewmodels/translations_view_model.dart';

final currentSampleProvider = StateProvider<List<Translation>>((ref) => []);

class DataViewModel extends Notifier<void> {
  @override
  void build() {
    Future.microtask(() => fetchData());
  }

  List<Translation> get translations =>
      ref.read(translationsViewModelProvider).asData?.value ?? [];

  fetchData() {
    print(translations);
  }
}
