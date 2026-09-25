import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Une réponse gardée en cache, et si elle est encore assez récente pour être
/// servie sans consulter le réseau.
class CachedBody {
  final String body;
  final bool isFresh;

  const CachedBody(this.body, {required this.isFresh});
}

/// Où [PokeApiService] range les réponses de l'API.
abstract class ApiCache {
  Future<CachedBody?> read(Uri url);
  Future<void> write(Uri url, String body);
}

/// Aucun cache : chaque appel part sur le réseau. C'est ce que reçoivent les
/// tests, pour qu'une réponse gardée par l'un ne fausse pas le suivant.
class NoApiCache implements ApiCache {
  const NoApiCache();

  @override
  Future<CachedBody?> read(Uri url) async => null;

  @override
  Future<void> write(Uri url, String body) async {}
}

/// Cache en mémoire doublé d'un cache disque.
///
/// Les données de la PokéAPI ne bougent presque jamais : une fiche déjà vue
/// s'ouvre instantanément, sans réseau, et reste consultable hors ligne. Au-delà
/// de [maxAge], une réponse est d'abord redemandée au réseau, mais reste servie
/// si celui-ci ne répond pas.
///
/// Le disque n'existe pas sur le web, où le navigateur fait déjà ce travail :
/// seul le cache mémoire y est actif. Une erreur d'accès au disque n'est jamais
/// fatale, le cache se contente alors de ne rien trouver.
class PersistentApiCache implements ApiCache {
  PersistentApiCache({this.maxAge = const Duration(days: 30)});

  /// Partagé par toutes les pages : chacune crée son propre service.
  static final PersistentApiCache shared = PersistentApiCache();

  final Duration maxAge;
  final Map<String, String> _memory = {};
  Future<Directory?>? _directory;

  Future<Directory?> _cacheDirectory() => _directory ??= () async {
    if (kIsWeb) return null;
    try {
      final base = await getApplicationCacheDirectory();
      return await Directory('${base.path}/pokeapi').create(recursive: true);
    } catch (_) {
      return null;
    }
  }();

  /// `https://pokeapi.co/api/v2/pokemon/6` → `api_v2_pokemon_6.json`
  static String _fileName(Uri url) =>
      '${'${url.path}${url.query}'.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_').replaceAll(RegExp(r'^_+|_+$'), '')}.json';

  @override
  Future<CachedBody?> read(Uri url) async {
    final key = url.toString();
    final inMemory = _memory[key];
    if (inMemory != null) return CachedBody(inMemory, isFresh: true);

    final directory = await _cacheDirectory();
    if (directory == null) return null;

    try {
      final file = File('${directory.path}/${_fileName(url)}');
      if (!await file.exists()) return null;

      final body = await file.readAsString();
      final age = DateTime.now().difference(await file.lastModified());
      _memory[key] = body;
      return CachedBody(body, isFresh: age < maxAge);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> write(Uri url, String body) async {
    _memory[url.toString()] = body;

    final directory = await _cacheDirectory();
    if (directory == null) return;

    try {
      await File('${directory.path}/${_fileName(url)}').writeAsString(body);
    } catch (_) {
      // Disque plein ou inaccessible : le cache mémoire suffit pour la session.
    }
  }
}
