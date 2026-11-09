function [efficiency, annualEfficiency, dailyIrradiance] = computeEfficiency(dailyEnergy, irradiance, irradianceSampleTime)
%COMPUTEEFFICIENCY Rendement journalier du suivi du point de puissance maximale.
%
%   EFFICIENCY = COMPUTEEFFICIENCY(DAILYENERGY, IRRADIANCE, TS_G) divise, jour
%   par jour, l'énergie produite (kWh) par l'énergie solaire incidente
%   (kWh/m2) calculée à partir de l'éclairement IRRADIANCE (W/m2) échantillonné
%   au pas TS_G secondes.
%
%   [EFFICIENCY, ANNUAL] = ... renvoie aussi le rendement annuel, rapport des
%   sommes et non moyenne des rapports journaliers.
%   [EFFICIENCY, ANNUAL, DAILYIRRADIANCE] = ... renvoie en plus l'énergie
%   solaire journalière.
%
%   Exemple :
%       [eff, effAnnuelle] = computeEfficiency(dailyPO, irradiance, 60);

    if nargin < 3 || isempty(irradianceSampleTime)
        irradianceSampleTime = 60;   % données STELLA au pas de 1 min
    end

    dailyIrradiance = computeDailyEnergy(irradiance, irradianceSampleTime);

    if numel(dailyEnergy) ~= numel(dailyIrradiance)
        error('computeEfficiency:length', ...
            ['Énergie produite (%d jours) et éclairement (%d jours) ' ...
             'n''ont pas la même longueur.'], ...
            numel(dailyEnergy), numel(dailyIrradiance));
    end

    efficiency       = dailyEnergy ./ dailyIrradiance;
    annualEfficiency = sum(dailyEnergy) / sum(dailyIrradiance);
end
