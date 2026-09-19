import '../l10n/localized_label.dart';

/// Référentiel des jeux de la licence principale.
///
/// Sert à deux choses : ordonner les sprites par jeu dans la page de détail, et
/// (à venir) trier le Pokédex par jeu depuis la page des régions.
class Game {
  /// Clé utilisée dans `sprites.versions` de l'endpoint /pokemon.
  final String spriteKey;

  /// Clé utilisée par l'endpoint /version-group. Elle ne coïncide pas toujours
  /// avec [spriteKey] : les sprites séparent Or et Argent, l'API des
  /// version-groups ne connaît que `gold-silver`.
  final String versionGroup;

  final LocalizedLabel label;

  /// Extension réelle des fichiers dans la banque de sprites. L'API annonce
  /// systématiquement des URL en `.png`, mais quelques jeux sont stockés en
  /// `.gif` — leurs URL déclarées renvoient alors un 404.
  final String spriteExtension;

  const Game({
    required this.spriteKey,
    required this.versionGroup,
    required this.label,
    this.spriteExtension = 'png',
  });
}

class Generation {
  final String key;
  final LocalizedLabel label;
  final List<Game> games;

  const Generation({
    required this.key,
    required this.label,
    required this.games,
  });
}

/// Génération d'origine de chaque version-group, y compris ceux qui n'ont aucun
/// sprite dans la banque (Épée·Bouclier par exemple) : une forme peut avoir été
/// introduite par un jeu absent de [pokemonGenerations].
const Map<String, String> versionGroupGenerations = {
  'red-blue': 'generation-i',
  'yellow': 'generation-i',
  'red-green-japan': 'generation-i',
  'blue-japan': 'generation-i',
  'gold-silver': 'generation-ii',
  'crystal': 'generation-ii',
  'ruby-sapphire': 'generation-iii',
  'emerald': 'generation-iii',
  'firered-leafgreen': 'generation-iii',
  'colosseum': 'generation-iii',
  'xd': 'generation-iii',
  'diamond-pearl': 'generation-iv',
  'platinum': 'generation-iv',
  'heartgold-soulsilver': 'generation-iv',
  'black-white': 'generation-v',
  'black-2-white-2': 'generation-v',
  'x-y': 'generation-vi',
  'omega-ruby-alpha-sapphire': 'generation-vi',
  'sun-moon': 'generation-vii',
  'ultra-sun-ultra-moon': 'generation-vii',
  'lets-go-pikachu-lets-go-eevee': 'generation-vii',
  'sword-shield': 'generation-viii',
  'the-isle-of-armor': 'generation-viii',
  'the-crown-tundra': 'generation-viii',
  'brilliant-diamond-shining-pearl': 'generation-viii',
  'legends-arceus': 'generation-viii',
  'scarlet-violet': 'generation-ix',
  'the-teal-mask': 'generation-ix',
  'the-indigo-disk': 'generation-ix',
  'legends-za': 'generation-ix',
  'mega-dimension': 'generation-ix',
  'champions': 'generation-ix',
};

/// Rang chronologique d'une génération, -1 si elle est inconnue.
int generationRank(String generationKey) => pokemonGenerations.indexWhere(
  (generation) => generation.key == generationKey,
);

