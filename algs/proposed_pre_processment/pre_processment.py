import pandas as pd
from sklearn.neighbors import KDTree

def natural_neighbour(df) -> pd.DataFrame:
    kdt = KDTree(df.values, leaf_size=30, metric='euclidean')
    nan = pd.DataFrame(columns=['natural_neighbours', 'num_neighbours'])
    
    r = 1
    num_instances_with_no_neighbour = 0
    
    stop = False
    last_iter = False
    while not stop:
        
        if last_iter:
                stop = True
                
        for i, row in df.iterrows():

            i_neighbours = kdt.query(row.values.reshape(1, -1), k=r+1, return_distance=False)
            i_natural_neighbours = []
            i_num_neighbours = 0

            for j in i_neighbours[0]:
                if j != i:
                    j_neighbours = kdt.query(df.iloc[j].values.reshape(1, -1), k=r+1, return_distance=False)
                    if i in j_neighbours:
                        i_natural_neighbours.append(j)

            try:
                nan.iloc[i].natural_neighbours = list(set(nan.iloc[i].natural_neighbours) | set(i_natural_neighbours))
                nan.iloc[i].num_neighbours = len(nan.iloc[i].natural_neighbours)
            except:
                nan = nan.append({
                    "natural_neighbours": i_natural_neighbours,
                    "num_neighbours": len(i_natural_neighbours)
                }, ignore_index=True)

        if num_instances_with_no_neighbour == len(nan[(nan['num_neighbours'] == 0)]):
            last_iter = True 
        else:
            last_iter = False
            stop = False
        
        num_instances_with_no_neighbour = len(nan[(nan['num_neighbours'] == 0)])
        r += 1
        
    return nan

def select_prototypes(df, nan, labels):
    filtered_df = pd.DataFrame()
    
    for i, row in nan.iterrows():
        i_natural_neighbours_df = df.iloc[nan.iloc[i].natural_neighbours]
        kdt = KDTree(i_natural_neighbours_df.values, leaf_size=30, metric='euclidean')
        i_nn = kdt.query(df.iloc[i].values.reshape(1, -1), k=1, return_distance=False)[0][0]
        if labels.iloc[i_nn] == labels.iloc[i]:
            filtered_df = filtered_df.append(df.iloc[i])
        
    return filtered_df