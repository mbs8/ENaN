import nn
from sklearn.neighbors import NearestNeighbors
from sklearn import datasets

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
    classified, distance = nn.threeNN(dataset[i], classes[i], subset_data, subset_classes)
    if( classified or distance > thresholdDistances[i] ):
      subset_classes.append(classes[i])
      subset_data.append(dataset[i])
    i += 1
  return (subset_data, subset_classes)

def run(dataset, classes):
  thresholdDistances = calculateThresholdDistances(dataset, classes)
  subset_data, subset_classes = subset(dataset, classes, thresholdDistances)
  return (subset_data, subset_classes)
