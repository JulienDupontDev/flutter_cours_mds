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
  PokemonBloc({required this.httpClient}) : super(const PokemonState());

  final http.Client httpClient;

  @override
  Stream<Transition<PokemonEvent, PokemonState>> transformEvents(
    Stream<PokemonEvent> events,
    TransitionFunction<PokemonEvent, PokemonState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 100)),
      transitionFn,
    );
  }

  @override
  Stream<PokemonState> mapEventToState(PokemonEvent event) async* {
    if (event is PokemonsFetched) {
      yield await _mapPostFetchedToState(state, event.query, event.page);
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
    if (response == null) throw Exception('error fetching pokemons');
    List<PokemonPreview> pokemonsToAdd = [];
    // print();
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

    throw Exception('error fetching pokemons');
  }
}
