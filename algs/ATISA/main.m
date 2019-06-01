%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Aprendizagem de M�quina - CIn/UFPE - Engenharia da Computa��o           %
% ATISA 1                                                                 %                                                                   
%                                                                         %
% S�rgio Renan Ferreira Vieira -  srfv@cin.ufpe.br                        % 
% Renan Hannouche Torres - rht@cin.ufpe.br                                %                                              
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear;

fprintf ('Base de dados: iris\n');
%classes das bd iris e wine na 1� coluna 
data = load ('iris.txt');
C = data(:, 1);  %classes da bd diabetes e ionosphere na �ltima coluna
folds = crossvalind ('kfold', C, 10);
%matrizes que guardam, para cad fold, as taxas de redu��o e acerto (knn)
R = zeros (10, 3); A = zeros (10, 3);
k = 3;

%n-fold cross validation
for i = 1:10
    %encontrar as inst�ncias que pertencem ao fold atual (i)
    mask = folds == i;
    %seprar conjuntos de treino e teste
    teste = data (mask, 2:(size (data, 2))); teste_classe = C(mask);
    treino = data (~mask, 2:(size (data, 2))); treino_classe = C(~mask);
    %Aplica��o dos ATISA 1, 2 e 3 al�m de classifica��o k-nn (ap�s)
    [S S_classe R(i, 1)] = f_atisa1 (treino, treino_classe, k);
    A(i, 1) = k_NN (k, S, teste, S_classe, teste_classe);
    
    [S S_classe R(i, 2)] = f_atisa2 (treino, treino_classe, k);
    A(i, 2) = k_NN (k, S, teste, S_classe, teste_classe);
    %base diabetes e ionosphere t�m 2 classes
    [S S_classe R(i, 3)] = f_atisa3 (treino, treino_classe, k, 3);%iris e wine t�m 3 classes
    A(i, 3) = k_NN (k, S, teste, S_classe, teste_classe);
end

fprintf ('A taxa m�dia de Redu��o do ATISA 1 foi de %1.2f%%\n', mean (R(:, 1)));
fprintf ('A taxa m�dia de Acerto p�s-ATISA 1 foi de %1.2f%%\n', mean (A(:, 1)));
fprintf ('A taxa m�dia de Redu��o do ATISA 2 foi de %1.2f%%\n', mean (R(:, 2)));
fprintf ('A taxa m�dia de Acerto p�s-ATISA 2 foi de %1.2f%%\n', mean (A(:, 2)));
fprintf ('A taxa m�dia de Redu��o do ATISA 3 foi de %1.2f%%\n', mean (R(:, 3)));
fprintf ('A taxa m�dia de Acerto p�s-ATISA 3 foi de %1.2f%%\n', mean (A(:, 3)));


