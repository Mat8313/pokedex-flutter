import '../l10n/localized_label.dart';

/// Un type, son libellé traduit et ce qu'il encaisse.
///
/// Les relations sont exprimées **en défense** : ce sont celles dont la fiche a
/// besoin pour dire de quoi un Pokémon est faible. Elles viennent de
/// `/type/<key>.damage_relations` et sont figées ici, la table n'ayant pas
/// bougé depuis la génération VI — cela évite dix-huit requêtes par fiche.
class PokemonType {
  final String key;
  final LocalizedLabel label;
  final List<String> doubleDamageFrom;
  final List<String> halfDamageFrom;
  final List<String> noDamageFrom;

  const PokemonType({
    required this.key,
    required this.label,
    required this.doubleDamageFrom,
    required this.halfDamageFrom,
    required this.noDamageFrom,
  });
}

const List<PokemonType> pokemonTypes = [
  PokemonType(
    key: 'normal',
    label: LocalizedLabel('Normal', 'Normal'),
    doubleDamageFrom: ['fighting'],
    halfDamageFrom: [],
    noDamageFrom: ['ghost'],
  ),
  PokemonType(
    key: 'fire',
    label: LocalizedLabel('Fire', 'Feu'),
    doubleDamageFrom: ['ground', 'rock', 'water'],
    halfDamageFrom: ['bug', 'fairy', 'fire', 'grass', 'ice', 'steel'],
    noDamageFrom: [],
  ),
  PokemonType(
    key: 'water',
    label: LocalizedLabel('Water', 'Eau'),
    doubleDamageFrom: ['electric', 'grass'],
    halfDamageFrom: ['fire', 'ice', 'steel', 'water'],
    noDamageFrom: [],
  ),
  PokemonType(
    key: 'electric',
    label: LocalizedLabel('Electric', 'Électrik'),
    doubleDamageFrom: ['ground'],
    halfDamageFrom: ['electric', 'flying', 'steel'],
    noDamageFrom: [],
  ),
  PokemonType(
    key: 'grass',
    label: LocalizedLabel('Grass', 'Plante'),
    doubleDamageFrom: ['bug', 'fire', 'flying', 'ice', 'poison'],
    halfDamageFrom: ['electric', 'grass', 'ground', 'water'],
    noDamageFrom: [],
  ),
  PokemonType(
    key: 'ice',
    label: LocalizedLabel('Ice', 'Glace'),
    doubleDamageFrom: ['fighting', 'fire', 'rock', 'steel'],
    halfDamageFrom: ['ice'],
    noDamageFrom: [],
  ),
  PokemonType(
    key: 'fighting',
    label: LocalizedLabel('Fighting', 'Combat'),
    doubleDamageFrom: ['fairy', 'flying', 'psychic'],
    halfDamageFrom: ['bug', 'dark', 'rock'],
    noDamageFrom: [],
  ),
  PokemonType(
    key: 'poison',
    label: LocalizedLabel('Poison', 'Poison'),
    doubleDamageFrom: ['ground', 'psychic'],
    halfDamageFrom: ['bug', 'fairy', 'fighting', 'grass', 'poison'],
    noDamageFrom: [],
  ),
  PokemonType(
    key: 'ground',
    label: LocalizedLabel('Ground', 'Sol'),
    doubleDamageFrom: ['grass', 'ice', 'water'],
    halfDamageFrom: ['poison', 'rock'],
    noDamageFrom: ['electric'],
  ),
  PokemonType(
    key: 'flying',
    label: LocalizedLabel('Flying', 'Vol'),
    doubleDamageFrom: ['electric', 'ice', 'rock'],
    halfDamageFrom: ['bug', 'fighting', 'grass'],
    noDamageFrom: ['ground'],
  ),
  PokemonType(
    key: 'psychic',
    label: LocalizedLabel('Psychic', 'Psy'),
    doubleDamageFrom: ['bug', 'dark', 'ghost'],
    halfDamageFrom: ['fighting', 'psychic'],
    noDamageFrom: [],
  ),
  PokemonType(
    key: 'bug',
    label: LocalizedLabel('Bug', 'Insecte'),
    doubleDamageFrom: ['fire', 'flying', 'rock'],
    halfDamageFrom: ['fighting', 'grass', 'ground'],
    noDamageFrom: [],
  ),
  PokemonType(
    key: 'rock',
    label: LocalizedLabel('Rock', 'Roche'),
    doubleDamageFrom: ['fighting', 'grass', 'ground', 'steel', 'water'],
    halfDamageFrom: ['fire', 'flying', 'normal', 'poison'],
    noDamageFrom: [],
  ),
  PokemonType(
    key: 'ghost',
    label: LocalizedLabel('Ghost', 'Spectre'),
    doubleDamageFrom: ['dark', 'ghost'],
    halfDamageFrom: ['bug', 'poison'],
    noDamageFrom: ['fighting', 'normal'],
  ),
  PokemonType(
    key: 'dragon',
    label: LocalizedLabel('Dragon', 'Dragon'),
    doubleDamageFrom: ['dragon', 'fairy', 'ice'],
    halfDamageFrom: ['electric', 'fire', 'grass', 'water'],
    noDamageFrom: [],
  ),
  PokemonType(
    key: 'dark',
    label: LocalizedLabel('Dark', 'Ténèbres'),
    doubleDamageFrom: ['bug', 'fairy', 'fighting'],
    halfDamageFrom: ['dark', 'ghost'],
    noDamageFrom: ['psychic'],
  ),
  PokemonType(
    key: 'steel',
    label: LocalizedLabel('Steel', 'Acier'),
    doubleDamageFrom: ['fighting', 'fire', 'ground'],
    halfDamageFrom: ['bug', 'dragon', 'fairy', 'flying', 'grass', 'ice', 'normal', 'psychic', 'rock', 'steel'],
    noDamageFrom: ['poison'],
  ),
  PokemonType(
    key: 'fairy',
    label: LocalizedLabel('Fairy', 'Fée'),
    doubleDamageFrom: ['poison', 'steel'],
    halfDamageFrom: ['bug', 'dark', 'fighting'],
    noDamageFrom: ['dragon'],
  ),
];

/// Accès par clé d'API, en minuscules.
final Map<String, PokemonType> pokemonTypesByKey = {
  for (final type in pokemonTypes) type.key: type,
};

/// Multiplicateur encaissé par un Pokémon de [defenderTypes] pour chaque type
/// d'attaque, les types absents de la table étant ignorés.
///
/// Les coefficients se multiplient entre eux : un Pokémon Plante·Sol prend
/// quatre fois les dégâts d'une attaque Glace, et rien d'une attaque Électrik.
Map<String, double> typeEffectiveness(List<String> defenderTypes) {
  final multipliers = {for (final type in pokemonTypes) type.key: 1.0};

  for (final defender in defenderTypes) {
    final type = pokemonTypesByKey[defender.toLowerCase()];
    if (type == null) continue;

    for (final attacker in type.doubleDamageFrom) {
      multipliers[attacker] = multipliers[attacker]! * 2;
    }
    for (final attacker in type.halfDamageFrom) {
      multipliers[attacker] = multipliers[attacker]! * 0.5;
    }
    for (final attacker in type.noDamageFrom) {
      multipliers[attacker] = 0;
    }
  }

  return multipliers;
}
