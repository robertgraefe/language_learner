import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/viewmodels/translations_view_model.dart';
import 'package:ui/views/learning/learning_page/widgets/actual.dart';
import 'package:ui/views/learning/learning_page/widgets/history.dart';
import 'package:ui/views/learning/learning_page/widgets/next.dart';
import 'package:ui/views/learning/learning_page/widgets/options.dart';
import 'package:ui/views/utils/error.dart';
import 'package:ui/views/utils/loading.dart';

class LearningPage extends ConsumerWidget {
  const LearningPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTranslations = ref.watch(translationsViewModelProvider);

    return asyncTranslations.when(
      data: (translations) => _ContentWidget(),
      error: (error, _) => errorWidget(error.toString()),
      loading: () => loadingWidget(),
    );
  }
}

class _ContentWidget extends StatelessWidget {
  const _ContentWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 3, child: LanguageHistory()),
            const SizedBox(height: 10),
            ActualWidget(),
            SizedBox(height: 10),
            OptionsWidget(),
            SizedBox(height: 10),
            NextWidget(),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
