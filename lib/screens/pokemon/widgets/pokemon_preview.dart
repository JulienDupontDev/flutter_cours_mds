import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cours/models/pokemon_preview.dart';
import 'package:flutter_cours/screens/pokemon/blocs/favorites/favorites_bloc.dart';
import 'package:flutter_cours/screens/pokemon/blocs/pokemons_data/pokemon_bloc.dart';
import 'package:flutter_cours/screens/pokemon/pokemon_details_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PokemonPreviewCard extends StatefulWidget {
  const PokemonPreviewCard({Key? key, required this.pokemon}) : super(key: key);
  final PokemonPreview pokemon;
  @override
  _PokemonPreviewCardState createState() => _PokemonPreviewCardState();
}

class _PokemonPreviewCardState extends State<PokemonPreviewCard> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<List<String>?> _favorites;
  late FavoritesBloc _favoritesBloc;

  @override
  void initState() {
    super.initState();
    _favoritesBloc = context.read<FavoritesBloc>();
    _favorites = _prefs.then((SharedPreferences prefs) {
      return prefs.getStringList("favorites");
    });
  }

  Future<void> _setFavorite(favorites, isFavorite) async {
    final SharedPreferences prefs = await _prefs;
    // print("is favorite $isFavorite");
    try {
      _favoritesBloc.add(PokemonFavorite(id: widget.pokemon.id));

      if (isFavorite) {
        favorites!.removeWhere((element) => element == widget.pokemon.id);
        prefs.setStringList("favorites", favorites);
      } else {
        prefs.setStringList("favorites",
            [...?prefs.getStringList("favorites"), this.widget.pokemon.id]);
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _favorites,
        builder: (BuildContext context, AsyncSnapshot<List<String>?> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return BlocBuilder<FavoritesBloc, FavoritesState>(
                    builder: (context, state) {
                  return Container(
                    margin: const EdgeInsets.all(20),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PokemonDetailsView(
                                    pokemonId: widget.pokemon.id,
                                  ))),
                      child: Card(
                        elevation: 6,
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(widget.pokemon.name),
                                  IconButton(
                                      splashRadius: 20.0,
                                      onPressed: () => _setFavorite(
                                          [...state.favorites],
                                          state.favorites
                                              .contains(widget.pokemon.id)),
                                      icon: Icon(state.favorites
                                              .contains(widget.pokemon.id)
                                          ? Icons.star
                                          : Icons.star_outline))
                                ],
                              ),
                            ),
                            Expanded(
                              child: CachedNetworkImage(
                                imageUrl: widget.pokemon.imageUrl,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.contain,
                                        colorFilter: ColorFilter.mode(
                                            Colors.red, BlendMode.colorBurn)),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                              flex: 5,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
              }
          }
        });
  }
}
