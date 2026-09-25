// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Pokédex';

  @override
  String get tabRegions => 'RÉGIONS';

  @override
  String get tabGames => 'JEUX';

  @override
  String get tabNational => 'NATIONAL';

  @override
  String get tabSprites => 'SPRITES';

  @override
  String get tabInfo => 'INFOS';

  @override
  String get tabBattle => 'COMBAT';

  @override
  String get tabEvolutions => 'ÉVOLUTIONS';

  @override
  String get errorNetwork => 'Erreur réseau';

  @override
  String get retry => 'Réessayer';

  @override
  String get searchHint => 'Rechercher un Pokémon';

  @override
  String get filterTypes => 'Types';

  @override
  String get filterClear => 'Effacer';

  @override
  String get noResults => 'Aucun résultat pour cette recherche';

  @override
  String resultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Pokémon',
      one: '1 Pokémon',
      zero: 'Aucun Pokémon',
    );
    return '$_temp0';
  }

  @override
  String get infoCategory => 'Catégorie';

  @override
  String get infoHeight => 'Taille';

  @override
  String get infoWeight => 'Poids';

  @override
  String get infoAbilities => 'Talents';

  @override
  String get infoHiddenAbility => 'caché';

  @override
  String get infoEggGroups => 'Groupes d\'œufs';

  @override
  String get infoCaptureRate => 'Taux de capture';

  @override
  String get infoGrowthRate => 'Courbe d\'expérience';

  @override
  String get infoGender => 'Sexe';

  @override
  String get infoGenderless => 'Asexué';

  @override
  String get infoPokedexEntry => 'Description du Pokédex';

  @override
  String get infoUnknown => 'Inconnu';

  @override
  String get statHp => 'PV';

  @override
  String get statAttack => 'Attaque';

  @override
  String get statDefense => 'Défense';

  @override
  String get statSpecialAttack => 'Atq. Spé.';

  @override
  String get statSpecialDefense => 'Déf. Spé.';

  @override
  String get statSpeed => 'Vitesse';

  @override
  String get statTotal => 'Total';

  @override
  String get battleBaseStats => 'Statistiques de base';

  @override
  String get battleTypeChart => 'Table des types';

  @override
  String get battleWeaknesses => 'Faible contre';

  @override
  String get battleResistances => 'Résiste à';

  @override
  String get battleImmunities => 'Immunisé contre';

  @override
  String get battleNeutral =>
      'Ce Pokémon n\'a ni faiblesse ni résistance particulière.';

  @override
  String get evolutionNone => 'Ce Pokémon n\'évolue pas.';

  @override
  String evolutionAtLevel(int level) {
    return 'Niveau $level';
  }

  @override
  String evolutionUseItem(String item) {
    return 'Utiliser $item';
  }

  @override
  String evolutionHoldItem(String item) {
    return 'En tenant $item';
  }

  @override
  String get evolutionTrade => 'Échange';

  @override
  String get evolutionHighFriendship => 'Bonheur élevé';

  @override
  String evolutionKnowsMove(String move) {
    return 'Connaît $move';
  }

  @override
  String get evolutionDaytime => 'Le jour';

  @override
  String get evolutionNighttime => 'La nuit';

  @override
  String get evolutionLevelUp => 'Montée de niveau';

  @override
  String get evolutionOther => 'Condition particulière';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageFrench => 'Français';

  @override
  String get settingsAppearance => 'Apparence';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeSystem => 'Système';

  @override
  String get settingsPokedexSection => 'Pokédex';

  @override
  String get settingsShinyByDefault => 'Chromatique par défaut';

  @override
  String get settingsShinyByDefaultHint =>
      'Ouvrir chaque Pokémon sur son sprite chromatique';

  @override
  String get settingsMissingSpecies => 'Espèces absentes d\'un jeu';

  @override
  String get settingsMissingSpeciesHint => 'Dans le Pokédex National d\'un jeu';

  @override
  String get settingsMissingGreyed => 'Grisées';

  @override
  String get settingsMissingHidden => 'Masquées';

  @override
  String get settingsMissingShown => 'Affichées normalement';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get settingsDataSource => 'Données issues de la PokéAPI';

  @override
  String get settingsSpritesSource =>
      'Sprites et illustrations issus de la banque PokeAPI/sprites';

  @override
  String get gameNoNationalDex => 'Ce jeu n\'a pas de Pokédex National.';

  @override
  String get errorNetworkHint => 'Vérifie ta connexion, puis réessaie.';

  @override
  String get errorFormLoad => 'Impossible de charger cette forme.';

  @override
  String get noGameSprites => 'Aucun sprite de jeu pour cette forme';

  @override
  String get a11yFemaleSprite => 'Sprite femelle';

  @override
  String get a11yShinySprite => 'Sprite chromatique';
}
