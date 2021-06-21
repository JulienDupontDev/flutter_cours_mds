import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cours/models/pokemon_preview.dart';
import 'package:flutter_cours/screens/pokemon/blocs/pokemon_bloc.dart';
import 'package:flutter_cours/screens/pokemon/widgets/pokemon_list.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Pokemons api"),
        ),
        body: BlocProvider(
          create: (_) =>
              PokemonBloc(httpClient: http.Client())..add(PokemonsFetched()),
          child: SingleChildScrollView(
            child: Column(
              children: [SearchBar(), PokemonList()],
            ),
          ),
        ));
  }
}
