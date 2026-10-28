%% =====================================================
%
% une routine pour la mise en oeuvre des EF P1 Lagrange
% pour l'equation de la chaleur suivante stationnaire, avec conditions de
% Dirichlet non homogene
%
% | \alpha T - div(\lambda \grad T) = S,   dans \Omega=\Omega_1 U \Omega_2
% |        T = T_\Gamma,   sur le bord
%
% ou S est la source de chaleur, T_\Gamma la température exterieure
% \alpha > 0 et
% \sigma = | \sigma_1 dans \Omega_1
%          | \sigma_2 dans \Omega_2
%
% =====================================================

clear all;
nom_maillage = 'geomChaleur.msh';
validation   = 'oui';
raffinement  = 'non';
reference    = 'non';

alpha   = 1;
T_Gamma = 0;

%% lecture du maillage et affichage
%% ---------------------------------
[Nbpt,Nbtri,Coorneu,Refneu,Numtri,Reftri,Nbaretes,Numaretes,Refaretes]=lecture_msh(nom_maillage);
% [Nbpt,Nbtri,Coorneu,Refneu,Numtri,Reftri,Nbaretes,Numaretes,Refaretes]=lecture_inria_medit_mesh(nom_maillage);
Nbpt

%% ----------------------
%% calcul des matrices EF
%% ----------------------

%% declarations
%% ------------
KK = sparse(Nbpt,Nbpt); % matrice de rigidite
MM = sparse(Nbpt,Nbpt); % matrice de rigidite
LL = zeros(Nbpt,1);     % vecteur second membre

%% boucle sur les triangles
%% ------------------------
for l=1:Nbtri
  %% Coordonnees des sommets du triangles
  S1=Coorneu(Numtri(l,1),:);
  S2=Coorneu(Numtri(l,2),:);
  S3=Coorneu(Numtri(l,3),:);

%%COMPLETADO AQUI

  II  = Numtri(l,:);
  Mel = matM_elem(S1, S2, S3);
  Kel = matK_elem(S1, S2, S3, Reftri(l));
  MM(II,II) = MM(II,II) + Mel;
  KK(II,II) = KK(II,II) + Kel;

end % for l

AA = alpha*MM + KK;

%% Calcul du second membre L
%% -------------------------
LL = 0; 
%%COMPLETADO AQUI
FF = zeros(Nbpt,1);
for i = 1:Nbpt
    FF(i) = f(Coorneu(i,1), Coorneu(i,2));
end
LL = MM*FF;

%% inversion
[tilde_AA, tilde_LL] = elimine(AA, LL, Refneu);
UU = tilde_AA\tilde_LL;
TT = UU + T_Gamma; %% A COMPLETER

%% visualisation
%% -------------
figure(1); affiche(TT, Numtri, Coorneu, sprintf('Uh - %s', nom_maillage));

%% Calcul de grad(u_h) par triangle
%% --------------------------------
grad_uh = zeros(Nbtri, 2);
for l=1:Nbtri

  %% Indices globaux des sommets du triangle
  II = Numtri(l,:);

  %% Coordonnees des sommets du triangle
  S1=Coorneu(II(1),:);
  S2=Coorneu(II(2),:);
  S3=Coorneu(II(3),:);

  grad_uh(l,:) = 0; %% A COMPLETER
end

%% Calcul de sigma_h comme une moyenne de -grad(u_h) par patch
%% -----------------------------------------------------------
Sigma = zeros(Nbpt,2);
Sigma(:,1) = moyenne_par_patch(-grad_uh(:,1), Numtri, Coorneu);
Sigma(:,2) = moyenne_par_patch(-grad_uh(:,2), Numtri, Coorneu);

figure(2); affiche(Sigma(:,1), Numtri, Coorneu, 'sigma_x');
figure(3); affiche(Sigma(:,2), Numtri, Coorneu, 'sigma_y');

