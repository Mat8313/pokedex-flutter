import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

/// Ce qu'on affiche quand un chargement échoue : l'explication et de quoi
/// réessayer, plutôt qu'un indicateur de chargement qui tournerait sans fin.
///
/// [onImage] sert sur la fiche de détail, dont le fond est l'image du type,
/// toujours colorée : le texte y est blanc quel que soit le thème.
class NetworkErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  final bool onImage;

  const NetworkErrorView({
    super.key,
    required this.onRetry,
    this.onImage = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = onImage ? Colors.white : context.colors.onSurface;
    final muted = onImage ? Colors.white70 : context.mutedColor;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 56, color: muted),
            const SizedBox(height: 16),
            Text(
              l10n.errorNetwork,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.errorNetworkHint,
              textAlign: TextAlign.center,
              style: TextStyle(color: muted, fontSize: 14),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.retry),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
