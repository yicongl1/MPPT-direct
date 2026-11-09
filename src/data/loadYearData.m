function [tsTemperature, tsIrradiance, dateStrings] = loadYearData(temperatureFile)
%LOADYEARDATA Charge une année de température et d'éclairement (pas de 1 min).
%
%   [TS_T, TS_G, DATES] = LOADYEARDATA() lit data/raw/CellT.xlsx (température de
%   cellule) et data/raw/Irradiation.xlsx, puis renvoie deux timeseries au pas
%   de 60 s prêtes à alimenter le modèle Simulink.
%
%   [...] = LOADYEARDATA('AmbiantT.xlsx') utilise la température ambiante.
%
%   Les fichiers d'entrée contiennent 366 lignes (une par jour) et 1441 colonnes
%   (une par minute, plus l'en-tête des heures).
%
%   DATES est un cellstr 'yyyy-mm-dd' ; il est passé à LOADDAYDATA pour
%   sélectionner une journée.
%
%   Exemple :
%       [tsT, tsG, dates] = loadYearData();
%       [tsTj, tsGj]      = loadDayData(tsT, tsG, dates, '2023-07-01');

    if nargin < 1 || isempty(temperatureFile)
        temperatureFile = 'CellT.xlsx';
    end

    rawDir = fullfile(projectRoot(), 'data', 'raw');
    temperatureTable = readtable(fullfile(rawDir, temperatureFile));
    irradianceTable  = readtable(fullfile(rawDir, 'Irradiation.xlsx'));

    numDays  = size(temperatureTable, 1) - 1;   % la 1re ligne porte les heures
    numTimes = 24 * 60;                         % un échantillon par minute

    dateStrings = tableDates(temperatureTable);
    if numel(dateStrings) ~= numDays
        error('loadYearData:dates', ...
            ['%d dates trouvées pour %d jours de mesures : ' ...
             'vérifier la première colonne des fichiers Excel.'], ...
            numel(dateStrings), numDays);
    end

    % Axe de temps absolu, une valeur par minute sur toute l'année
    timeStamps = NaT(numDays * numTimes, 1);
    for i = 1:numDays
        start = (i - 1) * numTimes;
        timeStamps(start + 1 : start + numTimes) = ...
            datetime(dateStrings{i}) + minutes(0:numTimes - 1)';
    end

    temperature = table2array(temperatureTable(2:end, 2:end));
    irradiance  = table2array(irradianceTable(2:end, 2:end));

    elapsed = seconds(timeStamps - timeStamps(1));
    tsTemperature = timeseries(temperature(:), elapsed);
    tsIrradiance  = timeseries(irradiance(:),  elapsed);
end

function dateStrings = tableDates(tableIn)
%TABLEDATES Extrait la première colonne en cellstr 'yyyy-mm-dd', quel que soit
%   le type renvoyé par READTABLE (datetime, texte ou cellule).

    column = tableIn{2:end, 1};
    if isdatetime(column)
        dateStrings = cellstr(datestr(column, 'yyyy-mm-dd'));
    else
        dateStrings = cellstr(string(column));
    end
    dateStrings = strtrim(dateStrings);
end
