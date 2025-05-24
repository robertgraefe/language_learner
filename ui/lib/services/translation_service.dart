// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ui/models/translation.dart';

class TranslationService {
  Future<List<Translation>> getTranslations() async {
    final response = await http.get(
      Uri.parse('http://165.232.124.109:3000/api/translation/all'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(
        utf8.decode(response.bodyBytes),
      );
      jsonData.map((item) => Translation.fromJson(item)).toList();
      return jsonData.map((item) => Translation.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load translation');
    }
  }
}
