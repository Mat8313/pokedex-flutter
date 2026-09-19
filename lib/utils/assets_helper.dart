import 'package:flutter/material.dart';

const Map<String, String> typeIcons = {
  'NORMAL': 'assets/icons/Miniature_Type_Normal_GO.png',
  'FIRE': 'assets/icons/Miniature_Type_Feu_GO.png',
  'WATER': 'assets/icons/Miniature_Type_Eau_GO.png',
  'GRASS': 'assets/icons/Miniature_Type_Plante_GO.png',
  'ELECTRIC': 'assets/icons/Miniature_Type_Électrik_GO.png',
  'ICE': 'assets/icons/Miniature_Type_Glace_GO.png',
  'FIGHTING': 'assets/icons/Miniature_Type_Combat_GO.png',
  'POISON': 'assets/icons/Miniature_Type_Poison_GO.png',
  'GROUND': 'assets/icons/Miniature_Type_Sol_GO.png',
  'FLYING': 'assets/icons/Miniature_Type_Vol_GO.png',
  'PSYCHIC': 'assets/icons/Miniature_Type_Psy_GO.png',
  'BUG': 'assets/icons/Miniature_Type_Insecte_GO.png',
  'ROCK': 'assets/icons/Miniature_Type_Roche_GO.png',
  'GHOST': 'assets/icons/Miniature_Type_Spectre_GO.png',
  'DRAGON': 'assets/icons/Miniature_Type_Dragon_GO.png',
  'DARK': 'assets/icons/Miniature_Type_Ténèbres_GO.png',
  'STEEL': 'assets/icons/Miniature_Type_Acier_GO.png',
  'FAIRY': 'assets/icons/Miniature_Type_Fée_GO.png',
};

const Map<String, String> typeBackgrounds = {
  'NORMAL': 'assets/background/Fond_Type_Normal_GO.png',
  'FIRE': 'assets/background/Fond_Type_Feu_GO.png',
  'WATER': 'assets/background/Fond_Type_Eau_GO.png',
  'GRASS': 'assets/background/Fond_Type_Plante_GO.png',
  'ELECTRIC': 'assets/background/Fond_Type_Électrik_GO.png',
  'ICE': 'assets/background/Fond_Type_Glace_GO.png',
  'FIGHTING': 'assets/background/Fond_Type_Combat_GO.png',
  'POISON': 'assets/background/Fond_Type_Poison_GO.png',
  'GROUND': 'assets/background/Fond_Type_Sol_GO.png',
  'FLYING': 'assets/background/Fond_Type_Vol_GO.png',
  'PSYCHIC': 'assets/background/Fond_Type_Psy_GO.png',
  'BUG': 'assets/background/Fond_Type_Insecte_GO.png',
  'ROCK': 'assets/background/Fond_Type_Roche_GO.png',
  'GHOST': 'assets/background/Fond_Type_Spectre_GO.png',
  'DRAGON': 'assets/background/Fond_Type_Dragon_GO.png',
  'DARK': 'assets/background/Fond_Type_Ténèbres_GO.png',
  'STEEL': 'assets/background/Fond_Type_Acier_GO.png',
  'FAIRY': 'assets/background/Fond_Type_Fée_GO.png',
};

const Map<String, String> transformationIcons = {
  'Mega': 'assets/icons/Mega_Evolution_Icon.png',
  'Gigamax': 'assets/icons/Dynamax_Icon.png',
};

/// Jaquette d'un jeu, nommée d'après sa clé de version-group.
///
/// Le fichier peut manquer — Champions n'a pas encore de visuel officiel — et
/// c'est volontairement toléré : la tuile retombe alors sur le titre du jeu sur
/// fond de couleur. Déposer `assets/games/<version-group>.png` suffit à la
/// faire apparaître, sans toucher au code.
String gameCoverPath(String versionGroup) => 'assets/games/$versionGroup.png';

/// Couleur d'identité de chaque version, derrière la jaquette et à la place de
/// celle-ci quand elle manque.
const Map<String, Color> gameColors = {
  'red-blue': Color(0xFFB33A3A),
  'yellow': Color(0xFFD9B23A),
  'gold-silver': Color(0xFFB59A3A),
  'crystal': Color(0xFF4AA3B8),
  'ruby-sapphire': Color(0xFF9B2D30),
  'emerald': Color(0xFF2E8B57),
  'firered-leafgreen': Color(0xFFE06030),
  'diamond-pearl': Color(0xFF6C7BA6),
  'platinum': Color(0xFF8A8F98),
  'heartgold-soulsilver': Color(0xFFC8A22E),
  'black-white': Color(0xFF3A3A3A),
  'black-2-white-2': Color(0xFF5A5A6E),
  'x-y': Color(0xFF3B5BA5),
  'omega-ruby-alpha-sapphire': Color(0xFFA02C2C),
  'sun-moon': Color(0xFFE4761B),
  'ultra-sun-ultra-moon': Color(0xFFB84A1E),
  'lets-go-pikachu-lets-go-eevee': Color(0xFFE8B21A),
  'sword-shield': Color(0xFF2C6FAF),
  'brilliant-diamond-shining-pearl': Color(0xFF7E6BB0),
  'legends-arceus': Color(0xFF6E8B5E),
  'scarlet-violet': Color(0xFFB33232),
  'legends-za': Color(0xFF3C7A6B),
  'champions': Color(0xFFB8862B),
};
