import 'package:flutter/material.dart';

class FavoritePokemons extends StatelessWidget {
  const FavoritePokemons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your favorite pokemons'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("currently under development")],
        ),
      ),
    );
  }
}
