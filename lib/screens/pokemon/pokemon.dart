import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

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
  List<Pokemon> pokemons = [];
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
      body: SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
