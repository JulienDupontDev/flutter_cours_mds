import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cours/models/pokemon_preview.dart';
import 'package:flutter_cours/screens/pokemon/blocs/pokemons_data/pokemon_bloc.dart';
import 'package:flutter_cours/screens/pokemon/blocs/theme.dart';
import 'package:flutter_cours/screens/pokemon/favorites_page.dart';
import 'package:flutter_cours/screens/pokemon/widgets/pokemon_list.dart';
import 'package:flutter_cours/screens/pokemon/widgets/pokemon_preview.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cours/screens/pokemon/widgets/search_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blocs/favorites/favorites_bloc.dart';

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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _favorites = _prefs.then((SharedPreferences prefs) {
      return prefs.getStringList("favorites");
    });
    _init();
    throw Exception("This is a crash!");
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
      context.read<PokemonBloc>().add(PokemonsFetched());

      if (favorites == null) {
        prefs.setStringList("favorites", []);
      }
      context.read<FavoritesBloc>().add(PokemonFavoritesRehydrate(
          favorites: favorites == null ? [] : [...favorites]));
      // _pokemonBloc.add(PokemonFavoritesRehydrate(favorites: favorites));
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: PokemonsTheme().theme,
      child: FutureBuilder(
          future: _favorites,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const CircularProgressIndicator();
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return BlocBuilder<FavoritesBloc, FavoritesState>(
                      builder: (context, state) {
                    return Scaffold(
                        appBar: AppBar(
                            title: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                              Text("Pokemons api"),
                              IconButton(
                                  tooltip: "Favorites",
                                  splashRadius: 20,
                                  onPressed: () => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    BlocProvider.value(
                                                        value: BlocProvider.of<
                                                                FavoritesBloc>(
                                                            context),
                                                        child:
                                                            FavoritePokemons())))
                                      },
                                  icon: Icon(Icons.star))
                            ])),
                        body: SingleChildScrollView(
                          child: Column(children: [SearchBar(), PokemonList()]),
                        ));
                  });
                }
            }
          }),
    );
  }
}
