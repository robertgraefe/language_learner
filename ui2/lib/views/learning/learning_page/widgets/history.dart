import 'package:flutter/material.dart';
import 'package:ui2/viewmodels/learning_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageHistory extends ConsumerStatefulWidget {
  const LanguageHistory({super.key});

  @override
  ConsumerState<LanguageHistory> createState() => _LanguageHistoryState();
}

class _LanguageHistoryState extends ConsumerState<LanguageHistory> {
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
