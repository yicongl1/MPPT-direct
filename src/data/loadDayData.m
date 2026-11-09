function [tsTemperatureDay, tsIrradianceDay] = loadDayData(tsTemperature, tsIrradiance, dateStrings, requestedDate)
%LOADDAYDATA Extrait une journée (00:00 -> 23:59) des séries annuelles.
%
%   [TS_T_J, TS_G_J] = LOADDAYDATA(TS_T, TS_G, DATES, 'yyyy-mm-dd') renvoie
%   les 1440 échantillons de la journée demandée, avec un axe de temps reparti
%   de 0. Les séries sont prêtes pour les blocs "From Workspace" de Simulink.
%
%   Sans quatrième argument, une boîte de dialogue demande la date.
%
%   TS_T, TS_G et DATES sont fournis par LOADYEARDATA.
%
%   Exemple :
%       [tsT, tsG, dates] = loadYearData();
%       [tsTj, tsGj]      = loadDayData(tsT, tsG, dates);   % interactif

    if nargin < 4 || isempty(requestedDate)
        answer = inputdlg('Date à simuler (yyyy-mm-dd) :', ...
                          'Choisir une date', [1, 30]);
        if isempty(answer)
            error('loadDayData:cancel', 'Aucune date sélectionnée.');
        end
        requestedDate = answer{1};
    end

    numTimes = 24 * 60;
    dayIndex = find(strcmp(dateStrings, strtrim(requestedDate)), 1);
    if isempty(dayIndex)
        error('loadDayData:date', ...
            'Date introuvable : %s (format attendu yyyy-mm-dd).', requestedDate);
    end

    samples = (dayIndex - 1) * numTimes + (1:numTimes);

    tsTemperatureDay = getsamples(tsTemperature, samples);
    tsIrradianceDay  = getsamples(tsIrradiance,  samples);

    % L'axe de temps de la journée repart de 0
    tsTemperatureDay.Time = tsTemperatureDay.Time - tsTemperatureDay.Time(1);
    tsIrradianceDay.Time  = tsIrradianceDay.Time  - tsIrradianceDay.Time(1);
end
