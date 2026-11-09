# Scripts d'origine

Ces fichiers sont les versions utilisées pendant le cours, avant l'unification.
Ils sont conservés tels quels (aucune correction) pour garder la trace du
cheminement ; le code maintenu est dans `../../src/`.

## Correspondance

| Script d'origine | Remplacé par | Remarque |
|---|---|---|
| `DataAnnee.m` | `src/data/loadYearData.m` | Version chinoise, lisait `CellT.xlsx`. |
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

## Défauts corrigés lors de l'unification

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
