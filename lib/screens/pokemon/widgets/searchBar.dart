import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key, required this.fetchPokemons}) : super(key: key);
  final Function(String) fetchPokemons;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: fetchPokemons,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: "Search pokemon",
          hintStyle: TextStyle(color: Colors.blue),
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white))),
    );
  }
}
