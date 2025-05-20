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
            Expanded(flex: 3, child: _LanguageHistory()),
            const SizedBox(height: 10),
            _ActualWidget(),
            SizedBox(height: 10),
            _OptionsWidget(),
            SizedBox(height: 10),
            _NextWidget(),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

class _LanguageHistory extends ConsumerStatefulWidget {
  const _LanguageHistory();

  @override
  ConsumerState<_LanguageHistory> createState() => _LanguageHistoryState();
}

class _LanguageHistoryState extends ConsumerState<_LanguageHistory> {
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  static const Gradient _maskingGradient = LinearGradient(
    colors: [Colors.transparent, Colors.black],
    stops: [0.0, 0.5],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  void initState() {
    super.initState();
    // Inject the key into your provider or viewmodel, if needed
    ref.read(translationHistoryProvider.notifier).state.key = _key;
  }

  @override
  Widget build(BuildContext context) {
    final translationHistory = ref.watch(translationHistoryProvider);

    return ShaderMask(
      shaderCallback: (bounds) => _maskingGradient.createShader(bounds),
      blendMode: BlendMode.dstIn,
      child: AnimatedList(
        key: _key,
        reverse: true,
        padding: const EdgeInsets.only(top: 100),
        initialItemCount: translationHistory.history.length,
        itemBuilder: (context, index, animation) {
          final language = translationHistory.history[index];
          return SizeTransition(
            sizeFactor: animation,
            child: Center(
              child: TextButton.icon(
                onPressed: () {},
                icon:
                    language.isCorrect == null
                        ? const SizedBox.shrink()
                        : (language.isCorrect!
                            ? const Icon(Icons.check)
                            : const Icon(Icons.close)),
                label: Text(language.id),
              ),
            ),
          );
        },
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

    final sample = ref.watch(currentSampleProvider);

    if (sample == null) {
      return const Center(child: Text("No sample available"));
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        color: Theme.of(context).colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(sample.actual.id, style: style),
        ),
      ),
    );
  }
}

class _OptionsWidget extends ConsumerWidget {
  const _OptionsWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sample = ref.watch(currentSampleProvider);

    if (sample == null) {
      return const Center(child: Text("No sample available"));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          children: [
            _OptionButton(text: sample.optionOne.en, actual: sample.actual.en),
            _OptionButton(text: sample.optionTwo.en, actual: sample.actual.en),
            _OptionButton(
              text: sample.optionThree.en,
              actual: sample.actual.en,
            ),
            _OptionButton(text: sample.optionFour.en, actual: sample.actual.en),
          ],
        ),
      ],
    );
  }
}

class _OptionButton extends ConsumerWidget {
  final String text;
  final String actual;
  final ValueNotifier<bool> _pressed = ValueNotifier<bool>(false);

  _OptionButton({required this.text, required this.actual});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(learningViewModelProvider.notifier);
    var isCorrect = viewModel.isCorrect;
    final isCorrectOption = text == actual;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 200,
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
              Theme.of(context).colorScheme.primary.withAlpha(100),
            ),
          ),
          onPressed: () {
            _pressed.value = true;

            if (text == actual && isCorrect == null) {
              isCorrect = true;
            } else {
              isCorrect = false;
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Text(text, textAlign: TextAlign.center)),
              ValueListenableBuilder<bool>(
                valueListenable: _pressed,
                builder: (context, value, _) {
                  if (_pressed.value && isCorrectOption) {
                    return Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.primary,
                    );
                  }

                  if (_pressed.value && !isCorrectOption) {
                    return Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.primary,
                    );
                  }

                  return Icon(Icons.check, color: Colors.transparent);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NextWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(learningViewModelProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          viewModel.fetchSample();
        },
        child: Text('Next'),
      ),
    );
  }
}
