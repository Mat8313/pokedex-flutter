// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pokédex';

  @override
  String get tabRegions => 'REGIONS';

  @override
  String get tabGames => 'GAMES';

  @override
  String get tabNational => 'NATIONAL';

  @override
  String get tabSprites => 'SPRITES';

  @override
  String get tabInfo => 'INFO';

  @override
  String get tabBattle => 'BATTLE';

  @override
  String get tabEvolutions => 'EVOLUTIONS';

  @override
  String get errorNetwork => 'Network error';

  @override
  String get retry => 'Retry';

  @override
  String get searchHint => 'Search a Pokémon';

  @override
  String get filterTypes => 'Types';

  @override
  String get filterClear => 'Clear';

  @override
  String get noResults => 'Nothing matches this search';

  @override
  String resultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Pokémon',
      one: '1 Pokémon',
      zero: 'No Pokémon',
    );
    return '$_temp0';
  }

  @override
  String get infoCategory => 'Category';

  @override
  String get infoHeight => 'Height';

  @override
  String get infoWeight => 'Weight';

  @override
  String get infoAbilities => 'Abilities';

  @override
  String get infoHiddenAbility => 'hidden';

  @override
  String get infoEggGroups => 'Egg groups';

  @override
  String get infoCaptureRate => 'Capture rate';

  @override
  String get infoGrowthRate => 'Growth rate';

  @override
  String get infoGender => 'Gender';

  @override
  String get infoGenderless => 'Genderless';

  @override
  String get infoPokedexEntry => 'Pokédex entry';

  @override
  String get infoUnknown => 'Unknown';

  @override
  String get statHp => 'HP';

  @override
  String get statAttack => 'Attack';

  @override
  String get statDefense => 'Defense';

  @override
  String get statSpecialAttack => 'Sp. Atk';

  @override
  String get statSpecialDefense => 'Sp. Def';

  @override
  String get statSpeed => 'Speed';

  @override
  String get statTotal => 'Total';

  @override
  String get battleBaseStats => 'Base stats';

  @override
  String get battleTypeChart => 'Type matchups';

  @override
  String get battleWeaknesses => 'Weak to';

  @override
  String get battleResistances => 'Resists';

  @override
  String get battleImmunities => 'Immune to';

  @override
  String get battleNeutral =>
      'This Pokémon has no particular weakness or resistance.';

  @override
  String get evolutionNone => 'This Pokémon does not evolve.';

  @override
  String evolutionAtLevel(int level) {
    return 'Level $level';
  }

  @override
  String evolutionUseItem(String item) {
    return 'Use $item';
  }

  @override
  String evolutionHoldItem(String item) {
    return 'Holding $item';
  }

  @override
  String get evolutionTrade => 'Trade';

  @override
  String get evolutionHighFriendship => 'High friendship';

  @override
  String evolutionKnowsMove(String move) {
    return 'Knows $move';
  }

  @override
  String get evolutionDaytime => 'Daytime';

  @override
  String get evolutionNighttime => 'Night';

  @override
  String get evolutionLevelUp => 'Level up';

  @override
  String get evolutionOther => 'Special condition';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageFrench => 'Français';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsPokedexSection => 'Pokédex';

  @override
  String get settingsShinyByDefault => 'Shiny by default';

  @override
  String get settingsShinyByDefaultHint =>
      'Open every Pokémon on its shiny sprite';

  @override
  String get settingsMissingSpecies => 'Species absent from a game';

  @override
  String get settingsMissingSpeciesHint => 'In a game\'s National Pokédex';

  @override
  String get settingsMissingGreyed => 'Greyed out';

  @override
  String get settingsMissingHidden => 'Hidden';

  @override
  String get settingsMissingShown => 'Shown normally';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsDataSource => 'Data from PokéAPI';

  @override
  String get settingsSpritesSource =>
      'Sprites and artwork from the PokeAPI/sprites bank';

  @override
  String get gameNoNationalDex => 'This game has no National Pokédex.';

  @override
  String get errorNetworkHint => 'Check your connection, then try again.';

  @override
  String get errorFormLoad => 'Couldn\'t load this form.';

  @override
  String get noGameSprites => 'No game sprites for this form';

  @override
  String get a11yFemaleSprite => 'Female sprite';

  @override
  String get a11yShinySprite => 'Shiny sprite';
}
