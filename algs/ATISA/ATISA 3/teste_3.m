clc, clear;
data = load ('sintetica_1.txt'); %as classes devem estar na �ltima coluna
Tf = data(:, 1:(size(data, 2) - 1));
Tf_class = data(:, (size(data, 2)));

c1 = find (data(:, 3) == 1);
c2 = find (data(:, 3) == 2);

%C�lculo das dist�ncias do Tf
Tf_dists = distancias (Tf); 
%ordena��o
[t Tf_idx] = sort (Tf_dists, 2, 'ascend');
Tf_idx = Tf_idx(:, 1:(size (Tf_idx, 2) - 1));

%PARTE 2: ATRIBUI��O DE LIMIARES
Tf_thresholds = threshold (Tf, Tf_class, Tf_idx);

%ORDENANDO Tf DE ACORDO COM OS LIMIARES DE CADA INST�NCIA (DESCRESCENTE)
[t thr_idx] = sort (Tf_thresholds, 'descend');

%nova coluna que indica se a inst�ncia foi adcionada a S
Tf = [Tf (zeros (size (Tf, 1), 1))];
[l c] = size (Tf);
%selecionando as primeiras inst�ncias de S
z = one_by_class (thr_idx, Tf_class, 2); %db iris tem 3 classes
Tf(z, c) = 1;

%C�lculo das dist�ncias em S
S_dists = distancias (Tf(z, 1:(c - 1))); 
%ordena��o
[t S_idx] = sort (S_dists, 2, 'ascend');
S_idx = S_idx(:, 1:(size (S_idx, 2) - 1));

%Atualiza��o dos limiares das inst�ncias em S
Tf_thresholds(z) = threshold (Tf(z, 1:(c - 1)), Tf_class(z), S_idx);

k = 1;
%PARTE 3: GERA��O DO CONJUNTO REDUZIDO
for i = 1:length(thr_idx)
    %seleciona os �ndices das inst�ncias mais pr�xima que est�o em S
    N = (Tf(Tf_idx(thr_idx(i), :), c)').*Tf_idx(thr_idx(i), :);
    N = N(N ~= 0);
    if (length (N) >= k)
        N = N(1:k);  %�ndices de N = k-nn (xi, S)
    end
    majorityClass = mode (Tf_class(N)); %classe_max (N)
    cd1 = Tf_class(thr_idx(i)) ~= majorityClass;
    cd2 = mean (Tf_dists(thr_idx(i), N)) > mean (Tf_thresholds(N));
    Tf(thr_idx(i), c) = cd1 || cd2; %Se cd1 || cd2, ent�o Tf(i) � adicionado em S
    if (cd1 || cd2)
        z = Tf(:, c) == 1;
        Tf_thresholds(z) = threshold (Tf(z, 1:(c - 1)), Tf_class(z), S_idx);
    end
end

%Subconjunto das inst�ncias selecionadas a partir do conj. de treinamento
S = Tf((Tf(:, c) == 1), 1:(c - 1));
S_class = Tf_class((Tf(:, c) == 1));

cc1 = find (S_class == 1);
cc2 = find (S_class == 2);

figure (1);
subplot (2, 1, 1);
scatter (Tf(c1, 1), Tf(c1, 2), 'xb');
hold on;
scatter (Tf(c2, 1), Tf(c2, 2), 'or');
title ('Conjunto filtrado pelo ENN');
legend ('Classe 1', 'Classe 2');
xlabel ('X1');
ylabel ('X2');
subplot (2, 1, 2);
scatter (S(cc1, 1), S(cc1, 2), 'xb');
hold on;
scatter (S(cc2, 1), S(cc2, 2), 'or');
title ('Conjunto reduzido pelo ATISA 3');
legend ('Classe 1', 'Classe 2');
xlabel ('X1');
ylabel ('X2');
axis ([-2.1 2.1 -2.1 2.1]);
