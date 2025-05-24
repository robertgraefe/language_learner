import 'dart:math';
import 'package:ui/models/translation_learning.dart';

class Sample {
  final TranslationLearning actual;
  final TranslationLearning optionOne;
  final TranslationLearning optionTwo;
  final TranslationLearning optionThree;
  final TranslationLearning optionFour;
  bool? isSelectedCorrectly;

  Sample({
    required this.optionOne,
    required this.optionTwo,
    required this.optionThree,
    required this.optionFour,
  }) : actual = _getRandomOption([
         optionOne,
         optionTwo,
         optionThree,
         optionFour,
       ]);

  static TranslationLearning _getRandomOption(
    List<TranslationLearning> options,
  ) {
    final random = Random();
    return options[random.nextInt(options.length)];
  }
}
