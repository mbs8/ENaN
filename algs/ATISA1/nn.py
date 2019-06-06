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

def threeNN(data, data_class, dataset, classes):
  avg_distance = 0
  n = len(dataset)
  if (n >= 3): m = 3
  else: m = n
  results = [(float('inf'), 0)] * m
  for i in range(n):
    dist = euclidianDistance(data, dataset[i])
    j = 0
    while(j < m):
      if (dist < results[j][0] and dist != 0):
        results.insert(j, (dist, i))
        results.pop()
        j = m
      j += 1
  same = 0
  dif = 0
  for i in range(m):
    avg_distance = avg_distance + results[i][0]
    if(results[i][1] == data_class): same += 1
    else: dif += 1
  tf = (same > dif)
  avg_distance = avg_distance/3
  return (tf, avg_distance)

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

