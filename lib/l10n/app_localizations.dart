import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Pokédex'**
  String get appTitle;

  /// No description provided for @tabRegions.
  ///
  /// In en, this message translates to:
  /// **'REGIONS'**
  String get tabRegions;

  /// No description provided for @tabGames.
  ///
  /// In en, this message translates to:
  /// **'GAMES'**
  String get tabGames;

  /// No description provided for @tabNational.
  ///
  /// In en, this message translates to:
  /// **'NATIONAL'**
  String get tabNational;

  /// No description provided for @tabSprites.
  ///
  /// In en, this message translates to:
  /// **'SPRITES'**
  String get tabSprites;

  /// No description provided for @tabInfo.
  ///
  /// In en, this message translates to:
  /// **'INFO'**
  String get tabInfo;

  /// No description provided for @tabBattle.
  ///
  /// In en, this message translates to:
  /// **'BATTLE'**
  String get tabBattle;

  /// No description provided for @tabEvolutions.
  ///
  /// In en, this message translates to:
  /// **'EVOLUTIONS'**
  String get tabEvolutions;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error'**
  String get errorNetwork;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search a Pokémon'**
  String get searchHint;

  /// No description provided for @filterTypes.
  ///
  /// In en, this message translates to:
  /// **'Types'**
  String get filterTypes;

  /// No description provided for @filterClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get filterClear;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches this search'**
  String get noResults;

  /// No description provided for @resultCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No Pokémon} =1{1 Pokémon} other{{count} Pokémon}}'**
  String resultCount(int count);

  /// No description provided for @infoCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get infoCategory;

  /// No description provided for @infoHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get infoHeight;

  /// No description provided for @infoWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get infoWeight;

  /// No description provided for @infoAbilities.
  ///
  /// In en, this message translates to:
  /// **'Abilities'**
  String get infoAbilities;

  /// No description provided for @infoHiddenAbility.
  ///
  /// In en, this message translates to:
  /// **'hidden'**
  String get infoHiddenAbility;

  /// No description provided for @infoEggGroups.
  ///
  /// In en, this message translates to:
  /// **'Egg groups'**
  String get infoEggGroups;

  /// No description provided for @infoCaptureRate.
  ///
  /// In en, this message translates to:
  /// **'Capture rate'**
  String get infoCaptureRate;

  /// No description provided for @infoGrowthRate.
  ///
  /// In en, this message translates to:
  /// **'Growth rate'**
  String get infoGrowthRate;

  /// No description provided for @infoGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get infoGender;

  /// No description provided for @infoGenderless.
  ///
  /// In en, this message translates to:
  /// **'Genderless'**
  String get infoGenderless;

  /// No description provided for @infoPokedexEntry.
  ///
  /// In en, this message translates to:
  /// **'Pokédex entry'**
  String get infoPokedexEntry;

  /// No description provided for @infoUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get infoUnknown;

  /// No description provided for @statHp.
  ///
  /// In en, this message translates to:
  /// **'HP'**
  String get statHp;

  /// No description provided for @statAttack.
  ///
  /// In en, this message translates to:
  /// **'Attack'**
  String get statAttack;

  /// No description provided for @statDefense.
  ///
  /// In en, this message translates to:
  /// **'Defense'**
  String get statDefense;

  /// No description provided for @statSpecialAttack.
  ///
  /// In en, this message translates to:
  /// **'Sp. Atk'**
  String get statSpecialAttack;

  /// No description provided for @statSpecialDefense.
  ///
  /// In en, this message translates to:
  /// **'Sp. Def'**
  String get statSpecialDefense;

  /// No description provided for @statSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get statSpeed;

  /// No description provided for @statTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get statTotal;

  /// No description provided for @battleBaseStats.
  ///
  /// In en, this message translates to:
  /// **'Base stats'**
  String get battleBaseStats;

  /// No description provided for @battleTypeChart.
  ///
  /// In en, this message translates to:
  /// **'Type matchups'**
  String get battleTypeChart;

  /// No description provided for @battleWeaknesses.
  ///
  /// In en, this message translates to:
  /// **'Weak to'**
  String get battleWeaknesses;

  /// No description provided for @battleResistances.
  ///
  /// In en, this message translates to:
  /// **'Resists'**
  String get battleResistances;

  /// No description provided for @battleImmunities.
  ///
  /// In en, this message translates to:
  /// **'Immune to'**
  String get battleImmunities;

  /// No description provided for @battleNeutral.
  ///
  /// In en, this message translates to:
  /// **'This Pokémon has no particular weakness or resistance.'**
  String get battleNeutral;

  /// No description provided for @evolutionNone.
  ///
  /// In en, this message translates to:
  /// **'This Pokémon does not evolve.'**
  String get evolutionNone;

  /// No description provided for @evolutionAtLevel.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String evolutionAtLevel(int level);

  /// No description provided for @evolutionUseItem.
  ///
  /// In en, this message translates to:
  /// **'Use {item}'**
  String evolutionUseItem(String item);

  /// No description provided for @evolutionHoldItem.
  ///
  /// In en, this message translates to:
  /// **'Holding {item}'**
  String evolutionHoldItem(String item);

  /// No description provided for @evolutionTrade.
  ///
  /// In en, this message translates to:
  /// **'Trade'**
  String get evolutionTrade;

  /// No description provided for @evolutionHighFriendship.
  ///
  /// In en, this message translates to:
  /// **'High friendship'**
  String get evolutionHighFriendship;

  /// No description provided for @evolutionKnowsMove.
  ///
  /// In en, this message translates to:
  /// **'Knows {move}'**
  String evolutionKnowsMove(String move);

  /// No description provided for @evolutionDaytime.
  ///
  /// In en, this message translates to:
  /// **'Daytime'**
  String get evolutionDaytime;

  /// No description provided for @evolutionNighttime.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get evolutionNighttime;

  /// No description provided for @evolutionLevelUp.
  ///
  /// In en, this message translates to:
  /// **'Level up'**
  String get evolutionLevelUp;

  /// No description provided for @evolutionOther.
  ///
  /// In en, this message translates to:
  /// **'Special condition'**
  String get evolutionOther;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get settingsLanguageFrench;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsPokedexSection.
  ///
  /// In en, this message translates to:
  /// **'Pokédex'**
  String get settingsPokedexSection;

  /// No description provided for @settingsShinyByDefault.
  ///
  /// In en, this message translates to:
  /// **'Shiny by default'**
  String get settingsShinyByDefault;

  /// No description provided for @settingsShinyByDefaultHint.
  ///
  /// In en, this message translates to:
  /// **'Open every Pokémon on its shiny sprite'**
  String get settingsShinyByDefaultHint;

  /// No description provided for @settingsMissingSpecies.
  ///
  /// In en, this message translates to:
  /// **'Species absent from a game'**
  String get settingsMissingSpecies;

  /// No description provided for @settingsMissingSpeciesHint.
  ///
  /// In en, this message translates to:
  /// **'In a game\'s National Pokédex'**
  String get settingsMissingSpeciesHint;

  /// No description provided for @settingsMissingGreyed.
  ///
  /// In en, this message translates to:
  /// **'Greyed out'**
  String get settingsMissingGreyed;

  /// No description provided for @settingsMissingHidden.
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get settingsMissingHidden;

  /// No description provided for @settingsMissingShown.
  ///
  /// In en, this message translates to:
  /// **'Shown normally'**
  String get settingsMissingShown;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsDataSource.
  ///
  /// In en, this message translates to:
  /// **'Data from PokéAPI'**
  String get settingsDataSource;

  /// No description provided for @settingsSpritesSource.
  ///
  /// In en, this message translates to:
  /// **'Sprites and artwork from the PokeAPI/sprites bank'**
  String get settingsSpritesSource;

  /// No description provided for @gameNoNationalDex.
  ///
  /// In en, this message translates to:
  /// **'This game has no National Pokédex.'**
  String get gameNoNationalDex;

  /// No description provided for @errorNetworkHint.
  ///
  /// In en, this message translates to:
  /// **'Check your connection, then try again.'**
  String get errorNetworkHint;

  /// No description provided for @errorFormLoad.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this form.'**
  String get errorFormLoad;

  /// No description provided for @noGameSprites.
  ///
  /// In en, this message translates to:
  /// **'No game sprites for this form'**
  String get noGameSprites;

  /// No description provided for @a11yFemaleSprite.
  ///
  /// In en, this message translates to:
  /// **'Female sprite'**
  String get a11yFemaleSprite;

  /// No description provided for @a11yShinySprite.
  ///
  /// In en, this message translates to:
  /// **'Shiny sprite'**
  String get a11yShinySprite;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
