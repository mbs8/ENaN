clc, clear;
data = load ('sintetica_1.txt'); %as classes devem estar na última coluna
training = data(:, 1:(size(data, 2) - 1));
classTraining = data(:, (size(data, 2)));

c1 = find (data(:, 3) == 1);
c2 = find (data(:, 3) == 2);

dists = distancias (training);
[dists2 idx] = sort (dists, 2, 'ascend');
dists2 = dists2(:, 1:(size(dists2, 2) - 1));
idx = idx(:, 1:(size (idx, 2) - 1));

thr = threshold (training, classTraining, idx);

training = [training (zeros (size (training, 1), 1))];
[l c] = size (training);
training(1, c) = 1;
k = 1;

for i= 2:l
    %seleciona os índices das instâncias mais próxima que estão em S
    N = (training(idx(i, :), c)').*idx(i, :);
    N = N(N ~= 0);
    if (length (N) >= k)
        N = N(1:k);  %índices de N = k-nn (xi, S)
    end
    majorityClass = mode (classTraining(N)); %classe_max (N)
    cd1 = classTraining(i) ~= majorityClass;
    cd2 = mean (dists(i, N)) > mean (thr(N));
    training(i, c) = cd1 || cd2; %Se cd1 || cd2, então Tf(i) é adicionado em S
end

%Subconjunto das instâncias selecionadas a partir do conj. de treinamento
S = training((training(:, c) == 1), 1:(c - 1));
S_class = classTraining((training(:, c) == 1));

cc1 = find (S_class == 1);
cc2 = find (S_class == 2);

figure (1);
subplot (2, 1, 1);
scatter (training(c1, 1), training(c1, 2), 'xb');
hold on;
scatter (training(c2, 1), training(c2, 2), 'or');
title ('Conjunto filtrado pelo ENN');
legend ('Classe 1', 'Classe 2');
xlabel ('X1');
ylabel ('X2');
subplot (2, 1, 2);
scatter (S(cc1, 1), S(cc1, 2), 'xb');
hold on;
scatter (S(cc2, 1), S(cc2, 2), 'or');
title ('Conjunto reduzido pelo ATISA 1');
legend ('Classe 1', 'Classe 2');
xlabel ('X1');
ylabel ('X2');
axis ([-2.1 2.1 -2.1 2.1]);