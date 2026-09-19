import 'pokemon_forms.dart';
import 'sprite_set.dart';

class PokemonDetail {
  final int id;
  final String name;
  final int weight;
  final int height;
  final List<String> types;
  final SpriteSet sprites;
  final List<PokemonForm> cosmeticSprite;
  final List<GenerationSprites> spritesByGeneration;

  /// Clé d'API de la statistique (`hp`, `special-attack`…) → valeur de base.
  final Map<String, int> stats;

  final List<PokemonAbility> abilities;

  PokemonDetail({
    required this.id,
    required this.name,
    required this.weight,
    required this.height,
    required this.types,
    required this.sprites,
    required this.cosmeticSprite,
    required this.spritesByGeneration,
    required this.stats,
    required this.abilities,
  });

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    List<String> extractedTypes = (json['types'] as List)
        .map((t) => t['type']['name'].toString().toUpperCase())
        .toList();

    final spritesJson = json['sprites'] as Map<String, dynamic>;

    List<PokemonForm> cosmeticSpriteList = (json['forms'] as List)
        .map((e) => PokemonForm.fromJson(e))
        .toList();

    return PokemonDetail(
      id: json['id'],
      name: json['name'],
      weight: json['weight'],
      height: json['height'],
      types: extractedTypes,
      sprites: SpriteSet.fromJson(spritesJson),
      cosmeticSprite: cosmeticSpriteList,
      spritesByGeneration: parseSpritesByGeneration(
        spritesJson['versions'] as Map<String, dynamic>?,
      ),
      // Tolerants : ces deux champs n'ont ete lus qu'a partir des onglets
      // Infos et Combat, et un appelant plus ancien peut les ignorer.
      stats: {
        for (final stat in (json['stats'] as List? ?? const []))
          stat['stat']['name'] as String: stat['base_stat'] as int,
      },
      abilities: [
        for (final ability in (json['abilities'] as List? ?? const []))
          PokemonAbility.fromJson(ability),
      ],
    );
  }
}

/// Un talent du Pokémon. Le nom n'est pas dans la réponse : l'API ne donne que
/// son identifiant, le libellé traduit se lit dans `ApiNames`.
class PokemonAbility {
  final int id;
  final String apiName;
  final bool isHidden;

  const PokemonAbility({required this.id, required this.apiName, required this.isHidden});

  factory PokemonAbility.fromJson(Map<String, dynamic> json) {
    final url = json['ability']['url'] as String;

    return PokemonAbility(
      id: int.parse(url.split('/').where((part) => part.isNotEmpty).last),
      apiName: json['ability']['name'] as String,
      isHidden: json['is_hidden'] as bool,
    );
  }
}
