part of 'pokemon_bloc.dart';

abstract class PokemonEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PokemonsFetched extends PokemonEvent {
  final String query;
  final int page;

  PokemonsFetched({this.query = "", this.page = 1});
}

class PokemonsRefresh extends PokemonEvent {
  final String query;
  final int page;

  PokemonsRefresh({this.query = "", this.page = 1});
}



// class PokemonDetails extends PokemonEvent {
//   // String? id;

//   PokemonsDetails();
// }
