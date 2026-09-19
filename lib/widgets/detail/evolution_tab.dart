import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/pokemon_species.dart';
import '../../services/api_names.dart';
import 'detail_panel.dart';

/// L'onglet « Évolutions » : la chaîne complète, avec ses conditions.
class EvolutionTab extends StatelessWidget {
  final EvolutionNode? chain;
  final int currentSpeciesId;
  final void Function(int speciesId, String apiName) onSelect;

  const EvolutionTab({
    super.key,
    required this.chain,
    required this.currentSpeciesId,
    required this.onSelect,
  });

  /// Traduit une condition d'évolution.
  ///
  /// Les conditions cumulables sont énumérées dans l'ordre où un joueur les
  /// lirait ; le déclencheur ne sert que de repli, quand aucun détail
  /// exploitable n'accompagne l'évolution.
  static String _describe(EvolutionStep step, AppLocalizations l10n, BuildContext context) {
    final parts = <String>[];

    if (step.minLevel != null) parts.add(l10n.evolutionAtLevel(step.minLevel!));
    if (step.item != null) parts.add(l10n.evolutionUseItem(context.itemName(step.item!)));
    if (step.heldItem != null) {
      parts.add(l10n.evolutionHoldItem(context.itemName(step.heldItem!)));
    }
    if (step.minHappiness != null) parts.add(l10n.evolutionHighFriendship);
    if (step.knownMove != null) {
      parts.add(l10n.evolutionKnowsMove(ApiNames.prettify(step.knownMove!)));
    }
    if (step.timeOfDay == 'day') parts.add(l10n.evolutionDaytime);
    if (step.timeOfDay == 'night') parts.add(l10n.evolutionNighttime);

    if (parts.isEmpty) {
      return switch (step.trigger) {
        'trade' => l10n.evolutionTrade,
        'level-up' => l10n.evolutionLevelUp,
        _ => l10n.evolutionOther,
      };
    }

    // L'échange se cumule avec le reste (Kadabra s'échange, Onix s'échange en
    // tenant une Peau Métal) : il vient en tête plutôt qu'en repli.
    if (step.trigger == 'trade') parts.insert(0, l10n.evolutionTrade);

    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final nodes = chain?.flattened ?? const <EvolutionNode>[];

    if (nodes.length < 2) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.evolutionNone,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        DetailPanel(
          title: l10n.tabEvolutions,
          child: Column(
            children: [
              for (final node in nodes)
                _EvolutionRow(
                  node: node,
                  isCurrent: node.speciesId == currentSpeciesId,
                  condition: node.steps.isEmpty
                      ? null
                      : node.steps.map((step) => _describe(step, l10n, context)).join('  /  '),
                  onTap: () => onSelect(node.speciesId, node.name),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EvolutionRow extends StatelessWidget {
  final EvolutionNode node;
  final bool isCurrent;
  final String? condition;
  final VoidCallback onTap;

  const _EvolutionRow({
    required this.node,
    required this.isCurrent,
    required this.condition,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (condition != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: [
                const Icon(Icons.arrow_downward, color: Colors.white54, size: 18),
                const SizedBox(height: 2),
                Text(
                  condition!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        Material(
          color: isCurrent ? Colors.white.withValues(alpha: 0.14) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: isCurrent ? null : onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  Image.network(
                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${node.speciesId}.png',
                    height: 56,
                    width: 56,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(height: 56, width: 56),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      context.speciesName(node.speciesId, node.name).toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: isCurrent ? FontWeight.w900 : FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  Text(
                    '#${node.speciesId.toString().padLeft(4, '0')}',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
