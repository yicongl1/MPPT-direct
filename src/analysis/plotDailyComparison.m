function fig = plotDailyComparison(series, outputFile)
%PLOTDAILYCOMPARISON Trace les énergies journalières sur une année.
%
%   FIG = PLOTDAILYCOMPARISON(SERIES) trace une courbe par champ de la
%   structure SERIES. Chaque champ est un vecteur (une valeur par jour) et son
%   nom sert de légende.
%
%   FIG = PLOTDAILYCOMPARISON(SERIES, 'nom.png') enregistre en plus la figure
%   dans results/.
%
%   Exemple :
%       series.irradiance = dailyIrradiance;
%       series.PO         = dailyPO;
%       series.POA        = dailyPOA;
%       plotDailyComparison(series, 'DailySum_PO_POA.png');

    if nargin < 2
        outputFile = '';
    end

    names  = fieldnames(series);
    styles = {'k-', 'b-', 'r-', 'g-', 'm-'};
    colors = lines(numel(names));

    fig = figure('Name', 'Comparaison journalière', 'Color', 'w');
    hold on;
    for k = 1:numel(names)
        values = series.(names{k});
        if k <= numel(styles)
            plot(values, styles{k}, 'DisplayName', names{k});
        else
            plot(values, '-', 'Color', colors(k, :), 'DisplayName', names{k});
        end
    end
    hold off;

    grid on;
    xlim([1, numel(series.(names{1}))]);
    xlabel('Jour de l''année');
    ylabel('Énergie journalière (kWh ou kWh/m^2)');
    title('Énergie journalière sur une année');
    legend('Location', 'northwest');

    if ~isempty(outputFile)
        resultsDir = fullfile(projectRoot(), 'results');
        if ~isfolder(resultsDir)
            mkdir(resultsDir);
        end
        saveas(fig, fullfile(resultsDir, outputFile));
    end
end
