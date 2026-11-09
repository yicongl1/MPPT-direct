# Autres méthodes et modèles de base

[中文](#中文) · [Français](#français)

Travaux du groupe qui ne relèvent pas du P&O / P&OA : ils sont conservés pour
montrer la couverture du rapport `../../docs/BA04_rapport.pdf`.

---

## 中文

这些是组内与 P&O / P&OA 无关的工作，保留用于展示报告
`../../docs/BA04_rapport.pdf` 的覆盖面。

### 模糊逻辑 —— `Fuzzy/`

| 文件 | 作用 |
|---|---|
| `Fuzzy_Logic.slx` | 模糊控制器 Simulink 模型（2019a 版本保存在 `.slx.r2019a`）。 |
| `MPPT_Controller.fis` | 模糊推理系统（Mamdani，5 个集合 NB/NS/Z/PS/PB），FIS 格式。 |
| `OutPO.m`、`OutPOA.m` | 针对该模型的日发电量计算变体（每天 1440 个样本，主模型是 43200 个）。 |
| `description.docx` | 使用说明。 |

该仿真保存的工作区文件（`P&O.mat`，18 MB）已删除：它是会话状态，脱离原环境
无法复现，且单独占了仓库五分之一的空间。

### 其他算法 —— `simulations_BA04_P24/`

| 文件 | 作用 |
|---|---|
| `INC.slx` | 固定步长的电导增量法。 |
| `PAS_VAR.slx` | 变步长算法。 |
| `pv_modeling_2_MPPT_POA.slx.r2020b` | 主模型的 2020b 版本，保留用于对比。 |

### 基础 PV 模型

| 文件 | 作用 |
|---|---|
| `KC200GT.slx` | Kyocera KC200GT 组件模型。 |
| `mod_pv.slx` | 课程用的基础 PV 模型。 |

这些模型所依据的文献 —— Villalva、Gazoli、Ruppert Filho，
*Comprehensive Approach to Modeling and Simulation of Photovoltaic Arrays*，
IEEE Trans. Power Electronics，2009 —— 归入 `../references/papers/`。

---

## Français

### Logique floue — `Fuzzy/`

| Fichier | Rôle |
|---|---|
| `Fuzzy_Logic.slx` | Modèle Simulink du contrôleur flou (version 2019a conservée en `.slx.r2019a`). |
| `MPPT_Controller.fis` | Système d'inférence flou (Mamdani, 5 ensembles NB/NS/Z/PS/PB) au format FIS. |
| `OutPO.m`, `OutPOA.m` | Variantes du calcul d'énergie journalière pour ce modèle (journées de 1440 échantillons, contre 43200 pour le modèle principal). |
| `description.docx` | Note d'utilisation. |

L'espace de travail sauvegardé de cette simulation (`P&O.mat`, 18 Mo) a été
supprimé : c'est un état de session, non reproductible sans son environnement, et
il représentait à lui seul un cinquième du dépôt.

### Autres algorithmes — `simulations_BA04_P24/`

| Fichier | Rôle |
|---|---|
| `INC.slx` | Conductance incrémentale à pas fixe. |
| `PAS_VAR.slx` | Algorithme à pas variable. |
| `pv_modeling_2_MPPT_POA.slx.r2020b` | Version 2020b du modèle principal, conservée pour comparaison. |

### Modèles PV de base

| Fichier | Rôle |
|---|---|
| `KC200GT.slx` | Modèle du panneau Kyocera KC200GT. |
| `mod_pv.slx` | Modèle PV élémentaire du cours. |

La référence scientifique de ces modèles — Villalva, Gazoli et Ruppert Filho,
*Comprehensive Approach to Modeling and Simulation of Photovoltaic Arrays*,
IEEE Trans. Power Electronics, 2009 — est rangée avec les autres articles, dans
`../references/papers/`.
