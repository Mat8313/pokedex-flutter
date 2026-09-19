# Session du 19/09/2026 — Pokédex par jeu

## Objectif

Ajouter un second classement à l'accueil : parcourir le Pokédex **par jeu** et non plus
seulement par région, avec pour chaque jeu ses Pokédex régionaux et un Pokédex national.

Décisions prises au démarrage :

- Accueil à **deux onglets** : RÉGIONS / JEUX
- L'onglet JEUX liste les jeux ; un clic ouvre la page du jeu
- Page du jeu : **un onglet par Pokédex régional, plus un onglet NATIONAL**
- Le national ne montre **que les espèces présentes dans le jeu** — pas de Miraidon dans
  Rouge·Bleu. *Révisé en cours de session, voir « Le Pokédex National, deuxième version ».*
- Les formes (Alola, méga, Gigamax…) sont remises à une seconde passe
- Jaquettes remises à plus tard : la couleur de la version en tient lieu.
  *Faites en fin de session, voir « Les jaquettes ».*

## Ce qui a été construit

### `lib/models/game.dart` — le référentiel des Pokédex

`GameDex` (version-group, libellé, liste de `PokedexRef`) et la liste `gamePokedexes`,
23 jeux. La génération n'y est pas recopiée : `GameDex.generationKey` la lit dans
`versionGroupGenerations`, déjà présent pour les sprites.

**Pourquoi une liste distincte de `pokemonGenerations`** — le référentiel des sprites ne
peut pas servir ici :

| Problème | Exemple |
|---|---|
| Il éclate un version-group en plusieurs jeux | `gold` et `silver` → un seul `gold-silver`, donc un seul Pokédex |
| Il ignore les jeux sans sprites | Épée·Bouclier, Soleil·Lune, Legends Arceus ont pourtant un Pokédex |

### `lib/models/pokedex_entry.dart`

- `PokedexEntry` : `entryNumber` (numéro régional), `speciesId` (numéro national), `name`,
  `availableInGame`. `hasOwnNumbering` dit si les deux numéros diffèrent — seul cas où
  afficher les deux a un sens.
- `speciesInGame` : les espèces que le jeu contient, tous ses Pokédex confondus.
- `buildNationalDex` : le national contigu de 1 au plafond du jeu.

### `lib/services/poke_api_service.dart`

`fetchPokedexEntries(String pokedexName)` — **un seul appel par Pokédex**, tout le contenu
arrive d'un coup. Rien à voir avec le N+1 des sprites.

### Côté écran

- `HomePage` : les deux onglets. `RegionPage` est devenue `RegionList` (`region_list.dart`),
  sans `Scaffold` puisqu'elle est désormais montée dans celui de l'accueil.
