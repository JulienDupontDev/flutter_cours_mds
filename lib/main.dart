// @dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cours/screens/exo_1/exo1.dart';
import 'package:flutter_cours/screens/exo_2/login.dart';
import 'package:flutter_cours/screens/exo_2/todos.dart';
import 'package:flutter_cours/screens/home_page/home.dart';
import 'package:flutter_cours/screens/pokemon/blocs/favorites/favorites_bloc.dart';
import 'package:flutter_cours/screens/pokemon/blocs/pokemons_data/pokemon_bloc.dart';
import 'package:flutter_cours/screens/pokemon/pokemon.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showSemanticsDebugger: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => HomePage(title: "Page d'accueil"),
        "/exo1": (context) => Exo1(title: "Exercice 1"),
        "/exo2": (context) => Login(title: "Exercice Sign in"),
        "/exo2/todos": (context) => Todos(title: "Exercice Todos"),
        "/pokemon": (context) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => PokemonBloc()),
                BlocProvider(create: (_) => FavoritesBloc())
              ],
              child: Pokemons(),
            )
      },
    );
  }
}
