# Archive

Ce dossier conserve les éléments qui ne font pas partie du projet « vivant ».
Le code exécutable se trouve dans `src/`, les modèles dans `models/`, les
données dans `data/`.

## Contenu

| Dossier | Contenu |
|---|---|
| `legacy_scripts/` | Versions d'origine des scripts MATLAB, avant unification. Conservées telles quelles pour l'historique. |
| `other_methods/` | Travaux du groupe sur les autres méthodes : logique floue (`Fuzzy/`), conductance incrémentale et pas variable (`Simulations BA04 P24/`), modèles PV de base (`KC200GT.slx`, `mod_pv.slx`). |
| `datasets/` | Variantes de jeux de données : sorties brutes de la station STELLA, extractions d'irradiation complémentaires. |
| `references/` | Bibliographie du projet : 17 articles rangés dans `papers/` (voir son `README.md`), plus la thèse UTC citée dans le rapport. |
| `simulink_build_cache/` | Caches de compilation Simulink (`slprj/`, `.slxc`, `.slx.r2022b`, `.slx.original`). Régénérables, ignorés par Git. |
| `README_original.md` | Premier README du dépôt, conservé pour mémoire. |

## Contenu retiré

- `references/exams/` (quatre sujets et corrigés de BA04 d'autres années) et
  `references/li_yicong.xlsx` (fiche administrative) : sans lien avec le projet.
- `references/Article.zip` : supprimé une fois son contenu décompressé et
  vérifié dans `references/papers/`.
- `misc/` : page web téléchargée, sans rapport avec le sujet.

## Doublons supprimés

Les fichiers strictement identiques (empreinte MD5 égale) ont été supprimés en
conservant une seule copie. Le dossier `archive/P&O(A)/` était une copie
complète du dépôt (185 fichiers identiques, même historique Git) : il a été
retiré au profit des fichiers actifs.

L'archive `references/Article.zip` contenait 16 PDF : trois étaient déjà présents
à l'identique dans `references/` et n'ont pas été dupliqués, les 13 autres ont
été extraits et renommés d'après leur titre. Le `.zip` a ensuite été supprimé
(voir « Contenu retiré »).
