function [S S_class R] = f_atisa1 (training, classTraining, k)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Aprendizagem de M�quina - CIn/UFPE - Engenharia da Computa��o           %
% ATISA 1                                                                 %                                                                   
%                                                                         %
% S�rgio Renan Ferreira Vieira -  srfv@cin.ufpe.br                        % 
% Renan Hannouche Torres - rht@cin.ufpe.br                                %                                              
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

training = normal01 (training);
%Calcula-se as dist�ncias de cada inst�ncia para todas as outras do 
%mesmo conjunto
dists = distancias (training);

%Ordena��o
[dists idx] = sort (dists, 2, 'ascend');
%excluimos a �ltima coluna pq cont�m a dist�ncia da inst�ncia para ela
%mesma
idx = idx(:, 1:(size (idx, 2) - 1));

%PARTE 1: PR�-PROCESSAMENTO (EDITED NEAREST NEIGHBOR)
classMajority = mode (classTraining(idx(:, 1:k)), 2); %k-nn
tmp = classTraining == classMajority;
Tf = training(tmp, :);
Tf_class = classTraining(tmp); 

%Embaralhar inst�ncias de Tf
aux = randperm (size (Tf, 1));
Tf = Tf(aux, :);
Tf_class = Tf_class(aux, :);

%C�lculo das dist�ncias do Tf
Tf_dists = distancias (Tf); 
%ordena��o
[t Tf_idx] = sort (Tf_dists, 2, 'ascend');
Tf_idx = Tf_idx(:, 1:(size (Tf_idx, 2) - 1));

%PARTE 2: ATRIBUI��O DE LIMIARES
Tf_thresholds = threshold (Tf, Tf_class, Tf_idx);

%nova coluna que indica se a inst�ncia foi adcionada a S
Tf = [Tf (zeros (size (Tf, 1), 1))];
[l c] = size (Tf);
Tf(1, c) = 1;  %Tf(1) � adicionado a S automaticamente

%PARTE 3: GERA��O DO CONJUNTO REDUZIDO
for i= 2:l
    %seleciona os �ndices das inst�ncias mais pr�ximas que est�o em S
    N = (Tf(Tf_idx(i, :), c)').*Tf_idx(i, :);
    N = N(N ~= 0);
    if (length (N) >= k)
        N = N(1:k);  %�ndices de N = k-nn (xi, S)
    end
    majorityClass = mode (Tf_class(N)); %classe_max (N)
    cd1 = Tf_class(i) ~= majorityClass;
    cd2 = mean (Tf_dists(i, N)) > mean (Tf_thresholds(N));
    Tf(i, c) = cd1 || cd2; %Se cd1 || cd2, ent�o Tf(i) � adicionado em S
end

%Subconjunto das inst�ncias selecionadas a partir do conj. de treinamento
S = Tf((Tf(:, c) == 1), 1:(c - 1));
S_class = Tf_class((Tf(:, c) == 1)); 
R = 100*(1 - (size (S, 1)/size (training, 1)));