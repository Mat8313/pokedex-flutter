import '../l10n/localized_label.dart';

/// Les groupes d'œufs, traduits. Quinze entrées figées : c'est moins cher
/// qu'un asset, et la liste n'a pas bougé depuis la génération II.
const Map<String, LocalizedLabel> eggGroupLabels = {
  'monster': LocalizedLabel("Monster", "Monstrueux"),
  'water1': LocalizedLabel("Water 1", "Aquatique 1"),
  'bug': LocalizedLabel("Bug", "Insectoïde"),
  'flying': LocalizedLabel("Flying", "Aérien"),
  'ground': LocalizedLabel("Field", "Terrestre"),
  'fairy': LocalizedLabel("Fairy", "Féerique"),
  'plant': LocalizedLabel("Grass", "Végétal"),
  'humanshape': LocalizedLabel("Human-Like", "Humanoïde"),
  'water3': LocalizedLabel("Water 3", "Aquatique 3"),
  'mineral': LocalizedLabel("Mineral", "Minéral"),
  'indeterminate': LocalizedLabel("Amorphous", "Amorphe"),
  'water2': LocalizedLabel("Water 2", "Aquatique 2"),
  'ditto': LocalizedLabel("Ditto", "Métamorph"),
  'dragon': LocalizedLabel("Dragon", "Draconique"),
  'no-eggs': LocalizedLabel("Undiscovered", "Inconnu"),
};
