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

  final String label;

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
  final String label;
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
    label: 'Génération I',
    games: [
      Game(
        spriteKey: 'red-blue',
        versionGroup: 'red-blue',
        label: 'Rouge · Bleu',
      ),
      Game(spriteKey: 'yellow', versionGroup: 'yellow', label: 'Jaune'),
    ],
  ),
  Generation(
    key: 'generation-ii',
    label: 'Génération II',
    games: [
      Game(spriteKey: 'gold', versionGroup: 'gold-silver', label: 'Or'),
      Game(spriteKey: 'silver', versionGroup: 'gold-silver', label: 'Argent'),
      Game(spriteKey: 'crystal', versionGroup: 'crystal', label: 'Cristal'),
    ],
  ),
  Generation(
    key: 'generation-iii',
    label: 'Génération III',
    games: [
      Game(
        spriteKey: 'ruby-sapphire',
        versionGroup: 'ruby-sapphire',
        label: 'Rubis · Saphir',
      ),
      Game(spriteKey: 'emerald', versionGroup: 'emerald', label: 'Émeraude'),
      Game(
        spriteKey: 'firered-leafgreen',
        versionGroup: 'firered-leafgreen',
        label: 'Rouge Feu · Vert Feuille',
      ),
    ],
  ),
  Generation(
    key: 'generation-iv',
    label: 'Génération IV',
    games: [
      Game(
        spriteKey: 'diamond-pearl',
        versionGroup: 'diamond-pearl',
        label: 'Diamant · Perle',
      ),
      Game(spriteKey: 'platinum', versionGroup: 'platinum', label: 'Platine'),
      Game(
        spriteKey: 'heartgold-soulsilver',
        versionGroup: 'heartgold-soulsilver',
        label: 'Or HeartGold · Argent SoulSilver',
      ),
    ],
  ),
  Generation(
    key: 'generation-v',
    label: 'Génération V',
    games: [
      Game(
        spriteKey: 'black-white',
        versionGroup: 'black-white',
        label: 'Noir · Blanc',
      ),
    ],
  ),
  Generation(
    key: 'generation-vi',
    label: 'Génération VI',
    games: [
      Game(spriteKey: 'x-y', versionGroup: 'x-y', label: 'X · Y'),
      Game(
        spriteKey: 'omegaruby-alphasapphire',
        versionGroup: 'omega-ruby-alpha-sapphire',
        label: 'Rubis Oméga · Saphir Alpha',
      ),
    ],
  ),
  Generation(
    key: 'generation-vii',
    label: 'Génération VII',
    games: [
      Game(
        spriteKey: 'ultra-sun-ultra-moon',
        versionGroup: 'ultra-sun-ultra-moon',
        label: 'Ultra-Soleil · Ultra-Lune',
        spriteExtension: 'gif',
      ),
    ],
  ),
  Generation(
    key: 'generation-viii',
    label: 'Génération VIII',
    games: [
      Game(
        spriteKey: 'brilliant-diamond-shining-pearl',
        versionGroup: 'brilliant-diamond-shining-pearl',
        label: 'Diamant Étincelant · Perle Scintillante',
      ),
    ],
  ),
  Generation(
    key: 'generation-ix',
    label: 'Génération IX',
    games: [
      Game(
        spriteKey: 'scarlet-violet',
        versionGroup: 'scarlet-violet',
        label: 'Écarlate · Violet',
      ),
    ],
  ),
];

/// Un Pokédex tel que l'API le nomme, avec son libellé d'onglet.
class PokedexRef {
  /// Clé de l'endpoint `/pokedex`.
  final String apiName;

  /// Libellé français, repris de `/pokedex/<apiName>.names`.
  final String label;

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

