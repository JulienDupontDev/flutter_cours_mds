import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_cours/models/pokemon_preview.dart';
import 'package:flutter_cours/screens/pokemon/pokemon_api_client.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

part 'pokemon_event.dart';
part 'pokemon_state.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  PokemonBloc() : super(const PokemonState());

  @override
  Stream<Transition<PokemonEvent, PokemonState>> transformEvents(
    Stream<PokemonEvent> events,
    TransitionFunction<PokemonEvent, PokemonState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<PokemonState> mapEventToState(PokemonEvent event) async* {
    if (event is PokemonsFetched) {
      yield await _mapPostFetchedToState(state, event.query, event.page);
    }
  }

  Future<PokemonState> _mapPokemonFavoriteRehydrate(
      PokemonState state, List<String> favorites) async {
    try {
      return state.copyWith(favorites: favorites);
    } catch (e) {
      return state;
    }
  }

  Future<PokemonState> _mapPokemonFavoriteToState(
      PokemonState state, String id) async {
    List<String> favorites = [...state.favorites];
    print("hi ${state.favorites}");
    try {
      print(favorites.contains(id));
      if (favorites.contains(id)) {
        print("yes");
        favorites.removeWhere((element) => element == id);
      } else {
        print("add");
        favorites.add(id);
      }
      print("hi 2 $favorites");

      return state.copyWith(favorites: favorites);
    } catch (e) {
      return state;
    }
  }

  Future<PokemonState> _mapPostFetchedToState(
      PokemonState state, String query, int page) async {
    if (state.hasReachedMax && query == state.query) return state;

    try {
      if (state.status == PokemonStatus.initial) {
        final pokemons = await _fetchPokemons(query, page);
        return state.copyWith(
            status: PokemonStatus.success,
            page: pokemons['count'] > 0 ? page : state.page,
            totalCount: pokemons['totalCount'],
            query: query,
            pokemons: [...state.pokemons, ...pokemons['pokemonsToAdd']],
            hasReachedMax: false);
      }
      final pokemons = await _fetchPokemons(query, page);
      return pokemons.isEmpty
          ? state.copyWith(
              status: PokemonStatus.loading,
              hasReachedMax: true,
              page: page,
              query: query,
            )
          : state.copyWith(
              status: PokemonStatus.success,
              page: pokemons['count'] > 0 ? page : state.page,
              query: query,
              totalCount: pokemons['totalCount'],
              pokemons: query == state.query
                  ? [...state.pokemons, ...pokemons['pokemonsToAdd']]
                  : pokemons['pokemonsToAdd'],
              hasReachedMax: false,
            );
    } on Exception {
      return state.copyWith(status: PokemonStatus.failure);
    }
  }

  Future<Map<String, dynamic>> _fetchPokemons(String query, int page) async {
    final dynamic response = await getPokemons(query, page);
    List<PokemonPreview> pokemonsToAdd = [];
    response['data'].forEach((pokemon) {
      pokemonsToAdd.add(PokemonPreview(
          id: pokemon['id'],
          name: pokemon['name'],
          imageUrl: pokemon['images']['small']));
    });
    return {
      "pokemonsToAdd": pokemonsToAdd,
      "totalCount": response['totalCount'],
      "count": response['count']
    };
  }
}
