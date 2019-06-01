function [S S_class R] = f_atisa3 (training, classTraining, k, q)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Aprendizagem de Máquina - CIn/UFPE - Engenharia da Computação           %
% ATISA 3                                                                 %                                                                   
%                                                                         %
% Sèrgio Renan Ferreira Vieira -  srfv@cin.ufpe.br                        % 
% Renan Hannouche Torres - rht@cin.ufpe.br                                %                                              
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

training = normal01 (training);
%Calcula-se as distâncias de cada instância para todas as outras do 
%mesmo conjunto
dists = distancias (training);

%Ordenação
[dists idx] = sort (dists, 2, 'ascend');
%excluimos a última coluna pq contém a distância da instância para ela
%mesma
idx = idx(:, 1:(size (idx, 2) - 1));

%PARTE 1: PRÉ-PROCESSAMENTO (EDITED NEAREST NEIGHBOR)
classMajority = mode (classTraining(idx(:, 1:k)), 2); %k-nn
tmp = classTraining == classMajority;
Tf = training(tmp, :);
Tf_class = classTraining(tmp); 

%Cálculo das distâncias do Tf
Tf_dists = distancias (Tf); 
%ordenação
[t Tf_idx] = sort (Tf_dists, 2, 'ascend');
Tf_idx = Tf_idx(:, 1:(size (Tf_idx, 2) - 1));

%PARTE 2: ATRIBUIÇÃO DE LIMIARES
Tf_thresholds = threshold (Tf, Tf_class, Tf_idx);

%ORDENANDO Tf DE ACORDO COM OS LIMIARES DE CADA INSTÂNCIA (DESCRESCENTE)
[t thr_idx] = sort (Tf_thresholds, 'descend');

%nova coluna que indica se a instância foi adcionada a S
Tf = [Tf (zeros (size (Tf, 1), 1))];
[l c] = size (Tf);
%selecionando as primeiras instâncias de S
z = one_by_class (thr_idx, Tf_class, q); %q é a quantidade de classes
Tf(z, c) = 1;

%Cálculo das distâncias em S
S_dists = distancias ( Tf(z, 1:(c - 1)) ); 
%ordenação
[t S_idx] = sort (S_dists, 2, 'ascend');
S_idx = S_idx(:, 1:(size (S_idx, 2) - 1));

%Atualização dos limiares das instâncias em S
Tf_thresholds(z) = threshold (Tf(z, 1:(c - 1)), Tf_class(z), S_idx);

%PARTE 3: GERAÇÃO DO CONJUNTO REDUZIDO
for i = 1:length(thr_idx)
    %thr_idx(i)
    %seleciona os índices das instâncias mais próxima que estão em S
    N = (Tf(Tf_idx(thr_idx(i), :), c)').*Tf_idx(thr_idx(i), :);
    N = N(N ~= 0);
    if (length (N) >= k)
        N = N(1:k);  %índices de N = k-nn (xi, S)
    end
    %N
    majorityClass = mode (Tf_class(N)); %classe_max (N)
    cd1 = Tf_class(thr_idx(i)) ~= majorityClass;
    cd2 = mean (Tf_dists(thr_idx(i), N)) > mean (Tf_thresholds(N));
    Tf(thr_idx(i), c) = cd1 || cd2; %Se cd1 || cd2, então Tf(i) é adicionado em S
    if (cd1 || cd2)
        z = Tf(:, c) == 1;
        S_dists = distancias ( Tf(z, 1:(c - 1)) ); 
        %ordenação
        [t S_idx] = sort (S_dists, 2, 'ascend');
        S_idx = S_idx(:, 1:(size (S_idx, 2) - 1));
        Tf_thresholds(z) = threshold (Tf(z, 1:(c - 1)), Tf_class(z), S_idx);
    end
end

%Subconjunto das instâncias selecionadas a partir do conj. de treinamento
S = Tf((Tf(:, c) == 1), 1:(c - 1));
S_class = Tf_class((Tf(:, c) == 1));
R = 100*(1 - (size (S, 1)/size (training, 1)));