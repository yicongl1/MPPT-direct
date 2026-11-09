# MPPT direct — P&O et son amélioration

[中文](#中文) · [Français](#français)

Étude et simulation du **MPPT direct** (suivi du point de puissance maximale)
d'un panneau photovoltaïque, sur une année complète de mesures réelles.
Projet **BA04** de l'UTC (Université de Technologie de Compiègne), soutenu en
juin 2024.

![Comparaison des énergies journalières](results/DailySum_PO_POA.png)

---

## 中文

### 这是什么

这是贡比涅技术大学（UTC）**BA04** 课程的四人小组项目，2024 年 6 月完成并答辩。
仓库里包含 MATLAB/Simulink 模型、一整年的实测数据，以及把仿真输出换算成
发电量与效率的分析代码。

小组分工：Nicolas Grand、Olivier Ondet、**Yicong Li**、Cenhao Liu。
报告的四个算法、SEPIC 变换器与结果分析见 `docs/BA04_rapport.pdf`；文献综述
做成了海报 `docs/BA04_poster.pdf`；答辩材料是 `docs/BA04_pre.pdf`。

**我个人负责 P&O 算法及其改进版 P&OA**：从 Simulink 建模、全年仿真，到能量
与效率的计算和对比图。组内其他方法（电导增量法、模糊逻辑）保存在
`archive/other_methods/`。

### 光伏与最大功率点

光伏电池把光能直接转成直流电，单体的电压很低（约 0.5 V），因此要把多片电池
**串联**提高电压、**并联**提高电流，组成组件和阵列。标准测试条件 STC 为
1000 W/m²、电池温度 25 °C、光谱 AM1.5。

对任意组件，输出功率是电压与电流的乘积：

```
P = V · I
```

I-V 曲线上存在唯一的一点，使 P 达到最大，这就是**最大功率点 MPP**。它的位置
不是固定的：辐照度升高时整条曲线向右上方移动，温度升高时电压下降、曲线左移。
如果负载一直固定在某个工作点，组件就会长期偏离 MPP，损失可达 20～30 %。

**MPPT** 的作用就是持续把工作点拉到 MPP 上。本项目用 Kyocera **KC200GT**
（200 Wp 多晶组件）作为建模对象，其 I-V 特性在 Simulink 中由
`I0`、`Ipv` 两个参数化的指数模型描述（报告图 3～5）。

### 直接法与间接法

| | 原理 | 特点 |
|---|---|---|
| **直接法**（本项目） | 直接调节组件电压或 DC-DC 的占空比，测量由此产生的功率变化，据此决定下一步动作。 | 不依赖组件参数，对老化、遮挡、辐照度突变适应性强；代价是稳态会有扰动。 |
| **间接法** | 不主动扰动，靠模型或可测量推算 MPP：开路电压比例系数、短路电流比例系数、查表、曲线拟合等。 | 实现简单、无稳态振荡；但系数需要逐块标定，环境突变时偏差大。 |

### 报告里的四种算法

报告按"步长固定 / 步长可变"分成两组，各两种。

**1. P&O — 扰动观察法（固定步长）**

周期性地改变电压，并观察功率的变化方向：

- 功率上升 → 继续同方向扰动；
- 功率下降 → 反向扰动。

优点是简单、只需测量电压和电流，不依赖组件模型。缺点是**稳态一直在 MPP
附近来回振荡**，步长越大振荡越大；辐照度突变时还会短暂朝错误方向走。报告图 6
给出了流程图，并测试了 0.1、0.5、1 三组增益：0.1 与 0.5 的结果相近，增益到 1
时功率明显下降（振荡加剧）。受计算量限制，这组扫描只做了 3 次仿真。

**2. INC — 电导增量法（固定步长）**

对 P = V·I 求导：

```
dP/dV = V · dI/dV + I
```

于是 MPP 的判据是 `dI/dV = -I/V`。按切线斜率判断工作点位置：

- `dI/dV > -I/V` → 工作点在 MPP 左侧，升高电压；
- `dI/dV < -I/V` → 工作点在 MPP 右侧，降低电压；
- 相等 → 已在 MPP。

当 `ΔV = 0` 时改用电流变化判断：`ΔI > 0` 降电压，`ΔI < 0` 升电压，`ΔI = 0`
保持。理论上比 P&O 更准确、收敛更快，代价是需要更精确的采样。

**3. P&OA — 改进型 P&O（变步长）**

核心思想：**步长随工作点到 MPP 的距离自适应**。远离时用大步长快速逼近，接近时
自动减小步长以抑制振荡。报告给出两种实现：

```
d(k+1) = d(k) + α · (V* - V)          % 用实测电压与最优电压之差
CycleDuty(k+1) = CycleDuty(k) + α · ΔP/Δd   % 或用功率曲线斜率缩放
```

`d` 是变换器占空比，`V*` 是目标电压，`α` 由设计者整定。第一式的优点是不需要
预先知道辐照度，只需要一个电压参考。

**4. 模糊逻辑（变步长）**

用语言变量代替精确判据，适合强非线性和参数不确定的场合：

- 输入：误差 `E` 与误差变化 `DE`；输出：占空比的变化量；
- 5 个模糊集：`NB`（很小）、`NS`（偏小）、`Z`（零）、`PS`（偏大）、`PB`（很大）；
- 隶属函数取钟形：`μ(x) = 1 / (1 + ((x - c) / a)²)`，`c` 为中心、`a` 为宽度；
- 推理用 **Mamdani**，合取用 `min` 算子；
- 去模糊化用**重心法**：`z = Σ μ(zᵢ)·zᵢ / Σ μ(zᵢ)`。

规则表见报告图 12，Simulink 实现见报告图 13～14。

### DC-DC 变换器

MPPT 必须通过变换器改变组件的工作点。报告用的是 **SEPIC**：两个电感、两个
电容、一个 MOSFET。它的优点是**输出与输入同极性**，且输出电压可以高于或低于
输入电压——这对输入电压随辐照度大幅波动的 PV 很重要（Buck 只能降压，Boost
只能升压，Buck-Boost 会反相）。

工作分两阶段：MOSFET 导通时电感储能；关断时储能经电容传给负载。

另外，INC 那一路的参考文献用的是 **Cuk** 变换器（同样非反相），模糊逻辑那一路
也基于 SEPIC。

### 数据与仿真设置

| 项目 | 内容 |
|---|---|
| 数据来源 | UTC 校区 **STELLA** 平台的实测数据（见 `archive/datasets/STELLA_Notice.pdf`） |
| 时间范围 | 2023-04-01 → 2024-03-31，共 **366 天** |
| 采样 | 每 **1 分钟**一个点，每天 1440 点 |
| 变量 | 辐照度 (W/m²)、环境温度 (°C)、电池温度 (°C) |
| 组件 | Kyocera **KC200GT**（200 Wp） |
| 工具 | MATLAB / Simulink，计算步长 2 s |

逐分钟的序列被写入 MATLAB 工作区，按 Simulink 模型的 *From Workspace* 模块
约定的名字注入（`ts_irradiance`、`ts_temperature`），逐日仿真后拼接成整年。
模型输出 `out.PO` 与 `out.POA` 是两种算法的**瞬时功率**（W）。

分析代码再把这些功率积分成日发电量（kWh），并除以同日入射的太阳能量
（kWh/m²）得到效率：

```
E_jour = Σ P(t) · Δt / 3.6e6          [kWh]
η      = Σ E_jour(PV) / Σ E_jour(G)   [%]
```

### 结果

- **全年发电量**：P&O 为 **180,28 kWh**，P&OA 为 **179,36 kWh**（相差 0,5 %）。
- 报告图 10 对比了两种算法在全年尺度上的功率曲线，图 11 对比了逐日发电量；
  两条曲线几乎重合。
- 报告还给出了"全年回收能量随 MPPT 输出增益变化"的曲线（图 8）。

一个诚实的观察：在**1 分钟分辨率、全年**这样的数据上，两种算法差别很小，
本次仿真里 P&O 甚至略高一点。P&OA 的优势主要体现在辐照度突变等**暂态过程**，
以及步长整定不当造成的稳态振荡上——这也是报告里"增益扫描"一节想说明的问题。

| 图 | 文件 |
|---|---|
| 逐日发电量对比（P&O vs P&OA） | `results/DailySum_PO_POA.png` |
| 辐照度 / P&O / P&OA 三条曲线 | `results/Dailycomparison.png` |
| Simulink 中的 P&O 实现 | `results/POslx.png` |

### 仓库结构

```
MPPT-direct/
├── README.md              本文件（中文 + 法语）
├── src/                   MATLAB 代码
│   ├── README.md          各函数说明与调用顺序
│   ├── setupProject.m     将代码加入 MATLAB 搜索路径
│   ├── projectRoot.m      由文件位置推导仓库根目录
│   ├── data/
│   │   ├── loadYearData.m 载入一整年数据
│   │   └── loadDayData.m  提取某一天用于仿真
│   ├── analysis/
│   │   ├── computeDailyEnergy.m    功率 → 日发电量
│   │   ├── computeEfficiency.m     能量效率
│   │   └── plotDailyComparison.m   全年曲线
│   ├── runSimulation.m    单日仿真
│   ├── runYearSimulation.m 全年 366 天仿真
│   └── runAnalysis.m      完整流程：CSV + 效率 + 绘图
├── models/                Simulink 模型（.slx）
├── data/
│   ├── raw/               原始测量数据（.xlsx）
│   └── processed/         计算得到的 CSV
├── results/               报告插图
├── docs/                  BA04 报告、海报与答辩材料
└── archive/               原始脚本、其他方法、参考文献（各自有 README）
```

### 快速开始

环境要求：MATLAB R2022b 及以上，并安装 Simulink。

```matlab
cd('MPPT-direct 所在路径');
addpath('src');
setupProject();                 % 加入 src/ 及其子目录

% 1. 载入全年数据，取出某一天
[tsT, tsG, dates] = loadYearData();
[tsTj, tsGj]      = loadDayData(tsT, tsG, dates, '2023-07-01');

% 2. 仿真该日
out = runSimulation('2023-07-01');

% 3. 计算发电量、效率并出图
runAnalysis(out, 'Irradiance', tsG.Data);
```

复现报告中的全年曲线：

```matlab
out = runYearSimulation();                  % 约每天一分钟
runAnalysis(out, 'Irradiance', tsG.Data);
```

脚本只使用相对于仓库根目录的路径，仓库可以随意移动；结果写入
`data/processed/` 与 `results/`。

### 数据格式

`data/raw/` 里的三个 xlsx 结构相同：

- 第 1 行是时刻表头（Excel 显示为 1899-12-30，是被误识别成日期的时刻）；
- 第 1 列是日期，ISO 格式 `yyyy-mm-dd`；
- 其余 1440 列对应一天的 1440 分钟。

`loadYearData` 会把它们重排成两条以秒为单位的 timeseries，并额外返回日期
字符串数组，供 `loadDayData` 选择某一天。

### 已知限制

- 分析默认模型步长为 2 s，可通过 `runAnalysis` 的 `SampleTime` 参数修改；
- 本仓库的分析链只覆盖 P&O / P&OA 两个通道，INC 与模糊逻辑在报告和
  `archive/other_methods/` 中；
- 代码是在课程结束后重写整理的，**没有在 MATLAB 中做自动化测试**，请在本地
  先跑一遍上面的快速开始。

### 作者与致谢

Nicolas Grand、Olivier Ondet、Yicong Li、Cenhao Liu —— BA04，UTC，2024 年 6 月。

数据来自 UTC 的 STELLA 平台；Simulink 模型和实测数据属于课程资料，引用时请
注明 UTC 与报告作者。

> 原 README 里的一句话，意思保留在这里：这是我（Yicong Li）在 BA04 上的工作，
> 负责 P&O 及其改进。仓库里放了 MATLAB 代码、Simulink 模型和原始数据，希望对
> 你的 PV 学习有用。谢谢，祝好。—— 2024 年 6 月 16 日，BA04 答辩之后。

---

## Français

### Le sujet

Projet de cours **BA04** à l'UTC, réalisé à quatre et soutenu en juin 2024. Le
dépôt contient les modèles MATLAB/Simulink, une année complète de mesures réelles
et le code d'analyse qui transforme les sorties de simulation en énergie produite
et en rendement.

Auteurs : Nicolas Grand, Olivier Ondet, **Yicong Li**, Cenhao Liu.
Le rapport complet (quatre algorithmes, convertisseur SEPIC, analyse des
résultats) est dans `docs/BA04_rapport.pdf` ; la revue de littérature a pris la
forme d'un poster, `docs/BA04_poster.pdf` ; la soutenance est
`docs/BA04_pre.pdf`.

**Mon périmètre : l'algorithme P&O et son amélioration P&OA**, de la modélisation
Simulink à la simulation annuelle, puis au calcul de l'énergie et du rendement.
Les travaux du groupe sur les autres méthodes (conductance incrémentale, logique
floue) sont conservés dans `archive/other_methods/`.

### Le photovoltaïque et le point de puissance maximale

Une cellule photovoltaïque convertit directement la lumière en courant continu,
mais sa tension est faible (environ 0,5 V) : on met donc les cellules en **série**
pour la tension et en **parallèle** pour le courant. Les conditions de test
standard (STC) sont 1000 W/m², 25 °C de température de cellule et un spectre
AM1.5.

Pour un module donné, la puissance vaut :

```
P = V · I
```

La courbe I-V admet un unique point où P est maximal : le **point de puissance
maximale (MPP)**. Sa position varie : une irradiation plus forte décale la courbe
vers le haut et la droite, une température plus élevée abaisse la tension et
décale la courbe vers la gauche. Si la charge impose un point de fonctionnement
fixe, le module peut s'en écarter et perdre 20 à 30 % de sa production.

Le rôle du **MPPT** est de ramener en permanence le point de fonctionnement sur
le MPP. Le projet modélise le module Kyocera **KC200GT** (200 Wp,
polycristallin), dont la caractéristique I-V est décrite dans Simulink par un
modèle exponentiel paramétré par `I0` et `Ipv` (figures 3 à 5 du rapport).

### MPPT direct et MPPT indirect

| | Principe | Caractéristiques |
|---|---|---|
| **Direct** (ce projet) | On agit directement sur la tension du module ou sur le rapport cyclique du convertisseur DC-DC, et on observe la variation de puissance qui en résulte. | Indépendant des paramètres du module, robuste au vieillissement, à l'ombrage et aux variations d'irradiation ; en contrepartie, il perturbe en permanence le point de fonctionnement. |
| **Indirect** | On n'agit pas sur la puissance : on estime la position du MPP à partir d'un modèle ou de grandeurs mesurables (coefficient de tension de circuit ouvert, de courant de court-circuit, tables, régression). | Simple, sans oscillation en régime établi ; mais les coefficients doivent être calibrés par module et dérivent lorsque les conditions changent brutalement. |

### Les quatre algorithmes du rapport

Le rapport les classe en deux familles : pas fixe et pas variable.

**1. P&O — Perturb and Observe (pas fixe)**

On perturbe périodiquement la tension et on observe le sens de variation de la
puissance :

- la puissance augmente → on continue dans la même direction ;
- la puissance diminue → on inverse la perturbation.

Simple, il ne demande que la mesure de la tension et du courant, sans modèle du
module. En contrepartie, il **oscille en permanence autour du MPP**, d'autant plus
que le pas est grand, et il part momentanément dans la mauvaise direction lors
d'une variation brutale d'irradiation. Le rapport (figure 6) donne l'organigramme
et teste trois gains, 0,1 / 0,5 / 1 : les deux premiers donnent des résultats
proches, le gain de 1 fait nettement chuter la puissance récupérée. Faute de
temps de calcul, seules trois simulations ont pu être menées.

**2. INC — Incremental Conductance (pas fixe)**

En dérivant P = V·I :

```
dP/dV = V · dI/dV + I
```

Le MPP correspond donc à `dI/dV = -I/V`. Le signe de la pente situe le point de
fonctionnement :

- `dI/dV > -I/V` → à gauche du MPP, on augmente la tension ;
- `dI/dV < -I/V` → à droite du MPP, on diminue la tension ;
- égalité → on est au MPP.

Lorsque `ΔV = 0`, on décide sur le courant : `ΔI > 0` → diminuer la tension,
`ΔI < 0` → l'augmenter, `ΔI = 0` → ne rien changer. Théoriquement plus précis et
plus rapide que le P&O, au prix d'un échantillonnage plus exigeant.

**3. P&OA — P&O amélioré (pas variable)**

Le pas s'adapte à la distance qui sépare le point de fonctionnement du MPP :
grand pour converger vite, petit pour limiter l'oscillation. Le rapport propose
deux formes :

```
d(k+1) = d(k) + α · (V* - V)                 % écart entre tension mesurée et tension optimale
CycleDuty(k+1) = CycleDuty(k) + α · ΔP/Δd    % ou pente de la courbe de puissance
```

`d` est le rapport cyclique du convertisseur, `V*` la tension visée et `α` un
coefficient à régler. La première forme a l'avantage de ne pas exiger la mesure
de l'irradiation.

**4. Logique floue (pas variable)**

On remplace le seuil précis par des variables linguistiques, ce qui convient aux
systèmes fortement non linéaires :

- entrées : l'erreur `E` et sa variation `DE` ; sortie : la variation du rapport
  cyclique ;
- cinq ensembles flous : `NB` (très petit), `NS` (petit négatif), `Z` (zéro),
  `PS` (petit positif), `PB` (très grand) ;
- fonctions d'appartenance en cloche : `μ(x) = 1 / (1 + ((x - c) / a)²)`, `c`
  étant le centre et `a` la largeur ;
- inférence **Mamdani**, intersection par l'opérateur `min` ;
- défuzzification par le **centre de gravité** : `z = Σ μ(zᵢ)·zᵢ / Σ μ(zᵢ)`.

La table de règles figure en figure 12 du rapport, l'implémentation Simulink en
figures 13 et 14.

### Le convertisseur DC-DC

Le MPPT doit agir sur le point de fonctionnement par l'intermédiaire d'un
convertisseur. Le rapport retient le **SEPIC** : deux inductances, deux
condensateurs, un MOSFET. Son intérêt est double : la sortie est de **même
polarité** que l'entrée, et la tension de sortie peut être supérieure ou
inférieure à la tension d'entrée — ce qui est indispensable quand la tension du
module varie fortement avec l'irradiation (un Buck ne sait que réduire, un Boost
qu'augmenter, un Buck-Boost inverse la polarité).

Le fonctionnement se décompose en deux phases : le MOSFET conduit et les
inductances se chargent ; il se bloque et l'énergie stockée est transférée à la
charge par les condensateurs.

La voie INC s'appuie sur la littérature un convertisseur **Cuk** (également non
inverseur), et la voie logique floue sur un SEPIC.

