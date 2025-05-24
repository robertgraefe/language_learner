import 'package:flutter/material.dart';
import 'package:ui/viewmodels/learning_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActualWidget extends ConsumerWidget {
  const ActualWidget({super.key});

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
