import 'package:equatable/equatable.dart';

class PokemonPreview extends Equatable {
  String name;
  String imageUrl;
  String id;
  PokemonPreview({
    required this.name,
    required this.imageUrl,
    required this.id,
  });
  @override
  List<Object> get props => [id, imageUrl, id];
}
