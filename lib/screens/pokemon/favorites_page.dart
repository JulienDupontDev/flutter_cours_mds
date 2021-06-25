import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cours/models/pokemon_preview.dart';
import 'package:flutter_cours/screens/pokemon/blocs/favorites/favorites_bloc.dart';
import 'package:flutter_cours/screens/pokemon/blocs/theme.dart';
import 'package:flutter_cours/screens/pokemon/pokemon_api_client.dart';
import 'package:flutter_cours/screens/pokemon/widgets/pokemon_preview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritePokemons extends StatefulWidget {
  const FavoritePokemons({Key? key}) : super(key: key);
  @override
  _FavoritePokemonsState createState() => _FavoritePokemonsState();
}

class _FavoritePokemonsState extends State<FavoritePokemons> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<List<String>?> _favorites;
  List<PokemonPreview> _pokemons = [];

  @override
  void initState() {
    super.initState();
    _favorites = _prefs.then((SharedPreferences prefs) {
      return prefs.getStringList("favorites");
    });
    // _favoritesBloc = context.read<FavoritesBloc>();

    _init();
  }

  Future<void> _init() async {
    final SharedPreferences prefs = await _prefs;

    try {
      List<String> favorites = prefs.getStringList("favorites") as List<String>;
      context
          .read<FavoritesBloc>()
          .add(FavoritePokemonsFetch(favorites: favorites));

      // List<PokemonPreview> pokemonsToAdd = [];

      // favorites.forEach((id) async {
      //   final dynamic response = await getPokemonDetails(id);
      //   if (response == null) return;
      //   var pokemon = response['data'];
      //   setState(() {
      //     _pokemons = [
      //       ..._pokemons,
      //       PokemonPreview(
      //           id: pokemon['id'],
      //           name: pokemon['name'],
      //           imageUrl: pokemon['images']['small'])
      //     ];
      //   });
      // });

      // _pokemonBloc.add(PokemonFavoritesRehydrate(favorites: favorites));
    } catch (e) {}
  }

  final FavoritesBloc _favoritesBloc = FavoritesBloc();

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
                                Text("Your favorites pokemons"),
                              ])),
                          body: Column(
                            children: [
                              Expanded(
                                  child: GridView.count(
                                childAspectRatio: 2 / 3,
                                crossAxisCount: 2,
                                children: [
                                  ...state.favoritePokemonsPreviews
                                      .map((pokemon) {
                                    return PokemonPreviewCard(pokemon: pokemon);
                                  })
                                ],
                              ))
                            ],
                          ));
                    },
                  );
                }
            }
          }),
    );
  }
}
