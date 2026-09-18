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

  const Generation({required this.key, required this.label, required this.games});
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
int generationRank(String generationKey) =>
    pokemonGenerations.indexWhere((generation) => generation.key == generationKey);

/// L'API renvoie ses générations dans un ordre arbitraire : c'est cette liste
/// qui fait foi pour l'ordre d'affichage. Les entrées `icons` de l'API sont
/// volontairement absentes, ce sont des icônes de menu et non des sprites.
const List<Generation> pokemonGenerations = [
  Generation(
    key: 'generation-i',
    label: 'Génération I',
    games: [
      Game(spriteKey: 'red-blue', versionGroup: 'red-blue', label: 'Rouge · Bleu'),
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
      Game(spriteKey: 'ruby-sapphire', versionGroup: 'ruby-sapphire', label: 'Rubis · Saphir'),
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
      Game(spriteKey: 'diamond-pearl', versionGroup: 'diamond-pearl', label: 'Diamant · Perle'),
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
    games: [Game(spriteKey: 'black-white', versionGroup: 'black-white', label: 'Noir · Blanc')],
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
      Game(spriteKey: 'scarlet-violet', versionGroup: 'scarlet-violet', label: 'Écarlate · Violet'),
    ],
  ),
];
