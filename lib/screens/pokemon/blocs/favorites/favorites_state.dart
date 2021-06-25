part of 'favorites_bloc.dart';

class FavoritesState extends Equatable {
  const FavoritesState(
      {this.favorites = const [], this.favoritePokemonsPreviews = const []});

  final List<String> favorites;
  final List<PokemonPreview> favoritePokemonsPreviews;
  FavoritesState copyWith(
      {List<String>? favorites,
      List<PokemonPreview>? favoritePokemonsPreviews}) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      favoritePokemonsPreviews:
          favoritePokemonsPreviews ?? this.favoritePokemonsPreviews,
    );
  }

  @override
  String toString() {
    return '''''';
  }

  @override
  List<Object> get props => [favorites, favoritePokemonsPreviews];
}
