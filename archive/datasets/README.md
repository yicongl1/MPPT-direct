# Jeux de données

Le jeu de données utilisé par le projet est dans `../../data/raw/`. Ce dossier
conserve les variantes et la documentation d'origine.

| Fichier | Contenu |
|---|---|
| `STELLA_Notice.pdf` | Notice de la plateforme STELLA : capteurs, pas de 1 min (1440 points par jour), panneaux SPR-X21-345, équations de puissance. |
| `irradiation_stella.xlsx` | Même acquisition que `../../data/raw/Irradiation.xlsx`, mais **sans la colonne de dates** : 366 lignes (une par jour) × 1440 colonnes (une par minute). Utilisé par `../legacy_scripts/irra_stella.m`. |
| `irradiation_pler.xlsx` | Autre série d'éclairement : 12 feuilles, 288 lignes par feuille (pas de 5 min), sans dates ni en-tête exploitable. Provenance non documentée dans le dépôt. |

Les fichiers d'entrée du projet (`CellT.xlsx`, `AmbiantT.xlsx`,
`Irradiation.xlsx`) sont dans `data/raw/`, avec une ligne d'en-tête des heures
et une colonne de dates ISO (`yyyy-mm-dd`).