### Données et conditions de simulation

| | |
|---|---|
| Source | mesures de la plateforme **STELLA** de l'UTC (voir `archive/datasets/STELLA_Notice.pdf`) |
| Période | 1er avril 2023 → 31 mars 2024, soit **366 jours** |
| Échantillonnage | un point par **minute**, 1440 points par jour |
| Grandeurs | irradiation (W/m²), température ambiante et température de cellule (°C) |
| Module | Kyocera **KC200GT** (200 Wp) |
| Outils | MATLAB / Simulink, pas de calcul de 2 s |

Les séries minute par minute sont injectées dans l'espace de travail sous les
noms attendus par les blocs *From Workspace* du modèle (`ts_irradiance`,
`ts_temperature`), simulation jour par jour puis concaténation sur l'année. Le
modèle renvoie `out.PO` et `out.POA`, les puissances instantanées (W) des deux
algorithmes.

Le code d'analyse intègre ensuite ces puissances en énergie journalière (kWh) et
la rapporte à l'énergie solaire incidente (kWh/m²) :

```
E_jour = Σ P(t) · Δt / 3,6e6          [kWh]
η      = Σ E_jour(PV) / Σ E_jour(G)   [%]
```

### Résultats

- **Énergie annuelle** : **180,28 kWh** avec le P&O, **179,36 kWh** avec le
  P&OA, soit 0,5 % d'écart.
