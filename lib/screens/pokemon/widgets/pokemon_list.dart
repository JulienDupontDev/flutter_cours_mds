import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cours/screens/pokemon/blocs/favorites/favorites_bloc.dart';
import 'package:flutter_cours/screens/pokemon/blocs/pokemons_data/pokemon_bloc.dart';
import 'package:flutter_cours/screens/pokemon/widgets/pokemon_preview.dart';

class PokemonList extends StatefulWidget {
  const PokemonList({Key? key}) : super(key: key);

  @override
  _PokemonListState createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  late PokemonBloc _pokemonBloc;
  final _scrollController = ScrollController();
  bool _isVisible = false;
  @override
  void initState() {
    super.initState();
    _pokemonBloc = context.read<PokemonBloc>();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    setState(() => _isVisible = _scrollController.hasClients &&
        _scrollController.offset > MediaQuery.of(context).size.height * 0.1);
    if (_isBottom)
      _pokemonBloc.add(PokemonsFetched(
          query: _pokemonBloc.state.query, page: _pokemonBloc.state.page + 1));
  }

  Future<void> refresh() async {
    _pokemonBloc.add(PokemonsRefresh(query: _pokemonBloc.state.query, page: 1));
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    return (_scrollController.position.maxScrollExtent * 0.7) <
        _scrollController.position.pixels;
    // final currentScroll = _scrollController.offset;
    // print("max wanted :  ${maxScroll * 0.5}");
    // print("current $currentScroll");
    // return currentScroll >= (maxScroll * 0.2);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonBloc, PokemonState>(builder: (context, state) {
      switch (state.status) {
        case PokemonStatus.failure:
          return const Center(child: Text('failed to fetch pokemons'));
        case PokemonStatus.success:
          if (state.pokemons.isEmpty) {
            return const Center(child: Text('no pokemons'));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(_pokemonBloc.state.totalCount > 0
                  ? "${_pokemonBloc.state.totalCount.toString()} results"
                  : ""),
              Container(
                height: MediaQuery.of(context).size.height - 160,
                child: Stack(children: [
                  RefreshIndicator(
                    onRefresh: refresh,
                    child: GridView.count(
                      controller: _scrollController,
                      crossAxisCount: 2,
                      childAspectRatio: 2 / 3,
                      children: [
                        ...state.pokemons
                            .map((pokemon) =>
                                PokemonPreviewCard(pokemon: pokemon))
                            .toList()
                      ],
                    ),
                  ),
                  Visibility(
                    child: Positioned(
                        bottom: 0,
                        right: 5.0,
                        child: FloatingActionButton(
                            onPressed: () => _scrollController.animateTo(0.0,
                                duration: Duration(seconds: 2),
                                curve: Curves.linearToEaseOut),
                            child: Icon(Icons.arrow_upward_outlined))),
                    visible: _isVisible,
                  ),
                ]),
              ),
            ],
          );
        default:
          return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [CircularProgressIndicator()],
                ),
              ]);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
