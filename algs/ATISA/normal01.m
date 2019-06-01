function newMatrix = normal01 (matrix)
%
%   input: matrix => a matrix, that stores only values of atributes,
%                    gonna be normalized
% 
%   output: newMatrix => matrix normalized
%

[lines cols] = size (matrix);
newMatrix = zeros (lines, cols);

for i = 1:cols
    greater = max (matrix(:, i)); %i atribute�s maximun value
    less = min (matrix(:, i)); %i atribute�s minimun value
	fprintf (greater);
	fprintf (less);
	
    if less == greater
        newMatrix(:, i) = 1;
    else
        newMatrix(:, i) = (matrix(:, i) - less)./(greater - less);
    end
end