- Les figures 10 et 11 du rapport superposent les puissances sur l'année puis les
  énergies journalières : les deux courbes sont pratiquement confondues.
- La figure 8 trace l'énergie annuelle récupérée en fonction du gain de sortie de
  la fonction MPPT.

Une observation honnête : sur des données à **une minute de résolution et sur une
année entière**, les deux algorithmes se distinguent très peu, et le P&O sort
même légèrement devant ici. L'apport du P&OA se lit sur les **transitoires**
(chute brutale d'irradiation) et sur l'oscillation de régime établi quand le pas
est mal réglé — c'est précisément ce que la section « balayage du gain » du
rapport met en évidence.

| Figure | Fichier |
|---|---|
| Énergie journalière P&O vs P&OA | `results/DailySum_PO_POA.png` |
| Irradiation, P&O et P&OA | `results/Dailycomparison.png` |
| Implémentation Simulink du P&O | `results/POslx.png` |

### Structure du dépôt

```
MPPT-direct/
├── README.md              ce document (ZH + FR)
├── src/                   code MATLAB
│   ├── README.md          description des fonctions et ordre d'appel
│   ├── setupProject.m     ajoute le code au chemin MATLAB
│   ├── projectRoot.m      racine du dépôt, indépendante de l'emplacement
│   ├── data/
│   │   ├── loadYearData.m charge une année de mesures
│   │   └── loadDayData.m  extrait une journée pour la simulation
│   ├── analysis/
│   │   ├── computeDailyEnergy.m    puissance → énergie journalière
│   │   ├── computeEfficiency.m     rendement énergétique
│   │   └── plotDailyComparison.m   tracé annuel
│   ├── runSimulation.m    simule une journée
│   ├── runYearSimulation.m simule les 366 journées
│   └── runAnalysis.m      chaîne complète : CSV + rendement + figure
├── models/                modèles Simulink (.slx)
├── data/
│   ├── raw/               mesures d'entrée (.xlsx)
│   └── processed/         résultats calculés (.csv)
├── results/               figures du rapport
├── docs/                  rapport, poster et présentation BA04
└── archive/               scripts d'origine, autres méthodes, bibliographie
```

### Démarrage rapide

Prérequis : MATLAB R2022b ou plus récent, avec Simulink.

```matlab
cd('chemin/vers/MPPT-direct');
addpath('src');
setupProject();

% 1. Charger les mesures et extraire une journée
[tsT, tsG, dates] = loadYearData();
[tsTj, tsGj]      = loadDayData(tsT, tsG, dates, '2023-07-01');

% 2. Simuler cette journée
out = runSimulation('2023-07-01');

% 3. Calculer énergie, rendement et figure
runAnalysis(out, 'Irradiance', tsG.Data);
```

Pour reproduire les figures du rapport, il faut simuler l'année entière :

```matlab
out = runYearSimulation();                  % environ une minute par journée
runAnalysis(out, 'Irradiance', tsG.Data);
```

Les scripts n'utilisent que des chemins relatifs à la racine et écrivent dans
`data/processed/` et `results/`.

### Format des données

Les trois fichiers de `data/raw/` ont la même structure :

- première ligne : l'en-tête des heures (Excel l'affiche comme 1899-12-30, une
  date parasite) ;
