# Session du 19/09/2026 — Onglet Sprites par jeu

## Objectif

Remplir l'onglet « Sprites » de la page de détail : regrouper tous les sprites d'un
Pokémon par jeu de la licence principale, dans une grille séparée par génération.

Décisions prises au démarrage :

- **Face uniquement**, une vignette par jeu — un clic remplace le sprite affiché en haut
- Les bascules **chromatique** et **sexe** de l'en-tête filtrent aussi l'onglet
- Séparation à **deux niveaux** : génération puis jeu
- Les jeux **sans sprite** pour le Pokémon affiché sont masqués

## Ce qui a été construit

### `lib/models/game.dart` — le référentiel des jeux

Liste ordonnée des générations et de leurs jeux, avec les libellés français. Chaque jeu
porte trois informations :

| Champ | Rôle |
|---|---|
| `spriteKey` | clé dans `sprites.versions` de l'endpoint `/pokemon` |
| `versionGroup` | clé de l'endpoint `/version-group` |
| `spriteExtension` | extension réelle des fichiers dans la banque (`png` par défaut) |

Le fichier contient aussi `versionGroupGenerations`, qui date **tous** les version-groups
existants — y compris ceux absents de la table des sprites, car une forme peut avoir été
introduite par un jeu qui n'a aucun sprite dans la banque.

> Ce référentiel resservira pour l'onglet de tri de la page des régions.

### `lib/models/sprite_set.dart` — les variantes et le parsing

- `SpriteSet` : les quatre variantes de face (`default`, `shiny`, `female`, `shiny female`)
  avec `variant(shiny:, female:)`, qui applique un repli quand la variante demandée
  n'existe pas — **on abandonne le sexe avant le chromatique**, bien plus visible à l'écran.
- `parseSpritesByGeneration` : construit la liste ordonnée depuis `sprites.versions`.
- `spritesSinceVersionGroup` : masque les générations antérieures à l'apparition de la forme.

Le même `SpriteSet` sert pour les sprites principaux du Pokémon et pour ceux de chaque jeu :
une seule logique de repli, un seul endroit à corriger.

### Côté écran

- État `selectedGameKey` : on mémorise **la clé du jeu**, jamais l'URL résolue. L'image se
  recalcule ainsi toute seule quand les bascules changent.
- Sélection réinitialisée au changement de forme (une méga n'existe pas dans les vieux jeux).
- Exclusion mutuelle avec le carrousel des formes cosmétiques.
- `FilterQuality.none` sur le pixel art, sinon l'agrandissement le rend flou.

## Pièges de la PokéAPI rencontrés

C'est la partie à relire avant de retoucher aux sprites.

### 1. L'ordre des clés JSON est arbitraire

L'API a renvoyé les générations dans cet ordre : I, V, II, IV, IX, VI, III, VII, VIII.
**Le parsing itère sur notre liste ordonnée, pas sur les clés du JSON.** Ça règle d'un coup
l'ordre chronologique, l'exclusion des entrées inconnues, et la robustesse si l'API ajoute
une clé un jour.

### 2. Les variantes disponibles changent selon la génération

| Génération | Ce qui existe |
|---|---|
| I | face/dos, **pas de chromatique** (ça n'existait pas), versions gris et transparent |
| II | + chromatique, transparent |
| III → IV | face/dos + chromatique, femelle à partir de la IV |
| V | tout, + des GIF animés |
| VI → VII | face uniquement, plus de dos |
| VIII → IX | souvent un seul sprite, **aucun chromatique** |

Aucun modèle ne peut supposer un jeu de clés fixe.

### 3. Les entrées `icons` ne sont pas des sprites

Présentes en générations V, VII et VIII : ce sont les icônes de menu. Elles sont simplement
absentes de notre référentiel, donc jamais lues.

### 4. Les clés sprites ≠ les clés version-group

Les sprites séparent `gold` et `silver`, l'API des version-groups ne connaît que
`gold-silver`. De même `omegaruby-alphasapphire` côté sprites contre
`omega-ruby-alpha-sapphire` côté version-group. D'où les deux champs distincts.

### 5. Génération ≠ région

Rubis Oméga · Saphir Alpha se déroule à Hoenn (région de la gen III) mais **appartient à la
génération VI** : c'est un remake sorti en 2014. Idem pour Rouge Feu·Vert Feuille (gen III,
région Kanto), Or HeartGold·Argent SoulSilver (gen IV, régions Kanto **et** Johto),
Diamant Étincelant·Perle Scintillante (gen VIII, région Sinnoh).

> Conséquence directe pour la suite : **trier par région et trier par jeu ne donneront pas
> le même résultat**. Kanto seul apparaît dans des jeux répartis sur quatre générations.
> C'est une relation plusieurs-à-plusieurs, pas une correspondance simple.

### 6. La banque contient des sprites rétro-dessinés

Le dossier `generation-v/black-white` est devenu la collection *de style* pixel art. Des
contributeurs y ont dessiné des sprites pour des formes qui n'existaient pas en 2010 —
un Gigamax façon Noir·Blanc, alors que le Gigamax date d'Épée·Bouclier (2019).

Corrigé en datant chaque forme par son jeu d'introduction, puis en masquant les générations
antérieures. Bénéfice collatéral : un Pokémon de gen IX n'affiche plus de sprite « Noir·Blanc ».

### 7. Les identifiants `/pokemon-form/` ≠ ceux de `/pokemon/`

`/pokemon-form/10195` renvoie `raticate-totem-alola`, pas `venusaur-gmax`. Le bon
identifiant se lit dans le champ `forms` du détail du Pokémon — que notre modèle
`PokemonForm` extrayait déjà.

### 8. L'API annonce des URL qui n'existent pas

Deux cas rencontrés :

- **Ultra-Soleil · Ultra-Lune** : l'API génère des URL en `.png`, la banque ne contient que
  des `.gif`. Les URL déclarées renvoyaient 404 — d'où le champ `spriteExtension`. Audit fait
  sur les huit autres jeux de la table : tous répondent bien en `.png`.
- **Rendus « home » des formes alternatives** : `other/home/female/<id>.png` n'existe pas
  pour les mégas. Traité par une chaîne de replis qui lâche le sexe avant le chromatique.

De façon générale, l'API construit ses URL sans vérifier le contenu réel du dépôt :
**une URL déclarée n'est pas une URL valide.**

### 9. Gen VIII et IX n'ont aucun sprite chromatique

Ni déclaré par l'API, ni présent sur le dépôt. Le repli affiche le sprite par défaut, de
façon silencieuse — à signaler visuellement un jour si ça prête à confusion.

## Tests

22 tests, dont 11 ajoutés cette session :

- `SpriteSet.variant` : variante exacte, repli sexe avant chromatique, dernier recours, jeu vide
- `parseSpritesByGeneration` : ordre imposé malgré un JSON désordonné, jeux vides écartés,
  générations vides écartées, entrées `icons` ignorées, correction d'extension
- `spritesSinceVersionGroup` : masquage des générations antérieures, forme d'origine conservée,
  **cas ROSA** (datation par génération et non par région), jeu d'introduction inconnu
- `PokeApiService.fetchFormVersionGroup` avec client simulé

## Suite

- Onglet sur la page des régions pour trier le Pokédex par région **ou** par jeu — le
  référentiel `game.dart` est prêt, voir le point 5 sur la relation plusieurs-à-plusieurs
- Onglets « Infos » et « Combat » de la page de détail, encore vides
- Éventuellement : signaler visuellement une vignette dont la variante demandée n'existe pas
