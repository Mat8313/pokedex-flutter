import 'package:http/http.dart' as http;

import 'dart:convert';

import '../models/pokemon.dart';
import '../models/pokemon_detail.dart';
import '../models/pokemon_forms.dart';
import '../models/pokedex_entry.dart';

class PokeApiService {
  final http.Client client;
  PokeApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Pokemon>> fetchPokemonList(int limit, int offset) async {
    final url = Uri.parse(
      'https://pokeapi.co/api/v2/pokemon?limit=$limit&offset=$offset',
    );
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

    if (response.statusCode == 200) {
      final List varieties = jsonDecode(response.body)['varieties'];
      final alternateForms = varieties
          .where(
            (v) =>
                v['is_default'] == false &&
                !(v['pokemon']['name'].contains('mega') ||
                    v['pokemon']['name'].contains('gmax')),
          )
          .toList();

      List<PokemonForm> forms = alternateForms
          .map((v) => PokemonForm.fromJson(v))
          .toList();
      return forms;
    } else {
      throw Exception('Erreur lors du chargement des formes');
    }
  }

  /// Version-group qui a introduit la forme, pour dater ses sprites.
  /// L'id attendu est celui de `/pokemon-form`, qui n'est pas celui de
  /// `/pokemon` : il se lit dans le champ `forms` du détail d'un Pokémon.
  Future<String?> fetchFormVersionGroup(int formId) async {
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon-form/$formId');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final versionGroup = jsonDecode(response.body)['version_group'];
      return versionGroup == null ? null : versionGroup['name'] as String?;
    } else {
      throw Exception('Erreur lors du chargement de la forme');
    }
  }

  Future<List<PokemonForm>> fetchPokemonTransformation(int id) async {
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon-species/$id');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final List varieties = jsonDecode(response.body)['varieties'];
      final transformationForm = varieties
          .where(
            (v) =>
                v['is_default'] == false &&
                (v['pokemon']['name'].contains('mega') ||
                    v['pokemon']['name'].contains('gmax')),
          )
          .toList();

      List<PokemonForm> forms = transformationForm
          .map((v) => PokemonForm.fromJson(v))
          .toList();
      return forms;
    } else {
      throw Exception('Erreur lors du chargement des formes');
    }
  }

  /// Les entrées d'un Pokédex régional, triées par numéro.
  ///
  /// Un seul appel suffit : contrairement aux sprites, l'endpoint renvoie tout
  /// le Pokédex d'un coup. Le tri n'est pas décoratif — l'API rend les entrées
  /// dans l'ordre aujourd'hui, mais rien ne le garantit.
  Future<List<PokedexEntry>> fetchPokedexEntries(String pokedexName) async {
    final url = Uri.parse('https://pokeapi.co/api/v2/pokedex/$pokedexName');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final List entries = jsonDecode(response.body)['pokemon_entries'];

      return entries.map((entry) => PokedexEntry.fromJson(entry)).toList()
        ..sort((a, b) => a.entryNumber.compareTo(b.entryNumber));
    } else {
      throw Exception('Erreur lors du chargement du Pokédex $pokedexName');
    }
  }
}
