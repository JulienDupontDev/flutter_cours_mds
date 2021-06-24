part of 'pokemon_bloc.dart';

enum PokemonStatus { initial, success, failure, loading }

class PokemonState extends Equatable {
  const PokemonState(
      {this.status = PokemonStatus.initial,
      this.pokemons = const <PokemonPreview>[],
      this.hasReachedMax = false,
      this.page = 1,
      this.totalCount = 0,
      this.query = "",
      this.favorites = const []});

  final PokemonStatus status;
  final List<PokemonPreview> pokemons;
  final bool hasReachedMax;
  final int page, totalCount;
  final String query;
  final List<String> favorites;

  PokemonState copyWith({
    PokemonStatus? status,
    List<PokemonPreview>? pokemons,
    bool? hasReachedMax,
    int? page,
    int? totalCount,
    String? query,
    List<String>? favorites,
  }) {
    return PokemonState(
      status: status ?? this.status,
      pokemons: pokemons ?? this.pokemons,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      totalCount: totalCount ?? this.totalCount,
      query: query ?? this.query,
      favorites: favorites ?? this.favorites,
    );
  }

  @override
  String toString() {
    return '''PokemonState { status: $status, pokemons: ${pokemons.length} }''';
  }

  @override
  List<Object> get props =>
      [status, pokemons, hasReachedMax, page, totalCount, query, favorites];
}
