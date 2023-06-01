import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'characters-event.dart';
import 'characters-state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  CharactersBloc() : super(CharactersInitial());

  List<dynamic> allHeroes = [];

  @override
  Stream<CharactersState> mapEventToState(CharactersEvent event) async* {
    if (event is FetchCharacters) {
      yield CharactersLoading();

      try {
        final response = await http.get(
          Uri.https('rickandmortyapi.com', '/api/character'),
        );

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          final List<dynamic> heroes = jsonData['results'];

          allHeroes.addAll(heroes);

          yield CharactersLoaded(allHeroes);
        } else {
          throw Exception('Failed to fetch heroes');
        }
      } catch (error) {
        yield CharactersError('Failed to fetch heroes');
      }
    }
  }
}
