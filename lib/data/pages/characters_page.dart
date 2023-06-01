import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'character_details_page.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({Key? key}) : super(key: key);

  @override
  _CharactersPageState createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  final ScrollController _scrollController = ScrollController();
  List<dynamic> heroes = [];
  int nextPage = 1;
  bool isFetching = false;
  bool isSnackbarDisplayed = false;
  bool isAllHeroesLoaded = false;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    fetchCharacters();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!isFetching && !isAllHeroesLoaded) {
        nextPage++;
        fetchCharacters();
        isFetching = true;
      }
    }
  }

  Future<void> fetchCharacters() async {
    if (isFetching || isAllHeroesLoaded) return;

    try {
      final List<dynamic> fetchedHeroes = await _fetchHeroes(nextPage);

      if (fetchedHeroes.isEmpty) {
        isAllHeroesLoaded = true;
      } else {
        heroes.addAll(fetchedHeroes);
        nextPage++;
      }
    } catch (error) {
      print('Failed to fetch characters: $error');
    }

    isFetching = false;
  }

  Future<List<dynamic>> _fetchHeroes(int page) async {
    final response = await http
        .get(Uri.parse('https://rickandmortyapi.com/api/character?page=$page'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> heroes = data['results'];
      return heroes;
    } else {
      throw Exception('Failed to fetch heroes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.grey.shade400,
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: heroes.length,
              itemBuilder: (context, index) {
                final hero = heroes[index];
                String name = hero['name'];
                String species = hero['species'];
                String image = hero['image'];

                if (_searchQuery.isNotEmpty &&
                    !name.toLowerCase().contains(_searchQuery.toLowerCase())) {
                  return const SizedBox();
                }

                return ListTile(
                  title: Text(name),
                  subtitle: Text(species),
                  leading: Image.network(image),
                  onTap: () {
                    navigateToHeroDetails(context, hero);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void navigateToHeroDetails(BuildContext context, dynamic hero) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CharacterDetailsPage(hero: hero),
      ),
    );
  }
}
