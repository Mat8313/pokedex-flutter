import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../l10n/localized_label.dart';
import '../../models/pokemon_detail.dart';
import '../../models/pokemon_type.dart';
import '../../utils/assets_helper.dart';
import 'detail_panel.dart';

/// L'onglet « Combat » : les statistiques de base et la table des types.
class BattleTab extends StatelessWidget {
  final PokemonDetail details;

  const BattleTab({super.key, required this.details});

  /// La plus haute statistique de base du jeu (les PV de Leveinard), pour que
  /// les barres soient comparables d'une fiche à l'autre plutôt que
  /// normalisées sur le maximum du Pokémon affiché.
  static const int _maxBaseStat = 255;

  static const List<String> _order = [
    'hp',
    'attack',
    'defense',
    'special-attack',
    'special-defense',
    'speed',
  ];

  static String _statLabel(String key, AppLocalizations l10n) => switch (key) {
    'hp' => l10n.statHp,
    'attack' => l10n.statAttack,
    'defense' => l10n.statDefense,
    'special-attack' => l10n.statSpecialAttack,
    'special-defense' => l10n.statSpecialDefense,
    'speed' => l10n.statSpeed,
    _ => key,
  };

  /// Du rouge au vert, pour situer une statistique d'un coup d'oeil.
  static Color _statColor(int value) {
    if (value >= 130) return const Color(0xFF4CAF50);
    if (value >= 90) return const Color(0xFF8BC34A);
    if (value >= 60) return const Color(0xFFFFC107);
    return const Color(0xFFFF7043);
  }

  /// Les seules valeurs possibles étant 0, ¼, ½, 2 et 4, on les écrit telles
  /// qu'un joueur les lit plutôt qu'en décimal.
  static String _multiplier(double value) => switch (value) {
    0 => '×0',
    0.25 => '×¼',
    0.5 => '×½',
    _ => '×${value.toInt()}',
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final total = _order.fold<int>(0, (sum, key) => sum + (details.stats[key] ?? 0));
    final effectiveness = typeEffectiveness(
      details.types.map((type) => type.toLowerCase()).toList(),
    );

    final weaknesses = <String, double>{};
    final resistances = <String, double>{};
    final immunities = <String, double>{};
    effectiveness.forEach((type, multiplier) {
      if (multiplier > 1) weaknesses[type] = multiplier;
      if (multiplier > 0 && multiplier < 1) resistances[type] = multiplier;
      if (multiplier == 0) immunities[type] = multiplier;
    });

    return DetailTabList(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        DetailPanel(
          title: l10n.battleBaseStats,
          child: Column(
            children: [
              for (final key in _order)
                _StatBar(
                  label: _statLabel(key, l10n),
                  value: details.stats[key] ?? 0,
                  color: _statColor(details.stats[key] ?? 0),
                ),
              const Divider(color: Colors.white24, height: 20),
              DetailRow(label: l10n.statTotal, value: '$total'),
            ],
          ),
        ),
        DetailPanel(
          title: l10n.battleTypeChart,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (weaknesses.isEmpty && resistances.isEmpty && immunities.isEmpty)
                Text(
                  l10n.battleNeutral,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              if (weaknesses.isNotEmpty)
                _TypeGroup(
                  title: l10n.battleWeaknesses,
                  types: weaknesses,
                  format: _multiplier,
                ),
              if (resistances.isNotEmpty)
                _TypeGroup(
                  title: l10n.battleResistances,
                  types: resistances,
                  format: _multiplier,
                ),
              if (immunities.isNotEmpty)
                _TypeGroup(
                  title: l10n.battleImmunities,
                  types: immunities,
                  format: _multiplier,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatBar extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatBar({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(
            width: 78,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 34,
            child: Text(
              '$value',
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (value / BattleTab._maxBaseStat).clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: Colors.white24,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeGroup extends StatelessWidget {
  final String title;
  final Map<String, double> types;
  final String Function(double) format;

  const _TypeGroup({required this.title, required this.types, required this.format});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final entry in types.entries)
                _TypeChip(typeKey: entry.key, multiplier: format(entry.value)),
            ],
          ),
        ],
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String typeKey;
  final String multiplier;

  const _TypeChip({required this.typeKey, required this.multiplier});

  @override
  Widget build(BuildContext context) {
    final type = pokemonTypesByKey[typeKey];
    final iconPath = typeIcons[typeKey.toUpperCase()];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconPath != null) ...[
            Image.asset(iconPath, height: 18, width: 18),
            const SizedBox(width: 6),
          ],
          Text(
            type == null ? typeKey : context.label(type.label),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          const SizedBox(width: 6),
          Text(
            multiplier,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
