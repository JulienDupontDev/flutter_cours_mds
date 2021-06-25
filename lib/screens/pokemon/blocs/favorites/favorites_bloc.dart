import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_cours/models/pokemon_preview.dart';
import 'package:flutter_cours/screens/pokemon/blocs/pokemons_data/pokemon_bloc.dart';
import 'package:flutter_cours/screens/pokemon/pokemon_api_client.dart';
import 'package:rxdart/rxdart.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(const FavoritesState());

  @override
  Stream<Transition<FavoritesEvent, FavoritesState>> transformEvents(
    Stream<FavoritesEvent> events,
    TransitionFunction<FavoritesEvent, FavoritesState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 50)),
      transitionFn,
    );
  }

  @override
  Stream<FavoritesState> mapEventToState(FavoritesEvent event) async* {
    if (event is PokemonFavorite) {
      yield await _mapPokemonFavoriteToState(state, event.id);
    }

    if (event is PokemonFavoritesRehydrate) {
      yield await _mapPokemonFavoriteRehydrate(state, event.favorites);
    }

    if (event is FavoritePokemonsFetch) {
      yield await _fetchFavoritePokemons(
          state: state, favorites: event.favorites, page: 1);
    }
  }

  Future<FavoritesState> _mapPokemonFavoriteRehydrate(
      FavoritesState state, List<String> favorites) async {
    try {
      return state.copyWith(favorites: favorites);
    } catch (e) {
      return state;
    }
  }

  Future<FavoritesState> _mapPokemonFavoriteToState(
      FavoritesState state, String id) async {
    List<String> favorites = [...state.favorites];
    try {
      if (favorites.contains(id)) {
        favorites.removeWhere((element) => element == id);
      } else {
        favorites.add(id);
      }

      return state.copyWith(favorites: favorites);
    } catch (e) {
      return state;
    }
  }

  Future<FavoritesState> _fetchFavoritePokemons(
      {state, List<String> favorites = const [], int page = 1}) async {
    List<PokemonPreview> pokemonsToAdd = [];

    for (String id in favorites) {
      final dynamic response = await getPokemonDetails(id);
      if (response == null) continue;
      var pokemon = response['data'];
      print("pokemons to add $pokemonsToAdd");

      pokemonsToAdd.add(PokemonPreview(
          id: pokemon['id'],
          name: pokemon['name'],
          imageUrl: pokemon['images']['small']));
    }
    print("pokemons to return $pokemonsToAdd");
    return state.copyWith(favoritePokemonsPreviews: pokemonsToAdd);
  }
}
