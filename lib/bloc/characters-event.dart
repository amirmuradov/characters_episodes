import 'package:equatable/equatable.dart';

abstract class CharactersEvent extends Equatable {
  final int page;

  const CharactersEvent(this.page);

  @override
  List<Object?> get props => [page];
}

class FetchCharacters extends CharactersEvent {
  FetchCharacters(int page) : super(page);
}
