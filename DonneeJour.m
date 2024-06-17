% L'utilisateur choisit une date
selected_date_str = inputdlg('Insérer une date (Format : yyyy-MM-dd) :', 'Choisir une date', [1, 20]);
selected_date_str = selected_date_str{1}; % Convertir la date entrée par l'utilisateur en chaîne de caractères

% Rechercher l'index de la date sélectionnée dans les données
selected_date_str = datestr(datetime(selected_date_str, 'InputFormat', 'yyyy-MM-dd'), 'dd-mmm-yyyy', 'Locale', 'fr_FR');
date_index = find(strcmp(date_str, selected_date_str));

% Vérifier si la date a été trouvée
if isempty(date_index)
    error('Date invalide : %s', selected_date_str);
end

% Extraire la plage horaire pour la date sélectionnée
start_index = (date_index - 1) * num_times + 1;
end_index = date_index * num_times;

% Extraire les échantillons pour la date sélectionnée
j_temperature = getsamples(j_temperature, start_index:end_index);
j_irradiance = getsamples(j_irradiance, start_index:end_index);

% Réinitialiser l'axe du temps pour commencer à 0
j_temperature.Time = j_temperature.Time - j_temperature.Time(1);
j_irradiance.Time = j_irradiance.Time - j_irradiance.Time(1);

% Enregistrer les données dans l'espace de travail
assignin('base', 'j_temperature', j_temperature);
assignin('base', 'j_irradiance', j_irradiance);