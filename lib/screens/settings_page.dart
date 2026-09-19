import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../settings/app_settings.dart';
import '../theme/app_theme.dart';

/// Les réglages de l'application.
///
/// Chaque modification est écrite immédiatement et notifiée : l'application se
/// reconstruit derrière, sans bouton « Enregistrer ».
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = context.settings;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle.toUpperCase())),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          _Section(title: l10n.settingsLanguage),
          RadioGroup<String>(
            groupValue: settings.locale.languageCode,
            onChanged: (code) {
              if (code != null) settings.locale = Locale(code);
            },
            child: Column(
              children: [
                _Choice(value: 'en', title: l10n.settingsLanguageEnglish),
                _Choice(value: 'fr', title: l10n.settingsLanguageFrench),
              ],
            ),
          ),

          _Section(title: l10n.settingsAppearance),
          RadioGroup<ThemeMode>(
            groupValue: settings.themeMode,
            onChanged: (mode) {
              if (mode != null) settings.themeMode = mode;
            },
            child: Column(
              children: [
                _Choice(value: ThemeMode.dark, title: l10n.settingsThemeDark),
                _Choice(value: ThemeMode.light, title: l10n.settingsThemeLight),
                _Choice(value: ThemeMode.system, title: l10n.settingsThemeSystem),
              ],
            ),
          ),

          _Section(title: l10n.settingsPokedexSection),
          SwitchListTile(
            value: settings.shinyByDefault,
            onChanged: (value) => settings.shinyByDefault = value,
            title: Text(l10n.settingsShinyByDefault),
            subtitle: Text(l10n.settingsShinyByDefaultHint),
            activeThumbColor: AppTheme.accent,
          ),
          ListTile(
            title: Text(l10n.settingsMissingSpecies),
            subtitle: Text(l10n.settingsMissingSpeciesHint),
          ),
          RadioGroup<MissingSpeciesDisplay>(
            groupValue: settings.missingSpecies,
            onChanged: (value) {
              if (value != null) settings.missingSpecies = value;
            },
            child: Column(
              children: [
                _Choice(
                  value: MissingSpeciesDisplay.greyed,
                  title: l10n.settingsMissingGreyed,
                ),
                _Choice(
                  value: MissingSpeciesDisplay.hidden,
                  title: l10n.settingsMissingHidden,
                ),
                _Choice(
                  value: MissingSpeciesDisplay.shown,
                  title: l10n.settingsMissingShown,
                ),
              ],
            ),
          ),

          _Section(title: l10n.settingsAbout),
          ListTile(
            leading: Icon(Icons.cloud_outlined, color: context.mutedColor),
            title: Text(l10n.settingsDataSource),
            subtitle: Text(l10n.settingsSpritesSource),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;

  const _Section({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
          color: AppTheme.accent,
        ),
      ),
    );
  }
}

class _Choice<T> extends StatelessWidget {
  final T value;
  final String title;

  const _Choice({required this.value, required this.title});

  @override
  Widget build(BuildContext context) {
    return RadioListTile<T>(
      value: value,
      title: Text(title),
      activeColor: AppTheme.accent,
      dense: true,
    );
  }
}
