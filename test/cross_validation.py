from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import cross_val_score

def cross_validation(df, labels):
    one_nn_classifier = KNeighborsClassifier(n_neighbors=1)
    return cross_val_score(one_nn_classifier, df, labels, cv=10)