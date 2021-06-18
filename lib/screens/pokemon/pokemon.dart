import 'dart:convert';
import 'package:flutter_cours/models/pokemon_preview.dart';
import 'package:flutter_cours/screens/pokemon/widgets/pokemon_preview.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cours/screens/pokemon/widgets/search_bar.dart';

class Pokemons extends StatefulWidget {
  const Pokemons({Key? key}) : super(key: key);

  @override
  _PokemonsState createState() => _PokemonsState();
}

class Pokemon {
  String id,
      name,
      smallPicture,
      bigPicture,
      evolvesFrom,
      level,
      hp,
      number,
      artist,
      rarity;
  int convertedRetreatCost;
  List<String> subTypes, types, retreatCost;
  Map images;
  Pokemon(
      {required this.id,
      required this.name,
      required this.smallPicture,
      required this.bigPicture,
      required this.evolvesFrom,
      required this.level,
      required this.hp,
      required this.number,
      required this.artist,
      required this.rarity,
      required this.convertedRetreatCost,
      required this.subTypes,
      required this.types,
      required this.retreatCost,
      required this.images});
  //modeles a creer : abilities, attacks, weekness, ressistances, tcgplayer

}

class _PokemonsState extends State<Pokemons>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<PokemonPreview> _pokemons = [];
  int _page = 1;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void fetchPokemons(String query) async {
    String defaultPageSize = "10";
    final response = await http.get(
        Uri.parse(
            'https://api.pokemontcg.io/v2/cards?q=supertype:pokemon ${query.length > 0 ? "name:$query" : ""}&page=$_page&pageSize=$defaultPageSize'),
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
    setState(() {
      _pokemons = pokemonsToAdd;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Pokemons api"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SearchBar(fetchPokemons: fetchPokemons),
            Container(
                height: 400,
                child: GridView.count(
                  crossAxisCount: 2,
                  children: [
                    ..._pokemons
                        .map((pokemon) => PokemonPreviewCard(pokemon: pokemon))
                        .toList()
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
