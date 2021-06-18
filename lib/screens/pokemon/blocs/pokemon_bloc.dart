import 'dart:async';

import 'package:flutter_cours/models/pokemon_preview.dart';
import 'package:flutter_cours/screens/pokemon/blocs/bloc.dart';

class PokemonBloc implements Bloc {
  List<PokemonPreview> _pokemons = [];
  List<PokemonPreview> get pokemons => _pokemons;

  // 1
  final _pokemonsController = StreamController<List<PokemonPreview>>();

  // 2
  Stream<List<PokemonPreview>> get locationStream => _pokemonsController.stream;

  // 3
  void setPokemons(List<PokemonPreview> pokemons) {
    _pokemons = pokemons;
    _pokemonsController.sink.add(pokemons);
  }

  // 4
  @override
  void dispose() {
    _pokemonsController.close();
  }
}