  final String label;

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
    label: 'Rouge · Bleu',
    pokedexes: [PokedexRef('kanto', 'Kanto')],
  ),
  GameDex(
    versionGroup: 'yellow',
    label: 'Jaune',
    pokedexes: [PokedexRef('kanto', 'Kanto')],
  ),
  GameDex(
    versionGroup: 'gold-silver',
    label: 'Or · Argent',
    nationalDexMax: 251,
    pokedexes: [PokedexRef('original-johto', 'Johto')],
  ),
  GameDex(
    versionGroup: 'crystal',
    label: 'Cristal',
    nationalDexMax: 251,
    pokedexes: [PokedexRef('original-johto', 'Johto')],
  ),
  GameDex(
    versionGroup: 'ruby-sapphire',
    label: 'Rubis · Saphir',
    nationalDexMax: 386,
    pokedexes: [PokedexRef('hoenn', 'Hoenn')],
  ),
  GameDex(
    versionGroup: 'emerald',
    label: 'Émeraude',
    nationalDexMax: 386,
    pokedexes: [PokedexRef('hoenn', 'Hoenn')],
  ),
  GameDex(
    versionGroup: 'firered-leafgreen',
    label: 'Rouge Feu · Vert Feuille',
    nationalDexMax: 386,
    pokedexes: [PokedexRef('kanto', 'Kanto')],
  ),
  GameDex(
    versionGroup: 'diamond-pearl',
    label: 'Diamant · Perle',
    nationalDexMax: 493,
    pokedexes: [PokedexRef('original-sinnoh', 'Sinnoh')],
  ),
  GameDex(
    versionGroup: 'platinum',
    label: 'Platine',
    nationalDexMax: 493,
    pokedexes: [PokedexRef('extended-sinnoh', 'Sinnoh étendu')],
  ),
  GameDex(
    versionGroup: 'heartgold-soulsilver',
    label: 'Or HeartGold · Argent SoulSilver',
    nationalDexMax: 493,
    pokedexes: [PokedexRef('updated-johto', 'Johto')],
  ),
  GameDex(
    versionGroup: 'black-white',
    label: 'Noir · Blanc',
    nationalDexMax: 649,
    pokedexes: [PokedexRef('original-unova', 'Unys')],
  ),
  GameDex(
    versionGroup: 'black-2-white-2',
    label: 'Noir 2 · Blanc 2',
    nationalDexMax: 649,
    pokedexes: [PokedexRef('updated-unova', 'Unys')],
  ),
  GameDex(
    versionGroup: 'x-y',
    label: 'X · Y',
    nationalDexMax: 721,
    pokedexes: [
      PokedexRef('kalos-central', 'Centre'),
      PokedexRef('kalos-coastal', 'Côte'),
      PokedexRef('kalos-mountain', 'Montagne'),
    ],
  ),
  GameDex(
    versionGroup: 'omega-ruby-alpha-sapphire',
    label: 'Rubis Oméga · Saphir Alpha',
    nationalDexMax: 721,
    pokedexes: [PokedexRef('updated-hoenn', 'Hoenn')],
  ),
  GameDex(
    versionGroup: 'sun-moon',
    label: 'Soleil · Lune',
    pokedexes: [PokedexRef('original-alola', 'Alola')],
  ),
  GameDex(
    versionGroup: 'ultra-sun-ultra-moon',
    label: 'Ultra-Soleil · Ultra-Lune',
    pokedexes: [PokedexRef('updated-alola', 'Alola')],
  ),
  GameDex(
    versionGroup: 'lets-go-pikachu-lets-go-eevee',
    label: "Let's Go Pikachu · Let's Go Évoli",
    pokedexes: [PokedexRef('letsgo-kanto', 'Kanto')],
  ),
  GameDex(
    versionGroup: 'sword-shield',
    label: 'Épée · Bouclier',
    pokedexes: [
      PokedexRef('galar', 'Galar'),
      PokedexRef('isle-of-armor', 'Isolarmure'),
      PokedexRef('crown-tundra', 'Couronneige'),
    ],
  ),
  GameDex(
    versionGroup: 'brilliant-diamond-shining-pearl',
    label: 'Diamant Étincelant · Perle Scintillante',
    nationalDexMax: 493,
    pokedexes: [PokedexRef('original-sinnoh', 'Sinnoh')],
  ),
  GameDex(
    versionGroup: 'legends-arceus',
    label: 'Légendes Arceus',
    pokedexes: [PokedexRef('hisui', 'Hisui')],
  ),
  GameDex(
    versionGroup: 'scarlet-violet',
    label: 'Écarlate · Violet',
    pokedexes: [
      PokedexRef('paldea', 'Paldea'),
      PokedexRef('kitakami', 'Septentria'),
      PokedexRef('blueberry', 'Myrtille'),
    ],
  ),
  GameDex(
    versionGroup: 'legends-za',
    label: 'Légendes Z-A',
    pokedexes: [
      PokedexRef('lumiose-city', 'Illumis'),
      PokedexRef('hyperspace', 'Extra Illumis'),
    ],
  ),
  GameDex(
    versionGroup: 'champions',
    label: 'Champions',
    pokedexes: [PokedexRef('champions', 'Champions')],
  ),
];
