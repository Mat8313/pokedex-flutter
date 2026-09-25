import 'package:http/http.dart' as http;

import 'dart:convert';

import '../models/pokemon.dart';
import '../models/pokemon_detail.dart';
import '../models/pokemon_forms.dart';
import '../models/pokedex_entry.dart';
import '../models/pokemon_species.dart';
import 'api_cache.dart';

class PokeApiService {
  final http.Client client;
  final ApiCache cache;

  /// Un réseau mobile peut rester muet sans jamais échouer : passé ce délai,
  /// on abandonne pour laisser place au cache ou au message d'erreur.
  static const Duration timeout = Duration(seconds: 15);

  /// Sans client fourni, le service parle au vrai réseau et garde ses réponses
  /// dans le cache partagé. Un client fourni — celui d'un test — vient sans
  /// cache, sauf à en passer un explicitement.
  PokeApiService({http.Client? client, ApiCache? cache})
    : client = client ?? http.Client(),
      cache =
          cache ??
          (client == null ? PersistentApiCache.shared : const NoApiCache());

  /// Le corps d'une réponse de l'API.
  ///
  /// Une réponse récente en cache est servie sans réseau. Sinon on interroge
  /// l'API, et si elle ne répond pas, une réponse ancienne vaut mieux que rien :
  /// c'est ce qui rend l'application utilisable hors ligne.
  Future<String> _get(Uri url, String errorMessage) async {
    final cached = await cache.read(url);
    if (cached != null && cached.isFresh) return cached.body;

    try {
      final response = await client.get(url).timeout(timeout);
      if (response.statusCode == 200) {
        await cache.write(url, response.body);
        return response.body;
      }
      if (cached != null) return cached.body;
      throw Exception(errorMessage);
    } catch (_) {
      if (cached != null) return cached.body;
      rethrow;
    }
  }

  Future<List<Pokemon>> fetchPokemonList(int limit, int offset) async {
    final url = Uri.parse(
      'https://pokeapi.co/api/v2/pokemon?limit=$limit&offset=$offset',
    );
    final data = jsonDecode(
      await _get(url, 'Erreur lors du chargement de la liste'),
    );
    final List results = data['results'];

    return List.generate(results.length, (index) {
      return Pokemon.fromJson(results[index], index + offset + 1);
    });
  }

  // Méthode pour récupérer les détails via l'ID.
  Future<PokemonDetail> fetchPokemonDetails(int id) async {
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$id');
    final body = await _get(url, 'Erreur lors du chargement des détails');

    return PokemonDetail.fromJson(jsonDecode(body));
  }

  Future<List<PokemonForm>> fetchPokemonForm(int id) async {
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon-species/$id');
    final body = await _get(url, 'Erreur lors du chargement des formes');

    final List varieties = jsonDecode(body)['varieties'];
    return varieties
        .where(
          (v) =>
              v['is_default'] == false &&
              !(v['pokemon']['name'].contains('mega') ||
                  v['pokemon']['name'].contains('gmax')),
        )
        .map((v) => PokemonForm.fromJson(v))
        .toList();
  }

  /// Version-group qui a introduit la forme, pour dater ses sprites.
  /// L'id attendu est celui de `/pokemon-form`, qui n'est pas celui de
  /// `/pokemon` : il se lit dans le champ `forms` du détail d'un Pokémon.
  Future<String?> fetchFormVersionGroup(int formId) async {
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon-form/$formId');
    final body = await _get(url, 'Erreur lors du chargement de la forme');

    final versionGroup = jsonDecode(body)['version_group'];
    return versionGroup == null ? null : versionGroup['name'] as String?;
  }

  Future<List<PokemonForm>> fetchPokemonTransformation(int id) async {
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon-species/$id');
    final body = await _get(url, 'Erreur lors du chargement des formes');

    final List varieties = jsonDecode(body)['varieties'];
    return varieties
        .where(
          (v) =>
              v['is_default'] == false &&
              (v['pokemon']['name'].contains('mega') ||
                  v['pokemon']['name'].contains('gmax')),
        )
        .map((v) => PokemonForm.fromJson(v))
        .toList();
  }

  /// Les entrées d'un Pokédex régional, triées par numéro.
  ///
  /// Un seul appel suffit : contrairement aux sprites, l'endpoint renvoie tout
  /// le Pokédex d'un coup. Le tri n'est pas décoratif — l'API rend les entrées
  /// dans l'ordre aujourd'hui, mais rien ne le garantit.
  Future<List<PokedexEntry>> fetchPokedexEntries(String pokedexName) async {
    final url = Uri.parse('https://pokeapi.co/api/v2/pokedex/$pokedexName');
    final body = await _get(
      url,
      'Erreur lors du chargement du Pokédex $pokedexName',
    );

    final List entries = jsonDecode(body)['pokemon_entries'];
    return entries.map((entry) => PokedexEntry.fromJson(entry)).toList()
      ..sort((a, b) => a.entryNumber.compareTo(b.entryNumber));
  }

  /// Les informations d'espèce : catégorie, description, groupes d'œufs, et le
  /// lien vers la chaîne d'évolution.
  Future<PokemonSpecies> fetchPokemonSpecies(int speciesId) async {
    final url = Uri.parse(
      'https://pokeapi.co/api/v2/pokemon-species/$speciesId',
    );
    final body = await _get(url, "Erreur lors du chargement de l'espece");

    return PokemonSpecies.fromJson(jsonDecode(body));
  }

  /// La chaîne d'évolution complète, depuis la forme de base.
  Future<EvolutionNode> fetchEvolutionChain(int chainId) async {
    final url = Uri.parse('https://pokeapi.co/api/v2/evolution-chain/$chainId');
    final body = await _get(
      url,
      "Erreur lors du chargement de la chaîne d'évolution",
    );

    return EvolutionNode.fromJson(jsonDecode(body)['chain']);
  }
}
