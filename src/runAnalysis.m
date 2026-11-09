function report = runAnalysis(out, varargin)
%RUNANALYSIS Calcule énergies et rendements d'une simulation, puis trace.
%
%   REPORT = RUNANALYSIS(OUT) traite la sortie Simulink OUT, qui doit contenir
%   les puissances instantanées OUT.PO (P&O) et OUT.POA (P&O amélioré) en
%   watts. Les vecteurs bruts sont acceptés aussi bien que les timeseries.
%
%   Nom-valeur :
%     'SampleTime'  pas de calcul du modèle, en secondes (défaut 2)
%     'Irradiance'  éclairement G (W/m2) au pas de 60 s, pour le rendement
%
%   Écrit dans data/processed/ :
%       PO_data_daily.csv, POA_data_daily.csv
%       irradiance_data_daily.csv, efficiency_data.csv (si 'Irradiance')
%   et enregistre results/DailySum_PO_POA.png.
%
%   Exemple :
%       out = runSimulation('2023-07-01');
%       [~, tsG, ~] = loadYearData();
%       runAnalysis(out, 'Irradiance', tsG.Data);

    options = struct('SampleTime', 2, 'Irradiance', []);
    for k = 1:2:numel(varargin)
        name = varargin{k};
        if ~isfield(options, name)
            error('runAnalysis:option', 'Option inconnue : %s', name);
        end
        options.(name) = varargin{k + 1};
    end

    sampleTime = options.SampleTime;
    processedDir = fullfile(projectRoot(), 'data', 'processed');
    if ~isfolder(processedDir)
        mkdir(processedDir);
    end

    % --- Énergie journalière -------------------------------------------------
    database = struct('name', {}, 'daily', {}, 'annual', {});
    if isfield(out, 'PO')
        database(end + 1) = computeEntry('PO',  out.PO,  sampleTime);
    end
    if isfield(out, 'POA')
        database(end + 1) = computeEntry('POA', out.POA, sampleTime);
    end
    if isempty(database)
        error('runAnalysis:fields', ...
            'La sortie Simulink ne contient ni OUT.PO ni OUT.POA.');
    end

    for k = 1:numel(database)
        exportDailyEnergy(database(k).daily, ...
            fullfile(processedDir, [database(k).name, '_data_daily.csv']));
        fprintf('%-4s : %.2f kWh sur l''année\n', ...
            database(k).name, database(k).annual);
    end

    % --- Rendement -----------------------------------------------------------
    report = struct();
    for k = 1:numel(database)
        report.(database(k).name) = database(k).daily;
        report.([database(k).name, 'Annual']) = database(k).annual;
    end

    if ~isempty(options.Irradiance)
        dailyIrradiance = computeDailyEnergy(options.Irradiance, 60);
        exportDailyEnergy(dailyIrradiance, ...
            fullfile(processedDir, 'irradiance_data_daily.csv'));
        report.irradiance = dailyIrradiance;

        efficiencyData = zeros(numel(dailyIrradiance), numel(database));
        columnNames    = cell(1, numel(database));
        for k = 1:numel(database)
            [efficiency, annualEfficiency] = ...
                computeEfficiency(database(k).daily, options.Irradiance, 60);

            efficiencyData(:, k) = efficiency;
            columnNames{k}       = ['Efficiency', database(k).name];
            report.efficiency.(database(k).name)       = efficiency;
            report.annualEfficiency.(database(k).name) = annualEfficiency;

            fprintf('Rendement annuel du %-4s : %.2f %%\n', ...
                database(k).name, annualEfficiency * 100);
        end

        writetable(array2table([(1:size(efficiencyData, 1))', efficiencyData], ...
            'VariableNames', [{'Day'}, columnNames]), ...
            fullfile(processedDir, 'efficiency_data.csv'));
    end

    % --- Figure --------------------------------------------------------------
    series = struct();
    if ~isempty(options.Irradiance)
        series.irradiance = report.irradiance;
    end
    for k = 1:numel(database)
        series.(database(k).name) = report.(database(k).name);
    end
    report.figure = plotDailyComparison(series, 'DailySum_PO_POA.png');
end

function entry = computeEntry(name, power, sampleTime)
%COMPUTEENTRY Calcule l'énergie journalière d'un vecteur de puissance.
    [daily, annual] = computeDailyEnergy(power, sampleTime);
    entry = struct('name', name, 'daily', daily, 'annual', annual);
end

function exportDailyEnergy(daily, fileName)
%EXPORTDAILYENERGY Écrit un CSV à deux colonnes (Day, DailySum_kWh).
    writetable(array2table([(1:numel(daily))', daily], ...
        'VariableNames', {'Day', 'DailySum_kWh'}), fileName);
end
