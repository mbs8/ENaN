import nn
from sklearn.neighbors import NearestNeighbors
from sklearn import datasets

def enn(dataset, classes):
  if (len(dataset) != len(classes)): raise Exception('Lista de classes deve ter o mesmo tamanho da lista de dados.')
  subset_data = []
  subset_classes = []
  i = 0
  n = len(dataset)
  neighbours = NearestNeighbors(n_neighbors=2, algorithm='ball_tree').fit(dataset)
  distances, indexes = neighbours.kneighbors(dataset)
  while (i < n):
    if (classes[i] == classes[indexes[i][1]]):
      subset_data.append(dataset[i])
      subset_classes.append(classes[i])
    i += 1
  return (subset_data, subset_classes)

def calculateThresholdDistances(dataset, classes):
  if (len(dataset) != len(classes)): raise Exception('Lista de classes deve ter o mesmo tamanho da lista de dados.')
  distances = []
  i = 0
  n = len(dataset)
  while(i < n):
    index, distance = nn.differentClass(dataset[i], dataset, classes, classes[i])
    distances.append(distance)
    i += 1
  return distances

def subset(dataset, classes, thresholdDistances):
  subset_data = []
  subset_classes = []
  i = 1
  n = len(dataset)
  subset_data.append(dataset[0])
  subset_classes.append(classes[0])
  while(i < n):
    index, distance = nn.nearestNeighbour(dataset[i], subset_data, subset_classes)
    if(classes[i] != classes[index] or distance > thresholdDistances[i] ):
      subset_classes.append(classes[i])
      subset_data.append(dataset[i])
    i += 1
  return (subset_data, subset_classes)

def run(dataset, classes):
  preprocess_data, preprocess_classes = enn(dataset, classes)
  thresholdDistances = calculateThresholdDistances(preprocess_data, preprocess_classes)
  subset_data, subset_classes = subset(preprocess_data, preprocess_classes, thresholdDistances)
  return (subset_data, subset_classes)