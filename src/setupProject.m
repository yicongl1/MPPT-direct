function root = setupProject()
%SETUPPROJECT Ajoute le code du projet au chemin MATLAB.
%
%   ROOT = SETUPPROJECT() ajoute src/ et tous ses sous-dossiers au chemin de
%   recherche MATLAB, puis renvoie la racine du dépôt.
%
%   À appeler une fois par session, depuis la racine du dépôt :
%
%       addpath('src');
%       setupProject();
%
%   Voir aussi PROJECTROOT, LOADYEARDATA, RUNSIMULATION, RUNANALYSIS.

    root = projectRoot();
    addpath(genpath(fullfile(root, 'src')));
    fprintf('MPPT-direct prêt (racine : %s)\n', root);
end
