part of 'favorites_bloc.dart';

class FavoritesState extends Equatable {
  const FavoritesState({this.favorites = const []});

  final List<String> favorites;

  FavoritesState copyWith({
    List<String>? favorites,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
    );
  }

  @override
  String toString() {
    return '''''';
  }

  @override
  List<Object> get props => [favorites];
}
