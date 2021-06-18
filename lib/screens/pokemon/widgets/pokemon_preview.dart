import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cours/models/pokemon_preview.dart';

class PokemonPreviewCard extends StatelessWidget {
  const PokemonPreviewCard({Key? key, required this.pokemon}) : super(key: key);

  final PokemonPreview pokemon;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () => print('open${pokemon.id}'),
        child: Card(
          elevation: 6,
          child: Column(
            children: [
              Expanded(
                child: Text(pokemon.name),
                flex: 1,
              ),
              Expanded(
                child: Image.network(
                  pokemon.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(child: Text('Loading...'));
                  },
                ),
                flex: 8,
              )
            ],
          ),
        ),
      ),
    );
  }
}
