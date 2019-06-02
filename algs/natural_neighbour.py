import pandas as pd
from sklearn.neighbors import KDTree

def natural_neighbour(df) -> pd.DataFrame:
    kdt = KDTree(df.values, leaf_size=30, metric='euclidean')
    nan = pd.DataFrame(columns=['true_neighbours', 'num_neighbours'])
    
    r = 1
    num_instances_with_no_neighbour = 0
    
    stop = False
    last_iter = False
    while not stop:
        
        if last_iter:
                stop = True
                
        for i, row in df.iterrows():

            i_neighbours = kdt.query(row.values.reshape(1, -1), k=r+1, return_distance=False)
            i_true_neighbours = []
            i_num_neighbours = 0

            for j in i_neighbours[0]:
                if j != i:
                    j_neighbours = kdt.query(df.iloc[j].values.reshape(1, -1), k=r+1, return_distance=False)
                    if i in j_neighbours:
                        i_true_neighbours.append(j)

            try:
                nan.iloc[i].true_neighbours = list(set(nan.iloc[i].true_neighbours) | set(i_true_neighbours))
                nan.iloc[i].num_neighbours = len(nan.iloc[i].true_neighbours)
            except:
                nan = nan.append({
                    "true_neighbours": i_true_neighbours,
                    "num_neighbours": len(i_true_neighbours)
                }, ignore_index=True)

        if num_instances_with_no_neighbour == len(nan[(nan['num_neighbours'] == 0)]):
            last_iter = True 
        else:
            last_iter = False
            stop = False
        
        num_instances_with_no_neighbour = len(nan[(nan['num_neighbours'] == 0)])
        r += 1
        
    return nan