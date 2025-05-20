import 'package:flutter/material.dart';
import 'package:ui2/models/translation.dart';
import 'package:ui2/viewmodels/learning_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui2/views/utils/error.dart';
import 'package:ui2/views/utils/loading.dart';

class LearningPage extends ConsumerWidget {
  const LearningPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTranslations = ref.watch(learningViewModelProvider);

    return asyncTranslations.when(
      data: (translations) => _ContentWidget(translations),
      error: (error, _) => errorWidget(error.toString()),
      loading: () => loadingWidget(),
    );
  }
}

class _ContentWidget extends StatelessWidget {
  const _ContentWidget(this.translations);

  final List<Translation> translations;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Expanded(flex: 3, child: LanguageHistory()),
            const SizedBox(height: 10),
            _ActualWidget(),
          ],
        ),
      ),
    );
  }
}

class _ActualWidget extends ConsumerWidget {
  const _ActualWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = Theme.of(context).textTheme.displayMedium!.copyWith(
      color: Theme.of(context).colorScheme.onPrimary,
    );

    final viewModel = ref.watch(learningViewModelProvider.notifier);
    final current = viewModel.currentTranslation;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        color: Theme.of(context).colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(current?.id ?? "No current translation", style: style),
        ),
      ),
    );
  }
}
