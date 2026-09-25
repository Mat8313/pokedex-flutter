import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Une image du réseau, gardée en cache sur l'appareil.
///
/// Sprites et illustrations ne changent jamais : sur téléphone, les garder sur
/// le disque évite de les retélécharger à chaque ouverture et les rend
/// disponibles hors ligne.
///
/// Sur le web, le navigateur les met déjà en cache. `cached_network_image` y
/// passe en plus par des éléments `<img>` que le moteur de rendu affiche en noir
/// quand l'image revient à l'écran (retour sur une page) : on s'en tient donc à
/// `NetworkImage`.
ImageProvider networkImage(String url) =>
    kIsWeb ? NetworkImage(url) : CachedNetworkImageProvider(url);