- `GameList` : une étagère de jaquettes sur deux colonnes (davantage s'il y a la place),
  chacune sur le dégradé de sa version, pris dans `gameColors` (`assets_helper.dart`).
- `GamePokedexPage` : les onglets, et un cache `Map<String, Future<…>>`. On **mémorise le
  `Future`, pas son résultat** : une requête par Pokédex quel que soit le nombre
  d'allers-retours entre onglets, et le national réutilise les `Future` des onglets
  régionaux au lieu de retélécharger.
- `PokemonGrid` (`lib/widgets/`) : la grille sortie de `PokemonPage`, partagée par les deux
  classements. `PokemonPage` lui passe des `PokedexEntry` dont les deux numéros sont égaux.

Un `Builder` enveloppe chaque `FutureBuilder` d'onglet : sans lui, les arguments des enfants
du `TabBarView` sont évalués à la construction de la liste et Épée·Bouclier lancerait ses
trois requêtes d'un coup au lieu d'une.

## Le Pokédex National, deuxième version

La première mouture affichait l'union des Pokédex régionaux du jeu, renumérotée au national.
Elle sautait donc des numéros : #133, puis #144, puis #810. Question de Matis en cours de
session : *est-ce que dans le jeu la numérotation ne commence pas toujours à 1 ?*

Si. Et la réponse change la conception.

**Ce que fait le vrai Pokédex National :** il est contigu de 1 à N et liste *toutes* les
espèces existantes jusqu'à la génération du jeu, y compris celles qu'on n'y obtiendra
jamais. Une espèce jamais croisée s'affiche en `-----`, sans sprite, mais **garde son
numéro**. Dans Platine on peut défiler jusqu'au #001 Bulbizarre, qu'aucune partie solo ne
permet d'attraper.

**Et surtout : la plupart des jeux n'en ont pas.**

| Jeu | Pokédex National |
|---|---|
| Rouge·Bleu, Jaune | aucun — le Pokédex de Kanto *est* la numérotation nationale |
| Or·Argent, Cristal | oui, 251, en bascule d'ordre sur les mêmes entrées |
| Gen III → VI | oui, jusqu'au dernier numéro de la génération |
| Soleil·Lune, USUL, Let's Go, Épée·Bouclier, Legends Arceus, gen IX | **aucun** |
| Diamant Étincelant·Perle Scintillante | oui, mais **493** : c'est un remake de la gen IV |

D'où `GameDex.nationalDexMax`, un `int?` porté par **le jeu** et non par sa génération — DEP·PS
est un jeu de génération VIII dont le national s'arrête à la génération IV. 13 jeux sur 23
en ont un ; les dix autres n'affichent tout simplement pas l'onglet.

Le national se construit donc depuis `/pokedex/national`, tronqué au plafond du jeu, les
espèces absentes étant **marquées et non retirées** : grisées et désaturées dans la grille,
notre équivalent du `-----`. Elles restent consultables au clic — l'application est un
ouvrage de référence, pas une sauvegarde.

`mergeAsNationalDex` a disparu au passage : la réunion des Pokédex régionaux ne sert plus à
bâtir la liste, seulement à savoir ce que le jeu contient.

## Pièges de la PokéAPI rencontrés

### 1. `entry_number` n'est pas le numéro national

Le Pokédex de Sinnoh commence à Tortipouss, 387e au national. Toute navigation vers la page
de détail doit passer `speciesId`, jamais `entryNumber`.

### 2. L'endpoint ne donne l'id de l'espèce que dans une URL

`pokemon_species` ne contient que `{name, url}`. L'id se lit en découpant
`.../pokemon-species/387/` — d'où `PokedexEntry._idFromUrl`.

### 3. Un jeu peut avoir plusieurs Pokédex

X·Y en a 3, Épée·Bouclier 3, Écarlate·Violet 3, Soleil·Lune 5 (le global plus quatre dex
d'îles). D'où un onglet par Pokédex plutôt qu'un bouton régional/national.

### 4. Les dex d'îles d'Alola sont redondants

`original-alola` est l'union de `original-melemele`, `-akala`, `-ulaula` et `-poni`.
Écartés : cinq onglets pour un seul jeu seraient illisibles.

### 5. Colosseum et XD n'ont aucun Pokédex

`/version-group/colosseum` renvoie `pokedexes: []`. Ils sont simplement absents de la liste.

### 6. Les DLC sont des version-groups à part entière

`the-isle-of-armor`, `the-crown-tundra`, `the-teal-mask`, `the-indigo-disk` et
`mega-dimension` existent séparément et **répètent** un Pokédex déjà rattaché au jeu parent.
Les lister donnerait des cartes en double ; leurs Pokédex apparaissent comme onglets
d'Épée·Bouclier, d'Écarlate·Violet et de Légendes Z-A.

### 7. Un même Pokédex sert à plusieurs jeux, parfois de générations différentes

`original-sinnoh` est celui de Diamant·Perle (gen IV) **et** de Diamant Étincelant·Perle
Scintillante (gen VIII). `kanto` sert à cinq version-groups. Ce n'est pas une anomalie — un
test le verrouille pour éviter qu'on « corrige » ça un jour.

### 8. `/pokedex/national` numérote exactement comme les espèces

Vérifié sur les 1025 entrées : `entry_number` égale toujours l'id de l'espèce, et les
paliers de génération tombent pile sur Mew, Celebi, Deoxys, Arceus, Genesect et Volcanion.
Le national se construit donc sans arithmétique d'index — on tronque au plafond du jeu.

> Limite connue : « présent dans le jeu » se lit dans les Pokédex régionaux, ce qui ne
> couvre pas ce qu'un échange ou un transfert pourrait y faire entrer. Platine marque donc
> 210 espèces comme disponibles, pas 493.

### 9. Un Pokédex régional contient des Pokémon des générations précédentes

Hoenn compte 202 entrées pour 135 espèces introduites en génération III. C'est le
prolongement du point 5 de `2026-09-19-onglet-sprites.md` : région et jeu ne découpent pas
la même chose.

### 10. L'ordre des entrées n'est pas garanti

Il est correct aujourd'hui, rien ne l'impose. Le service trie.

## Les jaquettes

22 jaquettes sur 23, récupérées depuis les archives Bulbagarden via leur API MediaWiki
(`action=query&prop=imageinfo`), redimensionnées à 360 px de côté long : 4,2 Mo au total
contre 25 Mo en taille d'origine. Elles vivent dans `assets/games/<version-group>.png`.

**Aucune table de correspondance** : le chemin se déduit de la clé du jeu, via
`gameCoverPath`. Un fichier manquant n'est pas une erreur — `Image.asset` a un
`errorBuilder` qui retombe sur le titre du jeu sur fond coloré. Champions n'ayant pas encore
de visuel officiel, c'est précisément son cas ; déposer le fichier suffira à le corriger,
sans toucher au code.

Deux détails de mise en page qui ont demandé une seconde passe :

- **Les formats varient énormément** : une boîte Game Boy est carrée, un boîtier Switch est
  en 0,62:1. D'où `BoxFit.contain` dans une tuile de proportion fixe, plutôt qu'un rognage
  qui amputerait les unes ou les autres.
- **La légende a une hauteur figée et une hauteur de ligne explicite.** Sans elle, les titres
  à rallonge (« Diamant Étincelant · Perle Scintillante ») étaient *rognés* au lieu d'être
  abrégés : la place réservée par le `Column` ne correspondait pas au rendu réel du texte.

> Ces visuels appartiennent à Nintendo. Le dépôt étant public, c'est un choix assumé — au
> même titre que les icônes de types déjà présentes. Pour revenir en arrière, il suffit
> d'ajouter `assets/games/` au `.gitignore` : le repli fait le reste.

## Tests

43 tests, dont 21 ajoutés cette session :

- `PokedexEntry.fromJson` : id lu dans l'URL, numérotation régionale ≠ nationale, URL du visuel
- `speciesInGame` : réunion des Pokédex du jeu, dédoublonnée ; jeu sans Pokédex
- `buildNationalDex` : contiguïté de 1 au plafond, espèces absentes conservées et marquées,
  troncature au plafond, numérotations confondues
- `fetchPokedexEntries` avec client simulé : parsing, tri d'un JSON désordonné, 404
- Invariants de `gamePokedexes` : pas de version-group en double, chacun daté par
  `versionGroupGenerations` et rattaché à une génération connue, aucun Pokédex vide, un même
  Pokédex partagé par plusieurs jeux, plafond national valide, jeux sans national à `null`,
  plafond de DEP·PS à 493 malgré sa génération VIII

## Suite

- **Les formes par jeu** : le Pokédex liste des espèces, Raichu d'Alola n'a pas d'entrée
  propre. Piste envisagée : un référentiel suffixe → version-group (`-mega` → `x-y`,
  `-alola` → `sun-moon`, `-galar` → `sword-shield`, `-hisui` → `legends-arceus`,
  `-gmax` → `sword-shield`), croisé avec `versionGroupGenerations`. La voie exacte
  (`/pokemon-species` puis `/pokemon-form` par espèce) coûterait 400 requêtes par jeu.
- **La jaquette de Champions**, quand le jeu en aura une.
- Onglets « Infos » et « Combat » de la page de détail, toujours vides.
