import 'package:flutter/material.dart';
import 'package:language_learner/context_service.dart';
import 'package:language_learner/learning_page/language_history.dart';
import 'package:language_learner/learning_page/option_button.dart';
import 'package:provider/provider.dart';

class LearningPage extends StatelessWidget {
  const LearningPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    if (context.watch<ContextService>().isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final sample = context.watch<ContextService>().currentSample;
    if (sample == null) {
      return const Center(child: Text("No sample available"));
    }

    return Expanded(
      child: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: 3, child: LanguageHistory()),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  color: theme.colorScheme.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(sample.actual.id, style: style),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      OptionButton(
                        text: sample.optionOne.en,
                        actual: sample.actual.en,
                      ),
                      OptionButton(
                        text: sample.optionTwo.en,
                        actual: sample.actual.en,
                      ),
                      OptionButton(
                        text: sample.optionThree.en,
                        actual: sample.actual.en,
                      ),
                      OptionButton(
                        text: sample.optionFour.en,
                        actual: sample.actual.en,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    context.read<ContextService>().fetchSample();
                  },
                  child: Text('Next'),
                ),
              ),
              Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
