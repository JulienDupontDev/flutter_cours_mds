import 'package:flutter/material.dart';

class PokemonsTheme {
  ThemeData get theme => ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey,
        textTheme: TextTheme(
            subtitle1: TextStyle(
                color: Colors.blueGrey, decoration: TextDecoration.none)),
        primarySwatch: Colors.blueGrey,
        accentColor: Colors.blueGrey,
        inputDecorationTheme: const InputDecorationTheme(
            hintStyle: TextStyle(color: Colors.blueGrey),
            labelStyle: TextStyle(color: Colors.blueGrey)),
        // textTheme: _textTheme,
        iconTheme: IconThemeData(color: Colors.blueGrey),
        cardColor: Color(0xff313A49),
        appBarTheme: AppBarTheme(color: Colors.blueGrey, elevation: 1),
      );
}
