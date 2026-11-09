# Archive

Ce dossier conserve les éléments qui ne font pas partie du projet « vivant ».
Le code exécutable est dans `src/`, les modèles dans `models/`, les données dans
`data/`.

## Contenu

| Dossier | Contenu |
|---|---|
| `legacy_scripts/` | Versions d'origine des scripts MATLAB et table de correspondance avec `src/`. |
| `other_methods/` | Travaux du groupe sur les autres méthodes : logique floue, conductance incrémentale, pas variable, modèles PV de base. |
| `datasets/` | Jeux de données d'origine et notice de la plateforme STELLA. |
| `references/` | Bibliographie du projet : 18 articles dans `papers/` (auteurs et années indiqués), plus la thèse UTC citée dans le rapport. |
| `simulink_build_cache/` | Caches de compilation Simulink (`slprj/`, `.slxc`, `.slx.r2022b`, `.slx.original`). Régénérables, ignorés par Git. |

Chaque sous-dossier dispose de son propre `README.md` détaillant fichier par
fichier.

## Contenu retiré

- `references/exams/` (quatre sujets et corrigés de BA04 d'autres années) et
  `references/li_yicong.xlsx` (fiche administrative) : sans lien avec le projet.
- `references/Article.zip` : supprimé une fois son contenu décompressé et
  vérifié dans `references/papers/`.
- `misc/` : page web téléchargée, sans rapport avec le sujet.
- `other_methods/Fuzzy/P&O.mat` (18 Mo) : état de session MATLAB, non
  reproductible, sans valeur documentaire une fois le rapport écrit.
- `README_original.md` : son contenu a été repris dans le `README.md` à la racine
  (section « Auteurs », mot d'origine), puis le fichier a été supprimé.

## Doublons supprimés

Les fichiers strictement identiques (empreinte MD5 égale) ont été supprimés en
conservant une seule copie. Le dossier `archive/P&O(A)/` était une copie complète
du dépôt (185 fichiers identiques, même historique Git) : il a été retiré au
profit des fichiers actifs.

L'archive `references/Article.zip` contenait 16 PDF : trois étaient déjà présents
à l'identique dans `references/` et n'ont pas été dupliqués, les 13 autres ont
été extraits et renommés d'après leur titre.