/// L'API renvoie ses générations dans un ordre arbitraire : c'est cette liste
/// qui fait foi pour l'ordre d'affichage. Les entrées `icons` de l'API sont
/// volontairement absentes, ce sont des icônes de menu et non des sprites.
const List<Generation> pokemonGenerations = [
  Generation(
    key: 'generation-i',
    label: LocalizedLabel('Generation I', 'Génération I'),
    games: [
      Game(
        spriteKey: 'red-blue',
        versionGroup: 'red-blue',
        label: LocalizedLabel('Red · Blue', 'Rouge · Bleu'),
      ),
      Game(spriteKey: 'yellow', versionGroup: 'yellow', label: LocalizedLabel('Yellow', 'Jaune')),
    ],
  ),
  Generation(
    key: 'generation-ii',
    label: LocalizedLabel('Generation II', 'Génération II'),
    games: [
      Game(spriteKey: 'gold', versionGroup: 'gold-silver', label: LocalizedLabel('Gold', 'Or')),
      Game(spriteKey: 'silver', versionGroup: 'gold-silver', label: LocalizedLabel('Silver', 'Argent')),
      Game(spriteKey: 'crystal', versionGroup: 'crystal', label: LocalizedLabel('Crystal', 'Cristal')),
    ],
  ),
  Generation(
    key: 'generation-iii',
    label: LocalizedLabel('Generation III', 'Génération III'),
    games: [
      Game(
        spriteKey: 'ruby-sapphire',
        versionGroup: 'ruby-sapphire',
        label: LocalizedLabel('Ruby · Sapphire', 'Rubis · Saphir'),
      ),
      Game(spriteKey: 'emerald', versionGroup: 'emerald', label: LocalizedLabel('Emerald', 'Émeraude')),
      Game(
        spriteKey: 'firered-leafgreen',
        versionGroup: 'firered-leafgreen',
        label: LocalizedLabel('FireRed · LeafGreen', 'Rouge Feu · Vert Feuille'),
      ),
    ],
  ),
  Generation(
    key: 'generation-iv',
    label: LocalizedLabel('Generation IV', 'Génération IV'),
    games: [
      Game(
        spriteKey: 'diamond-pearl',
        versionGroup: 'diamond-pearl',
        label: LocalizedLabel('Diamond · Pearl', 'Diamant · Perle'),
      ),
      Game(spriteKey: 'platinum', versionGroup: 'platinum', label: LocalizedLabel('Platinum', 'Platine')),
      Game(
        spriteKey: 'heartgold-soulsilver',
        versionGroup: 'heartgold-soulsilver',
        label: LocalizedLabel('HeartGold · SoulSilver', 'Or HeartGold · Argent SoulSilver'),
      ),
    ],
  ),
  Generation(
    key: 'generation-v',
    label: LocalizedLabel('Generation V', 'Génération V'),
    games: [
      Game(
        spriteKey: 'black-white',
        versionGroup: 'black-white',
        label: LocalizedLabel('Black · White', 'Noir · Blanc'),
      ),
    ],
  ),
  Generation(
    key: 'generation-vi',
    label: LocalizedLabel('Generation VI', 'Génération VI'),
    games: [
      Game(spriteKey: 'x-y', versionGroup: 'x-y', label: LocalizedLabel('X · Y', 'X · Y')),
      Game(
        spriteKey: 'omegaruby-alphasapphire',
        versionGroup: 'omega-ruby-alpha-sapphire',
        label: LocalizedLabel('Omega Ruby · Alpha Sapphire', 'Rubis Oméga · Saphir Alpha'),
      ),
    ],
  ),
  Generation(
    key: 'generation-vii',
    label: LocalizedLabel('Generation VII', 'Génération VII'),
    games: [
      Game(
        spriteKey: 'ultra-sun-ultra-moon',
        versionGroup: 'ultra-sun-ultra-moon',
        label: LocalizedLabel('Ultra Sun · Ultra Moon', 'Ultra-Soleil · Ultra-Lune'),
        spriteExtension: 'gif',
      ),
    ],
  ),
  Generation(
    key: 'generation-viii',
    label: LocalizedLabel('Generation VIII', 'Génération VIII'),
    games: [
      Game(
        spriteKey: 'brilliant-diamond-shining-pearl',
        versionGroup: 'brilliant-diamond-shining-pearl',
        label: LocalizedLabel('Brilliant Diamond · Shining Pearl', 'Diamant Étincelant · Perle Scintillante'),
      ),
    ],
  ),
  Generation(
    key: 'generation-ix',
    label: LocalizedLabel('Generation IX', 'Génération IX'),
    games: [
      Game(
        spriteKey: 'scarlet-violet',
        versionGroup: 'scarlet-violet',
        label: LocalizedLabel('Scarlet · Violet', 'Écarlate · Violet'),
      ),
    ],
  ),
];

/// Un Pokédex tel que l'API le nomme, avec son libellé d'onglet.
class PokedexRef {
  /// Clé de l'endpoint `/pokedex`.
  final String apiName;

  /// Libellés repris de `/pokedex/<apiName>.names`, qui les sert traduits.
  final LocalizedLabel label;

  const PokedexRef(this.apiName, this.label);
}

/// Les Pokédex d'un jeu.
///
/// Volontairement distinct de [Game] : le référentiel des sprites sépare Or et
/// Argent, qui ont deux banques d'images mais un seul version-group donc un
/// seul Pokédex. Il ignore aussi les jeux dépourvus de sprites — Épée·Bouclier
/// a pourtant bien un Pokédex à afficher.
class GameDex {
  /// Clé de l'endpoint `/version-group`, et clé de [versionGroupGenerations].
  final String versionGroup;

  final LocalizedLabel label;

  /// Dans l'ordre des onglets, jamais vide : les jeux sans Pokédex (Colosseum,
  /// XD) sont simplement absents de [gamePokedexes].
  final List<PokedexRef> pokedexes;

