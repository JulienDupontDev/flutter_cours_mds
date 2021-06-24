import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cours/screens/pokemon/blocs/pokemons_data/pokemon_bloc.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: BlocBuilder<PokemonBloc, PokemonState>(builder: (context, state) {
        return TextField(
          onChanged: (value) => context
              .read<PokemonBloc>()
              .add(PokemonsFetched(query: value, page: 1)),
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: "Search pokemon",
              hintStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white))),
        );
      }),
    );
  }
}
