import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'episode-details_page.dart';

class EpisodesPage extends StatefulWidget {
  @override
  _EpisodesPageState createState() => _EpisodesPageState();
}

class _EpisodesPageState extends State<EpisodesPage> {
  List<dynamic> episodes = [];
  List<dynamic> filteredEpisodes = [];
  bool isLoading = false;
  int page = 1;
  TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchEpisodes();
  }

  Future<void> fetchEpisodes() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.https('rickandmortyapi.com', '/api/episode', {'page': '$page'}),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final results = jsonData['results'];

      if (!mounted) return;

      setState(() {
        episodes.addAll(results);
        filteredEpisodes.addAll(results);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to fetch episodes.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void filterEpisodes(String query) {
    setState(() {
      filteredEpisodes = episodes
          .where((episode) =>
              episode['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Widget _buildEpisodeList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.grey.shade400,
            ),
            height: 45,
            child: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                filterEpisodes(value);
              },
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredEpisodes.length + 1,
            itemBuilder: (context, index) {
              if (index < filteredEpisodes.length) {
                final episode = filteredEpisodes[index];
                return ListTile(
                  title: Text(episode['name']),
                  subtitle: Text(episode['episode']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EpisodeDetailsPage(episode: episode),
                      ),
                    );
                  },
                );
              } else if (isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildEpisodeList(),
    );
  }
}
