abstract class CharactersState {}

class CharactersInitial extends CharactersState {}

class CharactersLoading extends CharactersState {}

class CharactersLoaded extends CharactersState {
  final List<dynamic> heroes;

  CharactersLoaded(this.heroes);
}

class CharactersError extends CharactersState {
  final String errorMessage;

  CharactersError(this.errorMessage);
}
