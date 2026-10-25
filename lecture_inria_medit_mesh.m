function [Nbpt,Nbtri,Coorneu,Refneu,Numtri,Reftri,Nbaretes,Numaretes,Refaretes]= ...
    lecture_inria_medit_mesh(meshfile)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NE FONCTIONNE QUE POUR DES TRIANGLES !!! Voir le fichier lecture.msh pour
% la reference des sorties
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%2026
fid = fopen(meshfile);
if fid <=0
   msg=['Le fichier de maillage : ' char(nomfile) ' est inconnu'];
   error(msg);
end
% HEADER
line = get_line(fid);
assert(strcmpi(line,"MeshVersionFormatted 2"),"Version de format invalide")
line = get_line(fid);
assert(strcmpi(line,"Dimension"),"Formattage invalide");
line = get_line(fid);
dim = str2double(line);
% NOEUDS
line = get_line(fid);
assert(strcmpi(line,"Vertices"),"Formattage invalide");
Nbpt = str2double(get_line(fid));
fmt = join(repmat("%f",1,dim+1)," "); fmt = strcat(fmt,"\n");
Coorneu = fscanf(fid,fmt,[dim+1 Nbpt]); Coorneu = Coorneu.';
Refneu  = Coorneu(:,end);
Coorneu = Coorneu(:,1:2);
%  ARETES
line = get_line(fid);
assert(strcmpi(line,"Edges"),"Formattage invalide");
Nbaretes = str2double(get_line(fid));
Numaretes = fscanf(fid,"%f %f\n",[3 Nbaretes]); Numaretes = Numaretes.';
Refaretes = Numaretes(:,end);
Numaretes = Numaretes(:,1:2);
% TRIANGLES
line = get_line(fid);
assert(strcmpi(line,"Triangles"),"Formattage invalide");
Nbtri = str2double(get_line(fid));
Numtri = fscanf(fid,"%f %f %f %f\n",[4 Nbtri]); Numtri = Numtri.';
Reftri = Numtri(:,end);
Numtri = Numtri(:,1:3);
% On reassigne les references des noeuds
Refneu(:) = 0;
unique_edge_ref = unique(Refaretes);
for i=1:numel(unique_edge_ref)
    mask = Refaretes == unique_edge_ref(i);
    edges = Numaretes(mask,:);
    Refneu(edges(:)) = unique_edge_ref(i);
end
% The end
fclose(fid);
% 
end

function line = get_line(fid)
% Recupere la premiere ligne non-vide suivant le curseur dans le fichier
% 
line = strtrim(fgetl(fid));
while isempty(line)
    line = strtrim(fgetl(fid));
end
% 
end