/// Une entrée de Pokédex.
///
/// [entryNumber] est le numéro dans ce Pokédex-là, [speciesId] le numéro
/// national : Tortipouss est le n°1 du Pokédex de Sinnoh et le n°387 du
/// national. Toute navigation vers la page de détail se fait sur [speciesId].
class PokedexEntry {
  final int entryNumber;
  final int speciesId;
  final String name;

  /// Faux uniquement dans un Pokédex National, pour une espèce que le jeu ne
  /// contient pas. Le jeu lui garde sa place et l'affiche en `-----` ; on la
  /// grise plutôt que de la retirer, sans quoi la numérotation sauterait.
  final bool availableInGame;

  const PokedexEntry({
    required this.entryNumber,
    required this.speciesId,
    required this.name,
    this.availableInGame = true,
  });

  factory PokedexEntry.fromJson(Map<String, dynamic> json) {
    final species = json['pokemon_species'] as Map<String, dynamic>;

    return PokedexEntry(
      entryNumber: json['entry_number'] as int,
      speciesId: _idFromUrl(species['url'] as String),
      name: species['name'] as String,
    );
  }

  /// Vrai quand la numérotation du Pokédex diffère de la numérotation
  /// nationale — seul cas où afficher les deux numéros a un intérêt.
  bool get hasOwnNumbering => entryNumber != speciesId;

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$speciesId.png';

  /// `.../pokemon-species/387/` → 387. L'endpoint `/pokedex` ne donne l'id de
  /// l'espèce nulle part ailleurs que dans cette URL.
  static int _idFromUrl(String url) =>
      int.parse(url.split('/').where((part) => part.isNotEmpty).last);
}

/// Les numéros nationaux des espèces qu'un jeu contient, tous ses Pokédex
/// régionaux confondus.
///
/// C'est la seule définition de « présent dans le jeu » que l'API permette :
/// elle couvre le Pokédex, pas ce qu'un échange ou un transfert pourrait y
/// faire entrer. Platine y compte donc 210 espèces, pas 493.
Set<int> speciesInGame(List<List<PokedexEntry>> regionalDexes) => {
  for (final dex in regionalDexes)
    for (final entry in dex) entry.speciesId,
};

/// Le Pokédex National tel que le jeu l'affiche : **contigu de 1 à [upTo]**, y
/// compris les espèces qu'on n'y trouvera jamais.
///
/// Le vrai Pokédex ne saute aucun numéro — une espèce jamais croisée s'affiche
/// en `-----` mais garde sa place. [availableSpecies] sert donc à marquer les
/// entrées, jamais à les filtrer.
///
/// [upTo] vient du jeu et non de sa génération, voir `GameDex.nationalDexMax`.
List<PokedexEntry> buildNationalDex({
  required List<PokedexEntry> allSpecies,
  required int upTo,
  required Set<int> availableSpecies,
}) => [
  for (final entry in allSpecies)
    if (entry.speciesId <= upTo)
      PokedexEntry(
        // Dans le national, les deux numérotations se confondent.
        entryNumber: entry.speciesId,
        speciesId: entry.speciesId,
        name: entry.name,
        availableInGame: availableSpecies.contains(entry.speciesId),
      ),
];
