import nn

def buildChain(data_index, dataset, classes): 
  if (len(dataset) != len(classes)): raise Exception('Lista com classes deve ter o mesmo tamanho da lista de dados.')
  n = len(dataset)
  same = False
  chains = []
  chains.append((data_index, -1))
  data = dataset[data_index]
  target = classes[data_index]
  old_index = data_index
  i = 0

  while (not same):
    if (i > 0): old_index = chains[i-1][0]

    if (i%2 == 0):
      (index, distance) = nn.differentClass(data, dataset, classes, target)
    else:
      (index, distance) = nn.withTargetClass(data, dataset, classes, target)
    data = dataset[index]

    if (index == old_index): same = True
    else: chains.append((index, distance))
    i += 1

  return chains

# marca para remoção os padrões que podem ser removidos
def mark(data_index, chain, alpha, markedForRemoval):
  i = 0
  n = len(chain)
  while(i+2 < n):
    if (not markedForRemoval[chain[i][0]]): # Se já está marcado, pula
      if(chain[i+1][1] > alpha*chain[i+2][1]):
        markedForRemoval[chain[i][0]] = True  
    i += 2

# retorna o subconjunto com dados e classes gerados pelo trknn
def run(dataset, classes, alpha):
  if (len(dataset) != len(classes)): raise Exception('Array com classes deve ter o mesmo tamanho do Array de dados.')
  n = len(dataset)
  chains = [None] * n
  markedForRemoval = [False] * n

  i = 0
  while(i < n):
    chains[i] = buildChain(i, dataset, classes)
    mark(i, chains[i], alpha, markedForRemoval)
    i += 1

  i = 0
  subset_data = [] 
  subset_classes = [] 
  while(i < n):
    if (not markedForRemoval[i]): 
      subset_data.append(dataset[i])
      subset_classes.append(classes[i])
    i += 1
  return (subset_data, subset_classes)