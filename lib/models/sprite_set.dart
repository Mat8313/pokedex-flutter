import 'game.dart';

/// Les quatre variantes de face d'un même sprite. Sert aussi bien pour les
/// sprites principaux du Pokémon que pour ceux de chaque jeu.
class SpriteSet {
  final String? frontDefault;
  final String? frontShiny;
  final String? frontFemale;
  final String? frontShinyFemale;

  const SpriteSet({this.frontDefault, this.frontShiny, this.frontFemale, this.frontShinyFemale});

  /// [extension] corrige l'extension des URL pour les jeux que l'API annonce
  /// en `.png` alors que la banque les stocke autrement.
  factory SpriteSet.fromJson(Map<String, dynamic> json, {String? extension}) => SpriteSet(
    frontDefault: _withExtension(json['front_default'] as String?, extension),
    frontShiny: _withExtension(json['front_shiny'] as String?, extension),
    frontFemale: _withExtension(json['front_female'] as String?, extension),
    frontShinyFemale: _withExtension(json['front_shiny_female'] as String?, extension),
  );

  static String? _withExtension(String? url, String? extension) {
    if (url == null || extension == null) return url;

    final lastDot = url.lastIndexOf('.');
    return lastDot < 0 ? url : '${url.substring(0, lastDot)}.$extension';
  }

  bool get isEmpty =>
      frontDefault == null && frontShiny == null && frontFemale == null && frontShinyFemale == null;

  /// Variante correspondant aux bascules, avec repli quand elle n'existe pas.
  /// On abandonne le sexe avant le chromatique, bien plus visible à l'écran.
  /// Ne renvoie null que si le jeu de sprites est entièrement vide.
  String? variant({required bool shiny, required bool female}) {
    if (shiny && female) return frontShinyFemale ?? frontShiny ?? frontDefault ?? _anyAvailable;
    if (shiny) return frontShiny ?? frontDefault ?? _anyAvailable;
    if (female) return frontFemale ?? frontDefault ?? _anyAvailable;
    return frontDefault ?? _anyAvailable;
  }

  String? get _anyAvailable => frontDefault ?? frontShiny ?? frontFemale ?? frontShinyFemale;
}

class GameSprites {
  final Game game;
  final SpriteSet sprites;

  const GameSprites({required this.game, required this.sprites});
}

class GenerationSprites {
  final Generation generation;
  final List<GameSprites> games;

  const GenerationSprites({required this.generation, required this.games});
}

/// Écarte les générations antérieures à l'apparition de la forme.
///
/// La banque de sprites contient des sprites au *style* d'une génération pour
/// des formes qui n'y existaient pas — un Gigamax dessiné façon Noir·Blanc, par
/// exemple, alors que le Gigamax date d'Épée·Bouclier. Sans ce filtre, l'onglet
/// prétendrait qu'un Gigamax existait en 2010.
List<GenerationSprites> spritesSinceVersionGroup(
  List<GenerationSprites> spritesByGeneration,
  String? introductionVersionGroup,
) {
  if (introductionVersionGroup == null) return spritesByGeneration;

  final introductionGeneration = versionGroupGenerations[introductionVersionGroup];
  if (introductionGeneration == null) return spritesByGeneration;

  final introductionRank = generationRank(introductionGeneration);
  if (introductionRank < 0) return spritesByGeneration;

  return spritesByGeneration
      .where((entry) => generationRank(entry.generation.key) >= introductionRank)
      .toList();
}

/// Construit les sprites par génération depuis `sprites.versions`.
///
/// L'itération part de [pokemonGenerations] et non des clés du JSON : l'ordre
/// chronologique est ainsi garanti, et une clé inconnue ajoutée un jour par
/// l'API ne peut rien casser. Les jeux sans sprite sont écartés — c'est le cas
/// courant sur les formes alternatives, qui n'existaient pas dans les vieux jeux.
List<GenerationSprites> parseSpritesByGeneration(Map<String, dynamic>? versions) {
  if (versions == null) return const [];

  final result = <GenerationSprites>[];

  for (final generation in pokemonGenerations) {
    final generationJson = versions[generation.key] as Map<String, dynamic>?;
    if (generationJson == null) continue;

    final games = <GameSprites>[];
    for (final game in generation.games) {
      final gameJson = generationJson[game.spriteKey] as Map<String, dynamic>?;
      if (gameJson == null) continue;

      final sprites = SpriteSet.fromJson(gameJson, extension: game.spriteExtension);
      if (sprites.isEmpty) continue;

      games.add(GameSprites(game: game, sprites: sprites));
    }

    if (games.isNotEmpty) {
      result.add(GenerationSprites(generation: generation, games: games));
    }
  }

  return result;
}
