function [dailyEnergy, annualEnergy] = computeDailyEnergy(power, sampleTime)
%COMPUTEDAILYENERGY Convertit une puissance instantanée en énergie journalière.
%
%   DAILYENERGY = COMPUTEDAILYENERGY(POWER, SAMPLETIME) découpe le vecteur de
%   puissance POWER (W) en journées de 24 h — la simulation ayant un pas de
%   SAMPLETIME secondes — et renvoie l'énergie de chaque journée en kWh.
%
%   [DAILYENERGY, ANNUALENERGY] = ... renvoie aussi l'énergie annuelle (kWh).
%
%   Si la longueur de POWER n'est pas un multiple exact d'une journée, la
%   dernière valeur est répétée jusqu'à compléter la journée (et un
%   avertissement est émis).
%
%   Exemple :
%       [dailyPO, annualPO] = computeDailyEnergy(out.PO, 2);

    if isa(power, 'timeseries')
        power = power.Data;
    end
    power = power(:);
    power(isnan(power)) = 0;

    samplesPerDay = round(86400 / sampleTime);
    numSamples    = numel(power);

    remainder = mod(numSamples, samplesPerDay);
    if remainder ~= 0
        padding = samplesPerDay - remainder;
        warning('computeDailyEnergy:padding', ...
            ['%d échantillons pour %d par jour : la dernière valeur est ' ...
             'répétée %d fois pour compléter la dernière journée.'], ...
            numSamples, samplesPerDay, padding);
        power = [power; repmat(power(end), padding, 1)];
        numSamples = numel(power);
    end

    numDays    = numSamples / samplesPerDay;
    reshaped   = reshape(power, samplesPerDay, numDays)';

    % P (W) -> kW, puis intégration sur un pas de SAMPLETIME secondes
    dailyEnergy  = sum(reshaped / 1000 * (sampleTime / 3600), 2);
    annualEnergy = sum(dailyEnergy);
end
