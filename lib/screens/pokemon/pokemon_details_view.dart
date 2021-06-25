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
  late Map<String, dynamic> data;

  _PokemosDetailsViewState(this.pokemonId);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<dynamic> fetchData() {
    return getPokemonDetails(widget.pokemonId).then((value) {
      setState(() {
        if (value != null) {
          data = value['data'];
          _isLoading = false;
        }
      });
      return true;
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
              future: fetchData(),
              builder: (context, snapshot) {
                return Scaffold(
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerFloat,
                    floatingActionButton: FloatingActionButton(
                      child: Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    body: !snapshot.hasData
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [CircularProgressIndicator()]),
                            ],
                          )
                        : snapshot.error != null
                            ? Text("Herro")
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(data['images']['large']),
                                    fit: BoxFit.cover,
                                    colorFilter: new ColorFilter.mode(
                                        Colors.black.withOpacity(0.5),
                                        BlendMode.dstATop),
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.3,
                                          child: header(data),
                                        ),
                                        Inner(data, context),
                                      ]),
                                ),
                              ));
              }));
}

Widget header(data) {
  // print("is favotite $isFavorite");
  return BlocBuilder<FavoritesBloc, FavoritesState>(
      bloc: FavoritesBloc(),
      builder: (context, state) {
        print(state);
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(flex: 9, child: Text(data['flavorText'] ?? "Pokémon")),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(Icons.star_border),
                  onPressed: () {},
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
        );
      });
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
