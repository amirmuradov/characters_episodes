import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EpisodeDetailsPage extends StatelessWidget {
  final Map<String, dynamic> episode;

  EpisodeDetailsPage({required this.episode});

  Future<List<dynamic>> fetchCharacters() async {
    final charactersUrls = episode['characters'].cast<String>();

    List<dynamic> characters = [];

    for (String url in charactersUrls) {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        characters.add(jsonData);
      }
    }

    return characters;
  }

  Widget _buildCharactersList(List<dynamic> characters) {
    return ListView.builder(
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];
        return ListTile(
          leading: Image.network(
            character['image'],
            height: 50,
            width: 50,
          ),
          title: Text(character['name']),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(episode['name']),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchCharacters(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildCharactersList(snapshot.data!);
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to fetch characters.'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
