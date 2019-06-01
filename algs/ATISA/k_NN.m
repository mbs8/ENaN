function taxaAcerto = k_NN (k, train, test, classTrain, classTest)
%   
%   Função que recebe o parâmetro k, os conjuntos de treinamento e teste 
%   além de suas respectivas classes.
%   A função retorna o percentual de acerto das previsões do conjunto de
%   teste.
%

D = distEuclidiana (test, train);
[D idx] = sort (D, 2, 'ascend');

%temp guarda os índices dos k exemplos mais próximos da query
temp = idx(:, 1:k);
%a função mode retorna a moda, neste caso, presente nas classes mais
%próximas
previsoes = mode (classTrain(temp), 2);
acertos = previsoes == classTest;

taxaAcerto = 100*(sum(acertos)/length (acertos));