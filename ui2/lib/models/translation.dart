class Translation {
  final String id;
  final String en;
  final String de;
  bool? isCorrect;

  Translation(this.id, this.en, this.de);

  Translation.fromJson(Map<String, dynamic> json)
    : id = json['id'] as String,
      en = json['en'] as String,
      de = json['de'] as String;

  Map<String, dynamic> toJson() => {'id': id, 'en': en, 'de': de};
}
