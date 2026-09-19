import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../l10n/localized_label.dart';
import '../models/pokedex_entry.dart';
import '../models/pokemon_type.dart';
import '../screens/pokemon_detail_page.dart';
import '../services/api_names.dart';
import '../settings/app_settings.dart';
import '../theme/app_theme.dart';
import '../utils/assets_helper.dart';

/// Grille de vignettes, partagée par le tri par région et le tri par jeu.
///
/// Travaille sur des [PokedexEntry] plutôt que sur des `Pokemon` : c'est la
/// seule forme qui porte à la fois le numéro affiché et le numéro national,
/// lesquels diffèrent dans un Pokédex régional.
///
/// Porte aussi la recherche et le filtre par type : les deux écrans qui
/// l'utilisent en bénéficient sans rien en savoir.
class PokemonGrid extends StatefulWidget {
  final List<PokedexEntry> entries;

  const PokemonGrid({super.key, required this.entries});

  @override
  State<PokemonGrid> createState() => _PokemonGridState();
}

class _PokemonGridState extends State<PokemonGrid> {
  final TextEditingController _search = TextEditingController();
  final Set<String> _selectedTypes = {};

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  /// La recherche porte sur le nom traduit **et** sur l'identifiant d'API :
  /// taper « bulba » doit fonctionner même en français.
  bool _matchesSearch(PokedexEntry entry, String query) {
    if (query.isEmpty) return true;

    final translated = entry.displayName(context).toLowerCase();

    return translated.contains(query) ||
        entry.name.toLowerCase().contains(query) ||
        '${entry.entryNumber}'.padLeft(3, '0').contains(query);
  }

  /// Un Pokémon doit porter **tous** les types cochés : cocher Plante et Poison
  /// cherche les Plante·Poison, pas les Plante ou Poison.
  bool _matchesTypes(PokedexEntry entry) {
    if (_selectedTypes.isEmpty) return true;

    final types = ApiNames.types(entry.speciesId);

    return _selectedTypes.every(types.contains);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final double screenWidth = MediaQuery.of(context).size.width;
    final missingDisplay = context.settings.missingSpecies;
    final query = _search.text.trim().toLowerCase();

    // Masquer les absents fait sauter la numérotation, c'est le choix de
    // l'utilisateur : le réglage le dit explicitement.
    final visible = widget.entries
        .where(
          (entry) =>
              (missingDisplay != MissingSpeciesDisplay.hidden || entry.availableInGame) &&
              _matchesSearch(entry, query) &&
              _matchesTypes(entry),
        )
        .toList();

    int dynamicCrossAxisCount = (screenWidth / 120).toInt();

    // minimum 3 colonnes
    if (dynamicCrossAxisCount < 3) {
      dynamicCrossAxisCount = 3;
    }

    return Column(
      children: [
        _SearchBar(
          controller: _search,
          hint: l10n.searchHint,
          onChanged: (_) => setState(() {}),
        ),
        _TypeFilter(
          selected: _selectedTypes,
          onToggle: (type) => setState(() {
            if (!_selectedTypes.remove(type)) _selectedTypes.add(type);
          }),
        ),
        if (visible.isEmpty)
          Expanded(
            child: Center(
              child: Text(
                l10n.noResults,
                style: TextStyle(color: context.mutedColor),
              ),
            ),
          )
        else
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: dynamicCrossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: visible.length,
              itemBuilder: (context, index) => _PokemonTile(
                entry: visible[index],
                // Dans un Pokédex National, une espèce absente du jeu garde sa
                // place mais s'efface : c'est notre équivalent du ----- du jeu.
                // Elle reste consultable, l'application étant un ouvrage de
                // référence et non une sauvegarde.
                missing:
                    !visible[index].availableInGame &&
                    missingDisplay == MissingSpeciesDisplay.greyed,
              ),
            ),
          ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.controller, required this.hint, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(color: context.colors.onSurface, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: context.mutedColor, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: context.mutedColor, size: 20),
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  icon: Icon(Icons.close, color: context.mutedColor, size: 18),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                ),
          filled: true,
          fillColor: context.cardColor,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _TypeFilter extends StatelessWidget {
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  const _TypeFilter({required this.selected, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: pokemonTypes.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final type = pokemonTypes[index];
          final isSelected = selected.contains(type.key);
          final iconPath = typeIcons[type.key.toUpperCase()];

          return GestureDetector(
            onTap: () => onToggle(type.key),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.accent : context.cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  if (iconPath != null) ...[
                    Image.asset(iconPath, height: 18, width: 18),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    context.label(type.label),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : context.colors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PokemonTile extends StatelessWidget {
  final PokedexEntry entry;
  final bool missing;

  const _PokemonTile({required this.entry, required this.missing});

  @override
  Widget build(BuildContext context) {
    Widget sprite = Image.network(entry.imageUrl, fit: BoxFit.contain);
    if (missing) {
      sprite = ColorFiltered(
        colorFilter: const ColorFilter.matrix(_greyscale),
        child: sprite,
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PokemonDetailPage(
              pokemonName: entry.name,
              // Le numéro national, jamais le numéro régional : le Pokédex de
              // Sinnoh commence à Tortipouss, qui est le 387e national.
              pokemonId: entry.speciesId,
            ),
          ),
        );
      },
      child: Opacity(
        opacity: missing ? 0.4 : 1,
        child: Container(
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(padding: const EdgeInsets.all(8.0), child: sprite),
              ),
              Text(
                entry.displayName(context).toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: context.colors.onSurface,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '#${entry.entryNumber.toString().padLeft(3, '0')}',
                style: TextStyle(
                  fontSize: 11,
                  color: context.mutedColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Hauteur réservée même sans second numéro, pour que les
              // vignettes d'une même grille gardent la même taille d'image.
              SizedBox(
                height: 14,
                child: entry.hasOwnNumbering
                    ? Text(
                        'N°${entry.speciesId.toString().padLeft(4, '0')}',
                        style: TextStyle(
                          fontSize: 10,
                          color: context.mutedColor.withValues(alpha: 0.7),
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

/// Matrice de désaturation (luminance ITU-R BT.709), pour les espèces qu'un jeu
/// ne contient pas.
const List<double> _greyscale = <double>[
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0, 0, 0, 1, 0,
];
