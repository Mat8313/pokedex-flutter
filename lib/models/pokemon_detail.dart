//import 'dart:js_interop';
import 'pokemon_forms.dart';

class PokemonDetail {
  final int id;
  final String name;
  final int weight;
  final int height;
  final List<String> types;
  final Map<String, String?> sprites;
  final List<PokemonForm> cosmeticSprite;


  PokemonDetail({
    required this.id,
    required this.name,
    required this.weight,
    required this.height,
    required this.types,
    required this.sprites,
    required this.cosmeticSprite,
  });

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    List<String> extractedTypes = (json['types'] as List)
        .map((t) => t['type']['name'].toString().toUpperCase())
        .toList();
    Map<String, String?> spritesList = {
      'default'        : (json['sprites']['front_default'] as String?),
      'shiny'          : (json['sprites']['front_shiny'] as String?),
      'female'         : (json['sprites']['front_female'] as String?),
      'shiny female'   : (json['sprites']['front_shiny_female'] as String?),
    };

    List<PokemonForm> cosmeticSpriteList = (json['forms'] as List)
      .map((e) => PokemonForm.fromJson(e)).toList();


    return PokemonDetail(
      id: json['id'],
      name: json['name'],
      weight: json['weight'],
      height: json['height'],
      types: extractedTypes,
      sprites: spritesList,
      cosmeticSprite: cosmeticSpriteList,
    );
  }
}