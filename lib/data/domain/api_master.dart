import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchHeroes() async {
  final response =
      await http.get(Uri.https('rickandmortyapi.com', '/api/character'));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return jsonData['results'];
  } else {
    throw Exception('Failed to fetch heroes');
  }
}
