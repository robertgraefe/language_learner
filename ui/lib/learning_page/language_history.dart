import 'package:flutter/material.dart';
import 'package:language_learner/context_service.dart';
import 'package:provider/provider.dart';

class LanguageHistory extends StatefulWidget {
  const LanguageHistory({Key? key}) : super(key: key);

  @override
  State<LanguageHistory> createState() => _LanguageHistoryState();
}

class _LanguageHistoryState extends State<LanguageHistory> {
  final _key = GlobalKey();

  static const Gradient _maskingGradient = LinearGradient(
    colors: [Colors.transparent, Colors.black],
    stops: [0.0, 0.5],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<ContextService>();
    appState.historyListKey = _key;

    return ShaderMask(
      shaderCallback: (bounds) => _maskingGradient.createShader(bounds),
      blendMode: BlendMode.dstIn,
      child: AnimatedList(
        key: _key,
        reverse: true,
        padding: EdgeInsets.only(top: 100),
        initialItemCount: appState.languageHistory.length,
        itemBuilder: (context, index, animation) {
          final language = appState.languageHistory[index];
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
