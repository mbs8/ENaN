function M = threshold (data, data_class, idx)
%
%   data : data set
%   data_class: instances (data set) classes
%   idx: index of nearest neighbors of an instance 
%
%   The function finds the nearest enemy (NE) of an instance and returns:
%           => M : distances (or radius of the coverage area)
%

[l c] = size (data);
j = 1;
NE = zeros (l, 1);
M = zeros(l, 1);

%encontra o ínimigo mais próximo de cada instância
for i = 1:l
    t = 1;
    while t
      if (data_class(i) ~= data_class(idx(i, j)))
          NE(i) = idx(i, j);
          j = 1;
          t = 0;
      else
          j = j + 1;
      end
    end
end
%ao fim do laço, teremos um vetor com os índices do NE de cada instância

for i = 1:l
    M(i) = norm (data(i, :) - data(NE(i), :));
end


