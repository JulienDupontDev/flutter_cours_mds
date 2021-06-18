import 'dart:async';
import 'dart:convert';

import 'package:flutter_cours/models/pokemon_preview.dart';
import 'package:flutter_cours/screens/pokemon/blocs/bloc.dart';
import 'package:http/http.dart' as http;

class PokemonQueryBloc implements Bloc {
  final _controller = StreamController<List<PokemonPreview>>();
  // final _client = ZomatoClient();
  Stream<List<PokemonPreview>> get locationStream => _controller.stream;

  void submitQuery(String query) async {
    String defaultPageSize = "10";
    final response = await http.get(
        Uri.parse(
            'https://api.pokemontcg.io/v2/cards?q=supertype:pokemon ${query.length > 0 ? "name:$query" : ""}&pageSize=$defaultPageSize'),
        headers: {"x-api-key": "99050b19-8ce8-4901-acbf-0858d56469ec"});
    final converted = jsonDecode(response.body);
    List<PokemonPreview> pokemonsToAdd = [];
    // print();
    converted['data'].forEach((pokemon) {
      pokemonsToAdd.add(PokemonPreview(
          id: pokemon['id'],
          name: pokemon['name'],
          imageUrl: pokemon['images']['small']));
    });

    _controller.sink.add(pokemonsToAdd);
  }

  @override
  void dispose() {
    _controller.close();
  }
}
