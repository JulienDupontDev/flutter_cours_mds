import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cours/models/pokemon_preview.dart';
import 'package:flutter_cours/screens/pokemon/pokemon_details_view.dart';

class PokemonPreviewCard extends StatelessWidget {
  const PokemonPreviewCard({Key? key, required this.pokemon}) : super(key: key);

  final PokemonPreview pokemon;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PokemonDetailsView(
                      pokemonId: pokemon.id,
                    ))),
        child: Card(
          elevation: 6,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(pokemon.name)],
                ),
              ),
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: pokemon.imageUrl,
                  imageBuilder: (context, imageProvider) => Container(
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
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                flex: 5,
              )
            ],
          ),
        ),
      ),
    );
  }
}
