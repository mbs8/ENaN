function  dist = distancias (u)
%   Função que recebe uma mastriz u e retorna a distância Euclidiana
%   de cada linha para todas as outras, exceto para ela mesma.
%   

[l col] = size (u);
dist = zeros (l, l);

for i= 1:l
    for j = 1:l 
        if (j ~= i)
            dist(i, j) =  norm (u(i, :) - u(j, :));
        else
            dist(i, j) = NaN; %distância de u(i) para u(i)
        end
    end
end