  /// Dernier numéro du Pokédex National **de ce jeu**, `null` quand le jeu n'en
  /// propose aucun.
  ///
  /// Se rattache au jeu et non à sa génération, pour deux raisons :
  /// - Diamant Étincelant·Perle Scintillante est un jeu de génération VIII dont
  ///   le national s'arrête à 493, celui de la génération IV : c'est un remake.
  /// - depuis la génération VII, le Pokédex National a disparu des jeux ; il ne
  ///   vit plus que dans Pokémon HOME.
  ///
  /// Rouge·Bleu et Jaune valent `null` eux aussi : leur Pokédex de Kanto *est*
  /// la numérotation nationale, un second onglet n'aurait rien à montrer.
  final int? nationalDexMax;

  const GameDex({
    required this.versionGroup,
    required this.label,
    required this.pokedexes,
    this.nationalDexMax,
  });

  /// Lue dans le référentiel existant, jamais recopiée ici.
  String? get generationKey => versionGroupGenerations[versionGroup];
}

/// Les jeux de la licence principale qui possèdent au moins un Pokédex.
///
/// Trois familles de version-groups en sont absentes :
/// - Colosseum et XD, auxquels l'API ne rattache aucun Pokédex ;
/// - les DLC (`the-isle-of-armor`, `the-teal-mask`, `mega-dimension`…), qui
///   répètent un Pokédex déjà listé sous le jeu parent ;
/// - les éditions japonaises de la première génération, qui reprennent Kanto.
///
/// Les Pokédex d'îles d'Alola (`*-melemele`, `*-akala`, `*-ulaula`, `*-poni`)
/// sont écartés au profit du Pokédex global, qui en est l'union : cinq onglets
/// pour un seul jeu seraient illisibles.
const List<GameDex> gamePokedexes = [
  GameDex(
    versionGroup: 'red-blue',
    label: LocalizedLabel('Red · Blue', 'Rouge · Bleu'),
    pokedexes: [PokedexRef('kanto', LocalizedLabel('Kanto', 'Kanto'))],
  ),
  GameDex(
    versionGroup: 'yellow',
    label: LocalizedLabel('Yellow', 'Jaune'),
    pokedexes: [PokedexRef('kanto', LocalizedLabel('Kanto', 'Kanto'))],
  ),
  GameDex(
    versionGroup: 'gold-silver',
    label: LocalizedLabel('Gold · Silver', 'Or · Argent'),
    nationalDexMax: 251,
    pokedexes: [PokedexRef('original-johto', LocalizedLabel('Johto', 'Johto'))],
  ),
  GameDex(
    versionGroup: 'crystal',
    label: LocalizedLabel('Crystal', 'Cristal'),
    nationalDexMax: 251,
    pokedexes: [PokedexRef('original-johto', LocalizedLabel('Johto', 'Johto'))],
  ),
  GameDex(
    versionGroup: 'ruby-sapphire',
    label: LocalizedLabel('Ruby · Sapphire', 'Rubis · Saphir'),
    nationalDexMax: 386,
    pokedexes: [PokedexRef('hoenn', LocalizedLabel('Hoenn', 'Hoenn'))],
  ),
  GameDex(
    versionGroup: 'emerald',
    label: LocalizedLabel('Emerald', 'Émeraude'),
    nationalDexMax: 386,
    pokedexes: [PokedexRef('hoenn', LocalizedLabel('Hoenn', 'Hoenn'))],
  ),
  GameDex(
    versionGroup: 'firered-leafgreen',
    label: LocalizedLabel('FireRed · LeafGreen', 'Rouge Feu · Vert Feuille'),
    nationalDexMax: 386,
    pokedexes: [PokedexRef('kanto', LocalizedLabel('Kanto', 'Kanto'))],
  ),
  GameDex(
    versionGroup: 'diamond-pearl',
    label: LocalizedLabel('Diamond · Pearl', 'Diamant · Perle'),
    nationalDexMax: 493,
    pokedexes: [PokedexRef('original-sinnoh', LocalizedLabel('Sinnoh', 'Sinnoh'))],
  ),
  GameDex(
    versionGroup: 'platinum',
    label: LocalizedLabel('Platinum', 'Platine'),
    nationalDexMax: 493,
    pokedexes: [PokedexRef('extended-sinnoh', LocalizedLabel('Extended Sinnoh', 'Sinnoh étendu'))],
  ),
  GameDex(
    versionGroup: 'heartgold-soulsilver',
    label: LocalizedLabel('HeartGold · SoulSilver', 'Or HeartGold · Argent SoulSilver'),
    nationalDexMax: 493,
    pokedexes: [PokedexRef('updated-johto', LocalizedLabel('Johto', 'Johto'))],
  ),
  GameDex(
    versionGroup: 'black-white',
    label: LocalizedLabel('Black · White', 'Noir · Blanc'),
    nationalDexMax: 649,
    pokedexes: [PokedexRef('original-unova', LocalizedLabel('Unova', 'Unys'))],
  ),
  GameDex(
    versionGroup: 'black-2-white-2',
    label: LocalizedLabel('Black 2 · White 2', 'Noir 2 · Blanc 2'),
    nationalDexMax: 649,
    pokedexes: [PokedexRef('updated-unova', LocalizedLabel('Unova', 'Unys'))],
  ),
  GameDex(
    versionGroup: 'x-y',
    label: LocalizedLabel('X · Y', 'X · Y'),
    nationalDexMax: 721,
    pokedexes: [
      PokedexRef('kalos-central', LocalizedLabel('Central', 'Centre')),
      PokedexRef('kalos-coastal', LocalizedLabel('Coastal', 'Côte')),
      PokedexRef('kalos-mountain', LocalizedLabel('Mountain', 'Montagne')),
    ],
  ),
  GameDex(
    versionGroup: 'omega-ruby-alpha-sapphire',
    label: LocalizedLabel('Omega Ruby · Alpha Sapphire', 'Rubis Oméga · Saphir Alpha'),
    nationalDexMax: 721,
    pokedexes: [PokedexRef('updated-hoenn', LocalizedLabel('Hoenn', 'Hoenn'))],
  ),
  GameDex(
    versionGroup: 'sun-moon',
    label: LocalizedLabel('Sun · Moon', 'Soleil · Lune'),
    pokedexes: [PokedexRef('original-alola', LocalizedLabel('Alola', 'Alola'))],
  ),
  GameDex(
    versionGroup: 'ultra-sun-ultra-moon',
    label: LocalizedLabel('Ultra Sun · Ultra Moon', 'Ultra-Soleil · Ultra-Lune'),
    pokedexes: [PokedexRef('updated-alola', LocalizedLabel('Alola', 'Alola'))],
  ),
  GameDex(
    versionGroup: 'lets-go-pikachu-lets-go-eevee',
    label: LocalizedLabel(
      "Let's Go Pikachu · Let's Go Eevee",
      "Let's Go Pikachu · Let's Go Évoli",
    ),
    pokedexes: [PokedexRef('letsgo-kanto', LocalizedLabel('Kanto', 'Kanto'))],
  ),
  GameDex(
    versionGroup: 'sword-shield',
    label: LocalizedLabel('Sword · Shield', 'Épée · Bouclier'),
    pokedexes: [
      PokedexRef('galar', LocalizedLabel('Galar', 'Galar')),
      PokedexRef('isle-of-armor', LocalizedLabel('Isle of Armor', 'Isolarmure')),
      PokedexRef('crown-tundra', LocalizedLabel('Crown Tundra', 'Couronneige')),
    ],
  ),
  GameDex(
    versionGroup: 'brilliant-diamond-shining-pearl',
    label: LocalizedLabel('Brilliant Diamond · Shining Pearl', 'Diamant Étincelant · Perle Scintillante'),
    nationalDexMax: 493,
    pokedexes: [PokedexRef('original-sinnoh', LocalizedLabel('Sinnoh', 'Sinnoh'))],
  ),
  GameDex(
    versionGroup: 'legends-arceus',
    label: LocalizedLabel('Legends: Arceus', 'Légendes Arceus'),
    pokedexes: [PokedexRef('hisui', LocalizedLabel('Hisui', 'Hisui'))],
  ),
  GameDex(
    versionGroup: 'scarlet-violet',
    label: LocalizedLabel('Scarlet · Violet', 'Écarlate · Violet'),
    pokedexes: [
      PokedexRef('paldea', LocalizedLabel('Paldea', 'Paldea')),
      PokedexRef('kitakami', LocalizedLabel('Kitakami', 'Septentria')),
      PokedexRef('blueberry', LocalizedLabel('Blueberry', 'Myrtille')),
    ],
  ),
  GameDex(
    versionGroup: 'legends-za',
    label: LocalizedLabel('Legends: Z-A', 'Légendes Z-A'),
    pokedexes: [
      PokedexRef('lumiose-city', LocalizedLabel('Lumiose City', 'Illumis')),
      PokedexRef('hyperspace', LocalizedLabel('Hyperspace', 'Extra Illumis')),
    ],
  ),
  GameDex(
    versionGroup: 'champions',
    label: LocalizedLabel('Champions', 'Champions'),
    pokedexes: [PokedexRef('champions', LocalizedLabel('Champions', 'Champions'))],
  ),
];
