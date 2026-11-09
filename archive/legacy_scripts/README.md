# Scripts d'origine

[中文](#中文) · [Français](#français)

Versions des scripts utilisées pendant le cours, avant unification. Le code
maintenu est dans `../../src/`.

---

## 中文

这些是课程期间使用的原始脚本，尚未合并去重。当前维护的代码在 `../../src/`。
文件按原样保留（未做任何修正），用于记录当时的做法。

### 对应关系

| 原始脚本 | 被谁取代 | 备注 |
|---|---|---|
| `DataAnnee.m` | `src/data/loadYearData.m` | 中文注释版，读取 `CellT.xlsx`。 |
| `DonneeAnnee.m` | `src/data/loadYearData.m` | 法文版，读取 `AmbiantT.xlsx`。 |
| `DataJour.m` | `src/data/loadDayData.m` | 提取某一天。 |
| `DonneeJour.m` | `src/data/loadDayData.m` | 同上，含下面提到的缺陷。 |
| `OutPO.m` / `OutPOA.m` | `src/analysis/computeDailyEnergy.m` | 由 `out.PO` / `out.POA` 计算日发电量。 |
| `EfficacePO.m` / `EfficacePOA.m` | `src/analysis/computeEfficiency.m` | 相对入射太阳能量的效率。 |
| `FigurePO.m` / `FigurePOAirr.m` | `src/analysis/plotDailyComparison.m` | 全年曲线。 |
| `irra_stella.m` | `src/analysis/computeDailyEnergy.m` | 快速估算全年发电量。 |
| `DataAnnee_fuzzy.m` | — | 配合模糊模型的变体，未沿用。 |

这些脚本使用相对文件名（`CellT.xlsx` 等），不宜直接重新运行；它们的价值在于
记录当时的做法。

### 合并时修掉的缺陷

- `DonneeJour.m` 调用了 `getsamples(j_temperature, ...)`，而该变量要到脚本末尾
  才定义，因此选择日期时会直接报错。当前代码使用 `ts_temperature`。
- `OutPO.m` / `OutPOA.m` 用 `extraPoints = 43200 - mod(n, 43200)` 补齐最后一天，
  当样本数恰好是 43200 的整数倍时会多补一整天的数据。
- 日期解析依赖系统区域设置（一边用 `yyyy/MM/dd`，一边用 `fr_FR` 下的
  `dd-MMM-yyyy`），导致其中一个版本无法解析 Excel 里的 ISO 日期。
- `EfficacePO.m` 与 `EfficacePOA.m` 都写入 `efficiency_data.csv`，后者会覆盖
  前者的结果。

---

## Français

### Correspondance

| Script d'origine | Remplacé par | Remarque |
|---|---|---|
| `DataAnnee.m` | `src/data/loadYearData.m` | Version à commentaires chinois, lisait `CellT.xlsx`. |
| `DonneeAnnee.m` | `src/data/loadYearData.m` | Version française, lisait `AmbiantT.xlsx`. |
| `DataJour.m` | `src/data/loadDayData.m` | Extraction d'une journée. |
| `DonneeJour.m` | `src/data/loadDayData.m` | Idem, avec le défaut décrit plus bas. |
| `OutPO.m` / `OutPOA.m` | `src/analysis/computeDailyEnergy.m` | Énergie journalière à partir de `out.PO` / `out.POA`. |
| `EfficacePO.m` / `EfficacePOA.m` | `src/analysis/computeEfficiency.m` | Rendement par rapport à l'énergie solaire. |
| `FigurePO.m` / `FigurePOAirr.m` | `src/analysis/plotDailyComparison.m` | Tracé annuel. |
| `irra_stella.m` | `src/analysis/computeDailyEnergy.m` | Calcul rapide de l'énergie annuelle. |
| `DataAnnee_fuzzy.m` | — | Variante associée au modèle flou, non reprise. |

Ces scripts utilisent des noms de fichiers relatifs (`CellT.xlsx`, etc.) et ne
sont pas destinés à être réexécutés tels quels ; ils documentent la démarche.

### Défauts corrigés lors de l'unification

- `DonneeJour.m` appelait `getsamples(j_temperature, ...)` alors que la variable
  n'existe qu'à la fin du script : la sélection d'une date échouait. Le code
  maintenu utilise `ts_temperature`.
- `OutPO.m` et `OutPOA.m` complétaient la dernière journée avec
  `extraPoints = 43200 - mod(n, 43200)`, ce qui ajoutait une journée entière
  lorsque le nombre d'échantillons était déjà un multiple de 43200.
- Le format de date dépendait de la locale (`yyyy/MM/dd` d'un côté,
  `dd-MMM-yyyy` en `fr_FR` de l'autre) : une des deux versions ne pouvait pas
  parser les dates ISO du fichier Excel.
- `EfficacePO.m` et `EfficacePOA.m` écrivaient tous deux `efficiency_data.csv` :
  le second écrasait le premier.
