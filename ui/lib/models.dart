import 'dart:math';

class Language {
  final String id;
  final String en;
  final String de;
  bool? isCorrect = null;

  Language(this.id, this.en, this.de);

  Language.fromJson(Map<String, dynamic> json)
    : id = json['id'] as String,
      en = json['en'] as String,
      de = json['de'] as String;

  Map<String, dynamic> toJson() => {'id': id, 'en': en, 'de': de};
}

class Sample {
  final Language actual;
  final Language optionOne;
  final Language optionTwo;
  final Language optionThree;
  final Language optionFour;

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

  static Language _getRandomOption(List<Language> options) {
    final random = Random();
    return options[random.nextInt(options.length)];
  }
}
