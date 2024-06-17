close all
clear
clc

% Importer les données de température
temperature_data = readtable('AmbiantT.xlsx');

% Importer les données d'irradiance
irradiance_data = readtable('Irradiation.xlsx');

% Obtenir la colonne des dates
date_str = cellstr(temperature_data{2:end, 1}); % Obtenir les dates à partir de la deuxième ligne

% Initialiser les tableaux de chaînes de caractères pour les dates et heures
num_dates = size(temperature_data, 1) - 1; % Soustraire la ligne des en-têtes
num_times = 24 * 60;
full_datetime_str = cell(num_dates * num_times, 1);

% Générer les chaînes de caractères de date et heure
for i = 1:num_dates
    for hour = 0:23
        for minute = 0:59
            index = (i - 1) * num_times + (hour * 60) + minute + 1;
            full_datetime_str{index} = [date_str{i} ' ' sprintf('%02d:%02d', hour, minute)];
        end
    end
end

% Convertir en objets datetime, en utilisant le format français
time_combined = datetime(full_datetime_str, 'InputFormat', 'dd-MMM-yyyy HH:mm', 'Locale', 'fr_FR');

% Convertir en secondes
time_seconds = seconds(time_combined - time_combined(1));

% Extraire les colonnes de données de température et d'irradiance
temperature = table2array(temperature_data(2:end, 2:end)); % Extraire les données de température à partir de la deuxième ligne
irradiance = table2array(irradiance_data(2:end, 2:end)); % Extraire les données d'irradiance à partir de la deuxième ligne

% Aplatir les matrices en vecteurs
temperature = temperature(:);
irradiance = irradiance(:);

% Créer des objets timeseries
ts_temperature = timeseries(temperature, time_seconds);
ts_irradiance = timeseries(irradiance, time_seconds);
