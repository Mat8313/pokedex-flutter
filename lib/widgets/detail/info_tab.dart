import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../l10n/localized_label.dart';
import '../../models/egg_group.dart';
import '../../models/pokemon_detail.dart';
import '../../models/pokemon_species.dart';
import '../../services/api_names.dart';
import 'detail_panel.dart';

/// L'onglet « Infos » : la carte d'identité de l'espèce.
class InfoTab extends StatelessWidget {
  final PokemonDetail details;
  final PokemonSpecies? species;

  const InfoTab({super.key, required this.details, required this.species});

  /// L'API compte en décimètres et en hectogrammes.
  static String _metres(int decimetres) => '${(decimetres / 10).toStringAsFixed(1)} m';
  static String _kilos(int hectograms) => '${(hectograms / 10).toStringAsFixed(1)} kg';

  /// [genderRate] est un nombre de chances sur huit d'obtenir une femelle,
  /// `-1` désignant une espèce asexuée.
  static String _gender(int genderRate, AppLocalizations l10n) {
    if (genderRate < 0) return l10n.infoGenderless;

    final female = genderRate / 8 * 100;
    return '♀ ${female.toStringAsFixed(female % 1 == 0 ? 0 : 1)} % · '
        '♂ ${(100 - female).toStringAsFixed(female % 1 == 0 ? 0 : 1)} %';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final language = Localizations.localeOf(context).languageCode;

    final flavor = species?.flavorText[language] ?? species?.flavorText['en'];
    final genus = species?.genus[language] ?? species?.genus['en'];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        if (flavor != null)
          DetailPanel(
            title: l10n.infoPokedexEntry,
            child: Text(
              flavor,
              style: const TextStyle(color: Colors.white, height: 1.5, fontSize: 14),
            ),
          ),
        DetailPanel(
          title: l10n.infoCategory,
          child: Column(
            children: [
              if (genus != null) DetailRow(label: l10n.infoCategory, value: genus),
              DetailRow(label: l10n.infoHeight, value: _metres(details.height)),
              DetailRow(label: l10n.infoWeight, value: _kilos(details.weight)),
              if (species != null)
                DetailRow(label: l10n.infoGender, value: _gender(species!.genderRate, l10n)),
            ],
          ),
        ),
        DetailPanel(
          title: l10n.infoAbilities,
          child: Column(
            children: [
              for (final ability in details.abilities)
                DetailRow(
                  label: context.abilityName(ability.id, ability.apiName),
                  value: ability.isHidden ? l10n.infoHiddenAbility : '',
                ),
            ],
          ),
        ),
        if (species != null)
          DetailPanel(
            title: l10n.appTitle,
            child: Column(
              children: [
                DetailRow(
                  label: l10n.infoEggGroups,
                  value: species!.eggGroups
                      .map(
                        (group) => eggGroupLabels[group] == null
                            ? ApiNames.prettify(group)
                            : context.label(eggGroupLabels[group]!),
                      )
                      .join(' · '),
                ),
                DetailRow(
                  label: l10n.infoCaptureRate,
                  value: '${species!.captureRate} / 255',
                ),
              ],
            ),
          ),
      ],
    );
  }
}
