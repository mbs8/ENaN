function  dist = distancias (u)
%   Fun��o que recebe uma mastriz u e retorna a dist�ncia Euclidiana
%   de cada linha para todas as outras, exceto para ela mesma.
%   

[l col] = size (u);
dist = zeros (l, l);

for i= 1:l
    for j = 1:l 
        if (j ~= i)
            dist(i, j) =  norm (u(i, :) - u(j, :));
        else
            dist(i, j) = NaN; %dist�ncia de u(i) para u(i)
        end
    end
end