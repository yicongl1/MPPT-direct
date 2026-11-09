# Autres méthodes et modèles de base

Travaux du groupe qui ne relèvent pas du P&O / P&OA : ils sont conservés pour
montrer la couverture du rapport `../../docs/BA04_rapport.pdf`.

## Logique floue — `Fuzzy/`

| Fichier | Rôle |
|---|---|
| `Fuzzy_Logic.slx` | Modèle Simulink du contrôleur flou (version 2019a conservée en `.slx.r2019a`). |
| `MPPT_Controller.fis` | Système d'inférence flou (Mamdani, 5 ensembles NB/NS/Z/PS/PB) au format FIS. |
| `OutPO.m`, `OutPOA.m` | Variantes du calcul d'énergie journalière pour ce modèle (journées de 1440 échantillons, contre 43200 pour le modèle principal). |
| `description.docx` | Note d'utilisation. |

L'espace de travail sauvegardé de cette simulation (`P&O.mat`, 18 Mo) a été
supprimé : c'est un état de session, non reproductible sans son environnement, et
il représentait à lui seul un cinquième du dépôt.

## Autres algorithmes — `simulations_BA04_P24/`

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

La référence scientifique de ces modèles — Villalva, Gazoli et Ruppert Filho,
*Comprehensive Approach to Modeling and Simulation of Photovoltaic Arrays*,
IEEE Trans. Power Electronics, 2009 — est rangée avec les autres articles, dans
`../references/papers/`.
