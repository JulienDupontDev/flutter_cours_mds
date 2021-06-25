import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cours/models/pokemon_detailed.dart';
import 'package:flutter_cours/screens/pokemon/blocs/favorites/favorites_bloc.dart';
import 'package:flutter_cours/screens/pokemon/blocs/theme.dart';
import 'package:flutter_cours/screens/pokemon/pokemon_api_client.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PokemonDetailsView extends StatefulWidget {
  const PokemonDetailsView({Key? key, required this.pokemonId})
      : super(key: key);
  final String pokemonId;
  @override
  _PokemosDetailsViewState createState() =>
      _PokemosDetailsViewState(this.pokemonId);
}

class _PokemosDetailsViewState extends State<PokemonDetailsView> {
  bool _isLoading = true;
  final String pokemonId;
  late Future<Map<String, dynamic>> _data;

  late FavoritesBloc _favoritesBloc;
  late Future<List<String>?> _favorites;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  _PokemosDetailsViewState(this.pokemonId);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _data = fetchData();
    _favoritesBloc = context.read<FavoritesBloc>();
    _favorites = _prefs.then((SharedPreferences prefs) {
      return prefs.getStringList("favorites");
    });
  }

  Future<Map<String, dynamic>> fetchData() async {
    return getPokemonDetails(pokemonId).then((value) {
      return value['data'];
    });
  }

  void stopLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      Theme(
          data: PokemonsTheme().theme,
          child: FutureBuilder(
              future: Future.wait([_data, _favorites]),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                return _body(snapshot);
              }));

  Widget _body(AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator()]),
        ],
      );
    }
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
        return Center(
          child: Text(
            snapshot.error.toString(),
            style: TextStyle(fontSize: 18),
          ),
        );
      }
      return BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, state) {
        return Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(snapshot.data[0]['images']['large']),
                  fit: BoxFit.cover,
                  colorFilter: new ColorFilter.mode(
                      Colors.black.withOpacity(0.5), BlendMode.dstATop),
                ),
              ),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: header(snapshot.data[0], state),
                  ),
                  Inner(snapshot.data[0], context),
                ]),
              ),
            ));
      });
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [CircularProgressIndicator()]),
      ],
    );
  }

  Future<void> _setFavorite(favorites, isFavorite) async {
    final SharedPreferences prefs = await _prefs;
    try {
      _favoritesBloc.add(PokemonFavorite(id: widget.pokemonId));

      if (prefs.getStringList("favorites")!.contains(widget.pokemonId)) {
        favorites!.removeWhere((element) => element == widget.pokemonId);
        prefs.setStringList("favorites", favorites);
      } else {
        prefs.setStringList("favorites",
            [...?prefs.getStringList("favorites"), this.widget.pokemonId]);
      }
    } catch (e) {}
  }

  Widget header(data, FavoritesState state) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(flex: 9, child: Text(data['flavorText'] ?? "Pokémon")),
          Expanded(
            flex: 1,
            child: IconButton(
              color: Colors.yellow[600],
              iconSize: 30,
              splashRadius: 20,
              icon: Icon(state.favorites.contains(widget.pokemonId)
                  ? Icons.star
                  : Icons.star_border),
              onPressed: () => _setFavorite(
                  data[1], state.favorites.contains(widget.pokemonId)),
            ),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }
}

Widget Inner(data, context) {
  return Container(
    height: 1000,
    width: MediaQuery.of(context).size.width,
    child: Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              data['name'],
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.blueGrey),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 5),
                  width: 200,
                  child: LinearProgressIndicator(
                    value: double.parse(data['hp']),
                    backgroundColor: Colors.white,
                  ),
                ),
                Text("${data['hp']} HP"),
                Container(
                  height: 10,
                ),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            data['id'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.blueGrey),
                          ),
                          Text(
                            'ID',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.grey[400]),
                          )
                        ],
                      ),
                      VerticalDivider(
                        thickness: 1,
                        color: Colors.grey[300],
                      ),
                      Column(
                        children: [
                          Text(
                            data['level'] ?? " ? ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.blueGrey),
                          ),
                          Text(
                            'LEVEL',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.grey[400]),
                          )
                        ],
                      ),
                      VerticalDivider(
                        thickness: 1,
                        color: Colors.grey[300],
                      ),
                      Column(
                        children: [
                          Text(
                            data['number'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.blueGrey),
                          ),
                          Text(
                            'NUMBER',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.grey[400]),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Divider(
                  thickness: 2,
                  color: Colors.grey[300],
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("${data['name']}'s attacks"),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ...data['attacks'].map((attack) {
                        return Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Text(attack['name']),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Visibility(
                                  visible: attack['damage'] != "",
                                  child: LinearProgressIndicator(
                                    backgroundColor: Colors.white,
                                    minHeight: 10,
                                    value: 10.0,
                                  )),
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            Text(attack['damage'])
                          ],
                        );
                      })
                    ],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Set : "),
                ListTile(
                  visualDensity: VisualDensity.comfortable,
                  tileColor: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  leading: Image.network(data['set']['images']['symbol']),
                  title: Text(
                    data['set']['name'],
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  subtitle: Text("id : ${data['set']['id']}"),
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}
