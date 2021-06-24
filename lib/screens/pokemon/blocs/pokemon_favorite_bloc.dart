// import 'dart:async';
// import 'dart:convert';

// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter_cours/models/pokemon_preview.dart';
// import 'package:flutter_cours/screens/pokemon/pokemon_api_client.dart';
// import 'package:http/http.dart' as http;
// import 'package:rxdart/rxdart.dart';

// part 'pokemon_event.dart';
// part 'pokemon_state.dart';

// class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
//   PokemonBloc(PokemonState initialState) : super(initialState);

//   @override
//   Stream<Transition<PokemonEvent, PokemonState>> transformEvents(
//     Stream<PokemonEvent> events,
//     TransitionFunction<PokemonEvent, PokemonState> transitionFn,
//   ) {
//     return super.transformEvents(
//       events.debounceTime(const Duration(milliseconds: 100)),
//       transitionFn,
//     );
//   }

//   @override
//   Stream<PokemonState> mapEventToState(PokemonEvent event) async* {
//     print("state $state");

//     if (event is PokemonFavorite) {
//       yield await _mapPokemonFavoriteToState(state, event.id);
//     }
//   }

//   Future<PokemonState> _mapPokemonFavoriteToState(
//       PokemonState state, String id) async {
//     List<String> favorites = [...state.favorites];
//     print("hi ${state.favorites}");
//     print(favorites.contains(id));
//     if (favorites.contains(id)) {
//       print("yes");
//       favorites.removeWhere((element) => element == id);
//     } else {
//       print("add");
//       favorites.add(id);
//     }
//     print("hi 2 $favorites");

//     return state.copyWith(favorites: favorites);
//   }
// }
