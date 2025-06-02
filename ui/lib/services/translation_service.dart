import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ui/models/translation.dart';
import 'package:http_parser/http_parser.dart';

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

  Future<void> putTranslations(List<Translation> translations) async {
    final response = await http.put(
      Uri.parse("http://165.232.124.109:3000/api/translation"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(translations.map((t) => t.toJson()).toList()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to put translations: ${response.body}');
    }
  }

  Future<void> putTranslationFile(File file) async {
    final request = http.MultipartRequest(
      'PUT',
      Uri.parse('http://165.232.124.109:3000/api/translation/file'),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: MediaType('application', 'octet-stream'),
      ),
    );

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Failed to upload translations');
    }
  }
}
