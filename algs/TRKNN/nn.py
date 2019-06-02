import math

# vizinho mais próximo de @data com classe diferente de @target
def differentClass(data, dataset, classes, target):
  if (len(dataset) != len(classes)): raise Exception('Lista de classes deve ter o mesmo tamanho da lista de dados.')
  distance = float('inf')
  i = 0
  n = len(dataset)
  index = 0
  while (i < n):
    if(classes[i] != target):
      dist = euclidianDistance(dataset[i], data)
      if (dist < distance and dist != 0):
        distance = dist
        index = i
    i += 1
  return (index, distance)

# vizinho mais próximo de @data com classe @target
def withTargetClass(data, dataset, classes, target):
  if (len(dataset) != len(classes)): raise Exception('Lista de classes deve ter o mesmo tamanho da lista de dados.')
  distance = float('inf')
  i = 0
  n = len(dataset)
  index = 0
  while (i < n):
    if(classes[i] == target):
      dist = euclidianDistance(dataset[i], data)
      if (dist < distance and dist != 0):
        distance = dist
        index = i
    i += 1
  return (index, distance)

def euclidianDistance(data1, data2):
  if (len(data1) != len(data2)): raise Exception('Tentando calcular distância entre dois padrões de tamanhos diferentes.')
  num = len(data1)
  result = 0
  i = 0
  while (i < num):
    dif = data1[i] - data2[i]
    result += dif * dif
    i += 1
  return math.sqrt(result)

