import 'package:flutter/material.dart';
import 'package:ui2/viewmodels/learning_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OptionsWidget extends ConsumerWidget {
  const OptionsWidget({super.key});

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
            OptionButton(text: sample.optionOne.en, actual: sample.actual.en),
            OptionButton(text: sample.optionTwo.en, actual: sample.actual.en),
            OptionButton(text: sample.optionThree.en, actual: sample.actual.en),
            OptionButton(text: sample.optionFour.en, actual: sample.actual.en),
          ],
        ),
      ],
    );
  }
}

class OptionButton extends ConsumerWidget {
  final String text;
  final String actual;
  final ValueNotifier<bool> _pressed = ValueNotifier<bool>(false);

  OptionButton({super.key, required this.text, required this.actual});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(learningViewModelProvider.notifier);

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

            viewModel.selectOption(text, actual);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Text(text, textAlign: TextAlign.center)),
              ValueListenableBuilder<bool>(
                valueListenable: _pressed,
                builder: (context, value, _) {
                  if (_pressed.value && text == actual) {
                    return Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.primary,
                    );
                  }

                  if (_pressed.value && text != actual) {
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
