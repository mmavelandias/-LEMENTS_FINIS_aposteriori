function [av] = moyenne_par_patch(champ, Numtri, Coorneu)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% moyenne_par_patch :
% lissage d'un champ par moyennage sur les éléments d'un patch
%
% SYNOPSIS [av] = moyenne_par_patch(champ, Numtri, Coorneu)
%
% INPUT * champ (vecteur Nbtri x 1) : le champ à lisser, une valeur par élément
%       * Numtri, Coorneu : description de la triangulation
%
% OUTPUT * av (vecteur Nbpt x 1) : champ lissé, une valeur par sommet
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  Nbpt = size(Coorneu, 1);
  Nbtri = size(Numtri, 1);

  Somme = zeros(Nbpt,1);
  Ncontrib = zeros(Nbpt,1);

  for l=1:Nbtri
    II = Numtri(l,:);

    %% A COMPLETER
  end % for l

  av = Somme ./ Ncontrib;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        fin de la routine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%2026
