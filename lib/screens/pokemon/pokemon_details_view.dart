import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cours/models/pokemon_detailed.dart';
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
    getPokemonDetails(widget.pokemonId).then((value) {
      setState(() {
        if (value != null) {
          data = value['data'];
          _isLoading = false;
        }
      });
    });
  }

  void stopLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          child: Visibility(
              visible: _isLoading,
              child: LinearProgressIndicator(
                color: Colors.orange,
              )),
          preferredSize: Size.fromHeight(1),
        ),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: _isLoading
            ? Text("Loading")
            : Text("#${data['number']} - ${data['name']}"),
      ),
      body: Stack(children: [
        Opacity(
            opacity: 0.3,
            child: CachedNetworkImage(
              imageUrl: data['images']['large'],
              imageBuilder: (context, imageProvider) => Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      repeat: ImageRepeat.noRepeat,
                      colorFilter:
                          ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
                ),
              ),
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
            )),
        SingleChildScrollView(
            child: !_isLoading ? Inner(data) : Text("Fetching data")),
      ]),
    );
  }
}

Widget Inner(data) {
  return Column(
    children: [
      Row(
        children: [
          Container(
            width: 100,
            child: LinearProgressIndicator(
              value: double.parse(data['hp']),
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
      Column(
        children: [
          Text("${data['name']}'s attacks"),
          Container(
            height: data['attacks'].length * 150.0,
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(20),
              children: [
                ...data['attacks'].map((attack) {
                  return Card(
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      children: [Text("name: ${attack['name']}")],
                    ),
                  );
                })
              ],
            ),
          ),
        ],
      )
    ],
  );
}
