import 'dart:convert';

import 'package:http/http.dart' as http;

Future<dynamic> getPokemons(String query, int page) async {
  String defaultPageSize = "10";

  Uri uri = Uri.parse(
      "https://api.pokemontcg.io/v2/cards?q=supertype:pokemon ${query.length > 0 ? 'name:' + (query.contains(' ') ? '"$query"' : query) : ''}&pageSize=10&page=$page");
  final response = await http
      .get(uri, headers: {"x-api-key": "99050b19-8ce8-4901-acbf-0858d56469ec"});
  try {
    final converted = jsonDecode(response.body);
    return converted;
  } catch (e) {
    return null;
  }
}

Future<dynamic> getPokemonDetails(String id) async {
  Uri uri = Uri.parse("https://api.pokemontcg.io/v2/cards/$id");
  final response = await http
      .get(uri, headers: {"x-api-key": "99050b19-8ce8-4901-acbf-0858d56469ec"});
  try {
    final converted = jsonDecode(response.body);
    return converted;
  } catch (e) {
    return null;
  }
}
