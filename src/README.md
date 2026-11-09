# Code MATLAB

[中文](#中文) · [Français](#français)

Dix fonctions, sans dépendance autre que MATLAB : charger les mesures, simuler,
puis calculer énergie et rendement. Tous les chemins sont déduits de
`projectRoot()`, donc le dépôt peut être déplacé.

---

## 中文

十个函数，除 MATLAB 外没有其他依赖：读数据 → 仿真 → 算发电量与效率。所有路径
都由 `projectRoot()` 推导，仓库可以随意移动。

### 组织方式

| 目录 | 内容 |
|---|---|
| `src/` | 入口与路径工具（`projectRoot`、`setupProject`、`run*`）。 |
| `src/data/` | 读取 Excel 数据，产出 timeseries。 |
| `src/analysis/` | 能量、效率的纯计算与绘图，不碰文件系统（保存除外）。 |

### 调用顺序

```
loadYearData ──► loadDayData ──► runSimulation ──► runAnalysis ──► CSV + 图
      │                                                  ▲
      └── runYearSimulation（循环 366 天）────────────────┘
```

### 函数一览

| 函数 | 输入 | 输出 | 作用 |
|---|---|---|---|
| `projectRoot` | — | `root` | 由自身位置推导仓库根目录。 |
| `setupProject` | — | `root` | 把 `src/` 及其子目录加入搜索路径。 |
| `loadYearData` | `temperatureFile`（可选，默认 `CellT.xlsx`） | `[tsTemperature, tsIrradiance, dateStrings]` | 读一年数据，生成两条 60 s 步长的 timeseries。 |
| `loadDayData` | `tsTemperature, tsIrradiance, dateStrings, requestedDate` | `[tsTemperatureDay, tsIrradianceDay]` | 取某一天的 1440 个点，时间轴归零；省略日期则弹窗询问。 |
| `computeDailyEnergy` | `power`（W），`sampleTime`（s） | `[dailyEnergy, annualEnergy]`（kWh） | 把瞬时功率按 24 h 切块积分。 |
| `computeEfficiency` | `dailyEnergy`，`irradiance`（W/m²），`irradianceSampleTime` | `[efficiency, annualEfficiency, dailyIrradiance]` | 日发电量 ÷ 当日入射太阳能（kWh/m²）。 |
| `plotDailyComparison` | `series`（结构体，每个字段一条曲线），`outputFile`（可选） | `fig` | 全年曲线，可保存到 `results/`。 |
| `runSimulation` | `requestedDate`，`modelName`（可选） | `out` | 仿真一天，注入 `ts_temperature` / `ts_irradiance`。 |
| `runYearSimulation` | `modelName`（可选） | `out`（含 `PO`、`POA`） | 循环 366 天并拼接结果。 |
| `runAnalysis` | `out`，`'SampleTime'`、`'Irradiance'` | `report` | 写 CSV、算效率、出图。 |

### 约定

- 单位统一：功率 W、能量 kWh、辐照度 W/m²、时间 s（辐照度数据为 60 s）。
- `power` 与 `irradiance` 既可以是 `timeseries`，也可以是普通向量。
- `runAnalysis` 写入 `data/processed/` 与 `results/`，其余函数不写文件。
- 函数头注释说明了参数与示例，`help 函数名` 即可查看。

### 最小示例

```matlab
addpath('src'); setupProject();

[tsT, tsG, dates] = loadYearData();
out = runSimulation('2023-07-01');
runAnalysis(out, 'Irradiance', tsG.Data);
```

---

## Français

### Organisation

| Dossier | Contenu |
|---|---|
| `src/` | Points d'entrée et gestion des chemins (`projectRoot`, `setupProject`, `run*`). |
| `src/data/` | Lecture des fichiers Excel, production des timeseries. |
| `src/analysis/` | Calculs purs (énergie, rendement) et tracé ; pas d'accès disque, sauf l'enregistrement des figures. |

### Ordre d'appel

```
loadYearData ──► loadDayData ──► runSimulation ──► runAnalysis ──► CSV + figure
      │                                                  ▲
      └── runYearSimulation (boucle sur 366 jours)───────┘
```

### Les fonctions

| Fonction | Entrées | Sorties | Rôle |
|---|---|---|---|
| `projectRoot` | — | `root` | Racine du dépôt, déduite de l'emplacement du fichier. |
| `setupProject` | — | `root` | Ajoute `src/` et ses sous-dossiers au chemin MATLAB. |
| `loadYearData` | `temperatureFile` (optionnel, `CellT.xlsx` par défaut) | `[tsTemperature, tsIrradiance, dateStrings]` | Lit une année et construit deux timeseries au pas de 60 s. |
| `loadDayData` | `tsTemperature, tsIrradiance, dateStrings, requestedDate` | `[tsTemperatureDay, tsIrradianceDay]` | Extrait les 1440 points d'une journée, temps ramené à zéro ; sans date, une boîte de dialogue la demande. |
| `computeDailyEnergy` | `power` (W), `sampleTime` (s) | `[dailyEnergy, annualEnergy]` (kWh) | Découpe la puissance instantanée en journées de 24 h et intègre. |
| `computeEfficiency` | `dailyEnergy`, `irradiance` (W/m²), `irradianceSampleTime` | `[efficiency, annualEfficiency, dailyIrradiance]` | Énergie produite divisée par l'énergie solaire incidente (kWh/m²). |
| `plotDailyComparison` | `series` (structure, un champ par courbe), `outputFile` (optionnel) | `fig` | Tracé annuel, enregistrable dans `results/`. |
| `runSimulation` | `requestedDate`, `modelName` (optionnel) | `out` | Simule une journée après avoir injecté `ts_temperature` / `ts_irradiance`. |
| `runYearSimulation` | `modelName` (optionnel) | `out` (champs `PO`, `POA`) | Boucle sur les 366 journées et concatène les résultats. |
| `runAnalysis` | `out`, `'SampleTime'`, `'Irradiance'` | `report` | Écrit les CSV, calcule le rendement, trace la figure. |

### Conventions

- Unités : puissance en W, énergie en kWh, éclairement en W/m², temps en s
  (les données d'éclairement sont au pas de 60 s).
- `power` et `irradiance` acceptent indifféremment un `timeseries` ou un vecteur.
- `runAnalysis` écrit dans `data/processed/` et `results/` ; les autres fonctions
  n'écrivent rien sur le disque.
- L'en-tête de chaque fonction documente les paramètres et donne un exemple :
  `help nom_de_la_fonction`.

### Exemple minimal

```matlab
addpath('src'); setupProject();

[tsT, tsG, dates] = loadYearData();
out = runSimulation('2023-07-01');
runAnalysis(out, 'Irradiance', tsG.Data);
```
