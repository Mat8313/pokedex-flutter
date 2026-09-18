import 'package:http/http.dart' as http;

import 'dart:convert';

import '../models/pokemon.dart';
import '../models/pokemon_detail.dart';
import '../models/pokemon_forms.dart';

class PokeApiService {
  final http.Client client; 
  PokeApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Pokemon>> fetchPokemonList(int limit, int offset) async {
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=$limit&offset=$offset');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];

      return List.generate(results.length, (index) {
        return Pokemon.fromJson(results[index], index + offset + 1);
      });
    } else {
      throw Exception('Erreur lors du chargement de la liste');
    }
  }

  // Méthode pour récupérer les détails via l'ID.
  Future<PokemonDetail> fetchPokemonDetails(int id) async {
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$id');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      return PokemonDetail.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erreur lors du chargement des détails');
    }
  }

  Future<List<PokemonForm>> fetchPokemonForm(int id) async {
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon-species/$id');
    final response = await client.get(url);

    if (response.statusCode == 200 ){
      final List varieties = jsonDecode(response.body)['varieties'];
      final alternateForms = varieties.where((v) => v['is_default'] == false && !(v['pokemon']['name'].contains('mega') || v['pokemon']['name'].contains('gmax'))).toList();

      
      List<PokemonForm> forms = alternateForms.map((v) => PokemonForm.fromJson(v)).toList();
      return forms; 
    } else {
      throw Exception('Erreur lors du chargement des formes');
    }
    
  }

  Future<List<PokemonForm>> fetchPokemonTransformation(int id) async {
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon-species/$id');
    final response = await client.get(url);

    if (response.statusCode == 200 ){
      final List varieties = jsonDecode(response.body)['varieties'];
      final transformationForm = varieties.where((v) => v['is_default'] == false && (v['pokemon']['name'].contains('mega') || v['pokemon']['name'].contains('gmax'))).toList();
      
      
      List<PokemonForm> forms = transformationForm.map((v) => PokemonForm.fromJson(v)).toList();
      return forms; 
    } else {
      throw Exception('Erreur lors du chargement des formes');
    }
    
  }
}