%% Estimateur d'erreur
%% -------------------
Eta = zeros(Nbtri, 1);
Eta_r2 = 0;  %% Composante en résidu
Eta_f2 = 0;  %% Composante en flux
for l = 1:Nbtri
  %% Indices des sommets du triangle
  II = Numtri(l,:);

  %% Coordonnees des sommets du triangle
  S1=Coorneu(II(1),:);
  S2=Coorneu(II(2),:);
  S3=Coorneu(II(3),:);

  X = Coorneu(II,1);
  Y = Coorneu(II,2);

  %% Matrices élémentaires
  M_el = matM_elem(S1, S2, S3);
  g_el = grad_elem(S1, S2, S3);

  %% Composante en flux :
  %% E_f  = grad(u_h) + sigma_h
  %% E_f2 = || Ef ||^2_{L2}
  E_fx = 0; %% A COMPLETER
  E_fy = 0; %% A COMPLETER

  E_f2 = 0; %% A COMPLETER

  %% Composante en résidu :
  %% E_r  = f - div(sigma_h) - u_h
  %% E_r2 = || E_r ||^2_{L2}
  gradSigmaX = 0; %% A COMPLETER
  gradSigmaY = 0; %% A COMPLETER
  divSigma   = 0; %% A COMPLETER

  E_r  = 0; %% A COMPLETER
  E_r2 = 0; %% A COMPLETER

  %% Estimateur global
  Eta_f2 = Eta_f2 + E_f2;
  Eta_r2 = Eta_r2 + E_r2;
  Eta(l) = sqrt(E_f2) + 2*sqrt(2)/pi * sqrt(E_r2);
end

%% Estimateur global
Eta_tot = sqrt(Eta_f2) + 2*sqrt(2)/pi * sqrt(Eta_r2)

%% Lissage de l'estimateur par triangle, pour visualisation et post-traitement
Eta_av = moyenne_par_patch(Eta, Numtri, Coorneu);
figure(4); affiche(Eta_av, Numtri, Coorneu, 'Eta');

%% validation
%% ----------
if strcmp(validation,'oui')
  X = Coorneu(:,1);
  Y = Coorneu(:,2);

  %% CAS I : REFERENCE ANALYTIQUE
  UU_ref = sin(pi*X) .* sin(2*pi*Y);
  Sigma_ref = zeros(Nbpt, 2);
  Sigma_ref(:,1) = 0; %% A COMPLETER
  Sigma_ref(:,2) = 0; %% A COMPLETER

  %% CAS II : REFERENCE NON ANALYTIQUE
  %% Récupération de la référence
  %% et interpolation sur le maillage courant
  %% [UU_ref, Sigma_ref] = lecture_reference(X, Y);

  %% Erreur sur u
  EE = (UU-UU_ref);
  figure(5); affiche(abs(EE), Numtri, Coorneu, sprintf('Erreur - %s', nom_maillage));

  %% Calcul de l erreur L2 sur u_h
  err_u_l2 = 0       %% A COMPLETER
  %% Calcul de l erreur en semi-norme H1 sur u_h
  err_u_semih1 = 0   %% A COMPLETER

  %% Erreur sur sigma
  EEx = Sigma(:,1) - Sigma_ref(:,1);
  EEy = Sigma(:,2) - Sigma_ref(:,2);

  %% Calcul de l'erreur L2 sur sigma_h
  err_sigma_l2 = 0 %% A COMPLETER
end

%% Raffinement du maillage
if strcmp(raffinement, 'oui')
  h = 1 ./ Eta_av;     % Calcul du nouveau pas de maillage
  h = h * 0.01/min(h); % - mise à l'échelle pour que : min(h) == 0.01
  h = min(h, 0.4);     % - écrêtement pour que :       max(h) <= 0.4
  figure(6); affiche(h, Numtri, Coorneu, 'h')

  %% Génération des fichiers pour gmsh
  %%
  %% Commande pour générer un maillage raffiné :
  %%   gmsh -bgm size.pos geomCarre.geo
  write_field('size.pos', 'Mesh size', h, Numtri, Coorneu);
end

%% Enregistrement des résultats de référence (si maillage suffisamment raffiné)
if strcmp(reference, 'oui')
  dx = 1e-3;
  X = Coorneu(:,1);
  Y = Coorneu(:,2);
  Xrange = min(X):dx:max(X);
  Yrange = min(Y):dx:max(Y);
  [XI,YI] = meshgrid(Xrange, Yrange);
  Uref      = griddata(X,Y,UU,        XI,YI);
  SigmaXref = griddata(X,Y,Sigma(:,1),XI,YI);
  SigmaYref = griddata(X,Y,Sigma(:,2),XI,YI);
  save 'ref.mat' Xrange Yrange Uref SigmaXref SigmaYref
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        fin de la routine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%2026