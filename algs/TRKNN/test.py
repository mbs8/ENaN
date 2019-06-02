import trknn
from sklearn import datasets

dataset = datasets.load_iris()
# dataset = datasets.load_breast_cancer()
# dataset = datasets.load_boston()
# dataset = datasets.load_diabetes()
# dataset = datasets.load_digits()

n = len(dataset.data)

subset = trknn.run(dataset.data, dataset.target, 1.2)
print(n)
print(len(subset[0]))