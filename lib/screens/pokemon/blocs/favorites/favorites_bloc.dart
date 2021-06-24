import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(const FavoritesState());

  @override
  Stream<Transition<FavoritesEvent, FavoritesState>> transformEvents(
    Stream<FavoritesEvent> events,
    TransitionFunction<FavoritesEvent, FavoritesState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<FavoritesState> mapEventToState(FavoritesEvent event) async* {
    if (event is PokemonFavorite) {
      yield await _mapPokemonFavoriteToState(state, event.id);
    }

    if (event is PokemonFavoritesRehydrate) {
      yield await _mapPokemonFavoriteRehydrate(state, event.favorites);
    }
  }

  Future<FavoritesState> _mapPokemonFavoriteRehydrate(
      FavoritesState state, List<String> favorites) async {
    try {
      return state.copyWith(favorites: favorites);
    } catch (e) {
      return state;
    }
  }

  Future<FavoritesState> _mapPokemonFavoriteToState(
      FavoritesState state, String id) async {
    List<String> favorites = [...state.favorites];
    print("hi ${state.favorites}");
    try {
      print(favorites.contains(id));
      if (favorites.contains(id)) {
        print("yes");
        favorites.removeWhere((element) => element == id);
      } else {
        print("add");
        favorites.add(id);
      }
      print("hi 2 $favorites");

      return state.copyWith(favorites: favorites);
    } catch (e) {
      return state;
    }
  }
}
