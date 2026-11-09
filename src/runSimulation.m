function out = runSimulation(requestedDate, modelName)
%RUNSIMULATION Simule le modèle Simulink sur une journée de mesures réelles.
%
%   OUT = RUNSIMULATION() simule models/pv_modeling_2_MPPT_POA.slx sur une
%   journée choisie par l'utilisateur.
%
%   OUT = RUNSIMULATION('2023-07-01') simule cette date.
%   OUT = RUNSIMULATION('2023-07-01', 'v19_POA') choisit le modèle.
%
%   Les séries ts_temperature et ts_irradiance sont créées dans l'espace de
%   travail de base, sous les noms attendus par les blocs "From Workspace".
%
%   Exemple :
%       addpath('src'); setupProject();
%       out = runSimulation('2023-07-01');
%       runAnalysis(out);

    if nargin < 1
        requestedDate = '';
    end
    if nargin < 2 || isempty(modelName)
        modelName = 'pv_modeling_2_MPPT_POA';
    end

    [tsTemperature, tsIrradiance, dateStrings] = loadYearData();
    [tsTemperatureDay, tsIrradianceDay] = ...
        loadDayData(tsTemperature, tsIrradiance, dateStrings, requestedDate);

    assignin('base', 'ts_temperature', tsTemperatureDay);
    assignin('base', 'ts_irradiance',  tsIrradianceDay);

    modelPath = fullfile(projectRoot(), 'models', modelName);
    load_system(modelPath);

    out = sim(modelName);
end
