import 'package:flutter/material.dart';

/// Les deux thèmes de l'application.
///
/// Les écrans lisent leurs couleurs dans `Theme.of(context)` plutôt que de les
/// écrire en dur : c'est ce qui permet au réglage clair/sombre d'exister.
/// Seule la fiche de détail fait exception, son texte étant posé sur l'image
/// de fond du type, toujours colorée.
abstract final class AppTheme {
  /// Le rouge de la licence, identique dans les deux thèmes.
  static const Color accent = Colors.redAccent;

  static final ThemeData dark = _build(
    brightness: Brightness.dark,
    background: const Color(0xFF121212),
    surface: const Color(0xFF1E1E1E),
    surfaceHigh: const Color(0xFF2A2D34),
    onSurface: Colors.white,
    onSurfaceVariant: const Color(0xFF9E9E9E),
  );

  static final ThemeData light = _build(
    brightness: Brightness.light,
    background: const Color(0xFFF2F2F7),
    surface: Colors.white,
    surfaceHigh: const Color(0xFFE4E7EF),
    onSurface: const Color(0xFF1C1C1E),
    onSurfaceVariant: const Color(0xFF6B6B70),
  );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color surfaceHigh,
    required Color onSurface,
    required Color onSurfaceVariant,
  }) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: accent,
      onPrimary: Colors.white,
      secondary: accent,
      onSecondary: Colors.white,
      error: Colors.redAccent,
      onError: Colors.white,
      surface: surface,
      onSurface: onSurface,
      surfaceContainerHighest: surfaceHigh,
      onSurfaceVariant: onSurfaceVariant,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      cardColor: surface,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: onSurface,
        titleTextStyle: TextStyle(
          color: onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: 2.0,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        indicatorColor: accent,
        labelColor: onSurface,
        unselectedLabelColor: onSurfaceVariant,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: accent),
    );
  }
}

/// Raccourcis de lecture, pour ne pas répéter `Theme.of(context).colorScheme`.
extension AppThemeContext on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;

  /// Le fond des cartes et des vignettes.
  Color get cardColor => Theme.of(this).cardColor;

  /// La couleur du texte secondaire : numéros, légendes, libellés discrets.
  Color get mutedColor => Theme.of(this).colorScheme.onSurfaceVariant;
}
