import 'package:flutter/material.dart';
import 'package:ui/viewmodels/learning_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NextWidget extends ConsumerWidget {
  const NextWidget({super.key});

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
