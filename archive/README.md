# Archive

[中文](#中文) · [Français](#français)

Ce dossier conserve les éléments qui ne font pas partie du projet « vivant ».
Le code exécutable est dans `src/`, les modèles dans `models/`, les données dans
`data/`.

---

## 中文

这个目录存放不属于"当前项目"的内容。可执行代码在 `src/`，模型在 `models/`，
数据在 `data/`。

### 内容

| 目录 | 内容 |
|---|---|
| `legacy_scripts/` | 课程期间的原始 MATLAB 脚本，以及与 `src/` 的对应表。 |
| `other_methods/` | 组内其他方法：模糊逻辑、电导增量法、变步长、基础 PV 模型。 |
| `datasets/` | 原始数据集与 STELLA 平台说明。 |
| `references/` | 项目文献：`papers/` 下 18 篇文章（含作者与年份），以及报告中引用的 UTC 博士论文。 |
| `simulink_build_cache/` | Simulink 编译缓存（`slprj/`、`.slxc`、`.slx.r2022b`、`.slx.original`）。可重新生成，已被 Git 忽略。 |

每个子目录都有自己的 `README.md`，逐个文件说明。

### 已移除的内容

- `references/exams/`（4 份往年 BA04 试题与答案）与 `references/li_yicong.xlsx`
  （个人信息表）：与项目无关。
- `references/Article.zip`：内容解压并与已有文件逐一核对后删除。
- `misc/`：下载的网页，与主题无关。
- `other_methods/Fuzzy/P&O.mat`（18 MB）：MATLAB 会话状态，无法复现，报告写完后
  已无文档价值。
- `README_original.md`：内容已并入根目录 `README.md`（作者一节与原文引言），
  随后删除该文件。

### 重复文件处理

逐字节相同（MD5 一致）的文件只保留一份。`archive/P&O(A)/` 是整个仓库的副本
（185 个文件全部相同，连 Git 历史都是同一个 commit），已删除，只保留活跃版本。

`references/Article.zip` 含 16 篇 PDF：其中 3 篇与 `references/` 里已有文件完全
相同（未重复保存），其余 13 篇解压后按标题重命名。

---

## Français

### Contenu

| Dossier | Contenu |
|---|---|
| `legacy_scripts/` | Versions d'origine des scripts MATLAB et table de correspondance avec `src/`. |
| `other_methods/` | Travaux du groupe sur les autres méthodes : logique floue, conductance incrémentale, pas variable, modèles PV de base. |
| `datasets/` | Jeux de données d'origine et notice de la plateforme STELLA. |
| `references/` | Bibliographie du projet : 18 articles dans `papers/` (auteurs et années indiqués), plus la thèse UTC citée dans le rapport. |
| `simulink_build_cache/` | Caches de compilation Simulink (`slprj/`, `.slxc`, `.slx.r2022b`, `.slx.original`). Régénérables, ignorés par Git. |

Chaque sous-dossier dispose de son propre `README.md` détaillant fichier par
fichier.

### Contenu retiré

- `references/exams/` (quatre sujets et corrigés de BA04 d'autres années) et
  `references/li_yicong.xlsx` (fiche administrative) : sans lien avec le projet.
- `references/Article.zip` : supprimé une fois son contenu décompressé et
  vérifié dans `references/papers/`.
- `misc/` : page web téléchargée, sans rapport avec le sujet.
- `other_methods/Fuzzy/P&O.mat` (18 Mo) : état de session MATLAB, non
  reproductible, sans valeur documentaire une fois le rapport écrit.
- `README_original.md` : son contenu a été repris dans le `README.md` à la racine,
  puis le fichier a été supprimé.

### Doublons supprimés

Les fichiers strictement identiques (empreinte MD5 égale) ont été supprimés en
conservant une seule copie. Le dossier `archive/P&O(A)/` était une copie complète
du dépôt (185 fichiers identiques, même historique Git) : il a été retiré au
profit des fichiers actifs.

L'archive `references/Article.zip` contenait 16 PDF : trois étaient déjà présents
à l'identique dans `references/` et n'ont pas été dupliqués, les 13 autres ont
été extraits et renommés d'après leur titre.
