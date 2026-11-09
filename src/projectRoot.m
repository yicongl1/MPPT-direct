function root = projectRoot()
%PROJECTROOT Racine du dépôt (dossier contenant src/, data/, models/...).
%
%   ROOT = PROJECTROOT() renvoie le chemin absolu du dossier racine, déduit de
%   l'emplacement de ce fichier (<racine>/src/projectRoot.m).
%
%   Tous les scripts passent par cette fonction pour construire leurs chemins :
%   le dépôt peut donc être déplacé ou cloné n'importe où sans rien modifier.

    here = fileparts(mfilename('fullpath'));   % .../src
    root = fileparts(here);                    % ...
end
