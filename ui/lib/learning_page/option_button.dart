import 'package:flutter/material.dart';
import 'package:language_learner/context_service.dart';
import 'package:provider/provider.dart';

class OptionButton extends StatelessWidget {
  final String text;
  final String actual;

  final ValueNotifier<bool> _buttonPressedNotifier = ValueNotifier<bool>(false);

  OptionButton({super.key, required this.text, required this.actual});

  @override
  Widget build(BuildContext context) {
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
            _buttonPressedNotifier.value = true;

            var isCorrect = context.read<ContextService>().isCorrect;

            if (text == actual && isCorrect == null) {
              context.read<ContextService>().isCorrect = true;
            } else {
              context.read<ContextService>().isCorrect = false;
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Text(text, textAlign: TextAlign.center)),
              ValueListenableBuilder<bool>(
                valueListenable: _buttonPressedNotifier,
                builder: (context, isPressed, child) {
                  if (!isPressed) {
                    return Icon(
                      Icons.check,
                      color: Colors.transparent,
                    ); // Make the icon invisible
                  }

                  if (text == actual) {
                    return Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.primary,
                    );
                  } else {
                    return Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.primary,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
