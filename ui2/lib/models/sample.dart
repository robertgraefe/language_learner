import 'dart:math';
import 'package:ui2/models/translation.dart';

class Sample {
  final Translation actual;
  final Translation optionOne;
  final Translation optionTwo;
  final Translation optionThree;
  final Translation optionFour;

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

  static Translation _getRandomOption(List<Translation> options) {
    final random = Random();
    return options[random.nextInt(options.length)];
  }
}
