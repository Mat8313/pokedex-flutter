# Session du 25/09/2026 — Prête pour iOS et Android

## Objectif

Passer l'application d'un projet qui tourne en `flutter run` à une application qu'on installe
sur un téléphone : build release fonctionnel, comportement hors ligne, finitions natives, icône.

## Ce qui a été corrigé ou ajouté

### Android

- **Permission `INTERNET`** dans `android/app/src/main/AndroidManifest.xml`. Le modèle Flutter
  ne la déclare que dans les manifestes debug et profile : sans elle, un APK release n'avait
  aucun accès réseau — aucune fiche, aucun sprite.
- **Signature de release** lue dans `android/key.properties` (voir plus bas). Sans ce fichier,
  le build retombe sur la clé de debug : suffisant pour installer l'APK soi-même, pas pour le
  Play Store.

### iOS

- `ios/Runner/PrivacyInfo.xcprivacy`, exigé par Apple : aucun suivi, aucune donnée collectée,
  et les deux API « à raison déclarée » qu'on utilise — `UserDefaults` (réglages, CA92.1) et
  les dates de fichiers (âge du cache, C617.1). Référencé dans `project.pbxproj`, sans quoi il
  ne serait pas embarqué.
- `ITSAppUsesNonExemptEncryption = false` dans `Info.plist` : seul HTTPS est utilisé, ce qui
  évite la question du chiffrement à chaque envoi sur App Store Connect.

### Réseau : erreurs et cache

- **`PersistentApiCache`** (`lib/services/api_cache.dart`) : chaque réponse de la PokéAPI est
  gardée en mémoire et sur disque. Une fiche déjà vue s'ouvre sans réseau ; au-delà de 30 jours
  la réponse est redemandée, mais reste servie si le réseau ne répond pas. Sur le web, seul le
  cache mémoire est actif (le navigateur fait le reste).
- `PokeApiService._get` centralise le chemin : cache frais → réseau (15 s max) → cache ancien
  → erreur. Un client HTTP injecté (les tests) vient **sans** cache par défaut, pour qu'une
  réponse gardée par un test ne fausse pas le suivant.
- **Images** : `networkImage()` (`lib/utils/network_image.dart`) partout à la place de
  `Image.network` — `cached_network_image` sur téléphone, `NetworkImage` sur le web, où le
  paquet affichait en noir les images revenant à l'écran.
- **`NetworkErrorView`** (`lib/widgets/network_error.dart`) remplace les chargements infinis :
  fiche, onglets Infos et Évolutions, grille d'une région, Pokédex d'un jeu. Un échec en
  changeant de forme garde la fiche affichée et le signale par un message discret.

### Fiche de détail

- **Tablette** (≥ 840 px) : deux colonnes, la fiche à gauche, les onglets à droite. L'en-tête,
  la barre d'onglets et leur contenu sont désormais trois variables assemblées selon la largeur.
- La barre d'onglets s'épingle **sous** la flèche retour : le défilement commence sous la barre
  d'app au lieu de passer dessous.
- Flèche retour adaptative (`BackButton` : chevron sur iOS, flèche sur Android).
- **Accessibilité** : libellés pour les bascules sexe et chromatique, les boutons Méga et
  Gigamax (« Méga-Dracaufeu X »), les cartes de forme et de sprite ; icônes de type masquées
  aux lecteurs d'écran, leur nom étant écrit juste dessous.
- **Retour haptique** léger sur chaque bascule et chaque changement de forme.
- Dernière chaîne française codée en dur passée dans les `.arb` (`noGameSprites`).

### Icône et écran de démarrage

Sources dans `assets/icon/` (un SVG par PNG) : la balle de l'icône `catching_pokemon` déjà
utilisée dans l'application, sur le rouge de l'accent. Icône adaptative Android avec sa
variante monochrome (icônes thématiques d'Android 13), écran de démarrage sur le fond sombre
du thème. Pour régénérer après modification :

```
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

### Tests

- Cache : réponse fraîche servie sans réseau, réponse gardée, repli hors ligne, échec sans cache.
- `integration_test/app_test.dart` : région → fiche → types traduits → Infos → groupes d'œufs →
  passage en français. Il tourne sur un appareil, avec le vrai réseau :
  `flutter test integration_test` (validé sur Windows desktop).

## Publier sur le Play Store : la clé de signature

À faire une fois, puis garder la clé **et** ses mots de passe en lieu sûr : une application
publiée ne peut être mise à jour qu'avec la même clé.

```
keytool -genkey -v -keystore %USERPROFILE%\pokedex-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias pokedex
```

Puis créer `android/key.properties` (ignoré par git) :

```
storePassword=<mot de passe du keystore>
keyPassword=<mot de passe de la clé>
keyAlias=pokedex
storeFile=C:\\Users\\<toi>\\pokedex-release.jks
```

`flutter build appbundle` produit alors un bundle signé pour la console Play.

## Distribution : GitHub, pas les stores

L'application se partage depuis GitHub. Le workflow `.github/workflows/release.yml` compile, à
chaque tag `v*`, un APK (Linux) et une IPA non signée (macOS), et les attache à la Release.
L'IPA s'installe avec AltStore, SideStore ou Sideloadly, qui la signent avec l'identifiant Apple
de chacun. Le README explique l'installation et la publication d'une version.

La clé de signature Android garde tout son intérêt hors store : sans elle, chaque APK est signé
par une clé jetable, et une mise à jour ne peut pas s'installer par-dessus la précédente. Elle
se renseigne dans les secrets du dépôt (voir le README).

Le manifeste de confidentialité iOS et la déclaration de chiffrement ne servent qu'aux stores ;
ils ne gênent en rien une installation par sideloading.

## Propriété intellectuelle

Le nom « Pokédex », les jaquettes et les illustrations appartiennent à Nintendo, Game Freak et
The Pokémon Company. Pour un projet de fan open source, sans but commercial et présenté comme
tel (c'est ce que dit le README), c'est l'usage courant ; les stores, eux, refuseraient
l'application.
