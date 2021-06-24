part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PokemonFavoritesRehydrate extends FavoritesEvent {
  final List<String> favorites;

  PokemonFavoritesRehydrate({required this.favorites});
}

class PokemonFavorite extends FavoritesEvent {
  final String id;

  PokemonFavorite({required this.id});
}

// class PokemonDetails extends PokemonEvent {
//   // String? id;

//   PokemonsDetails();
// }
