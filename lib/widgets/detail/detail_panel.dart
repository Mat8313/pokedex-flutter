import 'package:flutter/material.dart';

/// Le contenu défilant d'un onglet de la fiche.
///
/// La barre d'onglets est épinglée dans un `SliverOverlapAbsorber` : sans
/// l'injecteur correspondant, la liste démarrerait sous la barre et ses
/// premières lignes passeraient derrière les onglets.
///
/// Sur tablette, les onglets vivent dans leur propre colonne, hors de tout
/// `NestedScrollView` : il n'y a alors rien à injecter.
class DetailTabList extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final List<Widget> children;

  const DetailTabList({
    super.key,
    required this.padding,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final isNested =
        context.findAncestorStateOfType<NestedScrollViewState>() != null;

    return CustomScrollView(
      slivers: [
        if (isNested)
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
        SliverPadding(
          padding: padding,
          sliver: SliverList.list(children: children),
        ),
      ],
    );
  }
}

/// Un bloc de la fiche de détail.
///
/// Le fond de la fiche est l'image du type, toujours colorée : ces panneaux
/// sont volontairement sombres et translucides dans les deux thèmes, sans quoi
/// le texte deviendrait illisible par-dessus.
class DetailPanel extends StatelessWidget {
  final String title;
  final Widget child;

  const DetailPanel({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

/// Une ligne « libellé — valeur » dans un [DetailPanel].
class DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const DetailRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
