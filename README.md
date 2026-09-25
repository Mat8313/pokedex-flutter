<div align="center">

<img src="docs/images/icone.png" width="96" alt="Icône de l'application" />

# Pokédex

**Un Pokédex fait maison, en Flutter, pour Android et iPhone.**
Choisis un jeu, parcours son Pokédex, ouvre la fiche de n'importe quel Pokémon.
En français et en anglais.

[**⬇️ Télécharger la dernière version**](https://github.com/Mat8313/pokedex-flutter/releases/latest)

<img src="docs/images/demo.gif" width="300" alt="Démonstration de l'application" />

</div>

---

## Ce que fait l'application

- **Par région ou par jeu** — de Rouge · Bleu à Légendes Z-A, chaque jeu a son propre Pokédex,
  avec ses Pokédex régionaux (Paldea, Septentria, Myrtille…) et le National quand il existe.
- **Formes alternatives** — les formes régionales (Tauros de Paldéa, Raichu d'Alola…) apparaissent
  dans les jeux où elles existent ; Méga-Évolutions et formes Gigamax sont sur la fiche.
- **Fiche complète** — sprites de chaque génération (normaux, chromatiques, femelles), types,
  description, taille, poids, talents, groupes d'œufs, table des faiblesses, chaîne d'évolution
  avec ses conditions.
- **Recherche et filtres** par nom et par type.
- **Français et anglais**, thème sombre ou clair, sprite chromatique par défaut au choix.
- **Hors ligne** — tout ce qui a déjà été consulté reste disponible sans réseau.
- **Tablette** — la fiche passe sur deux colonnes.

<div align="center">

<img src="docs/images/01-regions.png" width="190" alt="Accueil par régions" />
<img src="docs/images/02-jeux.png" width="190" alt="Liste des jeux" />
<img src="docs/images/03-pokedex-jeu.png" width="190" alt="Pokédex d'un jeu" />
<img src="docs/images/04-fiche.png" width="190" alt="Fiche d'un Pokémon" />

<img src="docs/images/05-mega.png" width="190" alt="Méga-Évolution" />
<img src="docs/images/06-infos.png" width="190" alt="Onglet Infos et groupes d'œufs" />
<img src="docs/images/07-english.png" width="190" alt="Application en anglais" />
<img src="docs/images/09-hors-ligne.png" width="190" alt="Écran hors ligne" />

<img src="docs/images/08-tablette.png" width="620" alt="Fiche sur tablette" />

</div>

## Installer

> **En bref :** sur Android, on télécharge un fichier `.apk` et on l'ouvre (5 minutes).
> Sur iPhone, Apple n'autorise que l'App Store : il faut passer par un petit outil gratuit
> installé sur un ordinateur (20 minutes la première fois). Tout est détaillé ci-dessous,
> étape par étape.

| Ton appareil | Le fichier à prendre | Version minimale | Aller à |
|---|---|---|---|
| Téléphone ou tablette **Android** | `pokedex-vX.Y.Z.apk` | Android 7.0 | [Installer sur Android](#-installer-sur-android) |
| **iPhone** ou **iPad** | `pokedex-vX.Y.Z.ipa` | iOS 15 | [Installer sur iPhone / iPad](#-installer-sur-iphone--ipad) |

Les deux fichiers se trouvent sur la page
[**Releases → dernière version**](https://github.com/Mat8313/pokedex-flutter/releases/latest),
tout en bas, dans la partie **Assets** (si elle est repliée, touche le mot *Assets* pour la
déplier). `X.Y.Z` est le numéro de version, par exemple `pokedex-v1.0.0.apk`.

---

### 🤖 Installer sur Android

Tout se fait **depuis le téléphone**, sans ordinateur.

**1. Télécharger le fichier**

1. Sur le téléphone, ouvre ce lien dans Chrome (ou ton navigateur habituel) :
   **https://github.com/Mat8313/pokedex-flutter/releases/latest**
2. Fais défiler jusqu'à **Assets** et touche **`pokedex-vX.Y.Z.apk`**.
3. Chrome peut prévenir que *« ce type de fichier peut être dangereux »* : touche
   **Télécharger quand même**. C'est le message affiché pour toute application qui ne vient pas
   du Play Store.

**2. Ouvrir le fichier**

1. Quand le téléchargement est fini, touche **Ouvrir** dans la notification.
   Si tu l'as ratée : ouvre l'application **Fichiers** (ou *Mes fichiers* sur Samsung) →
   **Téléchargements** → touche `pokedex-vX.Y.Z.apk`.

**3. Autoriser l'installation (une seule fois)**

1. Android affiche : *« Pour votre sécurité, votre téléphone n'est pas autorisé à installer des
   applications inconnues provenant de cette source »*. Touche **Paramètres**.
2. Active **Autoriser cette source** (ou *Autoriser depuis cette source*).
3. Reviens en arrière avec le bouton retour : la fenêtre d'installation réapparaît.

**4. Installer**

1. Touche **Installer**.
2. Google Play Protect peut afficher *« Appli non vérifiée »* ou *« Application bloquée pour
   protéger votre appareil »*, simplement parce qu'il ne connaît pas l'application.
   Touche **Plus de détails** puis **Installer quand même**.
3. Touche **Ouvrir**. L'icône **Pokédex** (une Poké Ball sur fond rouge) est aussi sur l'écran
   d'accueil ou dans la liste des applications.

**Mettre à jour :** télécharge le nouvel `.apk` depuis la page Releases et refais les étapes 2
et 4. L'application s'installe par-dessus l'ancienne, tes réglages sont conservés.

**Désinstaller :** appui long sur l'icône → **Désinstaller**.

> [!NOTE]
> **Nouvelles règles d'Android (fin 2026 – 2027).** Google impose progressivement que les
> applications installées hors du Play Store viennent d'un développeur vérifié : à partir du
> 30 septembre 2026 au Brésil, en Indonésie, à Singapour et en Thaïlande, puis dans le monde
> entier en 2027. Si Android refuse un jour l'installation, il reste le **parcours avancé**
> prévu par Google, à faire une seule fois : activer les options pour les développeurs,
> confirmer que personne ne te guide à distance, redémarrer le téléphone, patienter 24 heures,
> puis autoriser l'installation des applications de développeurs non vérifiés.
> [Explications de Google](https://android-developers.googleblog.com/2026/03/android-developer-verification.html).

---

### 🍎 Installer sur iPhone / iPad

Apple n'autorise pas l'installation d'applications en dehors de l'App Store, sauf pour les
développeurs qui testent leur propre application. Les outils ci-dessous utilisent justement ce
mécanisme : ils signent l'`.ipa` avec **ton identifiant Apple** (un compte gratuit suffit), et
l'iPhone la considère alors comme ton application de test.

**Ce qu'il faut savoir avant de commencer :**

- Il faut un **ordinateur** (Windows ou Mac), un **câble** pour brancher l'iPhone, et ton
  **identifiant Apple** (adresse e-mail et mot de passe, plus le code à 6 chiffres reçu sur ton
  iPhone si la double authentification est activée).
- Ces outils envoient ton identifiant et ton mot de passe **uniquement aux serveurs d'Apple**.
  Si tu préfères, crée un identifiant Apple secondaire, gratuit, rien que pour ça.
- Avec un identifiant **gratuit**, l'application **cesse de s'ouvrir au bout de 7 jours** tant
  qu'elle n'est pas « rafraîchie » (re-signée). Ça prend quelques secondes, et AltStore ou
  SideStore peuvent le faire tout seuls. Tes données dans l'application ne sont pas perdues.
- Un identifiant gratuit est limité à **3 applications installées de cette façon en même temps**
  (AltStore ou SideStore comptent dans les trois).

**Quelle méthode choisir ?**

| Méthode | Facilité | Rafraîchissement tous les 7 jours | Ordinateur nécessaire |
|---|---|---|---|
| [**A. Sideloadly**](#méthode-a--sideloadly-la-plus-simple) | ⭐⭐⭐ | depuis l'ordinateur (automatique possible) | à chaque rafraîchissement |
| [**B. AltStore Classic**](#méthode-b--altstore-classic) | ⭐⭐ | automatique, si l'ordinateur est allumé sur le même Wi-Fi | tant que tu l'utilises |
| [**C. SideStore**](#méthode-c--sidestore-sans-ordinateur-ensuite) | ⭐ | depuis l'iPhone, tout seul | une seule fois, à l'installation |

Si tu hésites : **Sideloadly** pour essayer rapidement, **SideStore** pour ne plus avoir besoin
de l'ordinateur ensuite.

#### Méthode A — Sideloadly (la plus simple)

**Préparer l'ordinateur (une seule fois)**

1. **Sur Windows uniquement** : installe **iTunes** et **iCloud** depuis le **site d'Apple**, pas
   depuis le Microsoft Store (les versions du Store ne fonctionnent pas avec ces outils ; si tu
   les as, désinstalle-les d'abord) :
   - iTunes : https://www.apple.com/itunes/download/win64
   - iCloud : https://updates.cdn-apple.com/2020/windows/001-39935-20200911-1A70AA56-F448-11EA-8CC0-99D41950005E/iCloudSetup.exe

   Sur Mac, il n'y a rien à installer.
2. Télécharge **Sideloadly** sur **https://sideloadly.io** et installe-le.
3. Sur l'ordinateur, télécharge **`pokedex-vX.Y.Z.ipa`** depuis la
   [page Releases](https://github.com/Mat8313/pokedex-flutter/releases/latest).

**Installer l'application**

1. Branche l'iPhone à l'ordinateur avec le câble et **déverrouille-le**.
2. Si l'iPhone demande *« Faire confiance à cet ordinateur ? »* : touche **Se fier** et tape ton
   code.
3. Ouvre **Sideloadly**. Ton iPhone apparaît dans la liste des appareils (*iDevice*).
4. **Glisse le fichier `pokedex-vX.Y.Z.ipa`** sur la grande icône *IPA* de la fenêtre.
5. Tape ton **identifiant Apple** (adresse e-mail) dans le champ *Apple account*.
6. Clique sur **Start**, puis tape ton **mot de passe Apple** (et le code à 6 chiffres si
   demandé).
7. Attends le message **Done** en bas de la fenêtre.

Passe ensuite aux [réglages de l'iPhone](#réglages-à-faire-sur-liphone-toutes-les-méthodes).

**Tous les 7 jours :** rebranche l'iPhone et refais les étapes 3 à 7. Sideloadly propose aussi
un rafraîchissement automatique en arrière-plan quand l'ordinateur est allumé.

#### Méthode B — AltStore Classic

AltStore est une application installée sur l'iPhone, aidée par **AltServer**, un petit
programme qui tourne sur l'ordinateur.

> Dans l'Union européenne, il existe aussi *AltStore PAL*, une boutique alternative officielle :
> ce n'est **pas** celle-ci. Il faut **AltStore Classic**, qui permet d'installer un fichier `.ipa`.

**Préparer l'ordinateur (une seule fois, Windows)**

1. Installe **iTunes** et **iCloud** depuis le site d'Apple (pas le Microsoft Store), avec les
   mêmes liens que dans la [méthode A](#méthode-a--sideloadly-la-plus-simple).
2. Télécharge **AltServer** : https://cdn.altstore.io/file/altstore/altinstaller.zip
3. Décompresse le fichier `.zip` et lance **Setup.exe**.
4. Dans la barre de recherche Windows, tape **AltServer**, fais un clic droit →
   **Exécuter en tant qu'administrateur**. Autorise l'accès au réseau privé si Windows le
   demande. AltServer s'affiche sous forme d'icône près de l'horloge (derrière la petite flèche
   **^** si tu ne la vois pas).

Sur Mac, le guide officiel est ici :
https://faq.altstore.io/altstore-classic/how-to-install-altstore-macos

**Installer AltStore sur l'iPhone**

1. Branche l'iPhone, déverrouille-le, touche **Se fier** si l'ordinateur est demandé.
2. Ouvre **iTunes**, connecte-toi avec ton identifiant Apple, clique sur l'icône de l'iPhone et
   coche **Synchroniser avec cet iPhone en Wi-Fi** → **Appliquer**. C'est ce qui permettra le
   rafraîchissement automatique.
3. Clique sur l'icône **AltServer** près de l'horloge → **Install AltStore** → choisis ton iPhone.
4. Tape ton identifiant Apple et ton mot de passe, puis attends la notification de réussite.
5. Fais les [réglages de l'iPhone](#réglages-à-faire-sur-liphone-toutes-les-méthodes), puis
   ouvre **AltStore**.

**Installer Pokédex avec AltStore**

1. Sur l'iPhone, ouvre la
   [page Releases](https://github.com/Mat8313/pokedex-flutter/releases/latest) dans **Safari**,
   touche **`pokedex-vX.Y.Z.ipa`** puis **Télécharger**.
2. Ouvre **AltStore** → onglet **My Apps** → bouton **+** en haut à gauche.
3. Va dans **Téléchargements** et choisis `pokedex-vX.Y.Z.ipa`. L'application s'installe
   (l'ordinateur avec AltServer doit être allumé, sur le même Wi-Fi).

**Tous les 7 jours :** AltStore rafraîchit tout seul si AltServer tourne sur l'ordinateur et que
l'iPhone est sur le même Wi-Fi. Sinon : **My Apps** → **Refresh All**.

Guide officiel : https://faq.altstore.io/altstore-classic/how-to-install-altstore-windows

#### Méthode C — SideStore (sans ordinateur ensuite)

SideStore est une version d'AltStore qui se rafraîchit **depuis l'iPhone lui-même**, grâce à une
petite application VPN. Ce VPN ne fait passer ta connexion par aucun serveur : il reste sur le
téléphone. L'ordinateur ne sert qu'une fois, pour l'installation. Il faut **iOS 15 ou plus** et
le **Wi-Fi**.

**Préparer (une seule fois)**

1. Sur l'iPhone, installe **LocalDevVPN** depuis l'**App Store** (gratuit).
2. Sur l'ordinateur :
   - **Windows** : installe **iTunes** (site d'Apple ou Microsoft Store).
   - Télécharge **iloader**, l'installateur de SideStore, sur **https://iloader.app** (Windows :
     *MSI Installer* ou *EXE Installer*) et installe-le. Ne le télécharge que depuis ce site ou
     depuis https://github.com/nab138/iloader.

**Installer SideStore**

1. Branche l'iPhone, déverrouille-le, touche **Se fier** si demandé.
2. Ouvre **iloader** et connecte-toi avec ton identifiant Apple (attention aux majuscules).
3. Choisis ton iPhone, puis **Install SideStore (Stable)**. Attends la fin.
4. Fais les [réglages de l'iPhone](#réglages-à-faire-sur-liphone-toutes-les-méthodes).
5. Ouvre **LocalDevVPN** et active la connexion.
6. Ouvre **SideStore** et connecte-toi avec ton identifiant Apple.
7. Onglet **My Apps** → touche le compteur **7 DAYS** sous SideStore pour le rafraîchir une
   première fois, et accepte les messages éventuels.

Tu peux débrancher l'iPhone : l'ordinateur ne sert plus.

**Installer Pokédex avec SideStore**

1. Dans **Safari**, ouvre la
   [page Releases](https://github.com/Mat8313/pokedex-flutter/releases/latest), touche
   **`pokedex-vX.Y.Z.ipa`** puis **Télécharger**.
2. Active **LocalDevVPN**.
3. Ouvre **SideStore** → **My Apps** → **+** → **Téléchargements** → `pokedex-vX.Y.Z.ipa`.

**Tous les 7 jours :** active **LocalDevVPN**, ouvre **SideStore** → **My Apps** → touche le
compteur de jours (ou **Refresh All**).

Guide officiel : https://docs.sidestore.io/docs/installation/install

#### Réglages à faire sur l'iPhone (toutes les méthodes)

À faire **une seule fois**, juste après la première installation.

**1. Faire confiance à ton identifiant Apple**

Sans ça, l'application refuse de s'ouvrir (*« Développeur non approuvé »*).

1. **Réglages** → **Général** → **VPN et gestion de l'appareil**.
2. Sous *App de développeur*, touche ton adresse e-mail Apple.
3. Touche **Faire confiance à « ton adresse »** → **Se fier**.

**2. Activer le mode développeur (iOS 16 et plus)**

1. **Réglages** → **Confidentialité et sécurité** → tout en bas, **Mode développeur**. L'option
   n'apparaît qu'après avoir installé une première application par l'une des méthodes
   ci-dessus.
2. Active-le, puis touche **Redémarrer**.
3. Après le redémarrage, confirme avec **Activer** et ton code.

Tu peux maintenant ouvrir **Pokédex** depuis l'écran d'accueil.

#### Mettre à jour sur iPhone

Télécharge le nouvel `.ipa` et installe-le de la même façon (Sideloadly : glisser le nouveau
fichier ; AltStore ou SideStore : **My Apps** → **+**). Il remplace l'ancien, tes réglages sont
conservés.

---

### ❓ Problèmes fréquents

<details>
<summary><b>Android : « Application non installée » ou « Le package semble non valide »</b></summary>

- Le téléchargement est peut-être incomplet : supprime le fichier et retélécharge-le.
- Si une ancienne version avait été compilée par quelqu'un d'autre (autre signature),
  désinstalle-la d'abord.
- Vérifie qu'il reste de la place sur le téléphone (environ 150 Mo).
</details>

<details>
<summary><b>Android : je ne trouve pas l'option « Autoriser cette source »</b></summary>

Selon les marques, elle se trouve dans **Paramètres** → **Applications** → (menu ⋮) **Accès
spécial** → **Installer des applis inconnues** → choisis ton navigateur ou *Fichiers* → active
**Autoriser cette source**.
</details>

<details>
<summary><b>iPhone : « Développeur non approuvé » à l'ouverture</b></summary>

Fais l'étape [Faire confiance à ton identifiant Apple](#réglages-à-faire-sur-liphone-toutes-les-méthodes).
</details>

<details>
<summary><b>iPhone : l'application s'ouvre puis se ferme aussitôt, ou ne s'ouvre plus</b></summary>

Les 7 jours sont écoulés : rafraîchis-la (Sideloadly : réinstaller ; AltStore ou SideStore :
**My Apps** → **Refresh All**). Rien n'est perdu.
</details>

<details>
<summary><b>iPhone : « Maximum number of apps » ou limite de 3 applications</b></summary>

Un identifiant Apple gratuit n'autorise que 3 applications installées de cette façon en même
temps, et 10 nouvelles par semaine. Dans AltStore ou SideStore, désactive ou supprime une autre
application installée de cette façon, puis réessaie.
</details>

<details>
<summary><b>Windows : AltServer ou Sideloadly ne voient pas l'iPhone</b></summary>

- Vérifie que l'iPhone est **déverrouillé** et que tu as touché **Se fier**.
- Vérifie qu'iTunes et iCloud viennent bien du **site d'Apple**, pas du Microsoft Store.
- Essaie un autre câble ou un autre port USB, et relance AltServer **en tant qu'administrateur**.
</details>

<details>
<summary><b>iPhone : « Mode développeur » n'apparaît pas dans les réglages</b></summary>

Il n'apparaît qu'après la première installation d'une application par Sideloadly, AltStore ou
SideStore. Installe d'abord, puis retourne dans **Confidentialité et sécurité**. Sur iOS 15, ce
mode n'existe pas et n'est pas nécessaire.
</details>

## Compiler soi-même

Il faut [Flutter](https://docs.flutter.dev/get-started/install) (canal stable).

```bash
git clone https://github.com/Mat8313/pokedex-flutter.git
cd pokedex-flutter
flutter pub get
flutter run
```

```bash
flutter test                      # tests unitaires
flutter test integration_test     # parcours complet, sur un appareil branché
flutter build apk --release       # APK Android
```

## Publier une version

Pousser un tag de version déclenche le workflow [`release.yml`](.github/workflows/release.yml) :
il compile l'APK sur Linux et l'IPA sur macOS, puis crée la Release avec les deux fichiers.

```bash
git tag v1.0.0
git push origin v1.0.0
```

**Signature Android (recommandé).** Sans clé, chaque APK est signé avec une clé jetable
différente, et une nouvelle version ne peut pas remplacer l'ancienne sans désinstallation.
Créer la clé une fois (voir [`docs/2026-09-25-pret-pour-mobile.md`](docs/2026-09-25-pret-pour-mobile.md)),
puis l'ajouter dans *Settings → Secrets and variables → Actions* :

| Secret | Valeur |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | le fichier `.jks` encodé en base64 |
| `ANDROID_KEYSTORE_PASSWORD` | le mot de passe du keystore |
| `ANDROID_KEY_ALIAS` | l'alias de la clé (`pokedex`) |
| `ANDROID_KEY_PASSWORD` | le mot de passe de la clé |

Pour obtenir le base64 sous Windows :

```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("$env:USERPROFILE\pokedex-release.jks")) | Set-Clipboard
```

## Sous le capot

- **Flutter** / Dart, Material 3, sans framework d'état : `setState`, `FutureBuilder` et un
  `ChangeNotifier` pour les réglages.
- Données : [PokéAPI](https://pokeapi.co). Les noms traduits (espèces, talents, objets, formes)
  sont extraits hors ligne de ses fichiers CSV et embarqués dans `assets/i18n/`, pour qu'une
  grille de 400 Pokémon s'affiche traduite sans 400 requêtes.
- Cache : réponses de l'API gardées en mémoire et sur le disque (`lib/services/api_cache.dart`),
  images via `cached_network_image`.
- Traductions de l'interface : fichiers `.arb` dans `lib/l10n/`.

## Crédits

- Données et sprites : [PokéAPI](https://pokeapi.co) et [PokeAPI/sprites](https://github.com/PokeAPI/sprites).
- Projet personnel d'étudiant, sans but commercial et **sans lien avec Nintendo, Game Freak ou
  The Pokémon Company**. Pokémon et les noms associés sont des marques de leurs détenteurs.

---

<details>
<summary><b>English</b></summary>

A homemade Pokédex built with Flutter for Android and iOS: browse by region or by game (Red ·
Blue to Legends: Z-A, with each game's own regional dexes and alternate forms), open a full
entry for any Pokémon (sprites from every generation, types, abilities, egg groups, weaknesses,
evolution chain), in English or French, with offline caching and a tablet layout.

**Install:** grab the `.apk` (Android 7+) or the unsigned `.ipa` (iOS 15+) from the
[latest release](https://github.com/Mat8313/pokedex-flutter/releases/latest). On Android, open
the APK and allow installs from that source. On iPhone, sideload the IPA with
[Sideloadly](https://sideloadly.io), [AltStore Classic](https://faq.altstore.io) or
[SideStore](https://docs.sidestore.io) using your Apple ID (free accounts need a refresh every
7 days), then trust your Apple ID in *Settings → General → VPN & Device Management* and enable
*Developer Mode*. The French section above has every step in detail.
**Build:** `flutter pub get && flutter run`.

A personal student project, not affiliated with Nintendo, Game Freak or The Pokémon Company.

</details>