- première colonne : la date, au format ISO `yyyy-mm-dd` ;
- 1440 colonnes restantes : une par minute de la journée.

`loadYearData` les transforme en deux timeseries à base de secondes et renvoie
aussi le tableau de dates utilisé par `loadDayData`.

### Limites connues

- L'analyse suppose un pas de calcul de 2 s ; c'est le paramètre `SampleTime`
  de `runAnalysis` ;
- la chaîne d'analyse ne couvre que les voies P&O et P&OA ; INC et logique floue
  sont dans le rapport et dans `archive/other_methods/` ;
- le code a été restructuré après le cours et **n'a pas de tests automatisés sous
  MATLAB** : commencez par exécuter le démarrage rapide ci-dessus.

### Auteurs

Nicolas Grand, Olivier Ondet, Yicong Li, Cenhao Liu — BA04, UTC, juin 2024.

Mesures de la plateforme STELLA de l'UTC ; modèles Simulink et données issus du
cours BA04 — merci de citer l'UTC et les auteurs du rapport en cas de réemploi.

> Le mot du README d'origine, dont le sens est conservé ici : voici le travail de
> Yicong Li sur le MPPT direct, avec le panneau KC200GT modélisé en BA04 à l'UTC.
> Le MPPT direct agit sur la tension, contrairement au MPPT indirect qui passe par
> des grandeurs estimées ; irradiation et température variant en permanence, il
> faut un algorithme pour suivre le point de puissance maximale. Ma
> responsabilité portait sur le P&O et son amélioration. Vous trouverez ici du
> code MATLAB, un modèle Simulink et les données — de quoi servir à vos propres
> études PV. Merci, et bonne journée. — 16 juin 2024, après la soutenance de
> BA04.
