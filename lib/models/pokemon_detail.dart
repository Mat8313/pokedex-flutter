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

  PokemonDetail({
    required this.id,
    required this.name,
    required this.weight,
    required this.height,
    required this.types,
    required this.sprites,
    required this.cosmeticSprite,
    required this.spritesByGeneration,
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
    );
  }
}
