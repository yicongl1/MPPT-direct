# Jeux de données

[中文](#中文) · [Français](#français)

Le jeu de données utilisé par le projet est dans `../../data/raw/`. Ce dossier
conserve les variantes et la documentation d'origine.

---

## 中文

项目实际使用的数据在 `../../data/raw/`。这个目录保存的是原始变体和平台说明。

| 文件 | 内容 |
|---|---|
| `STELLA_Notice.pdf` | STELLA 平台说明：传感器、1 分钟采样（每天 1440 点）、SPR-X21-345 组件、功率计算公式。 |
| `irradiation_stella.xlsx` | 与 `../../data/raw/Irradiation.xlsx` 同一批采集数据，但**不含日期列**：366 行（每天一行）× 1440 列（每分钟一列）。`../legacy_scripts/irra_stella.m` 使用它。 |
| `irradiation_pler.xlsx` | 另一组辐照数据：12 个工作表，每表 288 行（5 分钟步长），无日期、无可用表头。仓库中未记录其来源。 |

项目输入文件（`CellT.xlsx`、`AmbiantT.xlsx`、`Irradiation.xlsx`）位于
`data/raw/`，第一行是时刻表头，第一列是 ISO 格式日期（`yyyy-mm-dd`）。

---

## Français

| Fichier | Contenu |
|---|---|
| `STELLA_Notice.pdf` | Notice de la plateforme STELLA : capteurs, pas de 1 min (1440 points par jour), panneaux SPR-X21-345, équations de puissance. |
| `irradiation_stella.xlsx` | Même acquisition que `../../data/raw/Irradiation.xlsx`, mais **sans la colonne de dates** : 366 lignes (une par jour) × 1440 colonnes (une par minute). Utilisé par `../legacy_scripts/irra_stella.m`. |
| `irradiation_pler.xlsx` | Autre série d'éclairement : 12 feuilles, 288 lignes par feuille (pas de 5 min), sans dates ni en-tête exploitable. Provenance non documentée dans le dépôt. |

Les fichiers d'entrée du projet (`CellT.xlsx`, `AmbiantT.xlsx`,
`Irradiation.xlsx`) sont dans `data/raw/`, avec une ligne d'en-tête des heures et
une colonne de dates ISO (`yyyy-mm-dd`).
