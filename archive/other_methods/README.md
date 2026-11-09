# Autres méthodes et modèles de base

Travaux du groupe qui ne relèvent pas du P&O / P&OA : ils sont conservés pour
montrer la couverture du rapport `../../docs/BA04_rapport.pdf`.

## Logique floue — `Fuzzy/`

| Fichier | Rôle |
|---|---|
| `Fuzzy_Logic.slx` | Modèle Simulink du contrôleur flou (version 2019a conservée en `.slx.r2019a`). |
| `MPPT_Controller.fis` | Système d'inférence flou (Mamdani) au format FIS. |
| `P&O.mat` | Espace de travail sauvegardé de la simulation (18 Mo). |
| `OutPO.m`, `OutPOA.m` | Variantes du calcul d'énergie journalière pour ce modèle (journées de 1440 échantillons, contrairement aux 43200 du modèle principal). |
| `description.docx` | Note d'utilisation. |

## Autres algorithmes — `Simulations BA04 P24/`

| Fichier | Rôle |
|---|---|
| `INC.slx` | Conductance incrémentale à pas fixe. |
| `PAS_VAR.slx` | Algorithme à pas variable. |
| `pv_modeling_2_MPPT_POA.slx.r2020b` | Version 2020b du modèle principal, conservée pour comparaison. |

## Modèles PV de base

| Fichier | Rôle |
|---|---|
| `KC200GT.slx` | Modèle du panneau Kyocera KC200GT. |
| `mod_pv.slx` | Modèle PV élémentaire du cours. |

La référence scientifique de ces modèles — *Comprehensive approach to modeling
and simulation of PV arrays* (IEEE, 2009) — est rangée avec les autres articles,
dans `../references/papers/`.
