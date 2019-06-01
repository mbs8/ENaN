function taxaAcerto = k_NN (k, train, test, classTrain, classTest)
%   
%   Fun��o que recebe o par�metro k, os conjuntos de treinamento e teste 
%   al�m de suas respectivas classes.
%   A fun��o retorna o percentual de acerto das previs�es do conjunto de
%   teste.
%

D = distEuclidiana (test, train);
[D idx] = sort (D, 2, 'ascend');

%temp guarda os �ndices dos k exemplos mais pr�ximos da query
temp = idx(:, 1:k);
%a fun��o mode retorna a moda, neste caso, presente nas classes mais
%pr�ximas
previsoes = mode (classTrain(temp), 2);
acertos = previsoes == classTest;

taxaAcerto = 100*(sum(acertos)/length (acertos));