function [Kel] = matK_elem(S1, S2, S3, Reftri)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mat_elem :
% calcul la matrice de raideur elementaire en P1 lagrange
%
% SYNOPSIS [Kel] = mat_elem(S1, S2, S3)
%
% INPUT * S1, S2, S3 : les 2 coordonnees des 3 sommets du triangle
%                      (vecteurs reels 1x2)
%
% OUTPUT - Kel matrice de raideur elementaire (matrice 3x3)
%
% NOTE (1) le calcul est exacte (pas de condensation de masse)
%      (2) calcul par passage a l'element de reference
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% preliminaires, pour faciliter la lecture:
x1 = S1(1); y1 = S1(2);
x2 = S2(1); y2 = S2(2);
x3 = S3(1); y3 = S3(2);
% calcul de la matrice de raideur
% -------------------------------
Kel = zeros(3,3);
%Points et poids de quadrature
M_hat(:,1) = [1/6; 1/6];
M_hat(:,2) = [2/3; 1/6];
M_hat(:,3) = [1/6, 2/3];
poids = 1/6;

% transformation affine F_l(M^) = A*M^ + B, avec F_l(M^_i) = S_i
A = [x2-x1, x3-x1; y2-y1, y3-y1];
B = [x1; y1];
detA = abs(det(A));
% gradients des fonctions de base de reference (colonne i = grad w^_i)
grad_hat = [-1 1 0; -1 0 1];
% gradients physiques : (A^T)^(-1) * grad w^_i
grad = (A') \ grad_hat;
% quadrature
for q = 1:size(M_hat,2)
    M = A*M_hat(:,q) + B;          % point de quadrature dans T_l
    if Reftri == 1
        lam = lambda1(M(1), M(2));
    elseif Reftri == 2
        lam = lambda2(M(1), M(2));
    else
        error('matK_elem : Reftri doit valoir 1 ou 2 (recu : %g)', Reftri);
    end
    Kel = Kel + poids * lam * (grad' * grad) * detA;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        fin de la routine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%2026