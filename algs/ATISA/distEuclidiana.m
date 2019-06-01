function  dist = distEuclidiana (u, v)
%   Função que recebe duas mastrizes u e v e retorna a distância Euclidiana
%   entre cada linha de u e todas linhas de v numa matriz D
%   

[l col] = size (u);
exs = size(v, 1);

dist = zeros (l, exs);

for i= 1:l
    for j= 1:exs
       dist(i, j) =  norm (u(i, :) - v(j, :));
    end
end