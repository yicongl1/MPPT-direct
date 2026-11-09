function out = runYearSimulation(modelName)
%RUNYEARSIMULATION Simule les 366 journées de l'année et concatène les sorties.
%
%   OUT = RUNYEARSIMULATION() simule models/pv_modeling_2_MPPT_POA.slx sur
%   chacune des journées de données, puis concatène les puissances PO et POA.
%   Le résultat a la même forme que celui d'une simulation unique et se passe
%   directement à RUNANALYSIS.
%
%   OUT = RUNYEARSIMULATION('v19_POA') choisit un autre modèle.
%
%   Compter plusieurs dizaines de minutes : environ une minute par journée
%   selon la machine.
%
%   Exemple :
%       addpath('src'); setupProject();
%       out = runYearSimulation();
%       [~, tsG, ~] = loadYearData();
%       runAnalysis(out, 'Irradiance', tsG.Data);

    if nargin < 1 || isempty(modelName)
        modelName = 'pv_modeling_2_MPPT_POA';
    end

    [tsTemperature, tsIrradiance, dateStrings] = loadYearData();
    numDays = numel(dateStrings);

    load_system(fullfile(projectRoot(), 'models', modelName));

    PO  = zeros(0, 1);
    POA = zeros(0, 1);
    for i = 1:numDays
        [tsTemperatureDay, tsIrradianceDay] = ...
            loadDayData(tsTemperature, tsIrradiance, dateStrings, dateStrings{i});

        assignin('base', 'ts_temperature', tsTemperatureDay);
        assignin('base', 'ts_irradiance',  tsIrradianceDay);

        dayOut = sim(modelName);
        PO  = [PO;  asVector(dayOut.PO)];    %#ok<AGROW>
        POA = [POA; asVector(dayOut.POA)];   %#ok<AGROW>

        if mod(i, 30) == 0
            fprintf('  %d / %d journées simulées\n', i, numDays);
        end
    end

    out = struct('PO', PO, 'POA', POA);
    fprintf('Simulation terminée : %d journées, %d échantillons.\n', ...
        numDays, numel(PO));
end

function values = asVector(signal)
%ASVECTOR Renvoie un vecteur colonne, que SIGNAL soit un timeseries ou non.
    if isa(signal, 'timeseries')
        values = signal.Data(:);
    else
        values = signal(:);
    end
end
