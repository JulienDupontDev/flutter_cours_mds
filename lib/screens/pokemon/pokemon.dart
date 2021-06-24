import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cours/models/pokemon_preview.dart';
import 'package:flutter_cours/screens/pokemon/blocs/pokemons_data/pokemon_bloc.dart';
import 'package:flutter_cours/screens/pokemon/widgets/pokemon_list.dart';
import 'package:flutter_cours/screens/pokemon/widgets/pokemon_preview.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cours/screens/pokemon/widgets/search_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pokemons extends StatefulWidget {
  const Pokemons({Key? key}) : super(key: key);

  @override
  _PokemonsState createState() => _PokemonsState();
}

class _PokemonsState extends State<Pokemons>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<List<String>?> _favorites;
  late PokemonBloc _pokemonBloc;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _favorites = _prefs.then((SharedPreferences prefs) {
      return prefs.getStringList("favorites");
    });
    _pokemonBloc = context.read<PokemonBloc>();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _init() async {
    final SharedPreferences prefs = await _prefs;

    try {
      List<String> favorites = prefs.getStringList("favorites") as List<String>;
      print(prefs.getStringList("favorites"));
      _pokemonBloc.add(PokemonsFetched());
      // _pokemonBloc.add(PokemonFavoritesRehydrate(favorites: favorites));
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _favorites,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      title: Text("Pokemons api"),
                    ),
                    body: BlocBuilder<PokemonBloc, PokemonState>(
                        builder: (context, state) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [SearchBar(), PokemonList()],
                        ),
                      );
                    }));
              }
          }
        });
  }
}
